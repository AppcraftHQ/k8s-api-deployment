variable "scaleway_access_key" {
  description = "Scaleway access key"
  type        = string
  sensitive   = true
}

variable "scaleway_secret_key" {
  description = "Scaleway secret key"
  type        = string
  sensitive   = true
}

variable "scaleway_organization_id" {
  description = "Scaleway organization ID"
  type        = string
  sensitive   = true
}

variable "scaleway_project_id" {
  description = "Scaleway project ID"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "real-estate-dev"
}

variable "region" {
  description = "Scaleway region"
  type        = string
  default     = "fr-par"
}

variable "zone" {
  description = "Scaleway zone"
  type        = string
  default     = "fr-par-1"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_type" {
  description = "Node type"
  type        = string
  default     = "DEV1-M" # 3 vCPUs & 4 GB RAM
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 1
}

variable "autoscaling" {
  description = "Enable autoscaling"
  type        = bool
  default     = false
}

variable "min_nodes" {
  description = "Min nodes"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Max nodes"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Resource tags"
  type        = list(string)
  default     = ["dev", "real-estate", "kubernetes"]
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
  description = "Path in the Git repo to the ArgoCD bootstrap folder"
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
