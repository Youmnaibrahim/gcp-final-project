resource "google_container_cluster" "my-gke" {
  name = "my-gke"
  location = "asia-east1-a"
  initial_node_count = 1
  remove_default_node_pool = true
  network = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.restricted-subnet.self_link

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.0.0/28"
    
  }

  

  ip_allocation_policy {
  }





  master_authorized_networks_config {
    cidr_blocks {
      display_name = "management-subnet"
      cidr_block = "10.0.0.0/24"
    }
  }

  
}



resource "google_container_node_pool" "private-workernode" {
    name = "private-workernode"
    cluster = google_container_cluster.my-gke.name
    location = "asia-east1-a"
    node_count = 1

    node_config {
      preemptible = true
      # tags = [ "private-rules" ]
      image_type = "COS_CONTAINERD"
      machine_type = "e2-medium"
      service_account = google_service_account.gke-service.email
      oauth_scopes = [ 
        "https://www.googleapis.com/auth/cloud-platform"
       ]
    }
}