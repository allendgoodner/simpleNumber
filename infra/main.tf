terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.1.00"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "project_name" {
  type       = string
  default    = "simpleNumber"
}

variable "location" {
  type       = string
  default    = "centralus"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location  
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.project_name}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"  
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id


  site_config {
    application_stack {
      docker_image                 = "${var.project_name}:latest"
      docker_image_tag             = "latest"        
    }
  }

  app_settings = {
    WEBSITES_PORT               = "8080"
    DOCKER_REGISTERY_SERVER_URL = azurerm_container_registry.acr.login_server
  }
}