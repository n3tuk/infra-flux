cluster_domain = "p.kub3.uk"
root_domain    = "kub3.uk"
t3st_domain    = "t3st.uk"
sit3_domain    = "sit3.uk"

proxmox_csi_plugin_token_id     = "kubernetes-csi@pve!csi"
proxmox_csi_plugin_token_secret = ""

metallb_pool_ipv4 = "172.23.0.64/26"
metallb_pool_ipv6 = "2a02:8010:8006:3a00::/64"
metallb_routers = {
  proxmox-01 = "172.23.0.17"
  proxmox-02 = "172.23.0.33"
  proxmox-03 = "172.23.0.49"
}
