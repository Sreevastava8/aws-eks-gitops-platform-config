Argo CD Bootstrap Guide

1. Purpose

This directory contains the initial Argo CD installation configuration for the GitOps-Karpenter-FinOps platform.

Argo CD is responsible for reconciling Kubernetes resources with the desired state stored in the GitOps repository.

2. Environment Architecture

Environment	Argo CD Installation
DEV	Standard installation
QA	Standard installation
PROD	High Availability installation

Argo CD installation manifests are pinned to version v3.5.0.

3. Bootstrap Sequence

Bootstrap each EKS cluster independently.

Step 1: Connect to the EKS cluster

Configure kubectl for the target cluster using AWS CLI.

Verify connectivity:

kubectl get nodes

Step 2: Install Argo CD

For DEV:

kubectl apply -k bootstrap/argocd/environments/dev

For QA:

kubectl apply -k bootstrap/argocd/environments/qa

For PROD:

kubectl apply -k bootstrap/argocd/environments/prod

Step 3: Wait for Argo CD

Verify that Argo CD components are running:

kubectl get pods -n argocd

Step 4: Configure the GitOps repository URL

Replace REPLACE_WITH_GITOPS_REPO_URL in the relevant AppProject, App-of-Apps and child Application manifests with the actual Git repository URL.

Do not commit credentials or access tokens.

Step 5: Install the environment AppProject

For DEV:

kubectl apply -f argocd/projects/dev-project.yaml

For QA:

kubectl apply -f argocd/projects/qa-project.yaml

For PROD:

kubectl apply -f argocd/projects/prod-project.yaml

Step 6: Install the root Application

For DEV:

kubectl apply -f argocd/app-of-apps/dev-apps.yaml

For QA:

kubectl apply -f argocd/app-of-apps/qa-apps.yaml

For PROD:

kubectl apply -f argocd/app-of-apps/prod-apps.yaml

The root Application will manage the child Applications for that environment.

4. Verification

Check Applications:

kubectl get applications -n argocd

Check application synchronization and health:

argocd app list

5. Security

* Keep Argo CD API access restricted.
* Use secure Git authentication.
* Do not commit AWS credentials or application secrets.
* Review AppProject permissions.
* Use separate EKS clusters for DEV, QA and PROD.
* Review synchronization and pruning policies before production use.

6. Deployment Safety

The initial bootstrap is performed manually after EKS provisioning.

Subsequent application and infrastructure configuration changes are managed through Git and Argo CD.

Do not perform bootstrap or deployment operations during the local coding and validation phase.