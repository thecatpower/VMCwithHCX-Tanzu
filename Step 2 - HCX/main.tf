################### SOURCE ###################
provider hcx {
   //hcx         = local.hcx_cloud1_url
   //username    = var.user
   //password    = var.pw
   vmc_token   = var.api_token
}
resource "hcx_vmc" "vmc_xpday" {  
    //sddc_name   = var.sddc_name
    sddc_id = var.sddc_id
}

################### TARGET ###################
provider "hcx" {
    alias  = "target"
    vmc_token   = var.api_token_target
}
resource "hcx_vmc" "vmc_xpday_target" {  
    provider = hcx.target
    //sddc_name   = var.sddc_name_target
    sddc_id = var.sddc_id_target
}

################### MESH ###################
provider hcx {
   alias       = "src-pw"
   hcx         = hcx_vmc.vmc_xpday.cloud_url
   username    = var.user
   password    = var.pw
   //vmc_token   = var.api_token
}
provider hcx {
   alias       = "target-pw"
   hcx         = hcx_vmc.vmc_xpday_target
   username    = var.user_target
   password    = var.pw_target
   //vmc_token   = var.api_token
}
// Site Pairing from SRC to TARGET
resource "hcx_site_pairing" "HCX_Pair_C2C" {
    provider    = hcx.src-pw
    url         = hcx_vmc.vmc_xpday_target.cloud_url
    username    = var.user_target
    password    = var.pw_target
}
resource "hcx_service_mesh" "HCX_SM_CtoC" {
  provider      = hcx.src-pw
  name                            = "c1toc2sm"
  site_pairing                    = hcx_site_pairing.HCX_Pair_C2C
  local_compute_profile           = "ComputeProfile(vcenter)"
  remote_compute_profile          = "ComputeProfile(vcenter)"
  app_path_resiliency_enabled     = false
  tcp_flow_conditioning_enabled   = false
  uplink_max_bandwidth            = 10000
  nb_appliances                   = 1 // Up to 16 L2 extension
  service {name = "INTERCONNECT"}
  service {name = "VMOTION"}
  service {name = "BULK_MIGRATION"}
  service {name = "NETWORK_EXTENSION"}
  service {name = "DISASTER_RECOVERY"}
}

/*
resource "hcx_l2_extension" "ls1" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls1"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "10.0.0.1"
  netmask                         = "255.255.255.0"
}


resource "hcx_l2_extension" "ls2" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls2"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "11.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls3" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls3"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "12.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls4" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls4"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "13.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls5" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls5"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "14.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls6" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls6"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "15.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls7" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls7"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "16.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true
}


resource "hcx_l2_extension" "ls8" {
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  service_mesh_id                 = hcx_service_mesh.service_mesh_1.id
  source_network                  = "ls8"
  network_type                    = "NsxtSegment"

  destination_t1                  = "cgw"
  gateway                         = "17.0.0.1"
  netmask                         = "255.255.255.0"

  egress_optimization             = false
  mon                             = true

  appliance_id                    = hcx_service_mesh.service_mesh_1.appliances_id[1].id
}

output "compute_profile_vmc" {
    value = data.hcx_compute_profile.vmc_cp
}

output "service_mesh_vmc" {
    value = hcx_service_mesh.service_mesh_1
}
*/