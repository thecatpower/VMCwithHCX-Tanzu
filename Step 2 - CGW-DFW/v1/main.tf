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

## Empty data source defined in order to store the org display name and name in terraform state
data "vmc_org" "my_org" {
}



data "vmc_sddc" "my_sddc" {
  sddc_id               = var.sddc_id
}




/*
resource "nsxt_policy_service" "service_l4port2" {
  description  = "L4 ports service provisioned by Terraform"
  display_name = "service-s2"
 
  l4_port_set_entry {
    display_name      = "TCP82"
    description       = "TCP port 82 entry"
    protocol          = "TCP"
    destination_ports = ["82"]
  }
}

###DFW RULE###
resource "nsxt_policy_security_policy" "policy2" {
  domain       = "cgw"
  display_name = "policy2"
  description  = "Terraform provisioned Security Policy"
  category     = "Application"
 
  rule {
    display_name       = "rule name"
    source_groups      = ["${nsxt_policy_group.mygroup2.path}"]
    action             = "DROP"
    services           = ["${nsxt_policy_service.service_l4port2.path}"]
    logged             = true
    disabled           = true
  }
}

###GFW RULE###
#resource "nsxt_policy_gateway_policy" "cgw_policy" {
#  display_name    = "default"
#  description     = "Terraform provisioned Gateway Policy"
#  category        = "LocalGatewayRules"
#  domain          = "cgw"
#  rule{
#    display_name = "test-rule"
#    scope        = ["/infra/labels/cgw-all"]
#  }
#}

*/




################MANAGEMENT GATEWAY################


resource "nsxt_policy_group" "MGW_grp-VPN" {
  display_name = "NET_VPN"
  description  = ""
  domain       = "mgw"
 
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.93.0.0/16"]
    }
  }
}

resource "nsxt_policy_group" "MGW_grp-Tanzu" {
  display_name = "NET_Tanzu"
  description  = ""
  domain       = "mgw"
 
  criteria {
    ipaddress_expression {
      ip_addresses = ["192.168.1.0/24"]
    }
  }
}

resource "nsxt_policy_group" "MGW_grp-JumpHost" {
  display_name = "JumpHost"
  description  = ""
  domain       = "mgw"
 
  criteria {
    ipaddress_expression {
      ip_addresses = ["192.168.1.2"]
    }
  }
}


resource "nsxt_policy_predefined_gateway_policy" "NSX_MGW_RULESET" {
  path = "/infra/domains/mgw/gateway-policies/default"

  rule {
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "ESXi Outbound Rule"
    description           = "ESXI"
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
    action                = "ALLOW"
    destination_groups    = []
    destinations_excluded = false
    direction             = "IN_OUT"
    disabled              = false
    display_name          = "vCenter Outbound Rule"
    description           = "VCENTER"
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
    source_groups    = [nsxt_policy_group.MGW_grp-VPN.path, nsxt_policy_group.MGW_grp-JumpHost.path]
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
    display_name          = "IN_Tanzu-vCenter (TF)"
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
    source_groups    = [nsxt_policy_group.MGW_grp-Tanzu.path]
    sources_excluded = false
  }
}

################COMPUTE GATEWAY################

resource "nsxt_policy_group" "CGW_grp-JumpHost" {
  display_name = "JumpHost"
  description  = ""
  domain       = "cgw"
 
  criteria {
    ipaddress_expression {
      ip_addresses = ["192.168.1.2"]
    }
  }
}

resource "nsxt_policy_group" "CGW_grp-VPN" {
  display_name = "NET_VPN"
  description  = ""
  domain       = "cgw"
 
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.93.0.0/16"]
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
    display_name  = "IN_VPN-JumpHost"
    source_groups = [nsxt_policy_group.CGW_grp-VPN.path]
    destination_groups = [nsxt_policy_group.CGW_grp-JumpHost.path]
    services      = []
    logged        = true
    log_label     = ""
    action        = "ALLOW"
  }
  
}