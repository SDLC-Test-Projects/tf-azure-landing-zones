# Terraform Mono-Repo Scaffold

## Overview
This repository bootstraps a Terraform mono-repo meant to house shared modules and per-environment stacks. The goal is to give each team a consistent starting point with pinned tooling, clear workflows, and space for reusable infrastructure code.

## Requirements
- Terraform CLI >= 1.5.0 (install via `tfenv` or your package manager)
- TFLint >= 0.51.0 for provider linting
- pre-commit >= 3.0.0 for local hook execution

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
1. `make init ENV=dev` – run Terraform init inside the desired environment directory (swap `dev` for `prod`).
2. `make plan ENV=dev VAR_FILE=terraform.tfvars` – review proposed changes. Copy `terraform.tfvars.example` to `terraform.tfvars` and adjust values before planning.
3. `make apply ENV=dev VAR_FILE=terraform.tfvars` – apply only after reviewing the plan output.
4. `make lint` – run fmt/validate/tflint checks in one go.

> ⚠️ Backend configuration in `main.tf` is intentionally a placeholder. Replace the `local` backend with your remote state solution (e.g., S3 + DynamoDB, Azure Storage) before running `apply` in collaborative environments.

## Testing & Validation
- `make fmt` – enforce canonical formatting before committing.
- `make validate` – verify configuration syntax and provider requirements.
- `make tflint` – lint provider usage inside the selected environment directory.
- `make lint` – run the full suite locally; CI should mirror this target.
- `make hooks` – install and execute pre-commit hooks (fmt, validate, tflint) across the repo.

## Contributing
1. Create a feature branch.
2. Make Terraform changes with clear separation between modules and environment stacks.
3. Run `make lint` (and optionally `make hooks`) to ensure fmt/validate/tflint all pass.
4. Open a pull request summarizing changes, validation output, and any follow-up work required.
