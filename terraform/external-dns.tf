# TODO: This will mostly likely require the creation of the Namespace for
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

resource "kubernetes_secret_v1" "flux_system_dns_system_n3tuk_rfc2136_key" {
  metadata {
    name      = "n3tuk-rfc2136-key"
    namespace = "dns-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "n3tuk"
      "flux.kub3.uk/instance" = "n3tuk"
      "flux.kub3.uk/part-of"  = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    "tsig-host"    = local.external_dns_bind_secrets.n3tuk.host
    "tsig-port"    = local.external_dns_bind_secrets.n3tuk.port
    "tsig-keyname" = local.external_dns_bind_secrets.n3tuk.keyname
    "tsig-secret"  = local.external_dns_bind_secrets.n3tuk.secret
    "tsig-alg"     = local.external_dns_bind_secrets.n3tuk.alg
  }
}

resource "kubernetes_secret_v1" "flux_system_dns_system_tailnet_rfc2136_key" {
  metadata {
    name      = "tailnet-rfc2136-key"
    namespace = "dns-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "tailnet"
      "flux.kub3.uk/instance" = "tailnet"
      "flux.kub3.uk/part-of"  = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    "tsig-host"    = local.external_dns_bind_secrets.tailnet.host
    "tsig-port"    = local.external_dns_bind_secrets.tailnet.port
    "tsig-keyname" = local.external_dns_bind_secrets.tailnet.keyname
    "tsig-secret"  = local.external_dns_bind_secrets.tailnet.secret
    "tsig-alg"     = local.external_dns_bind_secrets.tailnet.alg
  }
}
