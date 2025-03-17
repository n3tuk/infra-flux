# This password is not currently configured

resource "random_password" "elastic_logs_fluent_bit_password" {
  length           = 64
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!()-+<>"
}

resource "random_password" "elastic_logs_exporter_password" {
  length           = 64
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!()-+<>"
}

resource "random_password" "elastic_logs_grafana_password" {
  length           = 64
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!()-+<>"
}

resource "kubernetes_secret_v1" "flux_system_elastic_logs_credentials" {
  metadata {
    name      = "elastic-logs-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"     = "elastic-logs"
      "flux.kub3.uk/instance" = "elastic-logs"
    })
  }

  type = "Opaque"

  data = {
    elasticsearch_fluent_bit_password = random_password.elastic_logs_fluent_bit_password.result
    elasticsearch_exporter_password   = random_password.elastic_logs_exporter_password.result
    elasticsearch_grafana_password    = random_password.elastic_logs_grafana_password.result
  }
}
