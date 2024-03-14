
#ce code interroge des informations sur un groupe de ressources Azure spécifié (var.resource_group_name) et stocke ces informations dans un objet appelé "vnet". Vous pouvez ensuite référencer ces informations dans d'autres parties de votre configuration Terraform, comme pour créer des ressources qui dépendent de ce groupe de ressources.
data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  #référence vnet.name
  resource_group_name = data.azurerm_resource_group.vnet.name
  #référence vnet.location
  location      = data.azurerm_resource_group.vnet.location
  address_space = var.address_space
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]

}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

