# Azure-Scalable-Web-App-Terraform
Project: Deploy a Scalable and Secure Web Application on Azure

Objective:

Design, deploy, and manage a scalable, secure web application using Azure cloud services, adhering to the best practices outlined in the AZ-104 certification. I will use key Azure resources such as Virtual Machines Scale Sets, Virtual Networks, Storage, and Automation tools to ensure high availability, scalability, and security. All resources are fully defined in Terraform.

Key Tasks:

1. Set Up Azure Virtual Networks (VNet) and Subnets:

- Create a VNet to provide isolation for resources and ensure security.
- Configure multiple subnets to segment services (e.g., web, database).
- Implement Network Security Groups (NSGs) for each subnet to enforce access control.

2. Deploy Virtual Machines and Configure Load Balancing:

- Deploy two Azure Virtual Machines (VMs) in the web tier with a Linux OS to host a web application (Apache).
- Configure an Azure Load Balancer to distribute incoming traffic across VMs.
- Ensure that the VMs are in an Availability Set to improve uptime and reliability.
- Enable auto-scaling based on load (e.g., CPU usage).

3. Deploy a Managed Database Service:

- Deploy an Azure SQL Database to store web application data.
- Configure VNet Service Endpoints to secure database access.
- Implement firewall rules to allow access only from the web tier subnet.

4. Implement Storage and Backup:

- Configure an Azure Storage Account for storing static content (images, CSS, etc.) used by the web app.

5. Monitor and Automate:

- Set up Azure Monitor to track the performance of your VMs, databases, and overall infrastructure.
- Create alerts based on metrics (e.g., high CPU usage or low memory).
- Implement Azure Automation to automatically apply updates and patches to VMs.


Deliverables: 

- A fully operational, scalable web application hosted on Azure.
- A documented architecture diagram showing how different Azure resources are integrated.
- A monitoring dashboard with key performance metrics for the web application.
- A set of IaC files defining your infrastructure.
