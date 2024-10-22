provider "cloudflare" {
  retries = 3
}

data "cloudflare_api_token_permission_groups" "all" {}

data "cloudflare_zone" "n3tuk" {
  for_each = toset(local.cloudflare_domains)
  name     = each.value
}
