##############################################
#### VMs must be in Templates folder      ####
#### data.sh is a govc example to do that ####
##############################################

//source onprem SDDC
/*Matteo
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
*/

/*======================================================
Get Templates data
========================================================*/
/*Matteo
data "vsphere_virtual_machine" "onprem_JH" {
  provider      = vsphere.onprem
  name          = var.onprem_VM_JH
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
data "vsphere_virtual_machine" "onprem_VM_BE" {
  provider      = vsphere.onprem
  name          = var.onprem_VM_BE
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
data "vsphere_virtual_machine" "onprem_FE" {
  provider      = vsphere.onprem
  name          = var.onprem_VM_FE
  datacenter_id = data.vsphere_datacenter.onprem_dc.id
}
*/

/*======================================================
Deploy Templates to VMs
========================================================*/
/*OLD
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
}*/



/*OLD
resource "vsphere_virtual_machine" "jh" {
  provider         = vsphere.onprem
  name             = "grease-monkey"
  folder           = "Workloads"
  resource_pool_id = data.vsphere_resource_pool.onprem_pool.id
  datastore_id     = data.vsphere_datastore.onprem_datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = "debian10_64Guest"
  network_interface {
    network_id = data.vsphere_network.onprem_network1.id
  }
  disk {
    label = "disk0"
    size  = 6
  }
  disk {
    label = "disk1"
    size  = 500
    unit_number=1
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.onprem_JH.id
  }
}

resource "vsphere_virtual_machine" "be" {
  provider         = vsphere.onprem
  name             = "backend"
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
    template_uuid = data.vsphere_virtual_machine.onprem_VM_BE.id
  }
}*/

/*MATTEO
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
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
    template_uuid = data.vsphere_virtual_machine.onprem_FE.id
  }
}*/



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
/*MATTEO
data "vsphere_virtual_machine" "onprem_VM_JH" {
  provider      = vsphere.dst
  name          = var.cloud_VM_JH
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}*/
data "vsphere_host" "cloud_host" {
  provider         = vsphere.dst
  name             = var.cloud_host_name
  datacenter_id    = data.vsphere_datacenter.cloud_dc.id
}

/*MATTEO
data "vsphere_ovf_vm_template" "OVF_VM_JH" {
  provider         = vsphere.dst
  name             = var.VM_JH_TemplateName
  resource_pool_id = data.vsphere_resource_pool.cloud_pool.id
  datastore_id     = data.vsphere_datastore.cloud_datastore.id
  host_system_id   = data.vsphere_host.cloud_host.id
  remote_ovf_url   = "https://bucket-garage.s3.eu-central-1.amazonaws.com/template-grease-monkey.ova"
  ovf_network_map = {
    "Network 1": data.vsphere_network.cloud_network1.id
  }
}*/

/*MATTEO
resource "vsphere_folder" "dst_folder_Templates" {
  provider      = vsphere.dst
  path          = "Templates"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.cloud_dc.id
}*/
resource "vsphere_virtual_machine" "JH_VM_Template" {
  provider                    = vsphere.dst
  name                        = var.VM_JH_TemplateName
  resource_pool_id            = data.vsphere_resource_pool.cloud_pool.id
  datastore_id                = data.vsphere_datastore.cloud_datastore.id
  datacenter_id               = data.vsphere_datacenter.cloud_dc.id
  host_system_id              = data.vsphere_host.cloud_host.id
  folder                      = var.VM_JH_TemplateFolder
  wait_for_guest_net_timeout  = 0
  wait_for_guest_ip_timeout   = 0
  ovf_deploy {
    remote_ovf_url = "https://bucket-garage.s3.eu-central-1.amazonaws.com/template-grease-monkey.ova"
    disk_provisioning = "thin"
    ovf_network_map = {
      "sddc-cgw-network-1" = data.vsphere_network.cloud_network1.id
    }
  }
}

/*MATTEO
resource "vsphere_virtual_machine" "jh" {
  provider      = vsphere.dst
  name             = "JumpHost"
  folder           = "Workloads"
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
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.cloud_JH.id
  }
}
*/