## Three-tier architecture automation using Terraform

This project is used to automate the creation and deployment of a three tier infrastructure on AWS Cloud. There are two main files in this deployment. The "main.tf" file configures the AWS resources based on the variables defined in the "variables.tf" file. Before starting with the "main.tf" file execution, please make sure to validate the "variables.tf" file to confirm that you have defined all the variables as per your requirements. No variables can be left undefined, else it would lead to erroneous execution. After you have defined the variables, you can run the "main.tf" file using the commands mentioned below. Start with initialising Terraform which needs to be done only once in the execution folder. Initialise Terraform with the following command:
```
terraform init
```
After initialisation is done, you can proceed with executing the "main.tf" file using the following command:
```
terraform apply
```


![alt text](https://github.com/gdb-gopa/challenge/blob/main/Challenge-1_3-Tier/3-Tier-Architecture_AWS.JPG)

The deployment performs the following:
1. Creates a VPC with the CIDR block provided in the region you want.
2. Creates subnets for each layer.
3. Creates an IGW and NAT gateway.
4. Creates Route tables.
5. Creates a RDS instance.
6. Configures security group for Web layer.
7. EC2 instances for webservers.
8. Application load balancer.
9. Configure Route53

### Points to be noted: 
- Please make sure you create Rout53 zone and is already available in Route53 'Hosted  Zone' Records. The values should be correctly mapped in the variables file
- A certificate must be created and specified for HTTPS listeners, for the ALB to be configured correctly. This should be updated correctly in the variables.tf file
- DNS Name Entry is '3tier-challenge-example.com' for this example. Please alter this accordingly, to reflect a different DNS entry.









