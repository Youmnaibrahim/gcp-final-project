resource "google_service_account" "vm-service" {
  account_id = "vm-service"
  display_name = "vm-service"
}
resource "google_service_account" "gke-service" {
  account_id   = "gke-service"
  display_name = "gke-service"
}
resource "google_project_iam_member" "instance" {
  project = var.projectid
  role = "roles/container.admin"
  member = "serviceAccount:${google_service_account.vm-service.email}"
}
resource "google_project_iam_member" "gke_sa" {
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke-service.email}"
  project = var.projectid
}