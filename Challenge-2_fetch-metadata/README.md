## Challenge-2
The scripts are designed to fetch the metadata of the instance in JSON format, from the Elastic Compute-AWS.

These scripts are to perform 2 operations:
  - Can be used to fetch whole metadata
  - Also, the specific attribute value of the metadata
  
For whole meta data of EC2 instance run 
````
python3 get_aws_instance_metadata.py
````
Pass an argument while running the script.
````
python3 get_aws_particular_key.py ami-id
````
