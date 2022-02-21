//variable "template_url"       {default = "./vmc-demo.ova"}
variable "cloud_data_center"        {default = "SDDC-Datacenter"}
variable "cloud_cluster"            {default = "Cluster-1"}
variable "cloud_workload_datastore" {default = "WorkloadDatastore"}
variable "cloud_compute_pool"       {default = "Compute-ResourcePool"}

variable "onprem_data_center"        {default = "SDDC-Datacenter"}
variable "onprem_cluster"            {default = "Cluster-1"}
variable "onprem_workload_datastore" {default = "WorkloadDatastore"}
variable "onprem_compute_pool"       {default = "Compute-ResourcePool"}

/*================
Subnets IP ranges
=================*/
variable "cloud_subnets" {
  default = {
    Name1               = "sddc-cgw-network-1"
    Subnet1             = "10.3.0.0/24"
    Subnet1gw           = "10.3.0.1/24"
//    Subnet1dhcp        = "10.10.12.100-10.10.12.200"
  }
}
variable "onprem_subnets" {
  default = {
    Name1              = "sddc-cgw-network-1"
    Subnet1            = "172.17.0.0/24"
    Subnet1gw          = "172.17.0.1/24"
//    Subnet1dhcp        = "10.10.12.100-10.10.12.200"
  }
}


variable "vc_onprem_user" {default = ""}
variable "vc_onprem_pw" {default = ""}
variable "vc_onprem_url" {default = ""}
variable "vc_cloud_user" {default = ""}
variable "vc_cloud_pw" {default = ""}
variable "vc_cloud_url" {default = ""}

variable onprem_VM_BE {default = "BACKEND"}
variable onprem_VM_FE {default = "FRONTEND"}
variable onprem_VM_JH {default = "GREASE-MONKEY"}