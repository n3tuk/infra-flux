# The deployment of this resource requires that the Flux Namespace has already
# been created, or the ConfigMap cannot be deployed. Ensure the boot-strapping
# process is followed before planning this Terraform configuration

resource "kubernetes_config_map_v1" "common_substitutions" {
  metadata {
    name      = "common-substitutions"
    namespace = "flux-system"
  }

  data = {
    cluster        = terraform.workspace
    cluster_domain = var.cluster_domain
    root_domain    = var.root_domain
    t3st_domain    = var.t3st_domain
    sit3_domain    = var.sit3_domain
  }
}