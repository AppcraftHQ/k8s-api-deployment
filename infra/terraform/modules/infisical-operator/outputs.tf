output "namespace" {
  description = "Namespace where Infisical operator is installed"
  value       = helm_release.infisical_operator.namespace
}

output "chart_version" {
  description = "Installed Infisical chart version"
  value       = helm_release.infisical_operator.version
}
