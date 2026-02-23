variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "9.4.0"
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD to sync from"
  type        = string
}

variable "target_revision" {
  description = "Git branch or tag for ArgoCD to sync from"
  type        = string
  default     = "main"
}

variable "bootstrap_path" {
  description = "Path in the Git repo to the bootstrap folder for the environment"
  type        = string
}

variable "infisical_client_id" {
  description = "Infisical universal auth client ID"
  type        = string
  sensitive   = true
}

variable "infisical_client_secret" {
  description = "Infisical universal auth client secret"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub token for ArgoCD to access private repo"
  type        = string
  sensitive   = true
}
