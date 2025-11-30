resource "tailscale_oauth_client" "cluster" {
  description = "OAuth client for ${terraform.workspace} Kubernetes cluster"

  scopes = [
    "devices:core",
    "auth_keys",
    "services",
  ]

  tags = [
    "tag:${var.tailscale_operator_tag}",
  ]
}

resource "kubernetes_namespace_v1" "tailscale_operator" {
  metadata {
    name = "tailscale-operator"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "tailscale"
      "flux.kub3.uk/instance"    = "tailscale"
      "flux.kub3.uk/application" = "tailscale"
      "flux.kub3.uk/component"   = "operator"
      "pod-security.kubernetes.io/enforce" : "privileged"
      "pod-security.kubernetes.io/audit" : "privileged"
      "pod-security.kubernetes.io/warn" : "privileged"
    })
  }
}

resource "kubernetes_secret_v1" "tailscale_operator_tailscale_oauth_client" {
  metadata {
    name      = "tailscale-oauth-client"
    namespace = kubernetes_namespace_v1.tailscale_operator.id

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "tailscale"
      "flux.kub3.uk/instance"    = "tailscale"
      "flux.kub3.uk/application" = "tailscale"
      "flux.kub3.uk/component"   = "operator"
    })
  }

  type = "Opaque"

  data = {
    client_id     = tailscale_oauth_client.cluster.id
    client_secret = tailscale_oauth_client.cluster.key
  }
}

resource "kubernetes_config_map_v1" "tailscale_substitutions" {
  metadata {
    name      = "tailscale-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "tailscale-operator"
      "flux.kub3.uk/instance"    = "tailscale-operator"
      "flux.kub3.uk/application" = "tailscale"
      "flux.kub3.uk/component"   = "operator"
    })
  }

  data = {
    tailscale_oauth_secret_name = kubernetes_secret_v1.tailscale_operator_tailscale_oauth_client.metadata[0].name
    tailscale_tag               = "tag:${var.tailscale_operator_tag}"
  }

  depends_on = [
    kubernetes_namespace_v1.tailscale_operator,
    kubernetes_secret_v1.tailscale_operator_tailscale_oauth_client,
  ]
}
