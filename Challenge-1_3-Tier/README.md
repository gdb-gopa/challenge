### challenge 1

Multiple Cloudformation templates are used

* network.yml : This template will create VPC, SGs, subnets, routing tables, NATs
* ECS-cluster.yml : Its creates  ECS cluster
* database.yml : db template creates a RDS instance 
* ASG.yml : this templates is used to create auto scaling group which will provision EC2 instances 
* ALB : Its creates a application load balancer 

* Log.yml : For application log 

### Architecture Diagram


![alt text](https://github.com/gdb-gopa/challenge/blob/main/Challenge-1_3-Tier/3-Tier-Architecture.jpg)




