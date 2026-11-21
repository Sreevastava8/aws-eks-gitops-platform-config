Deployment Guide

1. Purpose

This guide describes the intended deployment sequence for the GitOps Karpenter FinOps Engine platform.

The project follows a code-first approach. Configuration is prepared and validated locally before AWS resources are created.

Do not execute deployment commands until the infrastructure repository and GitOps configuration have passed the final integration review.

2. Deployment Prerequisites

Required tools:

* AWS CLI.
* Terraform.
* kubectl.
* Helm.
* Kustomize.
* Argo CD CLI.
* Docker.
* Jenkins.
* Git.

Required AWS services:

* Amazon VPC.
* Amazon EKS.
* Amazon EC2.
* Amazon ECR.
* AWS IAM.
* AWS Secrets Manager.
* Amazon S3.
* AWS Cost Explorer.

3. Deployment Sequence

The recommended deployment order is:

1. Prepare and validate Terraform infrastructure.
2. Provision AWS networking and supporting IAM resources.
3. Provision the EKS clusters.
4. Configure Karpenter prerequisites.
5. Create the required ECR repositories.
6. Create the required AWS Secrets Manager secrets.
7. Install Argo CD into each EKS cluster.
8. Connect Argo CD to the GitOps repository.
9. Deploy External Secrets Operator.
10. Deploy Karpenter CRDs and controller.
11. Apply Karpenter EC2NodeClasses and NodePools.
12. Deploy Prometheus and Grafana.
13. Build and publish the FinOps Engine image.
14. Deploy the FinOps Engine through Argo CD.
15. Verify application health, monitoring and autoscaling.

4. Environment Deployment Strategy

Deploy environments progressively.

DEV

* Deploy the first EKS cluster.
* Configure Argo CD.
* Verify External Secrets integration.
* Verify Karpenter provisioning.
* Deploy monitoring.
* Deploy the FinOps Engine.
* Test application functionality.

QA

After DEV validation:

* Deploy the QA environment.
* Verify environment-specific secrets.
* Verify application deployment.
* Perform integration and performance testing.

PROD

After DEV and QA approval:

* Deploy the production environment.
* Review production resource limits.
* Verify monitoring and alerting.
* Confirm backup and recovery procedures.
* Follow the production change approval process.

5. Argo CD Bootstrap

The repository contains environment-specific Kustomize configurations under:

bootstrap/argocd/environments/

These configurations reference pinned Argo CD installation manifests.

After the target cluster is ready and the required access is configured, apply the appropriate environment configuration:

kubectl apply -k bootstrap/argocd/environments/dev

Use the corresponding qa or prod directory for those environments.

6. Connect the GitOps Repository

After Argo CD is installed:

1. Configure repository access.
2. Replace repository URL placeholders.
3. Review the environment-specific AppProject.
4. Apply the appropriate root Application manifest.
5. Verify that child Applications are created.
6. Verify synchronization and application health.

The repository URL and target revision must match the actual Git repository and branch.

7. Verify Deployments

Useful commands:

kubectl get nodes
kubectl get pods -A
kubectl get applications -n argocd
kubectl get nodepools
kubectl get ec2nodeclasses
kubectl get externalsecrets -A
kubectl get pods -n monitoring
kubectl get pods -n finops-dev

Check Argo CD application status:

argocd app list
argocd app get <application-name>

Check Karpenter controller logs:

kubectl logs -n karpenter deployment/karpenter

8. Deployment Safety

Before deploying:

* Replace all repository URL placeholders.
* Replace image repository and tag placeholders.
* Confirm AWS account and region.
* Confirm IAM role names.
* Confirm subnet and security group discovery tags.
* Confirm Secrets Manager secret names and values.
* Confirm Kubernetes storage classes.
* Confirm Argo CD project permissions.
* Confirm resource requests and limits.
* Review production synchronization and pruning behavior.

Never commit credentials, private keys, Terraform state or actual secret values.

9. Current Project Status

The repository configuration is being prepared and validated locally.

The commands in this guide describe the intended deployment process. They do not indicate that AWS resources or Kubernetes workloads have already been deployed.