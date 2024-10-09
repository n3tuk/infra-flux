locals {
  cloudflare_domains = [
    "kub3.uk",
    "pip3.uk",
    "sit3.uk",
    "liv3.uk",
    "t3st.uk",
  ]

  cloudflare_ip = [
    "82.69.106.64/32",
    "2a02:8010:8006::/48",
  ]

  kubernetes_labels = {
    "app.kubernetes.io/managed-by"  = "Terraform"
    "app.kubernetes.io/repository"  = "infra-flux"
    "app.kubernetes.io/environment" = terraform.workspace
  }
}
