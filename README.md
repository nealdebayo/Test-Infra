# Test-Infra
This repo demonstrates the expertise in configuring Azure services to support multiple software development teams and setting up essential components like virtual networks, subnets, load balancing, monitoring, and databases.

# TEST INFRASTRUCTURE USING TERRAFORM CODE
This repo demonstrates the expertise in configuring Azure services to support multiple software development teams and setting up essential components like virtual networks, subnets, load balancing, monitoring, and databases.
The Infrastructure as a Code (IaC) tool used is Terraform.
The project contains the following Azure resources and configurations.
# Virtual Network Setup
A virtual network (VNet) named "DevVNet" was created in Azure. Within the VNet, set up three subnets: "Web", "App", and "Database". Define appropriate address ranges for each subnet to ensure isolation and efficient IP management.
The address space “10.0.0.0/16” was choosing to allow for sufficient address management for all of the three subnets, namely;
Web - “10.0.1.0/24“
App - “10.0.2.0/24”
Database – “10.0.3.0/24”

# Load Balancing and High Availability
Set up an internal load balancer named "AppLB" to distribute traffic to the "Web" and "App" subnets.
Configure the load balancer to ensure high availability and fault tolerance for the application.
Implement health probes to monitor the availability of backend services.

# Database Configuration
Deploy an Azure SQL Database instance named "DevDB" within the "Database" subnet.
Configure appropriate firewall rules to allow access from the "App" subnet only.
