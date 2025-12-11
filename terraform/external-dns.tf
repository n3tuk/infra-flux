# TODO: This will most likely require the creation of the Namespace for
#       dns-system first in order to allow the Secrets to be created there
#       during the initial bootstrapping of the cluster.

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

resource "kubernetes_secret_v1" "flux_system_dns_system_cloudflare_token" {
  metadata {
    name      = "cloudflare-token"
    namespace = "dns-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "cloudflare"
      "flux.kub3.uk/instance" = "cloudflare"
      "flux.kub3.uk/part-of"  = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    "api-token" = cloudflare_api_token.external_dns.value
  }
}

resource "kubernetes_secret_v1" "flux_system_dns_system_internal_rfc2136_key" {
  metadata {
    name      = "internal-rfc2136-key"
    namespace = "dns-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "internal"
      "flux.kub3.uk/instance" = "internal"
      "flux.kub3.uk/part-of"  = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    "tsig-host"    = local.external_dns_bind_secrets.internal.host
    "tsig-port"    = local.external_dns_bind_secrets.internal.port
    "tsig-keyname" = local.external_dns_bind_secrets.internal.keyname
    "tsig-secret"  = local.external_dns_bind_secrets.internal.secret
    "tsig-alg"     = local.external_dns_bind_secrets.internal.alg
  }
}

resource "kubernetes_secret_v1" "flux_system_dns_system_tailscale_rfc2136_key" {
  metadata {
    name      = "tailscale-rfc2136-key"
    namespace = "dns-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "tailscale"
      "flux.kub3.uk/instance" = "tailscale"
      "flux.kub3.uk/part-of"  = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    "tsig-host"    = local.external_dns_bind_secrets.tailscale.host
    "tsig-port"    = local.external_dns_bind_secrets.tailscale.port
    "tsig-keyname" = local.external_dns_bind_secrets.tailscale.keyname
    "tsig-secret"  = local.external_dns_bind_secrets.tailscale.secret
    "tsig-alg"     = local.external_dns_bind_secrets.tailscale.alg
  }
}
