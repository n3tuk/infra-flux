locals {
  cloudflare_domains = [
    "kub3.uk",
    "pip3.uk",
    "sit3.uk",
    "liv3.uk",
    "t3st.uk",
  ]

  kubernetes_labels = {
    "flux.kub3.uk/managed-by" = "terraform"
    "flux.kub3.uk/repository" = "infra-flux"
    "flux.kub3.uk/cluster"    = terraform.workspace
  }
}
