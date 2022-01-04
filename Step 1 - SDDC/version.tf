terraform {
  required_providers {
    nsx = {
      source = "vmware/nsxt"
    }
    
    vmc = {
      source = "terraform-providers/vmc"
    }
  }
  required_version = ">= 0.12"
}