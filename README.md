# Technical Challenge
This Repo Contains Files which is part of a Code writing Challenge - Technical

## Challenge 1

The basic 3-Tier stack consists of the following resources:
```
Internet Gateway, DNS, DMZ, Firewall, Traffic Gateway, Primary / Secondary Networks, Subnets, Web / Application / DB Servers with Disaster Recovery
```

The Terraform Automation creates a 3-Tier architecture in AWS. 
For Automation considering 3-Tier AWS stack, the following resources are considered:
```
Internet Gateway, Route53, Availability Zones, DMZ, Nat Gateway, Bastion Host, VPC, Subnets, Web / Application EC2 Instances, RDS DB
```


## Challenge 2
The 'go' script will fetch the metadata of a EC2 instance 
This can be used to fetch whole metadata or single attribute value.


## Challenge 3
The python script will iterates through the dictionary  value and extract the key and and values

Have to pass the arguments while running the python script.

````
python json-object.py -d "{'x':{'y':{'z':'a'}}}" -k "x/y/z"
````

The output of above given input arguments is
````
Keys:['x', 'y', 'z']
Values:a
````

