# n3t.uk Flux Artifact Repository

TODO

<!-- terraform-docs-start -->
<!-- prettier-ignore-start -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | ~> 1.1.2 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.23 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.25.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.43.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_api_token.cert_manager](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/api_token) | resource |
| [cloudflare_api_token.external_dns](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/api_token) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.cluster](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared_config.cluster](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config) | resource |
| [kubernetes_config_map_v1.cloudflare_system_helm_tunnel_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.common_substitutions](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.external_dns_helm_cloudflare_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.routing_substitutions](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_manifest.flux_system_baseline](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.flux_system_cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.cloudflare_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.csi_proxmox](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.metallb_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.certificates_system_cloudflare_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.cloudflare_system_tunnel_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.csi_proxmox_helm_proxmox_csi_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_password.tunnel](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [cloudflare_api_token_permission_groups.all](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/api_token_permission_groups) | data source |
| [cloudflare_zone.n3tuk](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The external domain name of the EKS Cluster (i.e. the domain suffix for deployed services) | `string` | n/a | yes |
| <a name="input_metallb_pool_ipv4"></a> [metallb\_pool\_ipv4](#input\_metallb\_pool\_ipv4) | A CIDR for the IPv4 addresses to be used for metallb-managed LoadBalancer endpoints | `string` | n/a | yes |
| <a name="input_metallb_pool_ipv6"></a> [metallb\_pool\_ipv6](#input\_metallb\_pool\_ipv6) | A CIDR for the IPv6 addresses to be used for metallb-managed LoadBalancer endpoints | `string` | n/a | yes |
| <a name="input_metallb_routers"></a> [metallb\_routers](#input\_metallb\_routers) | A list of router IP addresses for each Proxmox Node for metallb | <pre>object({<br>    proxmox-01 = string<br>    proxmox-02 = string<br>    proxmox-03 = string<br>  })</pre> | n/a | yes |
| <a name="input_proxmox_csi_plugin_token_id"></a> [proxmox\_csi\_plugin\_token\_id](#input\_proxmox\_csi\_plugin\_token\_id) | The API token name to provide the proxmox-csi-plugin resource access to the Proxmox API for Ceph | `string` | n/a | yes |
| <a name="input_proxmox_csi_plugin_token_secret"></a> [proxmox\_csi\_plugin\_token\_secret](#input\_proxmox\_csi\_plugin\_token\_secret) | The API token secret to provide the proxmox-csi-plugin resource access to the Proxmox API for Ceph | `string` | n/a | yes |
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | The Account ID for the Cloudflare account to be used | `string` | `"e0d4aae3f32f077cd16bbc26f615738d"` | no |
| <a name="input_flux_artifact_repository"></a> [flux\_artifact\_repository](#input\_flux\_artifact\_repository) | The path to the repository for the Flux artifact to be uploaded to in GHCR | `string` | `"n3tuk/flux/baseline"` | no |
| <a name="input_flux_artifact_tag"></a> [flux\_artifact\_tag](#input\_flux\_artifact\_tag) | The tag of the Flux artifact uploaded to GHCR which should be deployed to this cluster | `string` | `"latest"` | no |

## Outputs

No outputs.

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->
