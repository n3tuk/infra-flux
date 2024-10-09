terraform {
  required_version = "~> 1.10.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2"
    }
  }

  backend "gcs" {
    bucket = "n3tuk-genuine-caiman-terraform-states"
    prefix = "github/n3tuk/infra-flux"
  }
}
