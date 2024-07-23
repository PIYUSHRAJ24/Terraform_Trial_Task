/*
 * This Terraform script creates a Google Cloud Platform infrastructure consisting of a Cloud SQL database, 
 * a Cloud Run service, and a load balancer.
 *
 * Prerequisites:
 * - We need to have a Google Cloud Platform project and provide the project ID in the "project" field of the provider block.
 * - Replace "<our-region>" with the desired region for your resources.
 * - Replace "<our-container-image>" with the URL of your container image.
 *
 * Steps:
 * 1. Define the Google Cloud provider with the project ID and region.
 * 2. Create a Cloud SQL database instance with the specified name, region, and database version.
 * 3. Create a Cloud Run service with the specified name and location, using the provided container image.
 * 4. Create a global forwarding rule for the load balancer, targeting the Cloud Run service and port 80.
 * 5. Output the IP address of the load balancer.
 */

// Define provider
provider "google" {
    project = "<our-project-id>"
    region  = "<our-region>"
}

// Create a Cloud SQL database
resource "google_sql_database_instance" "database_instance" {
    name             = "my-database-instance"
    region           = "<our-region>"
    database_version = "MYSQL_5_7"

    settings {
        tier = "db-f1-micro"
    }
}

// Create a Cloud Run service
resource "google_cloud_run_service" "cloud_run_service" {
    name     = "my-cloud-run-service"
    location = "<our-region>"

    template {
        spec {
            containers {
                image = "<our-container-image>"
            }
        }
    }
}

// Create a load balancer
resource "google_compute_global_forwarding_rule" "load_balancer" {
    name       = "my-load-balancer"
    target     = google_cloud_run_service.cloud_run_service.name
    port_range = "80"
}

// Output the load balancer IP address
output "load_balancer_ip" {
    value = google_compute_global_forwarding_rule.load_balancer.ip_address
}