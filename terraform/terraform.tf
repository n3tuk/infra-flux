terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.24"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.10.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }

  backend "gcs" {
    bucket = "n3tuk-genuine-caiman-terraform-states"
    prefix = "github/n3tuk/infra-flux"
  }
}
