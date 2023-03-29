module "sftpgo-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "sftpgo"
}

module "sftpgo-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "sftpgo"
  deployment_namespace = module.sftpgo-terraform-k8s-namespace.namespace
  chart                = "sftpgo"
  repository           = "https://charts.sagikazarmark.dev"
  chart_version        = var.sftpgo-config["chart_version"]
  values_yaml          = <<-EOF

podAnnotations: {
      "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
}
ui:
  ingress:
    enabled: true
    annotations:
      ingress.kubernetes.io/ssl-redirect: "false"
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
      acme.cert-manager.io/http01-edit-in-place: "true"
    hosts:
      - host: "sftpgo.${var.google_domain_name}"
        paths:
          - path: /
            pathType: ImplementationSpecific

    tls: 
      - secretName: sftpgo-tls
        hosts:
          - "sftpgo.${var.google_domain_name}"
  EOF
}
