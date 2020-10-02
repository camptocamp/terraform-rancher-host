terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    rancher = {
      source = "terraform-providers/rancher"
    }
  }
  required_version = ">= 0.13"
}
