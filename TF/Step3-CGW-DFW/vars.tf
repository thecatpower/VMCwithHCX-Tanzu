variable "org_id" {
  type = string
  default = ""
}
variable "token" {
  type = string
  default = ""
}
variable "sddc_id_src" {
  type = string
  default = ""
}
variable "sddc_id_dst" {
  type = string
  default = ""
}

variable "admin_public_ips" {
  type = list(string) 
  //default = ""
}

variable "hcx_ip_src" {default = "1.1.1.1"}
#variable "hcx_ip_dst" {default = "1.1.1.1"}
//variable "onprem_hcx_ips" {default = ["1.1.1.1","2.2.2.2","3.3.3.3"]}
variable "onprem_JumpHost_ip" {default = "172.17.0.2"}