resource "kubernetes_namespace_v1" "metallb_system" {
  metadata {
    name = "metallb-system"

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"             = "metallb"
      "app.kubernetes.io/instance"         = "metallb"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    })
  }
}

resource "kubernetes_config_map_v1" "routing_substitutions" {
  metadata {
    name      = "routing-substitutions"
    namespace = "flux-system"
  }

  data = merge(
    {
      environment = terraform.workspace
      ipv4_pool   = var.metallb_pool_ipv4
      ipv6_pool   = var.metallb_pool_ipv6
    },
    {
      for router, address in var.metallb_routers
      : replace(router, "-", "_") => address
    },
  )
}
