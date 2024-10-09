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
    dynamic "ingress_rule" {
      for_each = local.cloudflare_domains

      content {
        hostname = "*.${ingress_rule.value}"
        service  = "http://ingress-nginx-controller.ingress-system"
        origin_request {
          connect_timeout = "10s"
        }
      }
    }

    ingress_rule {
      service = "http://ingress-nginx-controller.ingress-system"
    }
  }
}

resource "kubernetes_namespace_v1" "cloudflare_system" {
  metadata {
    name = "cloudflare-system"

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "cloudflare-tunnel"
      "app.kubernetes.io/instance" = "tunnel"
    })
  }
}

resource "kubernetes_secret_v1" "cloudflare_system_tunnel_credentials" {
  metadata {
    name      = "tunnel-credentials"
    namespace = kubernetes_namespace_v1.cloudflare_system.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "cloudflare-tunnel"
      "app.kubernetes.io/instance" = "tunnel"
    })
  }

  type = "Opaque"

  data = {
    "credentials.json" = jsonencode({
      AccountTag   = var.cloudflare_account_id
      TunnelSecret = base64sha256(random_password.tunnel.result)
      TunnelName   = "kub3-${terraform.workspace}"
      TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.cluster.id
    })
  }
}

resource "kubernetes_config_map_v1" "cloudflare_system_helm_tunnel_overrides" {
  metadata {
    name      = "helm-tunnel-overrides"
    namespace = kubernetes_namespace_v1.cloudflare_system.id

    labels = merge(local.kubernetes_labels, {
      "app.kubernetes.io/name"     = "cloudflare-tunnel"
      "app.kubernetes.io/instance" = "tunnel"
    })
  }

  data = {
    "values.yaml" = yamlencode({
      cloudflare = {
        tunnelName = cloudflare_zero_trust_tunnel_cloudflared.cluster.cname
        secretName = kubernetes_secret_v1.cloudflare_system_tunnel_credentials.metadata[0].name
      }
    })
  }
}
