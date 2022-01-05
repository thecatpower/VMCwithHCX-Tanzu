
#########################################
#### VMs must be in Templates folder ####
#### data.sh is a govc example       ####
#########################################

/*
terraform {
  backend "local" {
    path = "../../phase3.tfstate"
  }
}
# Import the state from phase 1and 2 and read the outputs
data "terraform_remote_state" "phase1" {
  backend = "local" 
  config = {
    path    = "../../phase1.tfstate"
  }
}
data "terraform_remote_state" "phase2" {
  backend = "local" 
  config = {
    path    = "../../phase2.tfstate"
  }
}
*/

provider "vsphere" {
  user                  = var.vc_cloud_user
  password              = var.vc_cloud_pw
  vsphere_server        = var.vc_cloud_url
  allow_unverified_ssl  = true
}

provider "vsphere" {
  alias                 = "onprem"
  user                  = var.vc_onprem_user
  password              = var.vc_onprem_pw
  vsphere_server        = var.vc_onprem_url
  allow_unverified_ssl  = true
}


/*================
Deploy Virtual Machimes
=================*/
/*
module "VMs" {
  source = "../VMs"

  data_center         = var.data_center
  cluster             = var.cluster
  workload_datastore  = var.workload_datastore
  compute_pool        = var.compute_pool
  Subnet12            = data.terraform_remote_state.phase2.outputs.segment12_name
  Subnet13            = data.terraform_remote_state.phase2.outputs.segment13_name

 
}*/