# --- We add the Elastic helm repository
data "helm_repository" "elastic" {
  # tip to avoid use of this repo before init of helm
  name = "elastic-${var.stable_helm_repository}"
  url  = "https://helm.elastic.co"
}

# ---  We prepare the elasticsearch-values.yaml ---
data "template_file" "elasticsearch" {
  template = "${file("${path.module}/files/elasticsearch-values.yaml")}"

  vars {
    es_ingress_enabled   = "true"
    es_host              = "elasticsearch.${var.fqdn_suffix}"
    es_storageclass_name = "${var.cluster_provider == "google" ? "ssd" : "gp2"}"
  }
}

# --- We install the Elasticsearch masters ---
resource "helm_release" "elasticsearch" {
  repository = "${data.helm_repository.elastic.metadata.0.name}"
  name       = "elasticsearch"
  chart      = "elastic/elasticsearch"
  version    = "${lookup(var.helm_version, "elasticsearch")}"
  namespace  = "${var.monitoring_ns}"
  timeout    = "300"

  values = [
    "${data.template_file.elasticsearch.rendered}"
  ]
}

# ---  We prepare the elasticsearch-data-values.yaml ---
data "template_file" "elasticsearch-data-template" {
  template = "${file("${path.module}/files/elasticsearch-data-values.yaml")}"

  vars {
    es_storageclass_name = "${var.cluster_provider == "google" ? "ssd" : "gp2"}"
  }
}

# --- We install the Elasticsearch data ---
resource "helm_release" "elasticsearch-data" {
  repository = "${data.helm_repository.elastic.metadata.0.name}"
  name      = "elasticsearch-data"
  chart     = "elastic/elasticsearch"
  version   = "${lookup(var.helm_version, "elasticsearch")}"
  namespace = "${var.monitoring_ns}"
  timeout   = "300"

  values = [
    "${data.template_file.elasticsearch-data-template.rendered}"
  ]

  depends_on = ["data.helm_repository.elastic", "data.template_file.elasticsearch-data-template", "helm_release.elasticsearch"]
}

# --- We install the elasticsearch-exporter ---
resource "helm_release" "elasticsearch-exporter" {
  name      = "elasticsearch-exporter"
  chart     = "stable/elasticsearch-exporter"
  version   = "${lookup(var.helm_version, "es-exporter")}"
  namespace = "${var.monitoring_ns}"
  timeout   = "300"

  set {
    name  = "es.uri"
    value = "http://elasticsearch-master:9200"
  }

 depends_on = ["helm_release.elasticsearch-data"]
}