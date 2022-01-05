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

variable "admin_public_ips" {
  type = list(string) 
  //default = ""
}