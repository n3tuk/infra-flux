resource "kubernetes_secret_v1" "flux_system_trivy_operator_substitutions" {
  metadata {
    name      = "trivy-operator-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "trivy-operator"
      "flux.kub3.uk/instance"    = "trivy-operator"
      "flux.kub3.uk/application" = "trivy-operator"
      "flux.kub3.uk/component"   = "operator"
    })
  }

  type = "Opaque"

  data = {
    trivy_operator_github_token = data.google_secret_manager_secret_version.trivy_operator_github_token.secret_data
  }
}

resource "kubernetes_secret_v1" "flux_system_trivy_operator_dashboard_substitutions" {
  metadata {
    name      = "trivy-operator-dashboard-substitutions"
    namespace = "flux-system"

    labels = merge(local.kubernetes_labels, {
      "flux.kub3.uk/name"        = "trivy-operator"
      "flux.kub3.uk/instance"    = "trivy-operator"
      "flux.kub3.uk/application" = "trivy-operator"
      "flux.kub3.uk/component"   = "operator"
    })
  }

  type = "Opaque"

  data = {
    trivy_operator_dashboard_client_id     = random_uuid.trivy_operator_dashboard_client_id.result
    trivy_operator_dashboard_client_secret = random_string.trivy_operator_dashboard_client_secret.result
  }
}


data "authentik_flow" "default_authorization_flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

resource "random_uuid" "trivy_operator_dashboard_client_id" {}

resource "random_string" "trivy_operator_dashboard_client_secret" {
  length = 64

  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "#|+-="

  keepers = {
    uuid = random_uuid.trivy_operator_dashboard_client_id.result
  }
}

resource "authentik_provider_oauth2" "trivy_operator_dashboard" {
  name = "trivy-operator-dashboard-${terraform.workspace}"

  authorization_flow = data.authentik_flow.default_authorization_flow.id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow.id

  client_id     = random_uuid.trivy_operator_dashboard_client_id.result
  client_secret = random_string.trivy_operator_dashboard_client_secret.result

  sub_mode = "user_email"

  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://trivy.${var.cluster_domain}/dashboard/auth/callback",
    }
  ]
}

resource "authentik_application" "trivy_operator_dashboard" {
  name = "trivy-operator-dashboard-${terraform.workspace}"
  slug = "trivy-operator-dashboard-${terraform.workspace}"

  group            = "Security"
  meta_description = "Trivy Operator Dashboard for the ${terraform.workspace} Cluster"
  meta_icon        = "https://assets.n3t.uk/icons/trivy-256x256.png"
  meta_launch_url  = "https://trivy.${var.cluster_domain}/dashboard"
  meta_publisher   = "Trivy Operator Dashboard"

  protocol_provider = authentik_provider_oauth2.trivy_operator_dashboard.id
}
