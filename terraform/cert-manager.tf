data "cloudflare_api_token_permission_groups" "all" {}

data "cloudflare_zone" "n3tuk" {
  for_each = toset(local.cloudflare_domains)
  name     = each.value
}

resource "cloudflare_api_token" "cert_manager" {
  name = "cert-manager@${var.cluster_domain}"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
      data.cloudflare_api_token_permission_groups.all.zone["SSL and Certificates Write"],
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

resource "kubernetes_secret_v1" "flux_system_cert_manager_substitutions" {
  metadata {
    name      = "cert-manager-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "cert-manager"
      "flux.kub3.uk/instance" = "cert-manager"
    })
  }

  type = "Opaque"

  data = {
    "cloudflare_api_token" = cloudflare_api_token.cert_manager.value
  }
}
