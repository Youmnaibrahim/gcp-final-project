resource "google_compute_instance" "vm-restricted" {
  name = "vm-restricted"
  machine_type = "f1-micro"
  zone         = "asia-east1-a"


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  tags = ["ssh"]
  service_account {
    email = google_service_account.vm-service.email
    scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  }
    network_interface {
      subnetwork = google_compute_subnetwork.management-subnet.self_link
    }

  metadata_startup_script = file("script.sh")

}




resource "google_compute_firewall" "ssh" {
  project = var.projectid
  name = "ssh"
  network = google_compute_network.vpc_network.name
  priority = 100
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports = ["22","80"]
  }


  target_tags = ["ssh"]
  source_ranges = ["35.235.240.0/20","41.234.239.132"]

}