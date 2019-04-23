# ------------------------
# ---    Kubernetes    ---
# ------------------------
variable "cluster_dns" {
  description = "The K8S cluster DNS name"
  default     = "cluster.local"
}
variable "cluster_provider" {
  description = "The Kubernetes cluster provider (google or aws at the moment)"
}
variable "namespace_name" {
  description = "The default namespace name"
  type = "map"
}
# ------------------------
# --------- DNS ---------
# ------------------------
variable "fqdn_suffix" {
  description = "The suffix of the DNS names"
}

# ------------------------
# --- The applications ---
# ------------------------
variable "helm_version" {
  type = "map"
}
variable "grafana_admin_name" {
  description = "The administrator name to acces Grafana."
  default     = "grafadmin"
}
variable "grafana_admin_password" {
  description = "The administrator password to acces Grafana."
}
variable "redis_password" {
  description = "The Redis password."
}
variable "redis_service_name" {
  description = "The name of the Redis ServiceAccount"
  default     = "redis-redis-ha"
}
variable "fluentd_forward_port" {
  description = "The forward port of the Fluentd service"
  default     = "24224"
}
variable "fluentd_metrics_port" {
  description = "The metrics port of the Fluentd service"
  default     = "24231"
}

variable "cluster_ca_certificate" {}

variable "monitoring_ns" {}