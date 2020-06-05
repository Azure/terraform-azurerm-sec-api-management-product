data "azurerm_resource_group" "base" {
  name = var.apim_resource_group_name
}

data "azurerm_api_management" "apim" {
  name                = var.apim_name
  resource_group_name = var.apim_resource_group_name
}