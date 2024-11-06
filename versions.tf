terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      version = ">= 3.73.0, < 6.0.0"
      source  = "hashicorp/aws"
    }
    tls = {
      version = "~> 4.0.0"
      source  = "hashicorp/tls"
    }
  }
}
