terraform {
  required_version = ">= 0.12"
  backend "azurerm" {}
}
provider "azurerm" {
    version = "~>2.0"
    features {}
	subscription_id = "a7b78be8-6f3c-4faf-a43d-285ac7e92a05"
	#client_id       = "5898b2d-fb99-400a-9cdd-a277b1fd7ad7"
	#client_secret   = "5a58e09c-8a6e-4e2b-89b5-98145930ccdd"
	#tenant_id       = "c160a942-c869-429f-8a96-f8c8296d57db"
 }
# 1 Resource_Group
resource "azurerm_resource_group" "rg" {
  name     = "vnet1-resources"
  location = "West US 2"
}

/*******************
  VIRTUAL NETWORK
********************/
resource "azurerm_virtual_network" "linux_vm_vnet" {
  name                = var.virtual_network_name1
  address_space       = [var.address_space1]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet {
    name           = var.subnet_service_name
    address_prefix = var.saddress_prefix
    //enforce_private_link_service_network_policies = true
  }
}

# 2 Virtual_Network 
resource "azurerm_virtual_network" "vn" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# 2 Security_Group
resource "azurerm_network_security_group" "sg" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3 Subnet Service
resource "azurerm_subnet" "service" {
  name                 = "service"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes       = ["10.0.1.0/24"]

  enforce_private_link_service_network_policies = true
}

# 4 Subnet Endpoint
resource "azurerm_subnet" "endpoint" {
  name                 = "subnet-endpoint"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes       = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

# 5 Public Ip
resource "azurerm_public_ip" "ip" {
  name                = "pip"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# 6 Load Balancer
resource "azurerm_lb" "lb" {
  name                = "balancer"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.ip.name
    public_ip_address_id = azurerm_public_ip.ip.id
  }
}


# 7 Private Link Service
resource "azurerm_private_link_service" "pl" {
  name                = "privatelink"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  nat_ip_configuration {
    name      = azurerm_public_ip.ip.name
    primary   = true
    subnet_id = azurerm_subnet.service.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.lb.frontend_ip_configuration.0.id,
  ]
}

# 8 Private Endpoint
resource "azurerm_private_endpoint" "main" {
  name                = "private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_private_link_service.pl.id
    is_manual_connection           = false
  }
}

# 9 Network Interface
resource "azurerm_network_interface" "ni" {
  name                = "interface"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.service.id
    private_ip_address_allocation = "static"
    private_ip_address           = "10.0.1.5"

  }
}
# 10 Virtual Machine
/*
//AZURE LINUX VIRTUAL MACHINE TEST 1
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "virtual-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"
  network_interface_ids = [azurerm_network_interface.ni.id]
  provision_vm_agent = true

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
*/ 
//AZURE VIRTUAL MACHINE TEST 2
/*
resource "azurerm_virtual_machine" "vm2" {
  name                  = "virtual-machine"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ni.id]
  vm_size               = "Standard_DS1_v2"
    
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys  {
        path     = "/home/testadmin/.ssh/authorized_keys"
        key_data = file("~/.ssh/id_rsa.pub")
        
                
      }
  
  }
 */ 
//PROVISIONER
/*  
# Connection to VM
  connection {
host  = azurerm_linux_virtual_machine.vm2.id
agent = false
type = "ssh"
user = "adminuser"
private_key = file("~/.ssh/id_rsa")
password = "Password1234!"
}
# Install Azure Data Studio
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install libxss1",
      "sudo apt-get install libgconf-2-4",
      "sudo apt-get install libunwind8",
    ]
  }
//PROVISIONER
*/    
 

 
//WINDOWS SERVER VM TEST 3
resource "azurerm_virtual_machine" "vm2" {
  name                  = "server"
  location              = "westus2"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ni.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name      = "server"
    admin_username     = "adminUsername"
    admin_password     = "Passw0rd1234"
  
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
/*  
  provisioner "remote-exec" {
 
connection {
 
host = azurerm_virtual_machine.vm2.id
 
type = "winrm"
 
port = 5985
 
https = false
 
timeout = "5m"
 
user = "adminUsername"
 
password = "Passw0rd1234"
 
}
 
inline = [
 
"powershell.exe -ExecutionPolicy Unrestricted -Command {Install-WindowsFeature -name Web-Server -IncludeManagementTools}",
 
]
 
}
*/



// WITH VM MACHINE EXENSION
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                       = "vm_extension"
  virtual_machine_id         = azurerm_virtual_machine.vm2.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
    "commandToExecute" : "sudo apt-get install libxss1",
    "commandToExecute" : "sudo apt-get install libgconf-2-4",
    "commandToExecute" : "sudo apt-get install libunwind8",
    "commandToExecute" : "exit 0"
    }
SETTINGS

}
//WINDOWS SERVER VM TEST 3


