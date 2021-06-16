
terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
   features {}
}

locals {
  common_app_settings = {
    "INSTRUMENTATIONKEY" = azurerm_application_insights.appinsight-app.instrumentation_key
  }
}

data "azurerm_resource_group" "rg-app" {
  name     = "${var.resource_group_name}-${var.environment}"  
}


data "azurerm_app_service_plan" "myplan" {
  name                = "${var.service_plan_name}-${var.environment}"
  resource_group_name = data.azurerm_resource_group.rg-app.name
}

resource "azurerm_app_service" "app" {
  name                = "${var.app_name}-${var.environment}"
  location            = data.azurerm_resource_group.rg-app.location
  resource_group_name = data.azurerm_resource_group.rg-app.name
  app_service_plan_id = data.azurerm_app_service_plan.myplan.id
}

resource "azurerm_application_insights" "appinsight-app" {
  name                = "${var.app_name}-${var.environment}"
  location            = data.azurerm_resource_group.rg-app.location
  resource_group_name = data.azurerm_resource_group.rg-app.name
  application_type    = "web"

  tags = {
    ENV = var.environment
    CreatedBy = var.createdby
  }
}
