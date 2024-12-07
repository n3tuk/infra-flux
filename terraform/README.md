# n3t.uk Flux Artifact Repository

TODO

<!-- terraform-docs-start -->
<!-- prettier-ignore-start -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.25.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map_v1.common_substitutions](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_manifest.flux_system_baseline](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.flux_system_cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The external domain name of the EKS Cluster (i.e. the domain suffix for deployed services) | `string` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | The root external domain name of the EKS Cluster (i.e. the domain suffix for selected services) | `string` | n/a | yes |
| <a name="input_sit3_domain"></a> [sit3\_domain](#input\_sit3\_domain) | The external domain name of the EKS Cluster using the sit3.uk domain | `string` | n/a | yes |
| <a name="input_t3st_domain"></a> [t3st\_domain](#input\_t3st\_domain) | The external domain name of the EKS Cluster using the t3st.uk domain | `string` | n/a | yes |
| <a name="input_flux_artifact_repository"></a> [flux\_artifact\_repository](#input\_flux\_artifact\_repository) | The path to the repository for the Flux artifact to be uploaded to in GHCR | `string` | `"n3tuk/flux/baseline"` | no |
| <a name="input_flux_artifact_tag"></a> [flux\_artifact\_tag](#input\_flux\_artifact\_tag) | The tag of the Flux artifact uploaded to GHCR which should be deployed to this cluster | `string` | `"latest"` | no |

## Outputs

No outputs.

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->
