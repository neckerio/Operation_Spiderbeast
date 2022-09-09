terraform {
  required_version = ">= 1.2.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.1"
    }
  }
}
