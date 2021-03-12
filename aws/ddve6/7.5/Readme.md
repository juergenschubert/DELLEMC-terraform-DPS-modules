# terraform for aws
here we are discussion to way how to use the modules to deploy in aws with terraform.
As of today there are modules for:
-DDVE

## What we need to do on aws are differents tasks     
* create a S3 bucket to store the DDVE data on it  
* create access to this bucket with  
  * IAM Policy which will contain ddvepolicy.json  
  * IAM Role which will give ec2 permission to use this policy ddverolepolicy.json  
* Security group - aws firewall to open port to the instance  
* ec2 instance with a current DDOS and get all configured together  

rename the terraform.tfvars.example into terraform.tfvars and fill up with the needed config information

walk trough the main.tf and change values for your instance.

''''
terrafrom init  
terraform plan  
terraform apply -auto-approve  
'''
.. and you are done