resource "azurerm_traffic_manager_profile" "tm_p" {
  name                   = var.name
  resource_group_name    = var.resource_group
  traffic_routing_method = var.routing_method

  dns_config {
    relative_name = var.name
    ttl           = 30
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "endpoints" {
  for_each   = var.endpoints
  name       = each.value.name
  profile_id = azurerm_traffic_manager_profile.tm_p.id
  #resource_group_name = var.resource_group
  #type = "azureEndpoints"
  target_resource_id = each.value.resource_id
  #endpoint_status = "Enabled"
  priority = each.value.pr

  depends_on = [azurerm_traffic_manager_profile.tm_p]
}