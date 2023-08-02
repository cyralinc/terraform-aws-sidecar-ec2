terraform {
  required_version = ">= 0.12"
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
    aws = {
      version = ">= 3.73.0"
      source  = "hashicorp/aws"
    }
    tls = {
      version = ">= 4.0.4"
      source  = "hashicorp/tls"
    }
  }
}
