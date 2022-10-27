# terraform {
#   required_providers {
#       azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#   }
#   cloud {
#     organization = "pizza"

#     workspaces {
#       name = "reskeyva-apim-backend"
#     }
#   }
#   required_version = ">= 1.2.0"
# }

# provider "azurerm" {
#   features {}
# }
# resource "azurerm_resource_group" "rg" {
#   name     = "rg_apim"
#   location = "East US 2"
# }

# resource "azurerm_api_management" "apim" {
#   name                = "crud-apim"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   publisher_name      = "demo god"
#   publisher_email = "ericjaystevens+demogod@gmail.com"
#   sku_name = "Developer_1"

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_api_management_product" "product" {
#   product_id            = "crud"
#   api_management_name   = azurerm_api_management.apim.name
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
#   display_name          = "crud"
#   subscription_required = false
#   published             = true
# }

# resource "azurerm_api_management_api" "api" {
#   api_management_name = azurerm_api_management.apim.name 
#   name                = "reskeyva"
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
#   revision            = "1"
#   display_name        = "reskeyva backend"
#   path                = "reskeyva"
#   protocols           = ["https"]
  
# }

# resource "azurerm_api_management_product_api" "protudctToApi" {
#   api_name            = azurerm_api_management_api.api.name
#   product_id          = azurerm_api_management_product.product.product_id
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
# }

# data "template_file" "op_policy" {
#   template = "${file("${path.module}/set-policy.xml")}"
# }

# data "template_file" "getop_policy" {
#   template = "${file("${path.module}/get-policy.xml")}"
# }

# resource "azurerm_api_management_api_operation" "op" {
#   operation_id        = "set-value"
#   api_name            = azurerm_api_management_api.api.name
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
#   display_name        = "Set a value"
#   method              = "POST"
#   url_template        = "/{key}/"
#   template_parameter  {
#     name = "key"
#     required = true
#     type = "string"
#   }

#   description         = "set a key value"

#   response {
#     status_code = 200
#   } 
# }

# resource "azurerm_api_management_api_operation_policy" "example" {
#   api_name            = azurerm_api_management_api_operation.op.api_name
#   api_management_name = azurerm_api_management_api_operation.op.api_management_name
#   resource_group_name = azurerm_api_management_api_operation.op.resource_group_name
#   operation_id        = azurerm_api_management_api_operation.op.operation_id

#   xml_content = data.template_file.op_policy.rendered

# }

# resource "azurerm_storage_account" "sa" {
#   name                     = "sareskeyva"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_table" "table" {
#   name                 = "reskeyva"
#   storage_account_name = azurerm_storage_account.sa.name
# }


# resource "azurerm_role_assignment" "apim_reader" {
#   scope              = azurerm_storage_account.sa.id
#   role_definition_name = "Reader"
#   principal_id       = azurerm_api_management.apim.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "apim_table" {
#   scope              = azurerm_storage_account.sa.id
#   role_definition_name = "Storage Table Data Contributor"
#   principal_id       = azurerm_api_management.apim.identity[0].principal_id
# }

# resource "azurerm_api_management_api_operation" "get_op" {
#   operation_id        = "get-value"
#   api_name            = azurerm_api_management_api.api.name
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
#   display_name        = "Get a value"
#   method              = "GET"
#   url_template        = "/{key}/"
#   template_parameter  {
#     name = "key"
#     required = true
#     type = "string"
#   }

#   description         = "get a key value"

#   response {
#     status_code = 200
#   } 
# }

# resource "azurerm_api_management_api_operation_policy" "get_policy" {
#   api_name            = azurerm_api_management_api_operation.get_op.api_name
#   api_management_name = azurerm_api_management_api_operation.get_op.api_management_name
#   resource_group_name = azurerm_api_management_api_operation.get_op.resource_group_name
#   operation_id        = azurerm_api_management_api_operation.get_op.operation_id

#   xml_content = data.template_file.getop_policy.rendered

# }