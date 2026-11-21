# Karpenter - Kubernetes Node Autoscaling

## 1. Overview

Karpenter is used in this platform to automatically provision and manage
Kubernetes worker nodes based on application scheduling requirements.

It helps improve workload scheduling, infrastructure utilization and
compute cost optimization.

Karpenter is deployed independently in DEV, QA and PROD EKS clusters.

## 2. Architecture

Karpenter integrates with Amazon EKS and AWS EC2.

The workflow is:

1. Application Pods are created.
2. Kubernetes scheduler identifies Pods that cannot be scheduled.
3. Karpenter observes unschedulable Pods.
4. Karpenter evaluates NodePool scheduling requirements.
5. Karpenter selects suitable EC2 instance types.
6. Karpenter provisions EC2 instances.
7. New Kubernetes nodes join the EKS cluster.
8. Pending Pods are scheduled onto available nodes.
9. Karpenter consolidates underutilized nodes when disruption
   requirements permit.

## 3. Repository Structure

```text
platform/karpenter/
├── README.md
└── helm/
    ├── values.yaml
    └── environments/
        ├── dev-values.yaml
        ├── qa-values.yaml
        └── prod-values.yaml

platform/nodepools/
├── dev-nodepool.yaml
├── qa-nodepool.yaml
└── prod-nodepool.yaml

platform/ec2nodeclasses/
├── dev-ec2nodeclass.yaml
├── qa-ec2nodeclass.yaml
└── prod-ec2nodeclass.yaml