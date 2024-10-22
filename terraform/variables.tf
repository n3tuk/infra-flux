variable "environment" {
  description = "The name of the environment that this Terraform configuration will be deployed for"
  type        = string
  # No default

  validation {
    condition     = contains(["testing-01", "testing-02", "development", "production"], var.environment)
    error_message = "The name of the environment must be one of: testing-01, testing-02, development, or production."
  }
}

variable "aws_region" {
  description = "The name of the AWS Region this Terraform configuration will be deployed in to"
  type        = string
  # required

  validation {
    condition     = can(regex("^(us|eu)-(east|west|central|south|north)-[0-9]$", var.aws_region))
    error_message = "The AWS Region must be either in either US or EU geolocations"
  }
}

variable "aws_account_id" {
  description = "The ID of the AWS Account this Terraform configuration will be deployed in to"
  type        = string
  # required

  validation {
    condition = (
      length(var.aws_account_id) == 12 &&
      var.aws_account_id > 0 && var.aws_account_id <= 999999999999
    )

    error_message = "The AWS Account ID must be a number between 00000000000 and 999999999999."
  }
}

variable "cloudflare_account_id" {
  description = "The Account ID for the Cloudflare account to be used"
  type        = string
  default     = "e0d4aae3f32f077cd16bbc26f615738d"
}

variable "cluster_domain" {
  description = "The external domain name of the EKS Cluster (i.e. the domain suffix for deployed services)"
  type        = string
  # required

  validation {
    condition     = can(regex("^(([pds]|t[12])\\.)?kub3\\.uk$", var.cluster_domain))
    error_message = "The cluster domain must be 'kub3.uk' with (optionally) the prefixes 'p', 'd', 's', or 't1'/'t2'."
  }
}

variable "t3st_domain" {
  description = "The external domain name of the EKS Cluster using the t3st.uk domain"
  type        = string
  # required

  validation {
    condition     = can(regex("^(([pds]|t[12])\\.)?t3st\\.uk$", var.t3st_domain))
    error_message = "The cluster domain must be 't3st.uk' with (optionally) the prefixes 'p', 'd', 's', or 't1'/'t2'."
  }
}

variable "sit3_domain" {
  description = "The external domain name of the EKS Cluster using the sit3.uk domain"
  type        = string
  # required

  validation {
    condition     = can(regex("^(([pds]|t[12])\\.)?sit3\\.uk$", var.sit3_domain))
    error_message = "The cluster domain must be 'sit3.uk' with (optionally) the prefixes 'p', 'd', 's', or 't1'/'t2'."
  }
}

variable "flux_artifact_repository" {
  description = "The path to the repository for the Flux artifact to be uploaded to in GHCR"
  type        = string
  default     = "n3tuk/flux/baseline"
}

variable "flux_artifact_tag" {
  description = "The tag of the Flux artifact uploaded to GHCR which should be deployed to this cluster"
  type        = string
  default     = "latest"
}

variable "metallb_routers" {
  description = "A list of router IP addresses for each Proxmox Node for metallb"
  type = object({
    proxmox-01 = string
    proxmox-02 = string
    proxmox-03 = string
  })
  # required
}

variable "metallb_pool_ipv4" {
  description = "A CIDR for the IPv4 addresses to be used for metallb-managed LoadBalancer endpoints"
  type        = string
  # required
}

variable "metallb_pool_ipv6" {
  description = "A CIDR for the IPv6 addresses to be used for metallb-managed LoadBalancer endpoints"
  type        = string
  # required
}

variable "proxmox_csi_plugin_token_id" {
  description = "The API token name to provide the proxmox-csi-plugin resource access to the Proxmox API for Ceph"
  type        = string
  # required
}
variable "proxmox_csi_plugin_token_secret" {
  description = "The API token secret to provide the proxmox-csi-plugin resource access to the Proxmox API for Ceph"
  type        = string
  # required
}
