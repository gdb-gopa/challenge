# Technical Challenge
Repo is specifically created for a Technical Challenge

## Challenge 1
The cloudformation script creates a 3-Tier architecture in AWS. 

The stacks consists of the following resources
```
VPC, Subnets, Bastion Host, NATs, IGW
EC2 instances using auto scaling group.
MySql RDS.
```
## Challenge 2
The 'go' script will fetch the metadata of a EC2 instance 
This can be used to fetch whole metadata or single attribute value.

For whole meta data of EC2 instance run 
````
go run metaData.go
````
for a single attribute value.
````
go run metaData.go ami-id
````

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

