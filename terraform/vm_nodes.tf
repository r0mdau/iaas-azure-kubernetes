# K8S nodes
resource "azurerm_public_ip" "k8s_node1" {
  name                = "k8s_node1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_kubernetes.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "k8s_node1" {
  name                = "k8s_node1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_kubernetes.name

  ip_configuration {
    name                          = "k8s_node1"
    subnet_id                     = azurerm_subnet.dev_k8s_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s_node1.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface_security_group_association" "k8s_node1" {
  network_interface_id      = azurerm_network_interface.k8s_node1.id
  network_security_group_id = azurerm_network_security_group.dev_k8s_nsg.id
}

resource "azurerm_linux_virtual_machine" "k8s_node1" {
  name                  = "k8s_node1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dev_kubernetes.name
  network_interface_ids = [azurerm_network_interface.k8s_node1.id]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "k8s_node1_disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  computer_name                   = "node1"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.private_ssh_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "a06"
    role        = "node"
  }
}
