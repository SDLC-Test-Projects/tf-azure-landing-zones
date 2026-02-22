TF ?= terraform
TFLINT ?= tflint
ENV ?= dev
ENV_DIR := envs/$(ENV)
VAR_FILE ?= terraform.tfvars

.PHONY: init plan apply fmt validate tflint lint hooks

init:
	$(TF) -chdir=$(ENV_DIR) init

plan:
	$(TF) -chdir=$(ENV_DIR) plan -var-file=$(VAR_FILE)

apply:
	$(TF) -chdir=$(ENV_DIR) apply -var-file=$(VAR_FILE)

fmt:
	$(TF) fmt -recursive

validate:
	$(TF) -chdir=$(ENV_DIR) validate

tflint:
	$(TFLINT) --init
	$(TFLINT) --chdir=$(ENV_DIR)

lint: fmt validate tflint

hooks:
	pre-commit install
	pre-commit run --all-files
