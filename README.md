
# Crocus: Enterprise-Grade Azure Infrastructure & DevOps Automation 

---

## Overview
**Crocus** is a **modular, secure, and enterprise-ready Infrastructure as Code (IaC) framework** built with **Terraform** and **Azure DevOps**.  

It provisions, manages, and governs complete Azure environments — from **foundational landing zones** to **complex microservices platforms** — while following strict **DevSecOps principles**.

This repository acts as the **parent module / control plane**, orchestrating a library of **generic, versioned Terraform modules** to deliver consistent and compliant infrastructure across **Sandbox, Development, and Production** environments.

---

## 🚦 Getting Started

### Prerequisites
- Azure subscription with **Contributor** role  
- Azure DevOps project configured  
- Terraform `>= 1.0.0` installed locally  
- Azure CLI installed & authenticated  

### Deploying (Dev Environment)

```bash
# Clone the repository
git clone https://github.com/tripathicle/Crocus.git
cd crocus-iac-env

# Navigate to environment
cd environments/development

# Initialize Terraform
terraform init

# Plan & Apply (local testing only; use pipeline for official)
terraform plan -out=tfplan
terraform apply tfplan

```

---

## Features & Highlights

- **Generic & Modular IaC**  
  - Dynamic blocks and `for_each` loops for all Azure services.  
  - Modules for Management Groups, Subscriptions, Networking, AKS, App Gateway, Front Door, etc.  

- **End-to-End DevSecOps Pipeline**  
  - Automated CI/CD with:
    - Linting → `tflint`
    - Security scans → `checkov`, `tfsec`, `trufflehog`
    - Compliance checks → Chef InSpec
    - Quality gates → SonarQube  

- **Multi-Environment Strategy**  
  - Blueprints for Sandbox, Development, and Production with approvals and environment-specific variables.  

- **Security & Governance**  
  - Azure Policies (built-in + custom), aligned with **CIS Benchmarks & GDPR**.  
  - Remote state files encrypted with **Customer Managed Keys (CMK)**.  

- **Microservices & AKS Ready**  
  - AKS landing zones, ACR, Key Vault, Bastion Hosts.  
  - GitOps (ArgoCD) & Helm adoption planned.  

- **Operational Excellence**  
  - Prometheus, Grafana, and Datadog monitoring.  
  - Automated backup & rollback pipelines for resilience.  

---

## Architecture Overview

### Multi-Repository Strategy
- **Generic Modules** → `Parent-Child-Env Modules`  
  Each Azure service has its own dedicated, versioned Terraform module.  

- **This Repository** → `crocus-iac-env-solutions`  
  Acts as the **root module** that:
  - Calls generic modules
  - Injects environment-specific configs
  - Defines dependencies

### High-Level Infrastructure Stack

```
Management Groups
- └── Subscriptions 
-  └── Resource Groups
-  └── VNets & Subnets
-  ├── VPN Gateways
-  ├── Load Balancers
-  ├── Application Gateway / Front Door / Traffic-Manager
-  └── AKS / ACR / Key Vault / Bastion

```

Landing zones are provisioned with a **hierarchical structure**, ensuring **isolation, security, and compliance**.

---

## Provisioning Flow

### Adding New Infrastructure (e.g., VM)
1. **Branch** → Create a feature branch from `main`.  
2. **Code** → Update Terraform configs to call required modules.  
3. **PR & Checks** → Raise a PR to trigger pipeline:
   - `terraform validate`, `tflint`, `checkov`, `tfsec`, `trufflehog`
   - Chef InSpec compliance tests  
4. **Plan & Approve** → `terraform plan` reviewed & approved (GenTest Job).  
5. **Apply** → Changes applied to Development.  
6. **Promote to Prod** → Additional governance approvals required.  

### Application Deployment (Monolithic & Microservices)
- **CI** → PR triggers build, scans (SonarQube, Checkmarx), and artifact publishing to **Azure Artifacts**.  
- **CD** → Artifacts deployed across environments (Dev → Test → QA → Prod).  
- **Governance** → Manual approvals at each promotion stage.  
- **Rollback** → Dedicated rollback pipeline redeploys last stable artifact.  

---

## Technology Stack

| Category               | Tools / Services                                                                 |
|-------------------------|----------------------------------------------------------------------------------|
| **Infrastructure**     | Terraform                                                                        |
| **CI/CD**              | Azure DevOps (YAML Pipelines)                                                    |
| **Code Repo**          | Azure Repos (Git)                                                                |
| **Remote State**       | Azure Blob Storage (CMK encryption)                                              |
| **Secrets Mgmt**       | Azure Key Vault                                                                  |
| **Security Scanning**  | Checkov, TFSEC, TruffleHog                                                       |
| **Quality & SAST**     | SonarQube, Checkmarx                                                             |
| **Compliance**         | Chef InSpec                                                                      |
| **Artifacts**          | Azure Artifacts / JFrog / Nexus                                                  |
| **Containers**         | ACR, AKS, Helm (POC), ArgoCD (Planned)                                           |
| **Monitoring**         | Prometheus, Grafana, Datadog                                                     |
| **Backup & DR**        | Azure Backup                                                                     |

---

## Repository Structure

## Contributing
We follow a trunk-based development strategy for infrastructure code and a GitFlow-like strategy for application code.

1. Fork the repository.
2. Create your feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   git commit -m 'Add some amazing feature'
   git push origin feature/amazing-feature


## 📜 License
This project is proprietary and licensed under the [customer's agreement](./LICENSE).  
Not publicly distributed




