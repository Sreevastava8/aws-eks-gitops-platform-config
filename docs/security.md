Security Architecture

Overview

The GitOps Karpenter FinOps Engine implements security controls across infrastructure provisioning, Kubernetes workloads, secrets management, CI/CD and application deployment.

Infrastructure Security

Terraform provisions AWS infrastructure using:

* Private EKS worker nodes.
* IAM least-privilege permissions.
* Security groups.
* Encrypted Terraform state.
* S3 versioning.
* AWS KMS encryption.

Kubernetes Authentication

Workloads use EKS Pod Identity for AWS authentication.

Separate IAM permissions are maintained for:

* Karpenter controller.
* Karpenter worker nodes.
* External Secrets Operator.
* FinOps Engine.

IAM permissions should follow least-privilege principles.

Secrets Management

AWS Secrets Manager stores sensitive application credentials.

External Secrets Operator synchronizes required credentials into Kubernetes Secrets.

Sensitive values must never be committed to Git.

Container Security

The FinOps application uses:

* Non-root execution.
* Read-only root filesystem.
* Disabled privilege escalation.
* Dropped Linux capabilities.
* RuntimeDefault seccomp profile.
* CPU and memory resource limits.

Network Security

Kubernetes NetworkPolicies control application communication.

The FinOps application requires access to:

* CoreDNS.
* Prometheus.
* AWS Cost Explorer HTTPS endpoints.
* EKS Pod Identity credential endpoint.

The current broad HTTPS egress rule is a documented limitation. Production deployments requiring strict destination controls should use a suitable egress proxy or firewall.

DevSecOps Scanning

The project integrates the following security tools:

Tool	Purpose
Gitleaks	Secret detection
Trivy	Container and filesystem scanning
SonarQube	Code quality and security analysis
Checkov	Terraform and IaC scanning
TFLint	Terraform linting
Bandit	Python security scanning
pip-audit	Python dependency vulnerability scanning
Semgrep	Static application security analysis
Hadolint	Dockerfile linting

Deployment Security

Changes should pass automated validation and security scanning before deployment.

Production deployment should require explicit approval.

Security Operations

Security findings should be reviewed, prioritized and resolved before production deployment.

AWS credentials, passwords, API keys and Terraform state must never be committed to source control.