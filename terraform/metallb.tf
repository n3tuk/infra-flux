resource "kubernetes_config_map_v1" "flux_system_routing_substitutions" {
  metadata {
    name      = "routing-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "metallb"
      "flux.kub3.uk/instance" = "metallb"
    })
  }

  data = merge(
    {
      ipv4_pool = var.metallb_pool_ipv4
      ipv6_pool = var.metallb_pool_ipv6
    },
    {
      for router, address in var.metallb_routers
      : replace(router, "-", "_") => address
    },
  )
}
