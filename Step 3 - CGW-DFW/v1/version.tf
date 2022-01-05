terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    vmc = {
      source = "terraform-providers/vmc"
      version = "1.7.0"
    }
  }
  required_version = ">= 0.12"
}