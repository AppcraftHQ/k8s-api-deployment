variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "region" {
  description = "Scaleway region"
  type        = string
  default     = "fr-par"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_type" {
  description = "Node instance type"
  type        = string
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
  description = "Min nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Max nodes for autoscaling"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Resource tags"
  type        = list(string)
  default     = []
}

variable "project_id" {
  description = "Scaleway project ID"
  type        = string
}
