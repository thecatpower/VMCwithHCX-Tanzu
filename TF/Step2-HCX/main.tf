################### SOURCE ###################
provider hcx {
   vmc_token   = var.api_token
}
resource "hcx_vmc" "vmc_xpday" {  
    //sddc_name   = var.sddc_name
    sddc_id = var.sddc_id
}


################### DESTINATION ###################
provider "hcx" {
    alias  = "target"
    vmc_token   = var.api_token
}
resource "hcx_vmc" "vmc_xpday_target" {  
    provider = hcx.target
    //sddc_name   = var.sddc_name_target
    sddc_id = var.sddc_id_target
}