terraform {
  required_version = ">= 0.13"
  required_providers {
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
