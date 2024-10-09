variable "cluster_domain" {
  description = "The external domain name of the EKS Cluster (i.e. the domain suffix for deployed services)"
  type        = string
  # required

  validation {
    condition     = can(regex("^([pds]|t[12])\\.kub3\\.uk$", var.cluster_domain))
    error_message = "The cluster domain must be 'kub3.uk' with the prefixes 'p', 'd', 's', or 't1'/'t2'."
  }
}

variable "cloudflare_account_id" {
  description = "The Account ID for the Cloudflare account to be used"
  type        = string
  default     = "e0d4aae3f32f077cd16bbc26f615738d"
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
