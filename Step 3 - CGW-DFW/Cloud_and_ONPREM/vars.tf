variable "org_id" {
  type = string
  default = ""
}
variable "token" {
  type = string
  default = ""
}
variable "sddc_id" {
  type = string
  default = ""
}

variable "org_id_onprem" {
  type = string
  default = ""
}
variable "token_onprem" {
  type = string
  default = ""
}
variable "sddc_id_onprem" {
  type = string
  default = ""
}

variable "admin_public_ips" {
  type = list(string) 
  //default = ""
}

variable "cloud_hcx_ips" {default = ["1.1.1.1","2.2.2.2","3.3.3.3"]}
variable "onprem_hcx_ips" {default = ["1.1.1.1","2.2.2.2","3.3.3.3"]}
