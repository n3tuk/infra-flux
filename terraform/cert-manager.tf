resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
    })
  }
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

resource "kubernetes_secret_v1" "certificates_system_cloudflare_token" {
  metadata {
    name      = "cloudflare-token"
    namespace = kubernetes_namespace_v1.cert_manager.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
    })
  }

  type = "Opaque"

  data = {
    "api-token" = cloudflare_api_token.cert_manager.value
  }
}
