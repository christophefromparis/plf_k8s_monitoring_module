provider "helm" {
  version = "~> 0.9.0"

  kubernetes {
    cluster_ca_certificate = "${var.cluster_ca_certificate}"
  }
}