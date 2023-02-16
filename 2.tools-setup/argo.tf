module "argo-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "argo"
}

module "argo-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "argo"
  deployment_namespace = module.argo-terraform-k8s-namespace.namespace
  chart                = "argo-cd"
  repository           = "https://argoproj.github.io/argo-helm"
  chart_version        = var.argo-config["chart_version"]
  values_yaml          = <<-EOF


server:
  ingress:
    enabled: true
    annotations: 
      nginx.ingress.kubernetes.io/ssl-redirect: false/true
      nginx.ingress.kubernetes.io/backend-protocol: '"HTTP"/"HTTPS"'

    hosts: 
      - "argo.${var.google_domain_name}"
    paths:
      - /
    pathType: Prefix
    tls: 
      - secretName: your-certificate-name
        hosts:
          - "argo.${var.google_domain_name}"
    https: true
  EOF
}
