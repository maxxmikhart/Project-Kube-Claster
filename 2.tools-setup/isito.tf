module "istio-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "istio-system"
}

module "istio-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "istio"
  deployment_namespace = module.istio-terraform-k8s-namespace.namespace
  chart                = "base"
  chart_version        = "1.17.1"
  repository           = "https://istio-release.storage.googleapis.com/charts"
  values_yaml          = <<EOF

global:
  istioNamespace: istio-system

EOF
}



module "istiod-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "istiod"
  deployment_namespace = module.istio-terraform-k8s-namespace.namespace
  chart                = "istiod"
  chart_version        = "1.17.1"
  repository           = "https://istio-release.storage.googleapis.com/charts"
  values_yaml          = <<EOF

telemetry:
  enabled: true

global:
  istioNamespace: istio-system
  
meshConfig:
  ingressService: istio-gateway
  ingressSelector: gateway

EOF
}


module "istio-gateway" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "gateway"
  deployment_namespace = module.istio-terraform-k8s-namespace.namespace
  chart                = "gateway"
  chart_version        = "1.17.1"
  repository           = "https://istio-release.storage.googleapis.com/charts"
  values_yaml          = <<EOF

EOF
}




#####################################################################################
#
# Istio demo namespace
# 
# ###################################################################################
module "istio-demo-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "istio-demo"
  labels = {
    istio-injection = "enabled"
  }
}
