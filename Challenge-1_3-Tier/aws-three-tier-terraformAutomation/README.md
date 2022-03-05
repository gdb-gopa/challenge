## Three-tier architecture automation using Terraform

This project is used to automate the process of a three tier architecture in AWS. There are two main files here. A "main.tf" file which configures the AWS resources based on the variables defined in the "variables.tf" file. Before starting with the "main.tf" file make sure you go through the "variables.tf" file to make sure that you have defined all the variables as per your needs. No variables can be left undefined else it would result in an error. After you have defined the variables you can run the "main.tf" file. Before doing so you need to initialise Terraform which needs to be done only once in a folder. Initialise Terraform with the following command:
```
terraform init
```
After initialisation has been done, you can proceed to running the "main.tf" file with the following command:
```
terraform apply
```

The code does the following:
1. Creates a VPC with the CIDR block provided in the region you want.
2. Creates subnets for each layer.
3. Creates an IGW and NAT gateway.
4. Creates Route tables.
5. Creates a RDS instance.
6. Configures security group for Web layer.
7. EC2 instances for webservers.
8. Application load balancer.

### Points to be noted: 
- Please make sure you create Rout53 zone and is already available in Route53 'Hosted  Zone' Records. The values should be correctly mapped in the variables file
- A certificate must be created and specified for HTTPS listeners, for the ALB to be configured correctly. This should be updated correctly in the variables.tf file
- DNS Name Entry : 3tier-challenge-example.com









