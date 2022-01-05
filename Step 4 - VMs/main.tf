
#########################################
#### VMs must be in Templates folder ####
#### data.sh is a govc example       ####
#########################################

/*
terraform {
  backend "local" {
    path = "../../phase3.tfstate"
  }
}
# Import the state from phase 1and 2 and read the outputs
data "terraform_remote_state" "phase1" {
  backend = "local" 
  config = {
    path    = "../../phase1.tfstate"
  }
}
data "terraform_remote_state" "phase2" {
  backend = "local" 
  config = {
    path    = "../../phase2.tfstate"
  }
}
*/

provider "vsphere" {
  user                  = var.vc_cloud_user
  password              = var.vc_cloud_pw
  vsphere_server        = var.vc_cloud_url
  allow_unverified_ssl  = true
}

/*
provider "vsphere" {
  alias                 = "onprem"
  user                  = var.vc_onprem_user
  password              = var.vc_onprem_pw
  vsphere_server        = var.vc_onprem_url
  allow_unverified_ssl  = true
}
*/

/*================
Deploy Virtual Machimes
=================*/
/*
module "VMs" {
  source = "../VMs"

  data_center         = var.data_center
  cluster             = var.cluster
  workload_datastore  = var.workload_datastore
  compute_pool        = var.compute_pool
  Subnet12            = data.terraform_remote_state.phase2.outputs.segment12_name
  Subnet13            = data.terraform_remote_state.phase2.outputs.segment13_name
}*/

data "vsphere_datacenter" "cloud_dc" {
  name          = var.cloud_data_center
}
data "vsphere_compute_cluster" "cloud_cluster" {
  name          = var.cloud_cluster
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_datastore" "cloud_datastore" {
  name          = var.cloud_workload_datastore
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_resource_pool" "cloud_pool" {
  name          = var.cloud_compute_pool
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_network" "cloud_network1" {
  name          = var.cloud_subnets.Name1
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}

/*
data "vsphere_datacenter" "onprem_dc" {
  provider      = vsphere.onprem
  name          = var.onprem_data_center
}
data "vsphere_compute_cluster" "onprem_cluster" {
  provider      = vsphere.onprem
  name          = var.onprem_cluster
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
data "vsphere_datastore" "onprem_datastore" {
  provider      = vsphere.onprem
  name          = var.onprem_workload_datastore
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
data "vsphere_resource_pool" "onprem_pool" {
  provider      = vsphere.onprem
  name          = var.onprem_compute_pool
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
data "vsphere_network" "onprem_network1" {
  provider      = vsphere.onprem
  name          = var.onprem_subnets.Subnet1
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
*/


/*=================================================================
Get Templates data
==================================================================*/

data "vsphere_virtual_machine" "cloud_VM_BE" {
  name          = var.cloud_VM_BE
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
/*data "vsphere_virtual_machine" "onprem_FE" {
  provider      = vsphere.onprem
  name          = "FE-NGINX"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}*/

# ================================================
resource "vsphere_virtual_machine" "cloud-vm1" {
  name             = "terraform-BE"
  resource_pool_id = data.vsphere_resource_pool.cloud_pool.id
  datastore_id     = data.vsphere_datastore.cloud_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.cloud_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
  }
  disk {
    label = "disk1"
    size  = 50
    unit_number=1
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.cloud_VM_BE.id
  }
}
/*
resource "vsphere_virtual_machine" "vm2" {
  provider      = vsphere.onprem
  name             = "terraform-photo"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id = data.vsphere_network.network13.id
  }

  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = false
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.photo.id
  }
}
*/