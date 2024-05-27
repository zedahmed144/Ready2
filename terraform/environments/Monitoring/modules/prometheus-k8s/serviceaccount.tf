resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
    labels = {
      "app.ready" = "prometheus"
      "component"          = "Observability"
    }
  }
  image_pull_secret {
    name = "dockerhub-creds"
  }
}
