terraform {
  required_version = ">= 1.0"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }

  backend "remote" {
    organization = "real-estate"

    workspaces {
      name = "real-estate-app"
    }
  }
}

provider "scaleway" {
  access_key      = var.scaleway_access_key
  secret_key      = var.scaleway_secret_key
  organization_id = var.scaleway_organization_id
  region          = var.region
  zone            = var.zone
}

provider "helm" {
  kubernetes {
    host  = module.kubernetes.kubeconfig_host
    token = module.kubernetes.kubeconfig_token
    cluster_ca_certificate = base64decode(
      module.kubernetes.kubeconfig_cluster_ca_certificate
    )
  }
}

provider "kubernetes" {
  host  = module.kubernetes.kubeconfig_host
  token = module.kubernetes.kubeconfig_token
  cluster_ca_certificate = base64decode(
    module.kubernetes.kubeconfig_cluster_ca_certificate
  )
}

provider "kubectl" {
  host  = module.kubernetes.kubeconfig_host
  token = module.kubernetes.kubeconfig_token
  cluster_ca_certificate = base64decode(
    module.kubernetes.kubeconfig_cluster_ca_certificate
  )
  load_config_file = false
}

module "kubernetes" {
  source = "../../../modules/scaleway/kubernetes"

  cluster_name       = var.cluster_name
  region             = var.region
  kubernetes_version = var.kubernetes_version
  node_type          = var.node_type
  node_count         = var.node_count
  autoscaling        = var.autoscaling
  min_nodes          = var.min_nodes
  max_nodes          = var.max_nodes
  tags               = var.tags
  project_id         = var.scaleway_project_id
}

module "infisical_operator" {
  source = "../../../modules/infisical-operator"

  depends_on = [module.kubernetes]
}

module "argocd" {
  source = "../../../modules/argocd-bootstrap"

  repo_url                  = var.repo_url
  target_revision           = var.target_revision
  bootstrap_path            = var.bootstrap_path
  infisical_client_id       = var.infisical_client_id
  infisical_client_secret   = var.infisical_client_secret
  infisical_project_slug    = var.infisical_project_slug
  infisical_env_slug        = var.infisical_env_slug
  argocd_oidc_client_id     = var.argocd_oidc_client_id
  argocd_oidc_client_secret = var.argocd_oidc_client_secret
  argocd_url                = var.argocd_url

  depends_on = [module.kubernetes]
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
