# ---  We prepare the fluentd-values.yaml ---
data "template_file" "fluentd" {
  template = "${file("${path.module}/files/fluentd-values.yaml")}"

  vars {
    forward_port = "${var.fluentd_forward_port}"
    metrics_port = "${var.fluentd_metrics_port}"
  }
}

# --- We install Fluentd  ---
resource "helm_release" "fluentd" {
  name      = "fluentd"
  chart     = "stable/fluentd"
  version   = "${lookup(var.helm_version, "fluentd")}"
  namespace = "${lookup(var.namespace_name, "monitoring")}"
  timeout   = "300"

  values = [
    "${data.template_file.fluentd.rendered}"
  ]

  set {
    name  = "output.host"
    value = "${helm_release.elasticsearch.name}-master.${helm_release.elasticsearch.namespace}.svc.${var.cluster_dns}"
  }

  depends_on = ["helm_release.elasticsearch-data"]
}

# ---  We prepare the fluent-bit-values.yaml ---
data "template_file" "fluent-bit" {
  template = "${file("${path.module}/files/fluent-bit-values.yaml")}"
}

# --- We install Fluent-bit ---
resource "helm_release" "fluent-bit" {
  name      = "fluent-bit"
  chart     = "stable/fluent-bit"
  version   = "${lookup(var.helm_version, "fluent-bit")}"
  namespace = "${lookup(var.namespace_name, "monitoring")}"
  timeout   = "300"

  values = [
    "${data.template_file.fluent-bit.rendered}"
  ]

  set {
    name  = "backend.forward.host"
    value = "${helm_release.fluentd.name}.${helm_release.fluentd.namespace}.svc.${var.cluster_dns}"
  }

  set {
    name  = "backend.forward.port"
    value = "${var.fluentd_forward_port}"
  }

  depends_on = ["helm_release.elasticsearch-data", "helm_release.fluentd"]
}
