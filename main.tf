/*
data "terraform_remote_state" "infra" {
  backend = "s3"
  config {
    region  = "eu-west-1"
    bucket  = "veolia-vwis-infra-irl-terraform"
    key     = "dev.k8s.infra.tfstate"
  }
}

data "terraform_remote_state" "soft" {
  backend = "s3"
  config {
    region  = "eu-west-1"
    bucket  = "veolia-vwis-infra-irl-terraform"
    key     = "k8s.soft.tfstate"
  }
}

terraform {
  required_version = "~> 0.11.13"
  backend "s3" {
    region  = "eu-west-1"
    bucket  = "veolia-vwis-infra-irl-terraform"
    key     = "k8s.soft.monitoring.tfstate"
  }
}

# --- Providers ---
provider "kubernetes" {
  version = "~> 1.5.2"
  host = "${data.terraform_remote_state.infra.eks-cluster-endpoint}"
}

provider "helm" {
  version = "~> 0.9.0"
}*/
