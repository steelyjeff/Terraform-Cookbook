
terraform {
  required_version = ">= 0.12"
  backend "azurerm"{
    resource_group_name   = "RG_TFBACKEND"
    storage_account_name  = "storagetfbackend1"
    container_name        = "tfstate"
    key                   = "myapp.tfstate"
    access_key            = "yP4dFPEsLbu3DR+ZSCnd9unC5zhGALTUvggzwYfYoaqOMh/IAV4N3JRMKD0AvRsZklAv+F9+YG94xIGAZ/6BkQ=="
  }
}

provider "azurerm" {
  features {}
}

#locals {
#  common_app_settings = {
#    "INSTRUMENTATIONKEY" = azurerm_application_insights.appinsight-app.instrumentation_key
#  }
#}

resource "azurerm_resource_group" "rg-app" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
  tags = {
    ENV = var.environment
  }
}

resource "azurerm_app_service_plan" "plan-app" {
  name                = "${var.service_plan_name}-${var.environment}"
  location            = azurerm_resource_group.rg-app.location
  resource_group_name = azurerm_resource_group.rg-app.name

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    ENV = var.environment
    CreatedBy = var.createdby
  }
}

output "service_plan_id" {
  description = "Output ID of the service plan"
  value       = azurerm_app_service_plan.plan-app.id
}
#resource "azurerm_app_service" "app" {
#  name                = "${var.app_name}-${var.environment}"
 # location            = azurerm_resource_group.rg-app.location
 # resource_group_name = azurerm_resource_group.rg-app.name
 # app_service_plan_id = azurerm_app_service_plan.plan-app.id
#}

#resource "azurerm_application_insights" "appinsight-app" {
#  name                = "${var.app_name}-${var.environment}"
#  location            = azurerm_resource_group.rg-app.location
#  resource_group_name = azurerm_resource_group.rg-app.name
#  application_type    = "web"
#
#  tags = {
#    ENV = var.environment
#    CreatedBy = var.createdby
#  }
#}
