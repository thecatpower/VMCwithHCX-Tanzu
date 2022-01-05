variable "data_center" {}
variable "cluster" {}
variable "workload_datastore" {}
variable "compute_pool" {}


variable "Subnet12" {}
variable "Subnet13" {}


data "vsphere_datacenter" "dc" {
  name          = var.data_center
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name          = var.workload_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.compute_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network12" {
  name          = var.Subnet12
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network13" {
  name          = var.Subnet13
  datacenter_id = data.vsphere_datacenter.dc.id
}
/*=================================================================
Get Templates data (templates uploaded with GOVC from EC2 instance)
==================================================================*/

data "vsphere_virtual_machine" "demo" {
  name          = "vmc-demo"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "photo" {
  name          = "photoapp-u"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# ================================================

resource "vsphere_virtual_machine" "vm1" {
  name             = "terraform-testVM"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other26xLinuxGuest"

  network_interface {
    network_id = data.vsphere_network.network12.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.demo.id
  }
}

resource "vsphere_virtual_machine" "vm2" {
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