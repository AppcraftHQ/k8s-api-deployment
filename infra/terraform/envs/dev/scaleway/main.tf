terraform {
  required_version = ">= 1.0"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
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
