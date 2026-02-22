# Terraform Mono-Repo Scaffold

## Overview
This repository bootstraps a Terraform mono-repo meant to house shared modules and per-environment stacks. The goal is to give each team a consistent starting point with pinned tooling, clear workflows, and space for reusable infrastructure code.

## Requirements
- Terraform CLI >= 1.5.0 (install via `tfenv` or your package manager)
- (Optional) TFLint and pre-commit for linting once those hooks are wired in future tasks

## Directory Layout
```
.
├── README.md                  # Project documentation
├── versions.tf                # Required Terraform + provider versions
├── main.tf                    # Root configuration + backend placeholder
├── variables.tf               # Shared input variables
├── outputs.tf                 # Shared outputs
├── modules/                   # Reusable modules (to be added)
└── envs/                      # Per-environment stacks (to be added)
```

## Workflow
1. `terraform init` – run at the repository root (or individual env directories once they exist) to download providers and modules.
2. `terraform plan -var-file=terraform.tfvars` – review proposed changes. Copy `terraform.tfvars.example` to `terraform.tfvars` and adjust values before planning.
3. `terraform apply -var-file=terraform.tfvars` – apply only after reviewing the plan output.

> ⚠️ Backend configuration in `main.tf` is intentionally a placeholder. Replace the `local` backend with your remote state solution (e.g., S3 + DynamoDB, Azure Storage) before running `apply` in collaborative environments.

## Testing & Validation
- `terraform fmt -check` – enforce canonical formatting before committing.
- `terraform validate` – verify configuration syntax and provider requirements.
- (Future) `tflint` and `pre-commit run --all-files` – keep linting consistent once configured.

## Contributing
1. Create a feature branch.
2. Make Terraform changes with clear separation between modules and environment stacks.
3. Run formatting and validation commands listed above.
4. Open a pull request summarizing changes, validation output, and any follow-up work required.
