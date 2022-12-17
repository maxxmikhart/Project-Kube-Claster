module "kube-state-metrics-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "kube-state-metrics"
  deployment_namespace = "kube-system"
  repository           = "https://prometheus-community.github.io/helm-charts"
  chart                = "kube-state-metrics"
  chart_version        = var.kube-state-metrics-config["chart_version"]
  values_yaml          = ""
}