Karpenter Troubleshooting Guide

1. Purpose

This guide provides troubleshooting steps for Karpenter in the Amazon EKS environments.

Karpenter provisions EC2 worker nodes when Kubernetes Pods cannot be scheduled on existing capacity.

2. Common Issues

Issue 1: Pods Remain in Pending State

Possible causes:

* Insufficient cluster capacity.
* NodePool scheduling requirements do not match the Pod.
* Pod resource requests are too large.
* NodePool CPU or memory limits have been reached.
* Taints and tolerations do not match.
* No compatible EC2 instance type is available.

Check pending Pods:

kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>

Check NodePools:

kubectl get nodepools
kubectl describe nodepool <nodepool-name>

Check EC2NodeClasses:

kubectl get ec2nodeclasses
kubectl describe ec2nodeclass <ec2nodeclass-name>

Issue 2: Karpenter Controller Is Not Running

Check controller Pods:

kubectl get pods -n karpenter

Check controller logs:

kubectl logs -n karpenter deployment/karpenter

Check deployment status:

kubectl describe deployment karpenter -n karpenter

Possible causes:

* Incorrect cluster name.
* Incorrect cluster endpoint.
* IAM permission issues.
* Pod Identity configuration issues.
* Incorrect Helm values.
* Controller resource constraints.

Issue 3: EC2 Instances Are Not Provisioned

Check Karpenter logs:

kubectl logs -n karpenter deployment/karpenter --tail=200

Check NodePool conditions:

kubectl describe nodepool <nodepool-name>

Check EC2NodeClass conditions:

kubectl describe ec2nodeclass <ec2nodeclass-name>

Possible causes:

* Missing EC2 permissions.
* Incorrect node IAM role.
* Subnet discovery tags are missing.
* Security group discovery tags are missing.
* No compatible instance types.
* EC2 service quota limits.
* Insufficient subnet IP addresses.
* Invalid AMI configuration.

Issue 4: Node Does Not Join the EKS Cluster

Check Kubernetes nodes:

kubectl get nodes -o wide

Check Karpenter logs:

kubectl logs -n karpenter deployment/karpenter --tail=200

Possible causes:

* Incorrect node IAM role.
* EKS access configuration problems.
* Incorrect cluster networking.
* Bootstrap failure.
* Security group rules.
* Node cannot reach required AWS endpoints.

Check the EC2 instance state and its system logs in the AWS console.

Issue 5: IAM or Pod Identity Problems

Verify that the Karpenter controller ServiceAccount exists:

kubectl get serviceaccount karpenter -n karpenter

Verify the EKS Pod Identity association and the IAM role in AWS.

Confirm that the controller role has the required permissions for EC2, EKS and SQS operations used by the configured Karpenter features.

Check the controller logs for AccessDenied errors.

Issue 6: Interruption Handling Is Not Working

Verify:

* The interruption queue exists.
* The controller has permission to access the queue.
* The configured queue name matches the AWS resource.
* The required event rules and queue policies are configured.
* The controller Helm values contain the correct interruption queue name.

Check the controller logs for SQS or interruption-related errors.

3. Useful Commands

Check Karpenter resources:

kubectl get nodepools
kubectl get ec2nodeclasses
kubectl get nodes
kubectl get pods -n karpenter

Inspect NodePool details:

kubectl describe nodepool <nodepool-name>

Inspect EC2NodeClass details:

kubectl describe ec2nodeclass <ec2nodeclass-name>

Check recent events:

kubectl get events -A --sort-by=.metadata.creationTimestamp

Follow controller logs:

kubectl logs -n karpenter deployment/karpenter -f

4. Scheduling and Taints

If Pods remain pending, inspect their scheduling requirements:

kubectl describe pod <pod-name> -n <namespace>

Review:

* Node selectors.
* Node affinity.
* Pod affinity and anti-affinity.
* Tolerations.
* Resource requests.
* NodePool requirements.

A Pod must tolerate the relevant node taints and satisfy the node’s scheduling requirements before it can be scheduled.

5. AWS Checks

Review the following AWS resources when provisioning fails:

* EC2 instance launch failures.
* Subnet availability and free IP addresses.
* Security group discovery tags.
* Subnet discovery tags.
* IAM role permissions.
* EC2 instance quotas.
* SQS interruption queue.
* EKS cluster access and networking.

6. Troubleshooting Workflow

Follow this order:

1. Identify the pending or unhealthy Pod.
2. Describe the Pod and review scheduling events.
3. Check the NodePool configuration.
4. Check the EC2NodeClass configuration.
5. Review Karpenter controller logs.
6. Verify IAM and Pod Identity.
7. Verify subnet and security group discovery tags.
8. Check EC2 launch failures and AWS quotas.
9. Apply a reviewed configuration correction through Git.
10. Verify that the Pod is scheduled successfully.

7. Best Practices

* Keep separate NodePools for DEV, QA and PROD.
* Set appropriate CPU and memory limits.
* Use suitable instance families and generations.
* Review consolidation settings before production changes.
* Keep Karpenter controller capacity on a stable managed node group.
* Monitor pending Pods and node provisioning failures.
* Make configuration changes through Git and Argo CD.