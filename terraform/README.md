# Alta AWARE EKS Clusters Flux Kustomizations

This repository provides the Kustomizations for deploying services and
configuration via Flux in each of the EKS Clusters in AWS, enabling the
third-party services on the clusters, such as [`external-dns`][external-dns],
[`cert-manager`][cert-manager], and [`ingress-nginx`][ingress-nginx].
Additionally, it provides all the necessary Terraform configuration to create
the AWS resources (such as IAM Roles, Policies, and S3 buckets) and configure
them for importing by Helm via ConfigMaps in Kubernetes.

[external-dns]: https://github.com/kubernetes-sigs/external-dns
[cert-manager]: https://cert-manager.io/
[ingress-nginx]: https://github.com/kubernetes/ingress-nginx

## Documentation

The primary documentation is available via [GitHub Pages][site], based on the
documents kept under [`pages/docs/`][docs] and built by [`mkdocs`][mkdocs].
Please ensure any documentation updates are kept in sync with any infrastructure
and code changes, as it will be built and deployed through the same Terraform
GitHub Workflow ([`terraform.yaml`][workflow]) to GitHub Pages.

[docs]: https://github.com/msicie/alta-aware-infra-flux-services/tree/main/pages/docs
[mkdocs]: https://www.mkdocs.org/
[workflow]: https://github.com/msicie/alta-aware-infra-flux-services/blob/main/.github/workflows/terraform.yaml

> [!TIP]
> Access to this repository's documentation can be found at the [GitHub
> Pages][site] deployment (you must be authenticated by SSO to access),
> alongside the [Central Documentation Portal][portal].

[site]: https://supreme-fortnight-zw8jvv4.pages.github.io/
[portal]: https://congenial-adventure-j79gww8.pages.github.io/

<!-- terraform-docs-start -->
<!-- prettier-ignore-start -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.58 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.61.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sg_aws_privateca_issuer"></a> [sg\_aws\_privateca\_issuer](#module\_sg\_aws\_privateca\_issuer) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_sg_default_backend"></a> [sg\_default\_backend](#module\_sg\_default\_backend) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_sg_external_dns"></a> [sg\_external\_dns](#module\_sg\_external\_dns) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_sg_ingress_nginx"></a> [sg\_ingress\_nginx](#module\_sg\_ingress\_nginx) | terraform-aws-modules/security-group/aws | 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_privateca_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.private_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_privateca_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.private_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_privateca_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.private_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_config_map_v1.approver_policy_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.aws_privateca_issuer_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.aws_privateca_issuer_substitutions](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.cert_manager_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.csi_driver_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.ingress_nginx_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.ingress_nginx_substitutions](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.private_dns_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1.trust_manager_overrides](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_manifest.flux_services_artifact](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.flux_services_flux](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.flux_services](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.aws_privateca_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_privateca_issuer_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.private_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.private_dns_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ip_ranges.route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ip_ranges) | data source |
| [terraform_remote_state.cache](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.certificates](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.clusters](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.common](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The ID of the AWS Account this Terraform configuration will be deployed in to | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The name of the AWS Region this Terraform configuration will be primrily be deployed in to (this does not override the explicit providers for each AWS Region, if configured) | `string` | n/a | yes |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The external domain name of the EKS Cluster (i.e. the domain suffix for deployed services) | `string` | n/a | yes |
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | The external name of the location for this EKS Cluster (i.e. the domain prefix for deployed services) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment that this Terraform configuration will be deployed for | `string` | n/a | yes |
| <a name="input_flux_artifact_name"></a> [flux\_artifact\_name](#input\_flux\_artifact\_name) | The name of the Flux artifact uploaded to ECR repository which should be deployed to this Cluster | `string` | `"flux/eks/application"` | no |
| <a name="input_flux_artifact_tag"></a> [flux\_artifact\_tag](#input\_flux\_artifact\_tag) | The tag of the Flux artifact uploaded to ECR repository which should be deployed to this Cluster | `string` | `"latest"` | no |

## Outputs

No outputs.

<!-- prettier-ignore-end -->
<!-- terraform-docs-end -->
