variable "name_aws_iam_user" {
  default = "CloudTier_iam_user"
}
variable "iam_policy_name" {
  default = "s3_cloudtier_iam_policy_ddve6_terraform"
}
##
### IAM User
##
resource "aws_iam_user" "iam-user" {
  name = var.name_aws_iam_user
}
#
## create a secret for the user
#
resource "aws_iam_access_key" "iam-user" {
  user = aws_iam_user.iam-user.name
}
##
### IAM Profile
##
resource "aws_iam_policy" "iam-policy-terraform" {
  name        = var.iam_policy_name
  path        = "/"
  description = "Policy for s3 Storage acccess of our DELL DD CloudTier"
  policy      = file("ctpolicy.json")
}
##
### IAM user poliy attachment
##
resource "aws_iam_user_policy_attachment" "policy-attach" {
  user       = var.name_aws_iam_user
  policy_arn = aws_iam_policy.iam-policy-terraform.arn
}
