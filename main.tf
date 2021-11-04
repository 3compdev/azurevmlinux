# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}
# Create a resource group
resource "azurerm_resource_group" "Aamir-rg" {
  name     = "${var.resource_prefix}-RG"
  location = var.node_location
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Aamir-vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.Aamir-rg.name
  location            = var.node_location
  address_space       = var.node_address_space
}
# Create a subnets within the virtual network
resource "azurerm_subnet" "Aamir-subnet" {
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.Aamir-rg.name
  virtual_network_name = azurerm_virtual_network.Aamir-vnet.name
  address_prefixes     = [var.node_address_prefix]
}
# Create Linux Public IP
resource "azurerm_public_ip" "Aamir-public_ip" {
  count = var.node_count
  name  = "${var.resource_prefix}-${format("%02d", count.index)}-PublicIP"
  #name = "${var.resource_prefix}-PublicIP"
  location            = azurerm_resource_group.Aamir-rg.location
  resource_group_name = azurerm_resource_group.Aamir-rg.name
  allocation_method   = var.Environment == "Terraform" ? "Static" : "Dynamic"
  tags = {
    environment = "Terraform"
  }
}
# Create Network Interface
resource "azurerm_network_interface" "Aamir-nic" {
  count = var.node_count
  #name = "${var.resource_prefix}-NIC"
  name                = "${var.resource_prefix}-${format("%02d", count.index)}-NIC"
  location            = azurerm_resource_group.Aamir-rg.location
  resource_group_name = azurerm_resource_group.Aamir-rg.name
  #
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Aamir-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.Aamir-public_ip.*.id, count.index)
    #public_ip_address_id = azurerm_public_ip.Aamir-public_ip.id
    #public_ip_address_id = azurerm_public_ip.Aamir-public_ip.id
  }
}
# Creating resource NSG
resource "azurerm_network_security_group" "Aamir-nsg" {
  name                = "${var.resource_prefix}-NSG"
  location            = azurerm_resource_group.Aamir-rg.location
  resource_group_name = azurerm_resource_group.Aamir-rg.name
  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
  security_rule {
    name                       = "Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Terraform"
  }
}
# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "Aamir-subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.Aamir-subnet.id
  network_security_group_id = azurerm_network_security_group.Aamir-nsg.id
}
# Virtual Machine Creation — Linux
resource "azurerm_virtual_machine" "Aamir-linux_vm" {
  count = var.node_count
  name  = count.index == 0 ? "WebServer" : "DbServer"
  #name = "${var.resource_prefix}-VM"
  location                      = azurerm_resource_group.Aamir-rg.location
  resource_group_name           = azurerm_resource_group.Aamir-rg.name
  network_interface_ids         = [element(azurerm_network_interface.Aamir-nic.*.id, count.index)]
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = count.index == 0 ? "WebServer" : "DbServer"
    admin_username = "terminator"
    admin_password = "Password@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Terraform"
  }
}