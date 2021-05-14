# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "dev_kubernetes" {
  name     = "dev_kubernetes"
  location = var.location

  tags = {
    environment = "dev"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "dev_k8s_net" {
  name                = "dev_k8s_net"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_kubernetes.name

  tags = {
    environment = "dev"
  }
}

# Create subnet
resource "azurerm_subnet" "dev_k8s_subnet" {
  name                 = "dev_k8s_subnet"
  resource_group_name  = azurerm_resource_group.dev_kubernetes.name
  virtual_network_name = azurerm_virtual_network.dev_k8s_net.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "dev_k8s_nsg" {
  name                = "dev_k8s_nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_kubernetes.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WEB"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.dev_kubernetes.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.dev_kubernetes.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

# Create an SSH key
resource "tls_private_key" "private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
