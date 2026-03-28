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

  values = [
    <<-YAML
    configs:
      params:
        server.insecure: true
        server.basehref: /
        server.rootpath: ""

      cm:
        url: ${var.argocd_url}
        users.session.duration: 12h
        dex.config: |
          oauth2:
            skipApprovalScreen: true
          web:
            allowedOrigins:
              - ${var.argocd_url}
          connectors:
            - type: github
              id: github
              name: GitHub
              config:
                clientID: ${var.argocd_oidc_client_id}
                clientSecret: ${var.argocd_oidc_client_secret}
                redirectURI: ${var.argocd_url}/api/dex/callback
                orgs:
                  - name: AppcraftHQ

      rbac:
        policy.default: role:readonly
        policy.csv: |
          p, role:admin, applications,  *, */*,  allow
          p, role:admin, clusters,      get, *,  allow
          p, role:admin, repositories,  *, *,    allow
          g, AppcraftHQ:platform-engineers, role:admin
    YAML
  ]
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

# Terraform owns the dev-real-estate namespace - ArgoCD does not create it
resource "kubernetes_namespace_v1" "dev-real-estate" {
  metadata {
    name = "dev-real-estate"
  }

  depends_on = [kubectl_manifest.argocd_root_app]
}

# Creates the Infisical auth secret so the operator can authenticate with Infisical
resource "kubernetes_secret_v1" "infisical_auth" {
  metadata {
    name      = "infisical-auth-real-estate"
    namespace = "dev-real-estate"
  }

  data = {
    clientId     = var.infisical_client_id
    clientSecret = var.infisical_client_secret
  }

  depends_on = [kubernetes_namespace_v1.dev-real-estate]
}

# ArgoCD access GitHub repo via this secret - ArgoCD does not create it
resource "kubernetes_secret_v1" "infisical_auth_argocd" {
  metadata {
    name      = "infisical-auth"
    namespace = "argocd"
  }
  data = {
    clientId     = var.infisical_client_id
    clientSecret = var.infisical_client_secret
  }

  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "argocd_repo_credentials" {
  yaml_body = <<-YAML
    apiVersion: secrets.infisical.com/v1alpha1
    kind: InfisicalSecret
    metadata:
      name: argocd-repo-credentials
      namespace: argocd
      labels:
        argocd.argoproj.io/secret-type: repository
    spec:
      hostAPI: https://app.infisical.com/api
      authentication:
        universalAuth:
          secretsScope:
            envSlug: "${var.infisical_env_slug}"
            secretsPath: "/argocd"
            projectSlug: "${var.infisical_project_slug}"
          credentialsRef:
            secretName: infisical-auth
            secretNamespace: argocd
      managedSecretReference:
        secretName: argocd-github-app-secret
        secretNamespace: argocd
        secretType: Opaque
        creationPolicy: "Owner"
      resyncInterval: 300
  YAML

  depends_on = [kubernetes_secret_v1.infisical_auth_argocd]
}


resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [kubectl_manifest.argocd_root_app]
}

resource "kubernetes_secret_v1" "infisical_auth_monitoring" {
  metadata {
    name      = "infisical-auth-monitoring"
    namespace = "monitoring"
  }

  data = {
    clientId     = var.infisical_client_id
    clientSecret = var.infisical_client_secret
  }

  depends_on = [kubernetes_namespace_v1.monitoring]
}
