# ---  We prepare the kibana-values.yaml ---
data "template_file" "kibana-template" {
  template = "${file("${path.module}/files/kibana-values.yaml")}"

  vars {
    kibana_ingress_enabled = "true"
    kibana_host            = "kibana.${var.fqdn_suffix}"
  }
}

# --- We install Kibana ---
resource "helm_release" "kibana" {
  name      = "kibana"
  chart     = "elastic/kibana"
  version   = "${lookup(var.helm_version, "kibana")}"
  namespace = "${var.monitoring_namespace}"
  timeout   = "300"

  values = [
    "${data.template_file.kibana-template.rendered}"
  ]

  depends_on = ["data.helm_repository.elastic", "data.template_file.kibana-template", "helm_release.elasticsearch-data"]
}