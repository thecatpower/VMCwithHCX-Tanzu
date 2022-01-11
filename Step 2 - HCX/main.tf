terraform {
  required_providers {
    hcx = {
      source = "adeleporte/hcx"
    }
  }
}


################### SOURCE ###################
provider hcx {
   //hcx         = local.hcx_cloud1_url
   //username    = "cloudadmin@vmc.local"
   //password    = "kAHyG8Ipo3Y+-Xw"
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
    //sddc_name   = "XP_DAY_ONPREM"
    sddc_id = var.sddc_id_target
}

/*
// Site Pairing from On-prem to Cloud --> C2C
resource "hcx_site_pairing" "C2C" {
    provider = hcx.onprem
    url         = hcx_vmc.vmc_xpday.cloud_url
    username    = "cloudadmin@vmc.local"
    password    = "kAHyG8Ipo3Y+-Xw"
}
/*



/*
// Site Pairing with the other cloud - Remote is HCX-C2C-2
resource "hcx_site_pairing" "C2C1toC2C2" {
    url         = "https://hcx.sddc-35-177-56-95.vmwarevmc.com"
    username    = "cloudadmin@vmc.local"
    password    = "changeme"
}

resource "hcx_network_profile" "net_management" {
  site_pairing    = hcx_site_pairing.C2C1toC2C2
  vmc           = true

  name          = "externalNetwork"
  mtu           = 1500

  ip_range {
    start_address   = "18.132.147.242"
    end_address     = "18.132.147.242"
  }

  ip_range {
    start_address   = "18.168.66.74"
    end_address     = "18.168.66.74"
  }

  ip_range {
    start_address   = "18.134.93.71"
    end_address     = "18.134.93.71"
  }

  ip_range {
    start_address   = "18.132.159.50"
    end_address     = "18.132.159.50"
  }

  ip_range {
    start_address   = "35.178.52.104"
    end_address     = "35.178.52.104"
  }

  ip_range {
    start_address   = "18.132.31.109"
    end_address     = "18.132.31.109"
  }

  gateway           = ""
  prefix_length     = 0
  primary_dns       = ""
  secondary_dns     = ""
  dns_suffix        = ""
}

data "hcx_compute_profile" "vmc_cp" {
    vcenter       = hcx_site_pairing.C2C1toC2C2.local_vc
    name          = "ComputeProfile(vcenter)"
}

resource "hcx_service_mesh" "service_mesh_1" {
  name                            = "c1toc2sm"
  site_pairing                    = hcx_site_pairing.C2C1toC2C2
  local_compute_profile           = "ComputeProfile(vcenter)"
  remote_compute_profile          = "ComputeProfile(vcenter)"

  app_path_resiliency_enabled     = false
  tcp_flow_conditioning_enabled   = false

  uplink_max_bandwidth            = 10000

  nb_appliances                   = 2 // Up to 16 L2 extension

  service {
    name                = "INTERCONNECT"
  }

  service {
    name                = "VMOTION"
  }

  service {
    name                = "BULK_MIGRATION"
  }

  service {
    name                = "NETWORK_EXTENSION"
  }

  service {
    name                = "DISASTER_RECOVERY"
  }

}


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



resource "hcx_site_pairing" "onPrem2vmc" {
    provider    = hcx.onprem
    url         = "https://hcx.sddc-18-135-22-243.vmwarevmc.com"
    username    = "cloudadmin@vmc.local"
    password    = "changeme"

}

resource "hcx_network_profile" "net_onprem_management" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-management"
    name          = "HCX-Management-profile"
    mtu           = 1500

    ip_range {
        start_address   = "172.17.9.101"
        end_address     = "172.17.9.103"
    }

    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}



resource "hcx_network_profile" "net_onprem_uplink" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-uplink"
    name          = "HCX-Uplink-profile"
    mtu           = 1600

    ip_range {
        start_address   = "172.17.9.104"
        end_address     = "172.17.9.106"
    }


    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}

resource "hcx_network_profile" "net_onprem_vmotion" {
    provider        = hcx.onprem
    site_pairing    = hcx_site_pairing.onPrem2vmc
    network_name  = "hcx-vmotion"
    name          = "HCX-vMotion-profile"
    mtu           = 1500

    ip_range {
        start_address   = "172.17.9.107"
        end_address     = "172.17.9.109"
    }

    gateway           = "172.17.9.1"
    prefix_length     = 24
    primary_dns       = "172.17.9.1"
    secondary_dns     = ""
    dns_suffix        = "cpod-vcn.az-fkd.cloud-garage.net"
}

resource "hcx_compute_profile" "compute_profile_1" {
    provider              = hcx.onprem
    name                  = "comp1"
    datacenter            = "cPod-VCN"
    cluster               = "Cluster"
    datastore             = "vsanDatastore"

    management_network    = hcx_network_profile.net_onprem_management.id
    replication_network   = hcx_network_profile.net_onprem_management.id
    uplink_network        = hcx_network_profile.net_onprem_uplink.id
    vmotion_network       = hcx_network_profile.net_onprem_vmotion.id
    dvs                   = "dvs7"

    service {
        name                = "INTERCONNECT"
    }

    service {
        name                = "WANOPT"
    }

    service {
        name                = "VMOTION"
    }

    service {
        name                = "BULK_MIGRATION"
    }

    service {
        name                = "NETWORK_EXTENSION"
    }

    service {
        name                = "DISASTER_RECOVERY"
    }

}

resource "hcx_service_mesh" "onprem_sm1" {
    provider                        = hcx.onprem
    name                            = "sm1"
    site_pairing                    = hcx_site_pairing.onPrem2vmc
    local_compute_profile           = hcx_compute_profile.compute_profile_1.name
    remote_compute_profile          = "ComputeProfile(vcenter)"

    app_path_resiliency_enabled     = false
    tcp_flow_conditioning_enabled   = false

    uplink_max_bandwidth            = 10000

    service {
        name                = "INTERCONNECT"
    }

    service {
        name                = "VMOTION"
    }

    service {
        name                = "BULK_MIGRATION"
    }

    service {
        name                = "NETWORK_EXTENSION"
    }

    service {
        name                = "DISASTER_RECOVERY"
    }

}


resource "hcx_l2_extension" "l2_vlan1902" {
    provider                        = hcx.onprem
    site_pairing                    = hcx_site_pairing.onPrem2vmc
    service_mesh_id                 = hcx_service_mesh.onprem_sm1.id
    source_network                  = "vlan1902"

    destination_t1                  = "cgw"
    gateway                         = "10.19.2.1"
    netmask                         = "255.255.255.0"

    */