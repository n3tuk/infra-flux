data "google_secret_manager_secret_version" "proxmox_csi_plugin_token_secret" {
  secret = "github-infra-flux-${terraform.workspace}-proxmox-csi-plugin-token-secret"
}

data "google_secret_manager_secret_version" "flux_slack_token" {
  secret = "github-infra-flux-${terraform.workspace}-flux-slack-token"
}

data "google_secret_manager_secret_version" "flux_pagerduty_key" {
  secret = "github-infra-flux-${terraform.workspace}-flux-pagerduty-key"
}

data "google_secret_manager_secret_version" "alertmanager_slack_webhooks" {
  secret = "github-infra-flux-${terraform.workspace}-alertmanager-slack-webhooks"
}

data "google_secret_manager_secret_version" "alertmanager_pagerduty_key" {
  secret = "github-infra-flux-${terraform.workspace}-alertmanager-pagerduty-key"
}

data "google_secret_manager_secret_version" "alertmanager_incidentio_credentials" {
  secret = "github-infra-flux-${terraform.workspace}-alertmanager-incidentio-credentials"
}

data "google_secret_manager_secret_version" "external_dns_bind" {
  secret = "github-infra-flux-${terraform.workspace}-external-dns-bind"
}
