# Crocus Terraform Azure Infrastructure

Crocus is a Terraform-based Azure infrastructure repository built for a secure hub-and-spoke architecture in the `japaneast` region. The project is organized around reusable child modules and environment-specific inputs so deployment logic can be reused across `dev`, `stage`, and `prod` without duplicating infrastructure code.

## Purpose

This repository is designed to provision a repeatable Azure landing zone and application platform. It supports:

- hub-and-spoke network segregation
- public ingress through an Application Gateway
- secure administrative access through Bastion
- frontend and backend workload tiers
- internal traffic distribution with a load balancer
- centralized monitoring with Log Analytics and Application Insights
- modular Terraform structure for reuse and maintenance

## Architecture overview

The design follows a standard hub-and-spoke pattern:

```text
Internet
   ↓
Application Gateway (hub)
   ↓
Frontend VMs (spoke)
   ↓
Internal Load Balancer
   ↓
Backend VMs (spoke)
   ↓
SQL workload on backend VM / data layer
```

### Hub layer
- Application Gateway
- Bastion
- shared public ingress/admin components

### Spoke layer
- frontend subnet for presentation-tier VMs
- backend subnet for internal workloads
- separate NSGs for tiered security boundaries

## Environment structure

The repository separates deployment logic by environment:

```text
env/
├── dev/
├── stage/
└── prod/
```

Each environment folder contains Terraform variables and deployment inputs used to drive the same reusable modules with different values.

## Root structure

```text
.
├── README.md
├── LICENSE
├── backend.tf
├── env/
│   ├── dev/
│   ├── stage/
│   └── prod/
├── modules/
│   ├── app/
│   ├── bastion/
│   ├── gateway/
│   ├── lb/
│   ├── monitoring/
│   ├── network/
│   ├── nic/
│   ├── nsg/
│   ├── nsg-association/
│   ├── private-access/
│   ├── public-ip/
│   ├── rg/
│   ├── sa/
│   ├── security/
│   └── vm/
├── credential_example/
├── .azuredevops/
├── .github/
└── docs/
```

## Key Terraform modules

The project is built with reusable child modules including:

- `modules/network` – VNets, subnets, and VNet peering
- `modules/nsg` – security group definitions
- `modules/nsg-association` – subnet-to-NSG mapping
- `modules/nic` – NIC creation for VMs
- `modules/vm` – Linux VM deployment
- `modules/lb` – internal load balancing
- `modules/gateway` – Azure Application Gateway
- `modules/bastion` – Azure Bastion
- `modules/public-ip` – public IP allocation
- `modules/monitoring` – Log Analytics and Application Insights
- `modules/sa` – storage account provisioning
- `modules/rg` – resource group provisioning

The parent environment configuration in `env/dev/main.tf` wires these modules together.

## Current resource design

The active design includes:

- resource groups
- storage account
- hub and spoke VNets
- subnets
- VNet peering
- NSGs and subnet associations
- NICs
- 4 Linux VMs (`Standard_F1als_v7`)
- 2 public IPs
- 1 Application Gateway
- 1 Bastion host
- 1 internal load balancer
- monitoring workspace and Application Insights

## Why 2 NSGs

The frontend and backend tiers are separated by different network security rules:

- frontend NSG: allows public ingress traffic for application access
- backend NSG: allows internal traffic and restricted data-layer access

This segmentation helps enforce a least-privilege network model.

## Why 2 public IPs

The current design uses two public IPs:

- 1 attached to the Application Gateway for internet traffic
- 1 attached to Bastion for admin access

## VNet peering

The hub and spoke VNets are peered through the `modules/network` module. The module loops through all VNets and creates a peering relationship for each pair, enabling communication between shared hub services and spoke workloads.

## Backend configuration

Terraform remote state is configured in `backend.tf`. It uses Azure Storage as the backend and requires real storage values before an actual environment deployment.

## Typical workflow

```bash
cd env/dev
terraform init
terraform validate
terraform plan
terraform apply
```

## Deployment notes

- The project targets Azure resources in `japaneast`
- The code is modular and environment-aware
- Some services are intentionally left as placeholders or commented modules until the real Azure environment is configured
- Real Azure backend values, subscription context, and credentials must be filled in before a live deployment

## Summary

Crocus is a modular Azure Terraform project for creating a secure hub-and-spoke infrastructure with ingress, frontend/backend workload tiers, internal distribution, monitoring, and reusable environment-driven deployment logic. It is structured to grow into a more complete enterprise platform while keeping the infrastructure code organized and reusable.

