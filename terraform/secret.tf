data "google_secret_manager_secret_version" "proxmox_csi_plugin_token_secret" {
  secret = "github-infra-flux-${terraform.workspace}-proxmox-csi-plugin-token-secret"
}

data "google_secret_manager_secret_version" "flux_slack_token" {
  secret = "github-infra-flux-${terraform.workspace}-flux-slack-token"
}

data "google_secret_manager_secret_version" "flux_pagerduty_key" {
  secret = "github-infra-flux-${terraform.workspace}-flux-pagerduty-key"
}

data "google_secret_manager_secret_version" "alertmanager_slack_token" {
  secret = "github-infra-flux-${terraform.workspace}-alertmanager-slack-token"
}

data "google_secret_manager_secret_version" "alertmanager_pagerduty_key" {
  secret = "github-infra-flux-${terraform.workspace}-alertmanager-pagerduty-key"
}
