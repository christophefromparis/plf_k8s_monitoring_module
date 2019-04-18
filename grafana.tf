# ---  We prepare the grafana-values.yaml ---
data "template_file" "grafana-template" {
  template = "${file("${path.module}/files/grafana-values.yaml")}"

  vars {
    grafana_admin_name     = "${var.grafana_admin_name}"
    grafana_admin_password = "${var.grafana_admin_password}"
    grafana_replica        = "1"
    grafana_dash_label     = "grafana_dashboard"
    grafana_host           = "grafana.${var.fqdn_suffix}"
    grafana_plugins        = ""
    grafana_redis_url      = "${var.redis_service_name}.${helm_release.redis.namespace}.svc.cluster.local"
  }
}

/*

#todo Add redis as session manager

    #grafana_redis_url      = "${var.redis_service_name}.${helm_release.redis.namespace}.svc.cluster.local"
    #grafana_redis_password = "${var.redis_password}"

session:
provider: redis
provider_config: addr=${grafana_redis_url}:6379,pool_size=100,prefix=grafana,password=${grafana_redis_password}
*/

#--- Grafana Helm ---
resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "stable/grafana"
  version   = "${lookup(var.helm_version, "grafana")}"
  namespace = "${var.monitoring_namespace}"
  timeout   = "120"

  values = [
    "${data.template_file.grafana-template.rendered}"
  ]
}

locals {
  dashboard-keys = [
    "kube.json",
    "docker.json",
    "host.json",
    "capacity.json",
    "host-extended.json",
    "nodejs.json",
    "coredns.json",
    "es.json",
    "prometheus.json",
    "redis.json",
    "fluentd.json"
  ]

  dashboard-values = [
    "${file("${path.module}/files/dashboards/k8s-cluster.json")}",
    "${file("${path.module}/files/dashboards/docker.json")}",
    "${file("${path.module}/files/dashboards/hosts.json")}",
    "${file("${path.module}/files/dashboards/k8s-capacity-planning.json")}",
    "${file("${path.module}/files/dashboards/host-extended.json")}",
    "${file("${path.module}/files/dashboards/nodejs.json")}",
    "${file("${path.module}/files/dashboards/coredns.json")}",
    "${file("${path.module}/files/dashboards/elasticsearch.json")}",
    "${file("${path.module}/files/dashboards/prometheus.json")}",
    "${file("${path.module}/files/dashboards/redis.json")}",
    "${file("${path.module}/files/dashboards/fluentd.json")}"
  ]
}

# --- We add the Grafana dashboards ---
resource "kubernetes_config_map" "dashboard" {
  count = "${length(local.dashboard-keys)}"

  "metadata" {
    name = "grafana-dashboard-${count.index}"
    namespace = "${var.monitoring_namespace}"
    labels {
      grafana_dashboard = ""
    }
  }

  data = "${zipmap(slice(local.dashboard-keys, count.index, count.index+1), slice(local.dashboard-values, count.index, count.index+1))}"
}