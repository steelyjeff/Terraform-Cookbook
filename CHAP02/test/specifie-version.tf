terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "= 2.10.0"
    }
  }
}

provider "azurerm" {
  features {}
}


variable "resource_group_name" {
  default = "rg_test"
}

variable "location" {
  description = "Azure RG location"
  default     = "East US 2"
  validation  {
    condition     = can(index(["eastus","eastus2"], var.location) >= 0)
    error_message = "The location must be East US or East US 2."
  }

}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#resource "azurerm_public_ip" "pip" {
#  name                         = "book-ip"
#  location                     = azurerm_resource_group.rg.location
#  resource_group_name          = azurerm_resource_group.rg.name
#  public_ip_address_allocation = "Dynamic"
#  domain_name_label            = "bookdevops"
#}
