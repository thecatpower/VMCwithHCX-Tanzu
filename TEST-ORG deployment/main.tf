provider "vmc" {
  refresh_token = var.api_token
  org_id = var.org_id
}

data "vmc_org" "my_org" {
}

data "vmc_connected_accounts" "my_accounts" {
  account_number = var.aws_account_number
}

data "vmc_customer_subnets" "my_subnets" {
  connected_account_id = data.vmc_connected_accounts.my_accounts.id
  region               = replace(upper(var.sddc_region), "-", "_")
}

/*
resource "vmc_sddc" "sddc_xpday" {
  sddc_name           = var.sddc_name
  vpc_cidr            = var.sddc_mgmt_subnet
  num_host            = var.sddc_num_hosts
  provider_type       = var.provider_type
  region              = data.vmc_customer_subnets.my_subnets.region
  vxlan_subnet        = var.sddc_default
  delay_account_link  = false
  skip_creating_vxlan = false
  sso_domain          = "vmc.local"
  sddc_type           = var.sddc_type
  deployment_type     = var.deployment_type
  size                = var.size
  host_instance_type  = var.host_instance_type

  account_link_sddc_config {
    // customer_subnet_ids  = [data.vmc_customer_subnets.my_subnets.ids[0]]
    customer_subnet_ids  = [var.vpc_subnet_id]
    connected_account_id = data.vmc_connected_accounts.my_accounts.id
  }

  microsoft_licensing_config {
    mssql_licensing = "DISABLED"
    windows_licensing = "DISABLED"
  }

  timeouts {
    create = "300m"
    update = "300m"
    delete = "180m"
  }
}
*/

// commands for second sddc deployment
resource "vmc_sddc" "sddc_xpday_target" {
  sddc_name           = var.sddc_name_target
  vpc_cidr            = var.sddc_mgmt_subnet_target
  num_host            = var.sddc_num_hosts
  provider_type       = var.provider_type
  region              = data.vmc_customer_subnets.my_subnets.region
  vxlan_subnet        = var.sddc_default_target
  delay_account_link  = false
  skip_creating_vxlan = false
  sso_domain          = "vmc.local"
  sddc_type           = var.sddc_type
  deployment_type     = var.deployment_type
  size                = var.size
  host_instance_type  = var.host_instance_type

  account_link_sddc_config {
    // customer_subnet_ids  = [data.vmc_customer_subnets.my_subnets.ids[0]]
    customer_subnet_ids  = [var.vpc_subnet_id_target]
    connected_account_id = data.vmc_connected_accounts.my_accounts.id
  }

  microsoft_licensing_config {
    mssql_licensing = "DISABLED"
    windows_licensing = "DISABLED"
  }

  timeouts {
    create = "300m"
    update = "300m"
    delete = "180m"
  }
}