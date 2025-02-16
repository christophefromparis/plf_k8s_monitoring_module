# ---  We prepare the Prometheus values.yaml ---
data "template_file" "prometheus-template" {
  template = "${file("${path.module}/files/prometheus-values.yaml")}"

  vars {
    prometheus_host   = "prometheus.${var.fqdn_suffix}"
    alertmanager_host = "alertmanager.${var.fqdn_suffix}"
    source            = "${var.cluster_provider == "google" ? "GKE" : "EKS"}"
  }
}

#--- Prometheus Helm ---
resource "helm_release" "prometheus" {
  name         = "prometheus"
  chart        = "stable/prometheus"
  version      = "${lookup(var.helm_version, "prometheus")}"
  namespace    = "${var.monitoring_ns}"
  timeout      = "600"

  values = [
    "${data.template_file.prometheus-template.rendered}"
  ]

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "alertmanager.baseURL"
    value = "https://alertmanager.${var.fqdn_suffix}/"
  }

  set {
    name  = "server.global.external_labels.source"
    value = "${var.cluster_provider == "google" ? "GKE" : "EKS"}"
  }

  set {
    name  = "pushgateway.enabled"
    value = "false"
  }
}