resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "East US"  # Replace with your desired location
}

resource "azurerm_virtual_network" "DevVNet" {
  name                = "DevVNet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "Web" {
  name                 = "Web"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.DevVNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "App" {
  name                 = "App"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.DevVNet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "Database" {
  name                 = "Database"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.DevVNet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_lb" "AppLB" {
  name                = "AppLB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.Web.id
  }
}

resource "azurerm_lb_backend_address_pool" "olatope" {
  loadbalancer_id = azurerm_lb.AppLB.id
  name            = "backend-address-pool"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.AppLB.id
  name                = "my-lb-probe"
  port                = 443
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.AppLB.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "internal"
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_availability_set" "avset" {
  name                         = "availabilityset"
  location                     = azurerm_virtual_network.DevVNet.location
  resource_group_name          = azurerm_virtual_network.DevVNet.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
}

resource "azurerm_mssql_server" "example" {
  name                         = "kikiopesqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "AdminUser"
  administrator_login_password = "testpasword1TESTPASSWORD!"  # Replace with your actual password
}

resource "azurerm_mssql_firewall_rule" "app_subnet_rule" {
  name                = "AllowAppSubnet"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address   = "10.0.2.0"
  end_ip_address     = "10.0.2.255"
}

resource "azurerm_mssql_database" "example" {
  name                = "DevDB"
  server_id             = azurerm_mssql_server.example.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
}
