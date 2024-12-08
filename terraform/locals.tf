locals {
  kubernetes_labels = {
    "flux.kub3.uk/managed-by" = "terraform"
    "flux.kub3.uk/repository" = "infra-flux"
    "flux.kub3.uk/cluster"    = terraform.workspace
  }
}
