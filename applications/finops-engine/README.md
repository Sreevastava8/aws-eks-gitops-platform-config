FinOps Engine

Overview

The FinOps Engine is a Python FastAPI application designed to provide AWS cost visibility, Kubernetes utilization analysis and infrastructure cost optimization recommendations.

It integrates with AWS Cost Explorer and Prometheus.

Architecture

The application runs inside Amazon EKS and is deployed through Argo CD using a reusable Helm chart.

Technology Stack

* Python FastAPI
* AWS SDK for Python (Boto3)
* Amazon EKS
* Amazon ECR
* AWS Cost Explorer
* Prometheus
* Kubernetes
* Helm
* Argo CD

Application Endpoints

Endpoint	Purpose
/health	Application health
/ready	Application readiness
/api/v1/costs	AWS cost information
/api/v1/costs/summary	Cost summary
/api/v1/kubernetes/utilization	Kubernetes utilization
/api/v1/recommendations	FinOps recommendations
/metrics	Prometheus metrics

Environment Configuration

The application is deployed independently into DEV, QA and PROD.

Environment-specific Helm values are maintained in:

* chart/values-dev.yaml
* chart/values-qa.yaml
* chart/values-prod.yaml

AWS Authentication

The application uses EKS Pod Identity through the finops-engine Kubernetes service account.

AWS credentials must not be hardcoded into application configuration or container images.

The associated IAM role requires the permissions necessary for AWS Cost Explorer access.

Secrets Management

The API key is retrieved through External Secrets Operator.

The Kubernetes Secret is:

finops-engine-secret

The API key must never be committed to Git.

Monitoring

Prometheus scrapes application metrics through a ServiceMonitor.

Grafana provides visualization of the collected metrics.

Container Security

The application runs as a non-root user.

The Helm chart configures:

* Read-only root filesystem
* Privilege escalation disabled
* Linux capabilities dropped
* RuntimeDefault seccomp profile
* Resource requests and limits

Deployment

Argo CD deploys the application from:

applications/finops-engine/chart

The deployment uses the common Helm values and the appropriate environment-specific values file.

Scaling

Horizontal Pod Autoscaling is enabled using CPU utilization.

A PodDisruptionBudget is configured to reduce disruption during voluntary pod maintenance.