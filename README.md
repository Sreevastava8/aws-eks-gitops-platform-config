GitOps Karpenter FinOps Engine

A production-oriented GitOps platform for AWS EKS using Argo CD, Karpenter, Jenkins, Helm, Kustomize, External Secrets Operator, Prometheus, Grafana and a FastAPI-based FinOps Engine.

Architecture Overview

The platform supports three independent environments:

* DEV
* QA
* PROD

Each environment has its own EKS cluster and environment-specific configuration.

Technology Stack

Category	Tools
Cloud	AWS
Container Orchestration	Amazon EKS
GitOps	Argo CD
CI/CD	Jenkins
Infrastructure as Code	Terraform
Container Registry	Amazon ECR
Autoscaling	Karpenter
Kubernetes Packaging	Helm
Configuration Management	Kustomize
Secrets Management	AWS Secrets Manager, External Secrets Operator
Monitoring	Prometheus, Grafana
Application	Python, FastAPI
Security	Gitleaks, Trivy, SonarQube, Checkov, TFLint, Bandit, pip-audit, Semgrep, Hadolint
Policy Validation	OPA, Conftest

Repository Structure

gitops-karpenter-finops-gitops/
│
├── applications/
│   └── finops-engine/
│       ├── chart/
│       │   ├── templates/
│       │   ├── Chart.yaml
│       │   ├── values.yaml
│       │   ├── values-dev.yaml
│       │   ├── values-qa.yaml
│       │   └── values-prod.yaml
│       └── README.md
│
├── argocd/
│   ├── app-of-apps/
│   ├── applications/
│   │   ├── dev/
│   │   ├── qa/
│   │   └── prod/
│   └── projects/
│
├── bootstrap/
│   └── argocd/
│       ├── environments/
│       └── README.md
│
├── docs/
│   ├── architecture.md
│   ├── deployment-guide.md
│   ├── rollback-guide.md
│   ├── karpenter-troubleshooting.md
│   └── security.md
│
├── platform/
│   ├── ec2nodeclasses/
│   ├── external-secrets/
│   ├── karpenter/
│   ├── monitoring/
│   ├── nodepools/
│   └── policies/
│
├── policy/
│   └── finops-security.rego
│
├── Jenkinsfile.CI
└── README.md

GitOps Workflow

The deployment process follows this workflow:

1. Developers commit application changes.
2. Jenkins builds and tests the application.
3. Security scans are executed.
4. Docker images are built and pushed to Amazon ECR.
5. The approved image version is updated in the GitOps repository.
6. Jenkins validates the GitOps configuration.
7. Changes are reviewed and merged into the configured Git branch.
8. Argo CD detects the change.
9. Argo CD synchronizes the Kubernetes cluster with the desired state in Git.

Jenkins performs CI and validation. Argo CD manages Kubernetes deployment and reconciliation.

Karpenter Autoscaling

Karpenter dynamically provisions EC2 worker nodes based on Kubernetes scheduling requirements.

The platform includes:

* Environment-specific NodePools.
* Environment-specific EC2NodeClasses.
* CPU and memory limits.
* Instance selection requirements.
* Consolidation configuration.
* AWS discovery tags.

The controller is intended to run on stable managed node-group capacity.

Secrets Management

AWS Secrets Manager stores sensitive application values.

External Secrets Operator retrieves those values and creates Kubernetes Secrets.

Actual credentials and secret values must never be committed to Git.

Monitoring

The monitoring stack includes:

* Prometheus.
* Grafana.
* Alertmanager.
* kube-state-metrics.
* Node Exporter.

The FinOps Engine is designed to integrate with AWS Cost Explorer and Prometheus metrics.

Security and Validation

The GitOps CI pipeline is defined in Jenkinsfile.CI.

It includes validation for:

* YAML syntax.
* Kustomize builds.
* Helm charts.
* Kubernetes manifests.
* Karpenter resources.
* Argo CD configuration.
* FinOps security configuration.
* OPA policy checks.
* Gitleaks secret detection.
* Trivy scanning.

Documentation

Document	Description
docs/architecture.md	Platform architecture and component responsibilities
docs/deployment-guide.md	Deployment sequence and verification
docs/rollback-guide.md	GitOps rollback procedure
docs/karpenter-troubleshooting.md	Karpenter troubleshooting
docs/security.md	Security controls and practices

Project Status

The GitOps repository configuration and CI validation pipeline are being prepared for local validation and integration review.

AWS infrastructure provisioning, Jenkins execution, Argo CD deployment and end-to-end environment testing are subsequent phases.

No deployment should be considered complete until those phases have been executed and verified.