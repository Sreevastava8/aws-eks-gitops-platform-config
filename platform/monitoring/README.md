Monitoring and Observability

Overview

The GitOps Karpenter FinOps Engine uses the Prometheus monitoring ecosystem to collect, store and visualize infrastructure and application metrics.

The monitoring stack is deployed using the kube-prometheus-stack Helm chart through Argo CD.

Components

Component	Purpose
Prometheus	Metrics collection and time-series storage
Grafana	Metrics visualization and dashboards
Alertmanager	Alert grouping and notification management
Node Exporter	Kubernetes node metrics
kube-state-metrics	Kubernetes object and cluster-state metrics
Prometheus Operator	Prometheus and Alertmanager lifecycle management

Storage Configuration

* Prometheus persistent volume: 30 Gi
* Prometheus retention: 15 days
* Grafana persistent volume: 10 Gi
* Alertmanager persistent volume: 10 Gi

Persistent volumes require a functioning Kubernetes StorageClass and EBS CSI integration.

Application Monitoring

The FinOps Engine exposes application metrics through its /metrics endpoint.

Prometheus discovers application ServiceMonitors across namespaces.

The application metrics support infrastructure utilization analysis and FinOps recommendations.

Grafana Credentials

Grafana credentials are retrieved from AWS Secrets Manager using External Secrets Operator.

The Kubernetes Secret is:

grafana-admin-credentials

Credentials must never be committed to Git.

Deployment

Monitoring is deployed independently in DEV, QA and PROD EKS clusters through Argo CD.

The Argo CD application is defined in:

* argocd/applications/dev/monitoring.yaml
* argocd/applications/qa/monitoring.yaml
* argocd/applications/prod/monitoring.yaml

Operational Checks

After deployment, verify:

1. Prometheus StatefulSet is healthy.
2. Grafana is accessible.
3. Alertmanager is healthy.
4. Prometheus targets are up.
5. FinOps Engine ServiceMonitor is discovered.
6. Persistent volume claims are bound.
7. Grafana credentials are synchronized successfully.

Security

* Grafana credentials are stored in AWS Secrets Manager.
* External Secrets Operator synchronizes credentials into Kubernetes.
* Monitoring services should not be exposed publicly without appropriate access controls.
* Kubernetes RBAC and NetworkPolicies should restrict access to monitoring components.