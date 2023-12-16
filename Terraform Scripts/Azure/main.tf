
resource "azurerm_resource_group" "rg" {
  name     = "rg-paris-1"
  location = "eastus"
}

resource "azurerm_storage_account" "st" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "st-paris"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

resource "azurerm_storage_container" "sc" {
  name                  = "ctr"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "website" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = "$web" 
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Step 3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "azurerm_public_ip" "pip" {
  name                = "pip-paris-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-paris-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "frontend" {
  name                 = "snet-paris-frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "backend" {
  name                 = "snet-paris-backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_application_gateway" "agw" {
  name                = "agw-paris-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "paris-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "port-simperies"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "paris-fip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "paris-ba-pool"
  }

  backend_http_settings {
    name                  = "backend-http-paris"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "lis-paris"
    frontend_ip_configuration_name = "paris-fip"
    frontend_port_name             = "port-simperies"
    protocol                       = "Http"
    # host_name= azurerm_storage_account.st.primary_web_host
  }

  request_routing_rule {
    name                       = "rrr-paris"
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = "lis-paris"
    backend_address_pool_name  = "paris-ba-pool"
    backend_http_settings_name = "backend-http-paris"
  }
}

# ~~~~~~~~OUTPUT

output "web_endpoint" {
  value = azurerm_storage_account.st.primary_web_host
}
