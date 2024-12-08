# The deployment of these resources requires that the Flux CRDs have already
# been deployed, or the OCIRepository nor Kustomization resource will not be
# available and the Kubernetes provider will fail to plan. Ensure the
# boot-strapping process is followed before planning this Terraform
# configuration

resource "kubernetes_manifest" "flux_system_baseline" {
  manifest = {
    "apiVersion" = "source.toolkit.fluxcd.io/v1beta2"
    "kind"       = "OCIRepository"

    "metadata" = {
      "name"      = "baseline"
      "namespace" = "flux-system"

      "labels" = merge(local.kubernetes_labels, {
        "flux.kub3.uk/name"     = "flux"
        "flux.kub3.uk/instance" = "flux"
      })
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

      "labels" = merge(local.kubernetes_labels, {
        "flux.kub3.uk/name"     = "flux"
        "flux.kub3.uk/instance" = "flux"
      })
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
