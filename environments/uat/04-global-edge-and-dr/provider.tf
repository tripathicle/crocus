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
    storage_account_name = "sttfstateuat001"
    container_name       = "tfstate"
    key                  = "uat/04-global-edge-and-dr.tfstate"
  }
}

provider "azurerm" {
  features {}
}
