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

# Consumed by the Cloudflare workspace to create DNS records
output "traefik_ip" {
  description = "Traefik LoadBalancer external IP - consumed by the Cloudflare Terraform workspace"
  value = try(
    data.kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].ip,
    null # Returns null if Traefik IP is not yet assigned - re-apply after ArgoCD syncs
  )
}
