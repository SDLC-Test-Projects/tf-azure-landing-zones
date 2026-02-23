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

### Azure App Service Template
- Root `variables.tf` exposes `enable_app_service` plus inputs for plan name/SKU, Linux runtime stack, optional container image, app settings, and slot definitions. Each environment (`envs/dev`, `envs/prod`) defines locals for the names and SKUs it should use and passes them into `module "app_service"`.
- In your chosen `terraform.tfvars`, set `enable_app_service = true` and provide any overrides that differ from the environment defaults (for example, a custom runtime or slot map).
- Optional deployment slots can be declared by populating the slot object list input; each entry adds its own `azurerm_linux_web_app_slot` with the provided settings and inherits shared tags.
- Example snippet to drop into your environment var file:
```
enable_app_service         = true
app_service_app_name       = "quechua-dev-web"
app_service_plan_sku_tier  = "P1v3"
app_service_plan_sku_size  = "P1v3"
app_service_runtime_stack  = {
  stack = "node"
  version = "18-lts"
}
app_service_slots = [
  {
    name              = "staging"
    configuration_map = {
      APP_ENV = "staging"
    }
  }
]
```
- After toggling the module, rerun `make plan ENV=dev VAR_FILE=terraform.tfvars` (and for `prod` as needed) to confirm the App Service plan, web app, and slot resources are in the graph. Use `make apply` once the plan looks correct to provision the Linux plan, web app, and outputs such as the default hostname.

### Choosing a Cloud Network Target
- **AWS default**: leave `enable_azure_network = false` and populate the existing AWS-specific inputs.
- **Azure**: set `enable_azure_network = true`, define `azure_vnet_address_space`, and populate `azure_subnet_prefixes` (plus optional `azure_subnet_name_map`). Confirm Azure credentials via `azure_subscription_id`/`azure_tenant_id`.
- After toggling, re-run `make plan ENV=dev VAR_FILE=terraform.tfvars` to verify the selected network graph.

The module structure allows enabling only one provider at a time today; future work can orchestrate multi-cloud deployments within the same environment definition.

> ⚠️ Backend configuration in `main.tf` is intentionally a placeholder. Replace the `local` backend with your remote state solution (e.g., S3 + DynamoDB, Azure Storage) before running `apply` in collaborative environments.

## Testing & Validation
- `make fmt` – enforce canonical formatting before committing.
- `make validate` – verify configuration syntax and provider requirements.
- `make tflint` – lint provider usage inside the selected environment directory.
- `make lint` – run the full suite locally; CI should mirror this target.
- `make hooks` – install and execute pre-commit hooks (fmt, validate, tflint) across the repo.
- When App Service is enabled, include `make plan ENV=<env> VAR_FILE=terraform.tfvars` to compare environment-specific inputs (plan SKU, runtime, slots) and ensure hostnames/outputs align with expectations before applying.

## Contributing
1. Create a feature branch.
2. Make Terraform changes with clear separation between modules and environment stacks.
3. Run `make lint` (and optionally `make hooks`) to ensure fmt/validate/tflint all pass.
4. Open a pull request summarizing changes, validation output, and any follow-up work required.
