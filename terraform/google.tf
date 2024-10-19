provider "google" {
  project = "genuine-caiman"
  region  = "europe-west2"
  zone    = "europe-west2-a"

  default_labels = {
    environment = "development"
    deployer    = "terraform"
    owner       = "jonathan-wright"
  }
}
