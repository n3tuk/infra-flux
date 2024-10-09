resource "kubernetes_manifest" "flux_system_baseline" {
  manifest = {
    "apiVersion" = "source.toolkit.fluxcd.io/v1beta2"
    "kind"       = "OCIRepository"

    "metadata" = {
      "name"      = "baseline"
      "namespace" = "flux-system"
      "labels"    = local.kubernetes_labels
    }

    "spec" = {
      "secretRef" = {
        "name" = "ghcr-login"
      }
      "provider" = "generic"
      "interval" = "1h"
      "url"      = "oci://ghcr.io/${var.flux_artifact_repository}"
      "ref" = {
        "tag" = var.flux_artifact_tag
      }
    }
  }
}

resource "kubernetes_manifest" "flux_system_cluster" {
  manifest = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1"
    "kind"       = "Kustomization"

    "metadata" = {
      "name"      = "cluster"
      "namespace" = "flux-system"
      "labels"    = local.kubernetes_labels
    }

    "spec" = {
      "sourceRef" = {
        "kind" = "OCIRepository"
        "name" = "baseline"
      }
      "interval" = "1h"
      "timeout"  = "2m"
      "path"     = "cluster"
      "prune"    = true
    }
  }

  depends_on = [
    kubernetes_manifest.flux_system_baseline
  ]
}

resource "kubernetes_config_map_v1" "common_substitutions" {
  metadata {
    name      = "common-substitutions"
    namespace = "flux-system"
  }

  data = {
    environment       = terraform.workspace
    label_repository  = "infra-flux"
    label_environment = terraform.workspace
    cluster_domain    = var.cluster_domain
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config.yaml"
  config_context = "admin@${terraform.workspace}"
}
