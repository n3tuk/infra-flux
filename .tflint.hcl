config {
  format     = "default"
  plugin_dir = "~/.tflint.d/plugins"
}

plugin "terraform" {
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.9.1"
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

# Using main.tf is not always the best option for managing resources and data
# sources within larger modules and Terraform configurations
rule "terraform_standard_module_structure" {
  enabled = false
}

# tflint cannot always traverse included Terraform Modules, which means it may
# not be aware of provider usage within Modules and so report a false negative
rule "terraform_unused_required_providers" {
  enabled = false
}

plugin "aws" {
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.33.0"
  enabled = true
  # Disable additional checks which require AWS Access
  deep_check = false
}

rule "aws_iam_policy_document_gov_friendly_arns" {
  enabled = true
}

rule "aws_iam_policy_gov_friendly_arns" {
  enabled = true
}

rule "aws_iam_role_policy_gov_friendly_arns" {
  enabled = true
}

rule "aws_resource_missing_tags" {
  enabled = true

  tags = ["Name"]
}

plugin "google" {
  source  = "github.com/terraform-linters/tflint-ruleset-google"
  version = "0.30.0"
  enabled = true
}
