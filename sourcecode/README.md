# terraform for aws

here we are discussion to way how to use the modules to deploy in aws with terraform.  
As of today there are modules for:  
-DDVE
-DD CloudTier 

## DD CloudTier with terraform
We are preparing the aws Cloud to be ready to receiver CloudTier data.  
Therefor we need to create the following ressources in aws:
- IAM User ... Login and password credentials
- IAM Policy ... permission for the S3 Storage
- S3 bucket ... place to strore the CloudTier data

There is no need to clone the repository as the modules are called from the cloud. All you need to do  [download terraform](https://www.terraform.io/downloads.html), install terraform and create a drectory for this action. CD into this directory and start editing the following files:

touch ctpolicy.json
  
```json 
{
   "Version": "2012-10-17",
   "Statement": [
          {
          "Effect": "Allow",
          "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
                ],
          "Resource": [
                "arn:aws:s3:::ct-bucket-terraform",
                "arn:aws:s3:::ct-bucket-terraform/*"
                ]
          }
   ]
}
``` 

In Ressources you set permission for a very special S3 Bucket. Make sure this name matches with the one you do have in your vars. Otherwise you will not have access to the S3 bucket.   

touch variables.tf

```yaml
# aws login information
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}
#region - where do you wanna install your ddve?
variable "region" {
  type = string
  #  default = "eu-central-1"
}
```

touch terraform.tfvars

```yaml
access_key = "fill in your aws access key"
secret_key = "fill in your aws secret"
#created for Frankfurt but changing this is easy
region = "eu-central-1"
```

Now we'll create the provoder for was with these credentials. 

touch provider.tf  

```yaml
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
```

Try a terraform init in the commandline to see if things are working

touch main.tf

```yaml
#Create your storage location for cloudtier - S3 bucket
module "cloudtier_s3_bucket" {
  source         = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/cloudtier/s3_bucket?ref=main"
  s3_bucket_name = "ct-bucket-terraform"
}

#create permission needed to access your s3 bucket
# change the bucket name in your ctpolicy.json
module "CloudTier_iam_user" {
  source         = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/cloudtier/iam?ref=main"
  name_aws_iam_user = "CloudTier_iam_user"
  iam_policy_name   = "s3_cloudtier_iam_policy_ddve6_terraform"
}
```

within the main.tf you can change all variable values you like to change. Variables are :   
variable = value  

So you can change   
name_aws_iam_user = "CloudTier_iam_user"  
into  
name_aws_iam_user = "MyNewIAMUserName"   
and save the file. 

### let's get started with terraform on the commandline

```json
#terraform init
```

```
Initializing modules...
Downloading git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules?ref=main for CloudTier_iam_user...
- CloudTier_iam_user in .terraform/modules/CloudTier_iam_user/modules/aws/cloudtier/iam
Downloading git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules?ref=main for cloudtier_s3_bucket...
- cloudtier_s3_bucket in .terraform/modules/cloudtier_s3_bucket/modules/aws/cloudtier/s3_bucket

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.28.0...
- Installed hashicorp/aws v3.28.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
#terraform plan
```

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.CloudTier_iam_user.aws_iam_access_key.iam-user will be created
  + resource "aws_iam_access_key" "iam-user" {
      + create_date          = (known after apply)
      + encrypted_secret     = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret               = (sensitive value)
      + ses_smtp_password_v4 = (sensitive value)
      + status               = (known after apply)
      + user                 = "CloudTier_iam_user"
    }

  # module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform will be created
  + resource "aws_iam_policy" "iam-policy-terraform" {
      + arn         = (known after apply)
      + description = "Policy for s3 Storage acccess of our DELL DD CloudTier"
      + id          = (known after apply)
      + name        = "s3_cloudtier_iam_policy_ddve6_terraform"
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "s3:ListBucket",
                          + "s3:GetObject",
                          + "s3:PutObject",
                          + "s3:DeleteObject",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:s3:::ct-bucket-terraform",
                          + "arn:aws:s3:::ct-bucket-terraform/*",
                        ]
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
    }

  # module.CloudTier_iam_user.aws_iam_user.iam-user will be created
  + resource "aws_iam_user" "iam-user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "CloudTier_iam_user"
      + path          = "/"
      + unique_id     = (known after apply)
    }

  # module.CloudTier_iam_user.aws_iam_user_policy_attachment.policy-attach will be created
  + resource "aws_iam_user_policy_attachment" "policy-attach" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + user       = "CloudTier_iam_user"
    }

  # module.cloudtier_s3_bucket.aws_s3_bucket.ddve6 will be created
  + resource "aws_s3_bucket" "ddve6" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "ct-bucket-terraform"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = true
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 5 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

```
#terraform apply -auto-approve
```

```
module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform: Refreshing state... [id=arn:aws:iam::362307955468:policy/s3_cloudtier_iam_policy_ddve6_terraform]
module.cloudtier_s3_bucket.aws_s3_bucket.ddve6: Refreshing state... [id=ct-bucket-terraform]
module.CloudTier_iam_user.aws_iam_user.iam-user: Creating...
module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform: Creating...
module.CloudTier_iam_user.aws_iam_user.iam-user: Creation complete after 1s [id=CloudTier_iam_user]
module.CloudTier_iam_user.aws_iam_access_key.iam-user: Creating...
module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform: Creation complete after 1s [id=arn:aws:iam::362307955468:policy/s3_cloudtier_iam_policy_ddve6_terraform]
module.CloudTier_iam_user.aws_iam_user_policy_attachment.policy-attach: Creating...
module.CloudTier_iam_user.aws_iam_access_key.iam-user: Creation complete after 1s [id=AKIAVIWZ4VMGALJMOFUW]
module.CloudTier_iam_user.aws_iam_user_policy_attachment.policy-attach: Creation complete after 2s [id=CloudTier_iam_user-20210219113332930300000001]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

DONE.  
look into your aws and you'll find and IAM User, a S3bucket.  


When you are getting

```
Error: Error attaching policy arn:aws:iam::362307955468:policy/s3_cloudtier_iam_policy_ddve6_terraform to IAM User CloudTier_iam_user: AccessDenied: User: arn:aws:iam::362307955468:user/terraform is not authorized to perform: iam:AttachUserPolicy on resource: user CloudTier_iam_user with an explicit deny
	status code: 403, request id: fb84e9f8-2b29-4d24-a37a-4741f4d9687b



Error: Error creating IAM User CloudTier_iam_user: AccessDenied: User: arn:aws:iam::362307955468:user/terraform is not authorized to perform: iam:CreateUser on resource: arn:aws:iam::362307955468:user/CloudTier_iam_user with an explicit deny
	status code: 403, request id: 60695575-beb6-42fc-9ed8-52940fe98cd1
```  

You have to work with the needed permission for the user you are using credentials for. Reach out to juergen.schubert@dell.com to get help here.   

###delete the aws ressources

```
#terraform destroy -auto-approve    
```

```
module.CloudTier_iam_user.aws_iam_user_policy_attachment.policy-attach: Destroying... [id=CloudTier_iam_user-20210219113332930300000001]
module.CloudTier_iam_user.aws_iam_access_key.iam-user: Destroying... [id=AKIAVIWZ4VMGALJMOFUW]
module.cloudtier_s3_bucket.aws_s3_bucket.ddve6: Destroying... [id=ct-bucket-terraform]
module.cloudtier_s3_bucket.aws_s3_bucket.ddve6: Destruction complete after 0s
module.CloudTier_iam_user.aws_iam_access_key.iam-user: Destruction complete after 1s
module.CloudTier_iam_user.aws_iam_user_policy_attachment.policy-attach: Destruction complete after 1s
module.CloudTier_iam_user.aws_iam_user.iam-user: Destroying... [id=CloudTier_iam_user]
module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform: Destroying... [id=arn:aws:iam::362307955468:policy/s3_cloudtier_iam_policy_ddve6_terraform]
module.CloudTier_iam_user.aws_iam_user.iam-user: Destruction complete after 1s
module.CloudTier_iam_user.aws_iam_policy.iam-policy-terraform: Destruction complete after 1s

Destroy complete! Resources: 5 destroyed.
```

##DDVE