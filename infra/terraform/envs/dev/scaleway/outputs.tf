output "cluster_id" {
  description = "Cluster ID"
  value       = module.kubernetes.cluster_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.kubernetes.cluster_name
}

output "cluster_endpoint" {
  description = "API endpoint"
  value       = module.kubernetes.cluster_endpoint
  sensitive   = true
}

output "cluster_region" {
  description = "Cluster region"
  value       = module.kubernetes.cluster_region
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = module.kubernetes.cluster_version
}

output "kubeconfig" {
  description = "Kubeconfig for the Scaleway Kubernetes cluster"
  sensitive   = true
  value       = module.kubernetes.kubeconfig
}
