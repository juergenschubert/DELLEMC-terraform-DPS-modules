variable "iam_role_name" {
  default = "iam_role_ddve6_terraform"
}
variable "iam_policy_name" {
  default = "s3_ddve_iam_policy_ddve6_terraform"
}
variable "instance_profile_name" {
  default = "instance_profile_terraform"
}
##
### IAM Role
##
resource "aws_iam_role" "iam_role_terraform" {
  name               = var.iam_role_name
  assume_role_policy = file("ddverolepolicy.json")
}

##
### IAM Profile
##
resource "aws_iam_policy" "iam_policy_terraform" {
  name        = var.iam_policy_name
  path        = "/"
  description = "Policy for s3 Storage acccess of our DELL DDVE"
  policy      = file("ddvepolicy.json")
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
