##
### IAM Role
##
resource "aws_iam_role" "iam_role_terraform" {
  name               = var.iam_role_name
  assume_role_policy =  <<EOF
  {
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

##
### IAM Profile
##
resource "aws_iam_policy" "iam_policy_terraform" {
  name        = var.iam_policy_name
  path        = "/"
  description = "Policy for s3 Storage acccess of our DELL DDVE"
  policy      = <<EOF
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
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
                ]
          }
   ]
}
EOF
}

##
### IAM role poliy attachment
##
resource "aws_iam_role_policy_attachment" "assign-policy_terraform" {
  role       = aws_iam_role.iam_role_terraform.name
  policy_arn = aws_iam_policy.iam_policy_terraform.arn
}

##
###  instance_profile
##
resource "aws_iam_instance_profile" "instance_profile_terraform" {
  name = var.instance_profile_name
  role = aws_iam_role.iam_role_terraform.name
}

output "instance_profile" {
  value = aws_iam_instance_profile.instance_profile_terraform.name
}
