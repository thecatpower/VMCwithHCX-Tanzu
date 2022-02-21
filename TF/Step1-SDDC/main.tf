provider "vmc" {
  refresh_token = var.api_token
  org_id = var.org_id
}
data "vmc_org" "my_org_src" {
}
data "vmc_connected_accounts" "my_accounts_src" {
  account_number = var.aws_account_number
}
data "vmc_customer_subnets" "my_subnets_src" {
  connected_account_id = data.vmc_connected_accounts.my_accounts_src.id
  region               = replace(upper(var.sddc_region), "-", "_")
}
resource "vmc_sddc" "sddc_xpday_src" {
  sddc_name           = var.sddc_name_src
  vpc_cidr            = var.sddc_mgmt_subnet_src
  num_host            = var.sddc_num_hosts_src
  provider_type       = var.provider_type
  region              = data.vmc_customer_subnets.my_subnets_src.region
  vxlan_subnet        = var.sddc_default_src
  delay_account_link  = false
  skip_creating_vxlan = false
  sso_domain          = "vmc.local"
  sddc_type           = var.sddc_type
  deployment_type     = var.deployment_type
  size                = var.size
  host_instance_type  = var.host_instance_type
  account_link_sddc_config {
    // customer_subnet_ids  = [data.vmc_customer_subnets.my_subnets.ids[0]]
    customer_subnet_ids  = [var.vpc_subnet_id_src]
    connected_account_id = data.vmc_connected_accounts.my_accounts_src.id
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



provider "vmc" {
  alias  = "dst"
  refresh_token = var.api_token
  org_id = var.org_id
}
data "vmc_org" "my_org_dst" {
  provider = vmc.dst
}
data "vmc_connected_accounts" "my_accounts_dst" {
  provider = vmc.dst
  account_number = var.aws_account_number
}
data "vmc_customer_subnets" "my_subnets_dst" {
  provider = vmc.dst
  connected_account_id = data.vmc_connected_accounts.my_accounts_dst.id
  region               = replace(upper(var.sddc_region), "-", "_")
}
resource "vmc_sddc" "sddc_xpday_dst" {
  provider = vmc.dst
  sddc_name           = var.sddc_name_dst
  vpc_cidr            = var.sddc_mgmt_subnet_dst
  num_host            = var.sddc_num_hosts_dst
  provider_type       = var.provider_type
  region              = data.vmc_customer_subnets.my_subnets_dst.region
  vxlan_subnet        = var.sddc_default_dst
  delay_account_link  = false
  skip_creating_vxlan = false
  sso_domain          = "vmc.local"
  sddc_type           = var.sddc_type
  deployment_type     = var.deployment_type
  size                = var.size
  host_instance_type  = var.host_instance_type
  account_link_sddc_config {
    // customer_subnet_ids  = [data.vmc_customer_subnets.my_subnets.ids[0]]
    customer_subnet_ids  = [var.vpc_subnet_id_dst]
    connected_account_id = data.vmc_connected_accounts.my_accounts_dst.id
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
