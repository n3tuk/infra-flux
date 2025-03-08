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
