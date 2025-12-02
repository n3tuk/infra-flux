resource "random_password" "tunnel" {
  length = 128

  lower   = true
  upper   = true
  numeric = true
  special = true
}

# Create and configure a tunnel in Cloudflare specific for this Kubernetes
# Cluster, and then configure the namespace and additional configuration
# directly into the Cluster

resource "cloudflare_zero_trust_tunnel_cloudflared" "cluster" {
  account_id = var.cloudflare_account_id

  name   = "kub3-${terraform.workspace}"
  secret = base64sha256(random_password.tunnel.result)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "cluster" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.cluster.id

  config {
    ingress_rule {
      hostname = "dashboard.${var.t3st_domain}"
      service  = "http://haproxy-external.ingress-system.svc"
      origin_request {
        connect_timeout = "3s"
      }
    }

    ingress_rule {
      hostname = "podinfo.${var.t3st_domain}"
      service  = "https://external.envoy-gateway.svc"

      origin_request {
        origin_server_name = "podinfo.${var.t3st_domain}"

        http2_origin    = true
        connect_timeout = "3s"
        tls_timeout     = "3s"
      }
    }

    dynamic "ingress_rule" {
      for_each = local.cloudflare_domains

      content {
        hostname = "*.${ingress_rule.value}"
        service  = "http://haproxy-external.ingress-system.svc"
        origin_request {
          connect_timeout = "3s"
        }
      }
    }

    ingress_rule {
      service = "http://haproxy-external.ingress-nginx.svc"
    }
  }
}

resource "kubernetes_config_map_v1" "flux_system_cloudflared_substitutions" {
  metadata {
    name      = "cloudflared-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "cloudflared"
      "flux.kub3.uk/instance" = "cloudflared"
    })
  }

  data = {
    cloudflared_account_id  = var.cloudflare_account_id
    cloudflared_tunnel_name = cloudflare_zero_trust_tunnel_cloudflared.cluster.name
    cloudflared_tunnel_id   = cloudflare_zero_trust_tunnel_cloudflared.cluster.id
  }
}

resource "kubernetes_secret_v1" "flux_system_cloudflared_substitutions" {
  metadata {
    name      = "cloudflared-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "cloudflared"
      "flux.kub3.uk/instance" = "cloudflared"
    })
  }

  type = "Opaque"

  data = {
    cloudflared_tunnel_secret = base64sha256(random_password.tunnel.result)
  }
}
