variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zone and Access permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for infrajobs.dev"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "allowed_emails" {
  description = "List of emails allowed through Cloudflare Access"
  type        = list(string)
  sensitive   = true
}
