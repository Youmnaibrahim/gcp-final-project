resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}
resource "google_project_service" "container" {
  service = "container.googleapis.com"
}



resource "google_compute_network" "vpc_network" {
  name                    = "my-vpcone"
  auto_create_subnetworks = false
  project = var.projectid
}

resource "google_compute_subnetwork" "management-subnet" {
  name          = "management-subnet"
  ip_cidr_range = var.manged-cider
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
}


resource "google_compute_subnetwork" "restricted-subnet" {
  name          = "restricted-subnet"
  ip_cidr_range = var.private-cider
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "secondary-ip-range"
    ip_cidr_range = "10.0.4.0/24"
  }
}




resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"]
}



