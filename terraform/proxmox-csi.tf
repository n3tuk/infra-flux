resource "kubernetes_config_map_v1" "proxmox_csi_substitutions" {
  metadata {
    name      = "proxmox-csi-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "kub3.uk/name"     = "proxmox-csi"
      "kub3.uk/instance" = "proxmox-csi"
    })
  }

  data = {
    proxmox_csi_url      = "https://proxmox.${var.cluster_domain}:8006/api2/json"
    proxmox_csi_token_id = var.proxmox_csi_plugin_token_id
    proxmox_csi_region   = terraform.workspace
  }
}

resource "kubernetes_secret_v1" "proxmox_csi_substitutions" {
  metadata {
    name      = "proxmox-csi-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "kub3.uk/name"     = "proxmox-csi"
      "kub3.uk/instance" = "proxmox-csi"
    })
  }

  type = "Opaque"

  data = {
    proxmox_csi_token_secret = var.proxmox_csi_plugin_token_secret
  }
}
