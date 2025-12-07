resource "kubernetes_secret_v1" "flux_system_prometheus_substitutions" {
  metadata {
    name      = "prometheus-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "prometheus"
      "flux.kub3.uk/instance"    = "metrics"
      "flux.kub3.uk/application" = "prometheus"
      "flux.kub3.uk/component"   = "prometheus"
    })
  }

  type = "Opaque"

  data = {
    prometheus_client_id     = random_uuid.prometheus_client_id.result
    prometheus_client_secret = random_string.prometheus_client_secret.result
    prometheus_issuer_url    = data.authentik_provider_oauth2_config.prometheus.issuer_url
  }
}

resource "random_uuid" "prometheus_client_id" {}

resource "random_string" "prometheus_client_secret" {
  length = 64

  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "#|+-="

  keepers = {
    uuid = random_uuid.prometheus_client_id.result
  }
}

resource "authentik_provider_oauth2" "prometheus" {
  name = "prometheus-${terraform.workspace}"

  authentication_flow = data.authentik_flow.default_authentication_flow.id
  authorization_flow  = data.authentik_flow.default_authorization_flow.id
  invalidation_flow   = data.authentik_flow.default_invalidation_flow.id

  client_id     = random_uuid.prometheus_client_id.result
  client_secret = random_string.prometheus_client_secret.result
  signing_key   = data.authentik_certificate_key_pair.authentik_self_signed.id

  sub_mode = "user_email"

  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://prometheus.${var.cluster_domain}/oauth2/callback",
    }
  ]

  logout_uri    = "https://prometheus.${var.cluster_domain}/logout"
  logout_method = "frontchannel"
}

data "authentik_provider_oauth2_config" "prometheus" {
  provider_id = authentik_provider_oauth2.prometheus.id
}

resource "authentik_application" "prometheus" {
  name = "Prometheus (${title(terraform.workspace)})"
  slug = "prometheus-${terraform.workspace}"

  group            = "Observability"
  meta_description = "Prometheus Metrics for the ${terraform.workspace} Cluster"
  meta_icon        = "https://assets.n3t.uk/icons/prometheus-256x256.png"
  meta_launch_url  = "https://prometheus.${var.cluster_domain}/query"
  meta_publisher   = "Prometheus"

  protocol_provider = authentik_provider_oauth2.prometheus.id
}
