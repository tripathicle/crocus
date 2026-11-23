terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatepreprod001"
    container_name       = "tfstate"
    key                  = "preprod/03-monolith-spokes.tfstate"
  }
}

provider "azurerm" {
  features {}
}
