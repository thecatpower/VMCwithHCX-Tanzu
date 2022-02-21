variable "api_token" {
  description = "API token used to authenticate when calling the VMware Cloud Services API."
}
variable "org_id" {
  description = "Organization Identifier."
}
variable "aws_account_number" {
  description = "The AWS account number."
}
variable "sddc_region" {
  description = "The AWS  or VMC specific region."
}
variable host_instance_type {
  description = "The instance type for the ESX hosts in the primary cluster of the SDDC. Possible values: I3_METAL, R5_METAL."
}
variable provider_type {
  description = "Determines what additional properties are available based on cloud provider. Default value : AWS"
}
variable sddc_type {
  description = "Denotes the sddc type, if the value is null or empty, the type is considered as default. Possible values : '1NODE', 'DEFAULT'. "
}
variable size {
  description = "The size of the vCenter and NSX appliances. 'large' or 'LARGE' SDDC size corresponds to a large vCenter appliance and large NSX appliance. 'medium' or 'MEDIUM' SDDC size corresponds to medium vCenter appliance and medium NSX appliance. Default : 'medium'."
}
variable deployment_type {
  description = "Denotes if request is for a SingleAZ or a MultiAZ SDDC. Default : SingleAZ."
}

variable "vpc_subnet_id_src" {
  description = "The AWS VPC subnet id."
}
variable "sddc_name_src"{
  description = "Name of SDDC."
}
variable "sddc_mgmt_subnet_src" {
  description = "SDDC management network CIDR. Only prefix of 16, 20 and 23 are supported."
}
variable "sddc_default_src" {
  description = "A logical network segment that will be created with the SDDC under the compute gateway."
}
variable sddc_num_hosts_src {
  description = "The number of hosts in SDDC."
}

variable "vpc_subnet_id_dst" {
  description = "The AWS VPC subnet id."
}
variable "sddc_name_dst"{
  description = "Name of SDDC."
}
variable "sddc_mgmt_subnet_dst" {
  description = "SDDC management network CIDR. Only prefix of 16, 20 and 23 are supported."
}
variable "sddc_default_dst" {
  description = "A logical network segment that will be created with the SDDC under the compute gateway."
}
variable sddc_num_hosts_dst {
  description = "The number of hosts in SDDC."
}