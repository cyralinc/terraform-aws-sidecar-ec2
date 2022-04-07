terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      version = "3.74.3"
      source  = "hashicorp/aws"
    }
  }
}
