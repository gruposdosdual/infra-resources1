# WordPress Deployment
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress-deployment"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress:latest"
          name  = "wordpress"
          port {
            container_port = 80
          }
          # Environment variables to connect to the RDS MySQL database
          env {
            name  = "WORDPRESS_DB_HOST"
            value = "my-database-instance-dad.criuqg402mat.eu-west-3.rds.amazonaws.com"  
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = "mydatabaseDAD"
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = "admin"
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "password123!"  
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress_service" {
  metadata {
    name = "wordpress-service"
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  
  }
}
