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

  data = {
    alerts = data.google_secret_manager_secret_version.alertmanager_slack_token.secret_data
  }
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
