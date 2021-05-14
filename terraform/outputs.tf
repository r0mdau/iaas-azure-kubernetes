# Display private SSH key
output "tls_private_key" {
  value = tls_private_key.private_ssh_key.private_key_pem
}

# Display public ip of master1
output "public_ip_address_master1" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.k8s_master1.*.ip_address
}

# Display public ip of node1
output "public_ip_address_node1" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.k8s_node1.*.ip_address
}
