# terraform block
terraform {
    required_providers {
      azurerm = {
          source = "hashicorp/azurerm"
          version = "=4.3.0"
      }
    }
}

# provider block
provider "azurerm" {
    features {}
    subscription_id = "b14c50e0-832c-495a-8972-f31cde2082c3"
    tenant_id = "e4446420-af43-4a37-b2b2-eafcaf22488f"
    client_id = "d7dfd100-573d-4899-87b0-780d6bbb4c63"
    client_secret = "VXs8Q~P-87CNMtFqd2hrw05OK5y1ShrCnHtTOdr3" 
}

# resource group
resource "azurerm_resource_group" "projectrg" {
   name = "project-rg"
   location = "central india"
}

# virtual network
resource "azurerm_virtual_network" "projectvnet" {
    name = "project-vnet"
    location = "central india"
    resource_group_name = azurerm_resource_group.projectrg.name
    address_space       = ["10.0.0.0/16"]
}

# subnet
resource "azurerm_subnet" "projectsubnet" {
    name = "project-subnet"
    resource_group_name = azurerm_resource_group.projectrg.name
    virtual_network_name = azurerm_virtual_network.projectvnet.name
    address_prefixes = ["10.0.0.0/24"]
}

# kubernetes cluster
resource "azurerm_kubernetes_cluster" "projectaks" {
    name = "project-aks"
    location = azurerm_resource_group.projectrg.location
    resource_group_name = azurerm_resource_group.projectrg.name
    dns_prefix          = "projectaks"

    default_node_pool {
        name       = "default"
        node_count = 1
        vm_size    = "Standard_D2_v2"
    }

    identity {
        type = "SystemAssigned"
    }
}

# kubernetes cluster nodepool
resource "azurerm_kubernetes_cluster_node_pool" "projnodepool" {
    name = "projnodepool"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.projectaks.id
    vm_size               = "Standard_DS2_v2"
    node_count            = 1
}

# azure container registry
resource "azurerm_container_registry" "projectreg" {
    name = "projectreg11112024"
    location = azurerm_resource_group.projectrg.location
    resource_group_name = azurerm_resource_group.projectrg.name
    sku = "Basic"
}

# azure key vault
resource "azurerm_key_vault" "projectkv" {
    name = "project-kv1112024"
    location = azurerm_resource_group.projectrg.location
    resource_group_name = azurerm_resource_group.projectrg.name
    sku_name = "standard"
    tenant_id = "e4446420-af43-4a37-b2b2-eafcaf22488f"
}


# terraform init
# terraform validate
# terraform plan
# terraform apply

