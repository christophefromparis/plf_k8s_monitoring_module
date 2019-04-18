# ------------------------
# ---    The labels    ---
# ------------------------
variable "creator_label" {
  description = "The creators of the several artifact"
  default     = "Terraform_and_Christophe_Cosnefroy"
}

# ------------------------
# ---    Kubernetes    ---
# ------------------------

variable "cluster_dns" {
  description = "The K8S cluster DNS name"
  default     = "cluster.local"
}
variable "monitoring_namespace" {
  description = "The monitoring namespace name"
}
variable "cluster_provider" {
  description = "The Kubernetes cluster provider (google or aws at the moment)"
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

#todo share the global variables
variable "helm_version" {
  type = "map"

  default = {
    cert-manager  = "v0.6.6"
    external-dns  = "1.7.0"
    nginx-ingress = "1.4.0"
    prometheus    = "8.9.0"
    grafana       = "3.0.1"
    redis         = "3.3.5"
    elasticsearch = "6.5.0"
    kibana        = "6.5.0"
    fluent-bit    = "1.9.1"
    fluentd       = "1.6.0"
    es-exporter   = "1.1.3"
  }
}

variable "grafana_admin_name" {
  description = "The administrator name to acces Grafana."
  default     = "grafadmin"
}

#todo remove the default value
variable "grafana_admin_password" {
  description = "The administrator password to acces Grafana."
  default     = "changeme"
}

#todo remove the default value
variable "redis_password" {
  description = "The Redis password."
  default     = "changeme"
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