provider "vmc" {
  refresh_token = var.token
  org_id = var.org_id
}
provider "nsxt" {
  host                 = data.vmc_sddc.xpday_sddc_src.nsxt_reverse_proxy_url
  vmc_token            = var.token
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}
data "vmc_org" "my_org_src" {
}
data "vmc_sddc" "xpday_sddc_src" {
  sddc_id = var.sddc_id_src
}

provider "vmc" {
  alias = "dst"
  refresh_token = var.token
  org_id = var.org_id
}
provider "nsxt" {
  alias = "dst"
  host                 = data.vmc_sddc.xpday_sddc_dst.nsxt_reverse_proxy_url
  vmc_token            = var.token
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}
data "vmc_org" "my_org_dst" {
}
data "vmc_sddc" "xpday_sddc_dst" {
  sddc_id = var.sddc_id_dst
}


################SRC MANAGEMENT GATEWAY################
resource "nsxt_policy_group" "MGW-SRC_grp-Admins" {
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}

resource "nsxt_policy_predefined_gateway_policy" "NSX_MGW_RULESET-OP" {
  path = "/infra/domains/mgw/gateway-policies/default"
  rule {
    description           = "ESXI"
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "ESXi Outbound Rule"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = []
    source_groups = [
      "/infra/domains/mgw/groups/ESXI",
    ]
    sources_excluded = false
  }
  rule {
    description           = "VCENTER"
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "vCenter Outbound Rule"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = []
    source_groups = [
      "/infra/domains/mgw/groups/VCENTER",
    ]
    sources_excluded = false
  }
  rule {
    action = "ALLOW"
    destination_groups = [
      "/infra/domains/mgw/groups/VCENTER",
    ]
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "IN_MGMT-vCenter (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = [
      "/infra/services/HTTPS",
      "/infra/services/ICMP-ALL",
    ]
    source_groups    = [nsxt_policy_group.MGW-SRC_grp-Admins.path]
    sources_excluded = false
  }
  rule {
    action = "ALLOW"
    destination_groups = [
      "/infra/domains/mgw/groups/HCX",
    ]
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "IN_MGMT-HCX (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = [
      "/infra/services/HTTPS",
      "/infra/services/HCX-ApplianceManagement",
      "/infra/services/SSH",
      "/infra/services/ICMP_Echo_Request",
    ]
    source_groups    = [nsxt_policy_group.MGW-SRC_grp-Admins.path]
    sources_excluded = false
  }
  rule {
    description           = "HCX Outbound"
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "HCX Outbound Rule (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = []
    source_groups = [
      "/infra/domains/mgw/groups/HCX",
    ]
    sources_excluded = false
  }
}

################DST MANAGEMENT GATEWAY################
resource "nsxt_policy_group" "MGW-DST_grp-JumpHost" {
  provider = nsxt.dst
  display_name = "JumpHost"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.3.0.2", vmc_public_ip.PublicIP_JumpHost.ip]
    }
  }
}
resource "nsxt_policy_group" "MGW-DST_grp-Admins" {
  provider = nsxt.dst
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}

resource "nsxt_policy_group" "MGW-DST_grp-HCX-SRC-Public" {
  provider = nsxt.dst
  display_name = "HCX-Source-Public"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = [var.hcx_ip_src]
    }
  }
}


resource "nsxt_policy_predefined_gateway_policy" "NSX_MGW_RULESET" {
  provider = nsxt.dst
  path = "/infra/domains/mgw/gateway-policies/default"
  rule {
    description           = "ESXI"
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "ESXi Outbound Rule"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = []
    source_groups = [
      "/infra/domains/mgw/groups/ESXI",
    ]
    sources_excluded = false
  }
  rule {
    description           = "VCENTER"
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "vCenter Outbound Rule"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = []
    source_groups = [
      "/infra/domains/mgw/groups/VCENTER",
    ]
    sources_excluded = false
  }
  rule {
    action = "ALLOW"
    destination_groups = [
      "/infra/domains/mgw/groups/VCENTER",
    ]
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "IN_MGMT-vCenter (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = [
      "/infra/services/HTTPS",
      "/infra/services/ICMP-ALL",
    ]
    source_groups    = [nsxt_policy_group.MGW-DST_grp-Admins.path]
    sources_excluded = false
  }
  rule {
    action = "ALLOW"
    destination_groups = [
      "/infra/domains/mgw/groups/HCX",
    ]
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "IN_MGMT-HCX (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = [
      "/infra/services/HTTPS",
      "/infra/services/HCX-ApplianceManagement",
      "/infra/services/SSH",
      "/infra/services/ICMP_Echo_Request",
    ]
    source_groups    = [nsxt_policy_group.MGW-DST_grp-Admins.path, nsxt_policy_group.MGW-DST_grp-HCX-SRC-Public.path]
    sources_excluded = false
  }
  rule {
    action = "ALLOW"
    destination_groups = [
      "/infra/domains/mgw/groups/VCENTER",
      "/infra/domains/mgw/groups/NSX-MANAGER",
      "/infra/domains/mgw/groups/ESXI",
    ]
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "IN_MGMT-JumpTovCenterNSX (TF)"
    ip_version            = "IPV4_IPV6"
    logged                = false
    profiles              = []
    scope = [
      "/infra/labels/mgw",
    ]
    services = [
      "/infra/services/HTTPS",
      "/infra/services/ICMP-ALL",
    ]
    source_groups    = [nsxt_policy_group.MGW-DST_grp-JumpHost.path]
    sources_excluded = false
  }
}

################SRC COMPUTE GATEWAY################
/*
resource "nsxt_policy_fixed_segment" "NET-CGW1-OP" {
  display_name        = "sddc-cgw-network-1"
  description         = "sddc-cgw-network-1"
  connectivity_path   = "/infra/tier-1s/cgw"
  subnet {
    cidr        = "192.168.1.1/24"
    dhcp_ranges = ["192.168.1.128-192.168.1.254"]
    dhcp_v4_config {
      server_address = "100.96.1.1/30"
      lease_time     = 86400
    }
  }
}
*/

resource "nsxt_policy_predefined_gateway_policy" "NSX_CGW_RULESET-OP" {
  path = "/infra/domains/cgw/gateway-policies/default"
  rule {
    display_name = "Default VTI Rule"
    nsx_id       = "default-vti-rule"
    action       = "ALLOW"
    scope        = ["/infra/labels/cgw-vpn"]
  }
}

################DST COMPUTE GATEWAY################
resource "nsxt_policy_group" "CGW_grp-JumpHost" {
  provider = nsxt.dst
  display_name = "JumpHost"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.3.0.2"]
    }
  }
}
resource "nsxt_policy_group" "CGW_grp-NET-10-3-0" {
  provider = nsxt.dst
  display_name = "NET-10-3-0"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.3.0.0/24"]
    }
  }
}
resource "nsxt_policy_group" "CGW_grp-NET-10-10-0" {
  provider = nsxt.dst
  display_name = "NET-10-10-0"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.10.0.0/23"]
    }
  }
}
resource "nsxt_policy_group" "CGW_grp-NET-10-10-4" {
  provider = nsxt.dst
  display_name = "NET-10-10-4"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.10.4.0/23"]
    }
  }
}
resource "nsxt_policy_group" "CGW_grp-Admins" {
  provider = nsxt.dst
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}

resource "nsxt_policy_predefined_gateway_policy" "NSX_CGW_RULESET" {
  provider = nsxt.dst
  path = "/infra/domains/cgw/gateway-policies/default"
  rule {
    display_name = "Default VTI Rule"
    nsx_id       = "default-vti-rule"
    action       = "ALLOW"
    scope        = ["/infra/labels/cgw-vpn"]
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "JumpHostToRoW (TF)"
    source_groups = [nsxt_policy_group.CGW_grp-JumpHost.path]
    services      = [
      "/infra/services/HTTPS",
      "/infra/services/HTTP",
      "/infra/services/ICMP-ALL",
      "/infra/services/DNS-UDP",
      "/infra/services/NTP",
      "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "NET-10-3-0ToINET (TF)"
    source_groups = [nsxt_policy_group.CGW_grp-NET-10-3-0.path]
    services      = [
      "/infra/services/HTTPS",
      "/infra/services/HTTP",
      "/infra/services/ICMP-ALL",
      "/infra/services/DNS-UDP",
      "/infra/services/NTP",
      "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "NET-10-10-4ToINET (TF)"
    source_groups = [nsxt_policy_group.CGW_grp-NET-10-10-4.path]
    services      = [
      "/infra/services/HTTPS",
      "/infra/services/HTTP",
      "/infra/services/ICMP-ALL",
      "/infra/services/DNS-UDP",
      "/infra/services/NTP",
      "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "AdminsToJumpHost (TF)"
    source_groups = [nsxt_policy_group.CGW_grp-Admins.path] 
    destination_groups =[nsxt_policy_group.CGW_grp-JumpHost.path]  
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
}

####### CLOUD NAT RULES #######
resource "vmc_public_ip" "PublicIP_JumpHost" {
  provider = vmc.dst
  nsxt_reverse_proxy_url = data.vmc_sddc.xpday_sddc_dst.nsxt_reverse_proxy_url
  display_name = "JumpHost"
}
// HCX correct IP is 18.169.223.28 (autogenerated)
/*
data "vmc_public_ip" "PublicIP_HCX" {
  provider = vmc.dst
  nsxt_reverse_proxy_url = data.vmc_sddc.my_sddc.nsxt_reverse_proxy_url
  display_name = "HCX"
}
output "HCX_Public_IP-Cloud" {
  provider = vmc.dst
  value = data.vmc_public_ip.PublicIP_HCX.ip
}
*/





/*
################SRC COMPUTE GATEWAY################
resource "nsxt_policy_group" "CGW-OP_grp-Admins" {
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}
resource "nsxt_policy_group" "CGW-OP_grp-JumpHost" {
  display_name = "JumpHost"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = [var.onprem_JumpHost_ip]
    }
  }
}
resource "nsxt_policy_group" "CGW-OP_grp-NET-Inside" {
  display_name = "NET-Inside"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["172.17.0.0/24"]
    }
  }
}
resource "nsxt_policy_predefined_gateway_policy" "NSX_CGW_RULESET-OP" {
  path = "/infra/domains/cgw/gateway-policies/default"
  rule {
    display_name = "Default VTI Rule"
    nsx_id       = "default-vti-rule"
    action       = "DROP"
    scope        = ["/infra/labels/cgw-vpn"]
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "IN_Admins-JumpHost (TF)"
    source_groups = [nsxt_policy_group.CGW-OP_grp-Admins.path] 
    destination_groups =[nsxt_policy_group.CGW-OP_grp-JumpHost.path]  
    services      = [
      "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "OUT_JumpHost (TF)"
    source_groups = [nsxt_policy_group.CGW-OP_grp-JumpHost.path]
    services      = [
      "/infra/services/HTTPS",
      "/infra/services/HTTP",
      "/infra/services/ICMP-ALL",
      "/infra/services/DNS-UDP",
      "/infra/services/NTP",
      "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "OUT_NET-Inside (TF)"
    source_groups = [nsxt_policy_group.CGW-OP_grp-NET-Inside.path]
    services      = [
      "/infra/services/HTTPS",
      "/infra/services/HTTP",
      "/infra/services/ICMP-ALL",
      "/infra/services/DNS-UDP",
      "/infra/services/NTP",
    //  "/infra/services/SSH",
    ]
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
}

#ONPREM - NAT
resource "vmc_public_ip" "src_PublicIP_MGMT" {
  provider = vmc.onprem
  nsxt_reverse_proxy_url = data.vmc_sddc.my_sddc_onprem.nsxt_reverse_proxy_url
  display_name = "MGMT"
}
resource "nsxt_policy_nat_rule" "NAT_MGMT" {
  provider = nsxt.onprem
  display_name         = "MGMT-JumpHost-SSH"
  action               = "DNAT"
  destination_networks = [vmc_public_ip.src_PublicIP_MGMT.ip]
  translated_networks  = [var.onprem_JumpHost_ip]
  gateway_path         = "/infra/domains/cgw"
  service              = "/infra/services/SSH"
  translated_ports     = "22"
  logging              = true
  firewall_match       = "MATCH_INTERNAL_ADDRESS"
  tag {
    scope = "color"
    tag   = "blue"
  }
}
*/
