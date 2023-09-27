resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx-deploy-tf"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 30
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "loadbalancer-tf"
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80 #machine
      target_port = 80 #container
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "app-dns" {
    metadata {
    name = "loadbalancer-tf"
  }
}

output "URL" {
  value = data.kubernetes_service.app-dns.status
}