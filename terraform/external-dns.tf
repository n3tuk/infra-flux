resource "cloudflare_api_token" "external_dns" {
  name = "external-dns@${var.cluster_domain}"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
    ]

    resources = {
      for zone in data.cloudflare_zone.n3tuk :
      "com.cloudflare.api.account.zone.${zone.id}" => "*"
    }
  }

  condition {
    request_ip {
      in = local.cloudflare_ip
    }
  }
}

resource "kubernetes_secret_v1" "flux_system_external_dns_substitutions" {
  metadata {
    name      = "external-dns-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "external-dns"
      "flux.kub3.uk/instance" = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    cloudflare_api_token = cloudflare_api_token.external_dns.value
  }
}
