terraform {
  required_version = ">= 1.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    organization = "real-estate"

    workspaces {
      name = "real-estate-app-cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Reads the Traefik IP from the Scaleway workspace output automatically
data "terraform_remote_state" "scaleway" {
  backend = "remote"

  config = {
    organization = "real-estate"
    workspaces = {
      name = "real-estate-app"
    }
  }
}

# Points subdomains at the Traefik LoadBalancer IP
resource "cloudflare_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = "argocd"
  content = data.terraform_remote_state.scaleway.outputs.traefik_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  content = data.terraform_remote_state.scaleway.outputs.traefik_ip
  type    = "A"
  proxied = true
}
