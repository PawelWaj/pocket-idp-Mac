# Configure required values for backstage
resource "humanitec_value" "backstage_github_org_id" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_ORG_ID"
  description = ""
  value       = var.github_org_id
  is_secret   = false
}

resource "humanitec_value" "backstage_humanitec_org" {
  app_id      = humanitec_application.backstage.id
  key         = "HUMANITEC_ORG_ID"
  description = ""
  value       = var.humanitec_org
  is_secret   = false
}

resource "humanitec_value" "backstage_humanitec_token" {
  app_id      = humanitec_application.backstage.id
  key         = "HUMANITEC_TOKEN"
  description = ""
  value       = var.humanitec_token
  is_secret   = true
}

resource "humanitec_value" "backstage_cloud_provider" {
  app_id      = humanitec_application.backstage.id
  key         = "CLOUD_PROVIDER"
  description = ""
  value       = "5min"
  is_secret   = false
}
################ New Code ###############

resource "kubernetes_namespace" "backstage" {
  metadata {
    name = "backstage"
  }
}

resource "kubernetes_secret_v1" "backstage_cert" {
  depends_on = [kubernetes_namespace.backstage]
  metadata {
    name      = "backstage-tls"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = base64decode(var.tls_cert_string)
    "tls.key" = base64decode(var.tls_key_string)
  }
}

resource "helm_release" "backstage" {
  name             = "backstage"
  namespace        = kubernetes_namespace.backstage.metadata[0].name
  create_namespace = true
  repository       = "https://backstage.github.io/charts"
  chart            = "backstage"
  version          = "2.4.0"  # Replace with the latest version

  values = [
    file("${path.module}/backstage_values.yaml")
  ]

  depends_on = [
    kubernetes_secret_v1.backstage_cert,
    kubernetes_config_map.backstage_entities
  ]
}

resource "kubernetes_config_map" "backstage_entities" {
  depends_on = [kubernetes_namespace.backstage]
  metadata {
    name      = "backstage-example-entities"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }
  data = {
    "example-entities.yaml" = file("${path.module}/example-entities.yaml")
  }
}