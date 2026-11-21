Rollback Guide

1. Purpose

This guide explains how to recover from unsuccessful application or configuration changes in the GitOps platform.

Argo CD continuously reconciles the Kubernetes cluster with the desired state stored in Git.

For this reason, Git should normally be treated as the source of truth during rollback.

2. Rollback Strategy

The recommended rollback process is:

1. Identify the problematic commit.
2. Review the configuration changes.
3. Revert the commit using Git.
4. Push the rollback commit or merge the rollback pull request.
5. Allow Argo CD to detect the updated desired state.
6. Verify that the previous configuration is restored.
7. Confirm application health.

Argo CD does not automatically create a Git revert when an application becomes unhealthy.

3. Application Rollback

If a newly deployed application image causes problems:

1. Identify the last known-good image tag or digest.
2. Update the GitOps Helm values to use that version.
3. Submit and review the change.
4. Merge the rollback change.
5. Verify that Argo CD synchronizes the application.
6. Verify that the application Pods become healthy.

Example:

image:
  repository: <AWS_ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/finops-engine
  tag: <PREVIOUS_WORKING_TAG>

Use the actual image repository and previously tested image version.

4. Git-Based Configuration Rollback

After Git has been initialized, identify the problematic commit:

git log --oneline

Revert the selected commit:

git revert <COMMIT_ID>

Push the rollback commit:

git push

For a protected branch, create a rollback branch and submit a pull request instead of pushing directly.

5. Argo CD Verification

Check the application:

argocd app get <application-name>

Check Kubernetes resources:

kubectl get pods -n <namespace>
kubectl get deployments -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

If automated synchronization is enabled, Argo CD should reconcile the reverted Git configuration.

If automated synchronization is disabled, review the application and perform a controlled manual sync.

6. Karpenter Rollback

If a NodePool or EC2NodeClass change causes provisioning issues:

1. Identify the last known-good Git configuration.
2. Revert the problematic configuration.
3. Merge the rollback.
4. Verify the Karpenter resources.
5. Check pending Pods and controller logs.
6. Confirm that new nodes can be provisioned.

Avoid deleting healthy worker nodes as an initial troubleshooting step.

7. Important Considerations

* Do not use manual Helm rollback as the normal recovery method for Argo CD-managed applications. Argo CD may reconcile the cluster back to the Git-defined state.
* Do not delete production resources without understanding their dependencies.
* Check PersistentVolume and PersistentVolumeClaim behavior before changing storage resources.
* Check database backup and recovery procedures before rolling back database-related changes.
* Verify application health after every rollback.

8. Recovery Validation

A rollback is complete only after:

* Argo CD reports the expected synchronization state.
* Kubernetes workloads are healthy.
* Application health checks pass.
* Monitoring and alerts are functioning.
* The incident and recovery steps are documented.