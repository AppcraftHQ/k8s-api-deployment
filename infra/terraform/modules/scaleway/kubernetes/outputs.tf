output "cluster_id" {
  description = "Cluster ID"
  value       = scaleway_k8s_cluster.main.id
}

output "cluster_name" {
  description = "Cluster name"
  value       = scaleway_k8s_cluster.main.name
}

output "cluster_endpoint" {
  description = "API endpoint"
  value       = scaleway_k8s_cluster.main.apiserver_url
  sensitive   = true
}

output "cluster_region" {
  description = "Cluster region"
  value       = scaleway_k8s_cluster.main.region
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = scaleway_k8s_cluster.main.version
}

output "kubeconfig_host" {
  value = scaleway_k8s_cluster.main.kubeconfig[0].host
}

output "kubeconfig_token" {
  value     = scaleway_k8s_cluster.main.kubeconfig[0].token
  sensitive = true
}

output "kubeconfig_cluster_ca_certificate" {
  value     = scaleway_k8s_cluster.main.kubeconfig[0].cluster_ca_certificate
  sensitive = true
}

output "kubeconfig" {
  description = "Complete kubeconfig file"
  sensitive   = true
  value       = scaleway_k8s_cluster.main.kubeconfig[0].config_file
}

