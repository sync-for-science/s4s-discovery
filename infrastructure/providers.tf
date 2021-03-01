terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "s4s-discovery-tfstate"
    key    = "tfstate/s4s"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjunction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
