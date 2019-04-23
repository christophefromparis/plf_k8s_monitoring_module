# ---  We prepare the redis-values.yaml ---
data "template_file" "redis" {
  template = "${file("${path.module}/files/redis-values.yaml")}"
}

#--- Redis Helm ---
resource "helm_release" "redis" {
  name      = "redis"
  chart     = "stable/redis-ha"
  version   = "${lookup(var.helm_version, "redis-ha")}"
  namespace = "${var.monitoring_ns}"
  timeout   = "600"

  values = [
    "${data.template_file.redis.rendered}"
  ]

  set {
    name = "rbac.create"
    value = "true"
  }
  set {
    name  = "exporter.enabled"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "${var.redis_service_name}"
  }
  set {
    name  = "exporter.tag"
    value = "v0.33.0"
  }
  set {
    name  = "replicas"
    value = "2"
  }
}
