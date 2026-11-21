GitOps Karpenter FinOps Engine – Architecture

1. Project Overview

This project implements a production-oriented AWS platform using GitOps, Kubernetes autoscaling, FinOps automation, CI/CD and DevSecOps practices.

The platform is designed around three independent Amazon EKS environments:

* DEV
* QA
* PROD

Each environment has its own infrastructure and application configuration.

2. High-Level Architecture

The platform consists of the following components:

Component	Purpose
AWS VPC	Provides network isolation
Amazon EKS	Runs Kubernetes workloads
Managed Node Groups	Provide baseline system capacity
Karpenter	Dynamically provisions EC2 worker nodes
Argo CD	Continuously reconciles Kubernetes resources from Git
Helm	Packages and configures Kubernetes applications
Kustomize	Manages environment-specific configuration
Jenkins	Runs CI validation and application build pipelines
Amazon ECR	Stores container images
External Secrets Operator	Retrieves secrets from AWS Secrets Manager
Prometheus	Collects metrics
Grafana	Visualizes monitoring data
FastAPI FinOps Engine	Provides cost and cluster-metrics analysis

3. Repository Responsibilities

The project uses three separate repositories.

Infrastructure Repository

gitops-karpenter-finops-infra

Responsible for:

* AWS networking and VPC configuration.
* EKS cluster provisioning.
* IAM roles and permissions.
* Karpenter prerequisites.
* ECR repositories.
* AWS Secrets Manager integration.
* Terraform remote state management.

GitOps Repository

gitops-karpenter-finops-gitops

Responsible for:

* Argo CD configuration.
* Application deployment definitions.
* Helm values.
* Kustomize environment overlays.
* Karpenter NodePools and EC2NodeClasses.
* External Secrets configuration.
* Monitoring configuration.
* Kubernetes security policies.

Application Repository

gitops-karpenter-finops-engine

Responsible for:

* FastAPI application source code.
* Docker image creation.
* Application testing.
* Security scanning.
* Container image publishing.

4. CI/CD and GitOps Workflow

1. Developers commit application code.
2. Jenkins checks out the application repository.
3. Jenkins executes application tests and security scans.
4. Jenkins builds the Docker image.
5. The image is pushed to Amazon ECR.
6. The GitOps repository is updated with the approved image version.
7. Jenkins validates the GitOps configuration.
8. Changes are merged into the configured Git branch.
9. Argo CD detects the Git change.
10. Argo CD reconciles the Kubernetes cluster with the desired configuration.

Jenkins validates and builds. Argo CD is responsible for Kubernetes deployment and reconciliation.

5. Karpenter Workflow

1. An application Pod is created.
2. Kubernetes identifies that the Pod cannot be scheduled.
3. Karpenter evaluates the Pod’s scheduling requirements.
4. Karpenter selects an appropriate EC2 instance type.
5. Karpenter provisions a worker node.
6. The node joins the EKS cluster.
7. Kubernetes schedules the pending Pod.
8. Karpenter can consolidate underutilized nodes when disruption requirements allow it.

6. Secrets Management

Application secrets are stored in AWS Secrets Manager.

External Secrets Operator retrieves the required values and creates Kubernetes Secret resources.

Sensitive values are not stored directly in Git.

7. Monitoring and FinOps

Prometheus collects application and Kubernetes metrics.

Grafana provides dashboards and visualizations.

The FinOps Engine is designed to integrate with:

* AWS Cost Explorer.
* Prometheus metrics.
* Kubernetes workload information.

This provides a foundation for analyzing infrastructure usage and cloud costs.

8. Security

The platform integrates security checks into the CI workflow.

Tools include:

* Gitleaks.
* Trivy.
* SonarQube.
* Checkov.
* TFLint.
* Bandit.
* pip-audit.
* Semgrep.
* Hadolint.
* Conftest and OPA.

Kubernetes workloads use restricted container security settings and network policies.

9. Environment Strategy

DEV, QA and PROD use separate EKS clusters and environment-specific configuration.

Environment-specific Helm values, Karpenter settings and External Secrets resources are maintained separately.

Production changes should follow controlled review and approval procedures.

10. Deployment Status

This repository contains the GitOps configuration and CI validation pipeline.

Actual AWS infrastructure provisioning and Kubernetes deployment are separate execution phases and must be completed before the platform can be considered operational.