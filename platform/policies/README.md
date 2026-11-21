Platform Network Security Policies

Overview

The GitOps Karpenter FinOps Engine uses Kubernetes NetworkPolicies to restrict application network communication.

The objective is to implement controlled ingress and egress traffic between application workloads and platform services.

FinOps Engine NetworkPolicy

The FinOps application NetworkPolicy is maintained in:

applications/finops-engine/chart/templates/networkpolicy.yaml

It is deployed together with the FinOps Helm release.

Ingress Rules

The FinOps application accepts traffic on its application port from:

* Pods within its own namespace.
* The monitoring namespace for Prometheus metrics scraping.

Egress Rules

The application requires:

* DNS access to CoreDNS.
* Prometheus access on TCP port 9090.
* HTTPS access for AWS Cost Explorer.
* EKS Pod Identity credential endpoint access on TCP port 80.

AWS Authentication

The application uses EKS Pod Identity through the finops-engine service account.

AWS credentials are retrieved dynamically and are not stored in application configuration.

Egress Security Limitation

Standard Kubernetes NetworkPolicy does not support DNS hostname-based egress rules.

The current AWS HTTPS rule permits IPv4 TCP port 443 to external destinations.

For stricter production egress control, use a suitable DNS-aware egress proxy or AWS network firewall architecture.

Validation

After deployment, verify:

1. DNS resolution works.
2. Prometheus connectivity works.
3. AWS Cost Explorer requests succeed.
4. EKS Pod Identity credentials are available.
5. Unauthorized application traffic is denied.

NetworkPolicy enforcement must be supported by the installed Kubernetes CNI.