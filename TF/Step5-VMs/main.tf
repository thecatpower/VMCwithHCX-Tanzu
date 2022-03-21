##############################################
#### VMs must be in Templates folder      ####
#### data.sh is a govc example to do that ####
##############################################

//source onprem SDDC
provider "vsphere" {
  alias                 = "onprem"
  user                  = var.vc_onprem_user
  password              = var.vc_onprem_pw
  vsphere_server        = var.vc_onprem_url
  allow_unverified_ssl  = true
}

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
  name          = var.onprem_subnets.Name1
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}

/*======================================================
Get Templates data
========================================================*/
data "vsphere_content_library" "onprem_library" {
  provider   = vsphere.onprem
  name       = var.onprem_ContLib
}

data "vsphere_content_library_item" "item-BE" {
  provider   = vsphere.onprem
  name       = var.onprem_VM_BE
  type       = "ovf"
  library_id = data.vsphere_content_library.onprem_library.id
}

data "vsphere_content_library_item" "item-FE" {
  provider   = vsphere.onprem
  name       = var.onprem_VM_FE
  type       = "ovf"
  library_id = data.vsphere_content_library.onprem_library.id
}

/*======================================================
Deploy Templates to VMs
========================================================*/
resource "vsphere_virtual_machine" "be" {
  provider         = vsphere.onprem
  name             = var.onprem_VM_BE_VMname
  folder           = "Workloads"
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
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
    template_uuid = data.vsphere_content_library_item.item-BE.id
  }
}


resource "vsphere_folder" "src_folder01" {
  provider      = vsphere.onprem
  path          = "Workloads/Room01"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
resource "vsphere_folder" "src_folder02" {
  provider      = vsphere.onprem
  path          = "Workloads/Room02"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
resource "vsphere_folder" "src_folder03" {
  provider      = vsphere.onprem
  path          = "Workloads/Room03"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
resource "vsphere_folder" "src_folder04" {
  provider      = vsphere.onprem
  path          = "Workloads/Room04"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
resource "vsphere_folder" "src_folder05" {
  provider      = vsphere.onprem
  path          = "Workloads/Room05"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
resource "vsphere_folder" "src_folder06" {
  provider      = vsphere.onprem
  path          = "Workloads/Room06"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}

resource "vsphere_virtual_machine" "fe01" {
  provider         = vsphere.onprem
  name             = "frontend-room01"
  folder = vsphere_folder.src_folder01.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}

resource "vsphere_virtual_machine" "fe02" {
  provider         = vsphere.onprem
  name             = "frontend-room02"
  folder           = vsphere_folder.src_folder02.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}

resource "vsphere_virtual_machine" "fe03" {
  provider         = vsphere.onprem
  name             = "frontend-room03"
  folder           = vsphere_folder.src_folder03.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}

resource "vsphere_virtual_machine" "fe04" {
  provider         = vsphere.onprem
  name             = "frontend-room04"
  folder           = vsphere_folder.src_folder04.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}

resource "vsphere_virtual_machine" "fe05" {
  provider         = vsphere.onprem
  name             = "frontend-room05"
  folder           = vsphere_folder.src_folder05.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}

resource "vsphere_virtual_machine" "fe06" {
  provider         = vsphere.onprem
  name             = "frontend-room06"
  folder           = vsphere_folder.src_folder06.path
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-FE.id
  }
}


//target cloud SDDC
provider "vsphere" {
  alias = "dst"
  user                  = var.vc_cloud_user
  password              = var.vc_cloud_pw
  vsphere_server        = var.vc_cloud_url
  allow_unverified_ssl  = true
}

data "vsphere_datacenter" "cloud_dc" {
  provider      = vsphere.dst
  name          = var.cloud_data_center
}
data "vsphere_compute_cluster" "cloud_cluster" {
  provider      = vsphere.dst
  name          = var.cloud_cluster
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_datastore" "cloud_datastore" {
  provider      = vsphere.dst
  name          = var.cloud_workload_datastore
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_resource_pool" "cloud_pool" {
  provider      = vsphere.dst
  name          = var.cloud_compute_pool
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
data "vsphere_network" "cloud_network1" {
  provider      = vsphere.dst
  //name          = "vmk0-dvportgroup"
  name          = var.cloud_subnets.Name1
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}

data "vsphere_content_library" "cloud_library" {
  provider   = vsphere.dst
  name       = var.cloud_ContLib
}

data "vsphere_content_library_item" "item-JH" {
  provider   = vsphere.dst
  name       = var.cloud_VM_JH
  type       = "ovf"
  library_id = data.vsphere_content_library.cloud_library.id
}

resource "vsphere_virtual_machine" "jh" {
  provider      = vsphere.dst
  name             = var.cloud_VM_JH_VMname
  folder           = "Workloads"
  resource_pool_id = data.vsphere_resource_pool.cloud_pool.id
  datastore_id     = data.vsphere_datastore.cloud_datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = "debian10_64Guest"
  network_interface {
    network_id = data.vsphere_network.cloud_network1.id
  }
  disk {
    label = "disk0"
    size  = 16
    thin_provisioned = true
  }
  disk {
    label = "disk1"
    size  = 500
    unit_number=1
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.item-JH.id
  }
}

resource "vsphere_folder" "dst_folder01" {
  provider      = vsphere.dst
  path          = "Workloads/Room01"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
resource "vsphere_folder" "dst_folder02" {
  provider      = vsphere.dst
  path          = "Workloads/Room02"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
resource "vsphere_folder" "dst_folder03" {
  provider      = vsphere.dst
  path          = "Workloads/Room03"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
resource "vsphere_folder" "dst_folder04" {
  provider      = vsphere.dst
  path          = "Workloads/Room04"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
resource "vsphere_folder" "dst_folder05" {
  provider      = vsphere.dst
  path          = "Workloads/Room05"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}
resource "vsphere_folder" "dst_folder06" {
  provider      = vsphere.dst
  path          = "Workloads/Room06"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}