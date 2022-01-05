variable "template_url"       {default = "./vmc-demo.ova"}
variable "data_center"        {default = "SDDC-Datacenter"}
variable "cluster"            {default = "Cluster-1"}
variable "workload_datastore" {default = "WorkloadDatastore"}
variable "compute_pool"       {default = "Compute-ResourcePool"}


/*================
Subnets IP ranges
=================*/
variable "VMC_subnets" {
  default = {

    Subnet12            = "10.10.12.0/24"
    Subnet12gw          = "10.10.12.1/24"
    Subnet12dhcp        = "10.10.12.100-10.10.12.200"

    Subnet13            = "10.10.13.0/24"
    Subnet13gw          = "10.10.13.1/24"
    Subnet13dhcp        = "10.10.13.100-10.10.13.200"
  }
}


variable "vc_onprem_user" {default = ""}
variable "vc_onprem_pw" {default = ""}
variable "vc_onprem_url" {default = ""}
variable "vc_cloud_user" {default = ""}
variable "vc_cloud_pw" {default = ""}
variable "vc_cloud_url" {default = ""}
