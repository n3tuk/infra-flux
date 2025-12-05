# TODO: This will most likely require the creation of the Namespace for
#       prometheus-metrics first in order to allow the Secrets to be created
#       there during the initial bootstrapping of the cluster.

resource "kubernetes_secret_v1" "prometheus_metrics_slack_webhooks" {
  metadata {
    name      = "slack-webhooks"
    namespace = "prometheus-metrics"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "alertmanager"
      "flux.kub3.uk/instance" = "slack"
    })
  }

  type = "Opaque"

  # The Secrets Manager Secret is already configured in a JSON blob, decode it
  # here and then pass it directly into the Secret
  data = jsondecode(
    data.google_secret_manager_secret_version.alertmanager_slack_webhooks.secret_data
  )
}

resource "kubernetes_secret_v1" "prometheus_metrics_pagerduty_keys" {
  metadata {
    name      = "pagerduty-keys"
    namespace = "prometheus-metrics"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "alertmanager"
      "flux.kub3.uk/instance" = "pagerduty"
    })
  }

  type = "Opaque"

  data = {
    service-key = data.google_secret_manager_secret_version.alertmanager_pagerduty_key.secret_data
  }
}

resource "kubernetes_secret_v1" "prometheus_metrics_incidentio_credentials" {
  metadata {
    name      = "incidentio-credentials"
    namespace = "prometheus-metrics"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "alertmanager"
      "flux.kub3.uk/instance" = "incidentio"
    })
  }

  type = "Opaque"

  data = {
    credentials = data.google_secret_manager_secret_version.alertmanager_incidentio_credentials.secret_data
  }
}

resource "kubernetes_secret_v1" "flux_system_alertmanager_substitutions" {
  metadata {
    name      = "alertmanager-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "alertmanager"
      "flux.kub3.uk/instance"    = "metrics"
      "flux.kub3.uk/application" = "alertmanager"
      "flux.kub3.uk/component"   = "alertmanager"
    })
  }

  type = "Opaque"

  data = {
    alertmanager_client_id     = random_uuid.alertmanager_client_id.result
    alertmanager_client_secret = random_string.alertmanager_client_secret.result
    alertmanager_issuer_url    = data.authentik_provider_oauth2_config.alertmanager.issuer_url
  }
}

resource "random_uuid" "alertmanager_client_id" {}

resource "random_string" "alertmanager_client_secret" {
  length = 64

  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "#|+-="

  keepers = {
    uuid = random_uuid.alertmanager_client_id.result
  }
}

resource "authentik_provider_oauth2" "alertmanager" {
  name = "alertmanager-${terraform.workspace}"

  authentication_flow = data.authentik_flow.default_authentication_flow.id
  authorization_flow  = data.authentik_flow.default_authorization_flow.id
  invalidation_flow   = data.authentik_flow.default_invalidation_flow.id

  client_id     = random_uuid.alertmanager_client_id.result
  client_secret = random_string.alertmanager_client_secret.result
  signing_key   = data.authentik_certificate_key_pair.authentik_self_signed.id

  sub_mode = "user_email"

  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://alerts.${var.cluster_domain}/oauth2/callback",
    }
  ]

  logout_uri    = "https://alerts.${var.cluster_domain}/logout"
  logout_method = "frontchannel"
}

data "authentik_provider_oauth2_config" "alertmanager" {
  provider_id = authentik_provider_oauth2.alertmanager.id
}

resource "authentik_application" "alertmanager" {
  name = "Alertmanager (${title(terraform.workspace)})"
  slug = "alertmanager-${terraform.workspace}"

  group            = "Observability"
  meta_description = "Prometheus Alertmanager for the ${terraform.workspace} Cluster"
  meta_icon        = "https://assets.n3t.uk/icons/prometheus-256x256.png"
  meta_launch_url  = "https://alerts.${var.cluster_domain}/#/alerts"
  meta_publisher   = "Prometheus"

  protocol_provider = authentik_provider_oauth2.alertmanager.id
}
