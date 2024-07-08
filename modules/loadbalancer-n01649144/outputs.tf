
output "load_balancer_name" {
  description = "The name of the Load Balancer"
  value       = azurerm_lb.load_balancer.name
}

