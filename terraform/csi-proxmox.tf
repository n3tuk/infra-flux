resource "kubernetes_namespace_v1" "csi_proxmox" {
  metadata {
    name = "csi-proxmox"

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"             = "proxmox-csi"
      "app.kubernetes.io/instance"         = "proxmox-csi"
      "pod-security.kubernetes.io/enforce" = "privileged"
    })
  }
}

resource "kubernetes_secret_v1" "csi_proxmox_helm_proxmox_csi_overrides" {
  metadata {
    name      = "helm-proxmox-csi-overrides"
    namespace = kubernetes_namespace_v1.csi_proxmox.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "proxmox-csi"
      "app.kubernetes.io/instance" = "proxmox-csi"
    })
  }

  type = "Opaque"

  data = {
    "values.yaml" = yamlencode({
      config = {
        clusters = [
          {
            url          = "https://proxmox.${var.cluster_domain}:8006/api2/json"
            token_id     = var.proxmox_csi_plugin_token_id
            token_secret = var.proxmox_csi_plugin_token_secret
            region       = terraform.workspace
          },
        ],
      }
    })
  }
}
