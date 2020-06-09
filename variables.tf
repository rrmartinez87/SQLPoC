
/*******************************
Resource Group variables
*******************************/
variable "resource_group_name" {
  description = "Default resource group name that the resources will be created in."
  default     = "vnet1-resources"
}
/*******************************
Location variables
*******************************/
variable "location" {
  description = "The location/region where the resources are created. Changing this forces a new resource to be created."
  default     = "West US 2"
}
/*******************************
Virtual_Network
*******************************/
variable "virtual_network_name1" {
  description = "Default virtual network name"
  default     = "virtual-network1"
}
variable "address_space1" {
  description = "When creating a VNet, you must specify a custom private IP address space using public and private addresses. Azure assigns resources in a virtual network a private IP address from the address space that you assign."
  default     = "10.0.0.0/16"
}
variable "virtual_network_name2" {
  description = "Default virtual network name"
  default     = "virtual-network2"
}
variable "address_space2" {
  description = "When creating a VNet, you must specify a custom private IP address space using public and private addresses. Azure assigns resources in a virtual network a private IP address from the address space that you assign."
  default     = "10.0.0.0/16"
}
/*******************************
Subnet Service
*******************************/
variable "subnet_service_name" {
  description = "Default subnet service name"
  default     = "subnet-service"
}
variable "saddress_prefix" {
  description = "addres prefix"
  default     = "10.0.1.0/24"
}
variable "subnet_service_name2" {
  description = "Default subnet service name"
  default     = "subnet-service2"
}
variable "saddress_prefix2" {
  description = "addres prefix"
  default     = "10.0.3.0/24"
}  
/*******************************
Subnet Endpoint
*******************************/
variable "subnet_endpoint_name" {
  description = "Default subnet endpoint name"
  default     = "subnet-endpoint"
}
variable "eaddress_prefix" {
  description = "addres prefix"
  default     = "10.0.2.0/24"
}  
/*******************************
security Group
*******************************/
variable "security_group_name" {
  description = "Default security group name"
  default     = "security-group"
}

/*******************************
Public Ip
*******************************/
variable "public_ip_name" {
  description = "Default public ip name"
  default     = "public-ip"
}
variable "sku" {
  description = "Default sku"
  default     = "Standard"
}
variable "allocation_method" {
  description = "Default allocation_method"
  default     = "Static"
}

/*******************************
Load Balancer
*******************************/
variable "lb_name" {
  default     = "azurerm-lb"
}
variable "lb_sku" {
  default     = "Standard"
}

/*******************************
Link Service
*******************************/
variable "ls_name" {
  default     = "privatelink"
}

/*******************************
Private Endpoint
*******************************/
variable "private_endpoint_name" {
  default = "private-endpoint"  
}
variable "service_connection_name" {
  default = "privateserviceconnection"  
}
/*******************************
Network Interface
*******************************/
variable "network_interface_name" {
  default = "interface"  
}
variable "ip_configuration_name" {
  default = "testconfiguration1"  
}
variable "address_allocation" {
  default = "Dynamic"  
}


variable "name" {
  description = "The name for cluster"
  type        = string
  default     = "aks"
}

variable "rbac_enabled" {
  default     = true
  description = "Boolean to enable or disable role-based access control"
  type        = bool
}

variable "client_id" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
  type        = string
}

variable "client_secret" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
  type        = string
}

/*variable "resource_group_name" {
  description = "Default resource group name that the database will be created in."
  default     = "myapp-rg"
}

variable "location" {
  description = "The location/region where the database and server are created. Changing this forces a new resource to be created."
}

variable "server_version" {
  description = "The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default     = "12.0"
}

variable "db_name" {
  description = "The name of the database to be created."
}

variable "db_edition" {
  description = "The edition of the database to be created."
  default     = "Basic"
}

variable "service_objective_name" {
  description = "The performance level for the database. For the list of acceptable values, see https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers. Default is Basic."
  default     = "Basic"
}

variable "collation" {
  description = "The collation for the database. Default is SQL_Latin1_General_CP1_CI_AS"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sql_admin_username" {
  description = "The administrator username of the SQL Server."
}

variable "sql_password" {
  description = "The administrator password of the SQL Server."
}

variable "start_ip_address" {
  description = "Defines the start IP address used in your database firewall rule."
  default     = "0.0.0.0"
}

variable "end_ip_address" {
  description = "Defines the end IP address used in your database firewall rule."
  default     = "0.0.0.0"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"

  default = {
    tag1 = ""
    tag2 = ""
  }
}
*/
