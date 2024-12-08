provider "google" {
  project = "genuine-caiman"
  region  = "europe-west2"
  zone    = "europe-west2-a"

  default_labels = {
    environment = terraform.workspace
    deployer    = "terraform"
    owner       = "jonathan-n3t-uk"
  }
}

provider "cloudflare" {
  retries = 3
}

provider "kubernetes" {
  config_path    = "~/.kube/config.yaml"
  config_context = "admin@${terraform.workspace}"
}
