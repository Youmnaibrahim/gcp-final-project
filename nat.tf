resource "google_compute_router" "router" {
  name = "nat-router"
  network = google_compute_network.vpc_network.self_link
  region = google_compute_subnetwork.management-subnet.region
}

resource "google_compute_router_nat" "nat" {
  name                  = "my-first-nat"
  router                = google_compute_router.router.name
  region = google_compute_router.router.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option = "AUTO_ONLY"
  subnetwork {
    name  = google_compute_subnetwork.management-subnet.id
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}

