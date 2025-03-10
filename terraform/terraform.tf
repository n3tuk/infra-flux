terraform {
  required_version = "~> 1.10.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.6"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.1"
    }
  }

  backend "gcs" {
    bucket = "n3tuk-genuine-caiman-terraform-states"
    prefix = "github/n3tuk/infra-flux"
  }
}
