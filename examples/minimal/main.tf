provider "azurerm" {
  version = "~>2.0"
  features {}
}

module "naming" {
  source = "git@github.com:Azure/terraform-azurerm-naming"
}

resource "azurerm_resource_group" "test_group" {
  name     = "${module.naming.resource_group.slug}-${module.naming.api_management.slug}-product-min-test-${substr(module.naming.unique-seed, 0, 5)}"
  location = "uksouth"
}

resource "azurerm_api_management" "apim" {
  name                = module.naming.api_management.name_unique
  location            = azurerm_resource_group.test_group.location
  resource_group_name = azurerm_resource_group.test_group.name
  publisher_name      = "John Doe"
  publisher_email     = "john@doe.com"

  sku_name = "Developer_1"
}

module "apim_product" {
  source = "../../"

  # API Management
  apim_name                = azurerm_api_management.apim.name
  apim_resource_group_name = azurerm_resource_group.test_group.name

  # API Management Product
  apim_product_id           = "myproductid"
  apim_product_display_name = "My Product ID"
}
