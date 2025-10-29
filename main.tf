terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }

  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {}
}

# Generate random suffix for unique name
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "weather-rg"
  location = "East Asia"
}

# Create Storage Account with Static Website Enabled
resource "azurerm_storage_account" "sa" {
  name                     = "weatherstatic${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# Ensure static website is enabled before upload
resource "null_resource" "wait_for_static_site" {
  depends_on = [azurerm_storage_account.sa]

  provisioner "local-exec" {
    command = "echo Static website enabled..."
  }
}

# Upload the index file into $web container (after static website enabled)
resource "azurerm_storage_blob" "index" {
  depends_on             = [null_resource.wait_for_static_site]
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "C:/Users/Bathula Joel/Documents/3rd Internal project/devops/Project/index.html"
  content_type           = "text/html"
}


# Output website URL
output "static_website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}
