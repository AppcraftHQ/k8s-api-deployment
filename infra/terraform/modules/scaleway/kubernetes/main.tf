terraform {
  required_version = ">= 1.0"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

resource "scaleway_k8s_cluster" "main" {
  name    = var.cluster_name
  version = var.kubernetes_version
  region  = var.region
  cni     = "cilium"
  tags    = var.tags

  private_network_id = scaleway_vpc_private_network.k8s.id

  # Delete associated resources on cluster deletion
  delete_additional_resources = true

  # Set project id
  project_id = var.project_id
}

resource "scaleway_k8s_pool" "main" {
  cluster_id = scaleway_k8s_cluster.main.id
  name       = "${var.cluster_name}-pool"
  node_type  = var.node_type
  size       = var.node_count

  autoscaling = var.autoscaling
  min_size    = var.autoscaling ? var.min_nodes : null
  max_size    = var.autoscaling ? var.max_nodes : null

  tags = var.tags
}

# Required for stable cluster creation with Cilium on Scaleway
resource "scaleway_vpc_private_network" "k8s" {
  name       = "${var.cluster_name}-pn"
  project_id = var.project_id
  tags       = var.tags
}


# Reads the Traefik LoadBalancer IP after ArgoCD syncs Traefik.
# This IP is exposed as an output and consumed by the Cloudflare workspace.
data "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = "traefik"
  }

  depends_on = [module.argocd]
}
