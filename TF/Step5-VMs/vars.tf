//variable "template_url"       {default = "./vmc-demo.ova"}
variable "onprem_data_center"        {default = "SDDC-Datacenter"}
variable "onprem_cluster"            {default = "Cluster-1"}
variable "onprem_workload_datastore" {default = "WorkloadDatastore"}
variable "onprem_compute_pool"       {default = "Compute-ResourcePool"}

variable "cloud_data_center"        {default = "SDDC-Datacenter"}
variable "cloud_cluster"            {default = "Cluster-1"}
variable "cloud_workload_datastore" {default = "WorkloadDatastore"}
variable "cloud_compute_pool"       {default = "Compute-ResourcePool"}

/*================
Subnets IP ranges
=================*/
variable "onprem_subnets" {
  default = {
    Name1              = "sddc-cgw-network-1"
    Subnet1            = "192.168.1.0/24"
    Subnet1gw          = "192.168.1.1/24"
//    Subnet1dhcp        = "10.10.12.100-10.10.12.200"
  }
}
variable "cloud_subnets" {
  default = {
    Name1               = "sddc-cgw-network-1"
    Subnet1             = "10.3.0.0/24"
    Subnet1gw           = "10.3.0.1/24"
//    Subnet1dhcp        = "10.10.12.100-10.10.12.200"
  }
}

variable "cloud_host_name" {default="10.2.0.69"}

//TEMPLATES
variable "onprem_ContLib" {default = "XPday"}
variable "cloud_ContLib" {default = "XPday"}

variable "onprem_VM_BE" {default = "BACKEND"}
variable "onprem_VM_FE" {default = "frontend-roomxx"}
variable "onprem_VM_BE_VMname" {default = "backend"}
variable "onprem_VM_FE_VMname" {default = "frontend-room"}

variable "cloud_VM_JH" {default = "GREASE-MONKEY"}
variable "cloud_VM_JH_VMname" {default = "grease-monkey"}


variable "VM_JH_OVA" {default = "https://bucket-garage.s3.eu-central-1.amazonaws.com/template-grease-monkey.ova"}
variable "VM_JH_TemplateName" {default = "GREASE-MONKEY"}
variable "VM_JH_TemplateFolder" {default = "Templates"}
variable "VM_JH_VMName" {default = "grease-monkey"}
variable "VM_JH_Folder" {default = "Workloads"}



variable "vc_onprem_user" {default = ""}
variable "vc_onprem_pw" {default = ""}
variable "vc_onprem_url" {default = ""}
variable "vc_cloud_user" {default = ""}
variable "vc_cloud_pw" {default = ""}
variable "vc_cloud_url" {default = ""}

