resource "helm_release" "infisical_operator" {
  name       = "infisical-operator"
  repository = "https://dl.cloudsmith.io/public/infisical/helm-charts/helm/charts/"
  chart      = "secrets-operator"
  namespace  = "infisical-operator-system"
  version    = var.chart_version

  create_namespace = true
}
