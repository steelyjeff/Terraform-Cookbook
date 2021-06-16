terraform {
  required_version = ">= 0.12"
  backend "azurerm"{
    resource_group_name   = "RG_TFBACKEND"
    storage_account_name  = "storagetfbackend1"
    container_name        = "tfstate"
    key                   = "myapp2.tfstate"
    access_key            = "yP4dFPEsLbu3DR+ZSCnd9unC5zhGALTUvggzwYfYoaqOMh/IAV4N3JRMKD0AvRsZklAv+F9+YG94xIGAZ/6BkQ=="
  }  
}

provider "azurerm" {
  features{}
  #skip_provider_registration = true
}

locals {
  common_app_settings = {
    "INSTRUMENTATIONKEY" = azurerm_application_insights.appinsight-app.instrumentation_key
  }
}

data "azurerm_resource_group" "rg-app" {
  name     = "${var.resource_group_name}-${var.environment}"  
}


data "terraform_remote_state" "service_plan_tfstate" {
  backend = "azurerm"
  config = {
    resource_group_name  = "RG-TFBACKEND"
    storage_account_name = "storagetfbackend1"
    container_name       = "tfstate"
    key                  = "myapp.tfstate"
    access_key            = "yP4dFPEsLbu3DR+ZSCnd9unC5zhGALTUvggzwYfYoaqOMh/IAV4N3JRMKD0AvRsZklAv+F9+YG94xIGAZ/6BkQ=="

  }
}

resource "azurerm_app_service" "app" {
  name                = "${var.app_name}-${var.environment}"
  location            = data.azurerm_resource_group.rg-app.location
  resource_group_name = data.azurerm_resource_group.rg-app.name
  app_service_plan_id = data.terraform_remote_state.service_plan_tfstate.outputs.service_plan_id
}

resource "azurerm_application_insights" "appinsight-app" {
  name                = "${var.app_name}-${var.environment}"
  location            = data.azurerm_resource_group.rg-app.location
  resource_group_name = data.azurerm_resource_group.rg-app.name
  application_type    = "web"

  tags = {
    ENV       = var.environment
    CreatedBy = var.createdby
  }
}
