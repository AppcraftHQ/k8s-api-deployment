# The Access application - defines what is being protected
resource "cloudflare_access_application" "argocd" {
  account_id       = var.cloudflare_account_id
  name             = "ArgoCD"
  domain           = "argocd.mayorstacks.work"
  session_duration = "12h"
  type             = "self_hosted"
}

# The Access policy - defines who is allowed through
resource "cloudflare_access_policy" "argocd_admin" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.argocd.id
  name           = "ArgoCD Admin Access"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.allowed_emails
  }
}

resource "cloudflare_access_application" "grafana" {
  account_id       = var.cloudflare_account_id
  name             = "Grafana"
  domain           = "grafana.mayorstacks.work"
  session_duration = "12h"
  type             = "self_hosted"
}

resource "cloudflare_access_policy" "grafana_admin" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.grafana.id
  name           = "Grafana Admin Access"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.allowed_emails
  }
}
