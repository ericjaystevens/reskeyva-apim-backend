terraform {
  required_providers {
      azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  cloud {
    organization = "pizza"

    workspaces {
      name = "reskeyva-apim-backend"
    }
  }
  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = "rg_apim"
  location = "East US 2"
}

resource "azurerm_api_management" "apim" {
  name                = "example-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "demo god"
  publisher_email = "ericjaystevens+demogod@gmail.com"
  sku_name = "Developer_1"
}