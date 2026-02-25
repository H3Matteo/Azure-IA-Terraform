output "vnet_id" {
  description = "L'ID du Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "L'ID du Subnet principal"
  value       = azurerm_subnet.subnet.id
}