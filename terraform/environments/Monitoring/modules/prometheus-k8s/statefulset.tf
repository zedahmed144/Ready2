resource "kubernetes_stateful_set" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
  }
  spec {
    replicas = "1"
    selector {
      match_labels = {
        "app.ready" = "prometheus"
      }
    }
    template {
      metadata {
        labels = {
          "app.ready"      = "prometheus"
          "last.configuration.hash" = "${md5(local.prometheus_config_yaml)}"
        }
      }
      spec {
        container {
          name  = "prometheus"
          image = var.prometheus_image
          args = [
            "--storage.tsdb.retention.size=40GB",
            "--config.file=/etc/prometheus/config/prometheus.yaml",
            "--storage.tsdb.path=/prometheus",
            "--storage.tsdb.retention.time=30d",
            "--web.enable-lifecycle",
            "--web.route-prefix=/",
          ]
          port {
            name           = "web"
            container_port = 9090
            protocol       = "TCP"
          }
          resources {
            limits   = var.limits
            requests = var.requests
          }
          volume_mount {
            name       = "config"
            read_only  = true
            mount_path = "/etc/prometheus/config"
          }
          volume_mount {
            name       = "prometheus-db"
            mount_path = "/prometheus"
            sub_path   = "prometheus-db"
          }
          volume_mount {
            name       = "tls-assets"
            read_only  = true
            mount_path = "/etc/prometheus/certs"
          }
          readiness_probe {
            http_get {
              path   = "/-/ready"
              port   = "web"
              scheme = "HTTP"
            }
            timeout_seconds   = 3
            period_seconds    = 5
            success_threshold = 1
            failure_threshold = 120
          }
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"
        } // :container (prometheus)

        restart_policy                   = "Always"
        termination_grace_period_seconds = 600
        dns_policy                       = "ClusterFirst"
        service_account_name             = kubernetes_service_account.prometheus.metadata[0].name
        automount_service_account_token  = true
        security_context {
          run_as_user     = "1000"
          run_as_group    = "2000"
          run_as_non_root = true
          fs_group        = "2000"
        }
        image_pull_secrets {
          name = "dockerhub-creds"
        }

        // Define volumes that these pods will use
        volume {
          name = "config"
          secret {
            secret_name  = kubernetes_secret.prometheus.metadata[0].name
            default_mode = "0420"
          }
        }
        volume {
          name = "tls-assets"
          secret {
            secret_name  = kubernetes_secret.tls-assets.metadata[0].name
            default_mode = "0420"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "prometheus-db"
        annotations = {
          "volume.beta.kubernetes.io/storage-provisioner" = "kubernetes.io/aws-ebs"
        }
      }
      spec {
        access_modes = [
          "ReadWriteOnce"
        ]
        resources {
          requests = {
            "storage" = var.ebs_volume_size
          }
        }
        storage_class_name = "gp2"
      }
    }
    service_name = "prometheus-operated"
    update_strategy {
      type = "RollingUpdate"
    }
    revision_history_limit = 10
  }
}
