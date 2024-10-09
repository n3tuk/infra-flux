resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "external-dns"
      "app.kubernetes.io/instance" = "external-dns"
    })
  }
}

resource "kubernetes_config_map_v1" "external_dns_helm_cloudflare_overrides" {
  metadata {
    name      = "helm-cloudflare-overrides"
    namespace = kubernetes_namespace_v1.external_dns.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "external-dns"
      "app.kubernetes.io/instance" = "external-dns"
    })
  }

  data = {
    "values.yaml" = yamlencode({
      domainFilters = local.cloudflare_domains
      # Make sure we specify which EKS Cluster any created DNS record will
      # belong to is set to the name of the cluster it is deployed for
      txtOwnerId = "${var.cluster_domain}/cloudflare"
    })
  }
}

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

resource "kubernetes_secret_v1" "external_dns_cloudflare_token" {
  metadata {
    name      = "cloudflare-token"
    namespace = kubernetes_namespace_v1.external_dns.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "external-dns"
      "app.kubernetes.io/instance" = "external-dns"
    })
  }

  type = "Opaque"

  data = {
    token = cloudflare_api_token.external_dns.value
  }
}
