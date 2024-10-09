locals {
  kubernetes_labels = {
    "kub3.uk/managed-by" = "Terraform"
    "kub3.uk/repository" = "infra-flux"
    "kub3.uk/cluster"    = terraform.workspace
  }
}
