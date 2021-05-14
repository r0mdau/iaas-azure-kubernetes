# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~>2.0"
  features {}
}
