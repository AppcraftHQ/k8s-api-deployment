terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

# Install ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.chart_version

  create_namespace = true
  wait             = true
  timeout          = 600
}

# Create ArgoCD root application (App of Apps)
resource "kubectl_manifest" "argocd_root_app" {
  wait = true

  yaml_body = <<-YAML
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: root
     namespace: argocd
     finalizers:
       - resources-finalizer.argocd.argoproj.io
   spec:
     project: default
     source:
       repoURL: ${var.repo_url}
       targetRevision: ${var.target_revision}
       path: ${var.bootstrap_path}
     destination:
       server: https://kubernetes.default.svc
       namespace: argocd
     syncPolicy:
       automated:
         prune: true
         selfHeal: true
       syncOptions:
         - CreateNamespace=true
 YAML

  depends_on = [helm_release.argocd]
}

# Terraform owns the app namespace - ArgoCD does not create it
resource "kubernetes_namespace_v1" "dev-real-estate" {
  metadata {
    name = "dev-real-estate"
  }

  depends_on = [kubectl_manifest.argocd_root_app]
}

# Creates the Infisical auth secret so the operator can authenticate with Infisical
resource "kubernetes_secret_v1" "infisical_auth" {
  metadata {
    name      = "infisical-auth"
    namespace = "dev-real-estate"
  }

  data = {
    clientId     = var.infisical_client_id
    clientSecret = var.infisical_client_secret
  }

  depends_on = [kubernetes_namespace_v1.dev-real-estate]
}
