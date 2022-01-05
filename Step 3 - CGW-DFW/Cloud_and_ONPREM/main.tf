provider "vmc" {
  refresh_token = var.token
  org_id = var.org_id
}
provider "nsxt" {
  host                 = data.vmc_sddc.my_sddc.nsxt_reverse_proxy_url
  vmc_token            = var.token
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}
data "vmc_org" "my_org" {
}
data "vmc_sddc" "my_sddc" {
  sddc_id = var.sddc_id
}

################CLOUD MANAGEMENT GATEWAY################
resource "nsxt_policy_group" "MGW_grp-JumpHost" {
  display_name = "JumpHost"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.3.0.2", vmc_public_ip.PublicIP_JumpHost.ip]
    }
  }
}

resource "nsxt_policy_group" "MGW_grp-Admins" {
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "mgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}

resource "nsxt_policy_predefined_gateway_policy" "NSX_MGW_RULESET" {
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
    source_groups    = [nsxt_policy_group.MGW_grp-Admins.path]
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
    source_groups    = [nsxt_policy_group.MGW_grp-Admins.path]
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
    source_groups    = [nsxt_policy_group.MGW_grp-JumpHost.path]
    sources_excluded = false
  }
}

################CLOUD COMPUTE GATEWAY################
resource "nsxt_policy_group" "CGW_grp-JumpHost" {
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
  path = "/infra/domains/cgw/gateway-policies/default"
  rule {
    display_name = "Default VTI Rule"
    nsx_id       = "default-vti-rule"
    action       = "DROP"
    scope        = ["/infra/labels/cgw-vpn"]
  }
  rule {
    scope = ["/infra/labels/cgw-all"]
    display_name  = "JumpHostToRoW (TF)"
    source_groups = [nsxt_policy_group.CGW_grp-JumpHost.path]
    //destination_groups =[nsxt_policy_group.CGW_grp-JumpHost.path] 
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
    //destination_groups =[nsxt_policy_group.CGW_grp-JumpHost.path] 
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
    //destination_groups =[nsxt_policy_group.CGW_grp-JumpHost.path] 
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
  nsxt_reverse_proxy_url = data.vmc_sddc.my_sddc.nsxt_reverse_proxy_url
  display_name = "JumpHost"
}

/*
// HCX correct IP is 18.169.223.28 (autogenerated)
data "vmc_public_ip" "PublicIP_HCX" {
  nsxt_reverse_proxy_url = data.vmc_sddc.my_sddc.nsxt_reverse_proxy_url
  display_name = "HCX"
}
output "HCX_Public_IP-Cloud" {
  value = data.vmc_public_ip.PublicIP_HCX.ip
}
*/

/*
data "nsxt_policy_tier1_gateway" "tier1_router" {
  display_name = "Compute Gateway"
}
resource "nsxt_policy_nat_rule" "NAT_JumpHost" {
  display_name         = "NAT_JumpHost"
  action               = "DNAT"
  #source_networks      = ["9.1.1.1", "9.2.1.1"]
  destination_networks = ["10.3.0.2"]
  translated_networks  = [vmc_public_ip.PublicIP_JumpHost.ip]
  gateway_path         = "/infra/domains/cgw"
  #data.nsxt_policy_tier1_gateway.tier1_router.path
  #nsxt_policy_tier1_gateway.t1gateway.path
  #data.nsxt_policy_tier1_gateway.tier1_router.id
  logging              = false
  firewall_match       = "MATCH_INTERNAL_ADDRESS"
}*/

##################################
############# ONPREM #############
##################################

provider "vmc" {
  alias         = "onprem"
  refresh_token = var.token_onprem
  org_id        = var.org_id_onprem
}

provider "nsxt" {
  alias                = "onprem"
  host                 = data.vmc_sddc.my_sddc_onprem.nsxt_reverse_proxy_url
  vmc_token            = var.token_onprem
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}

data "vmc_org" "my_org_onprem" {
  provider = vmc.onprem
}
data "vmc_sddc" "my_sddc_onprem" {
  provider = vmc.onprem
  sddc_id  = var.sddc_id_onprem
}

################ONPREM MANAGEMENT GATEWAY################
resource "nsxt_policy_group" "MGW-OP_grp-Admins" {
  provider = nsxt.onprem
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
  provider = nsxt.onprem
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
    source_groups    = [nsxt_policy_group.MGW-OP_grp-Admins.path]
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
    source_groups    = [nsxt_policy_group.MGW-OP_grp-Admins.path]
    sources_excluded = false
  }
}

################COMPUTE GATEWAY################
resource "nsxt_policy_group" "CGW-OP_grp-Admins" {
  provider = nsxt.onprem
  display_name = "AdminsToVMC"
  description  = ""
  domain       = "cgw"
  criteria {
    ipaddress_expression {
      ip_addresses = var.admin_public_ips
    }
  }
}
resource "nsxt_policy_predefined_gateway_policy" "NSX_CGW_RULESET-OP" {
  provider = nsxt.onprem
  path = "/infra/domains/cgw/gateway-policies/default"
  rule {
    display_name = "Default VTI Rule"
    nsx_id       = "default-vti-rule"
    action       = "DROP"
    scope        = ["/infra/labels/cgw-vpn"]
  }
}
