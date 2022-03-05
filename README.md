# Technical Challenge
This Repo Contains Files which are part of a Code writing Challenge - Technical

## Challenge-1

The basic 3-Tier stack consists of the following resources:
```
Internet Gateway, DNS, DMZ, Firewall, Traffic Gateway, Primary / Secondary Networks, Subnets, Web / Application / DB Servers with Disaster Recovery
```

The Terraform Automation creates a 3-Tier architecture in AWS. 
For Automation considering 3-Tier AWS stack, the following resources are considered:
```
Internet Gateway, Route53, Availability Zones, DMZ, Nat Gateway, Bastion Host, VPC, Subnets, Web / Application EC2 Instances, RDS DB
```


## Challenge-2
The scripts are designed to fetch the metadata of the instance in JSON format, from the Elastic Compute-AWS.

These scripts are to perform 2 operations:
  - Can be used to fetch whole metadata
  - Also, the specific attribute value of the metadata


## Challenge-3
The very simple python script will iterates through the value entered for the prompt and extract the value for the key combination entered:

Command to execute:

````
python3 nested_object_challenge
````

The output of above execution:
````
Input the nested Object: {"a":{"b":{"c":1}}}
Input the key: a/b
Output  : {"c":1}
````

