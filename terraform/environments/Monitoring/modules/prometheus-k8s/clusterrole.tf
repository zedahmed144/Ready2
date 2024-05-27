resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus"
  }
  rule {
    api_groups = ["*"]
    resources = [
      "nodes",
      "nodes/metrics",
      "services",
      "endpoints",
      "pods"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = [
      "ingresses"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
  rule {
    non_resource_urls = [
      "/metrics",
      "/metrics/cadvisor"
    ]
    verbs = [
      "get"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "promtheus" {
  metadata {
    name = "prometheus"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.prometheus.metadata[0].name
    namespace = kubernetes_service_account.prometheus.metadata[0].namespace
  }
}
