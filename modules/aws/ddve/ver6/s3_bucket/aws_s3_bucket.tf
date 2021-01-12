variable "s3_bucket_name" {
  default = "ddve6-bucket-terraform"
}
#s4 bucket where the data will be stored from the DDVE
# need to change the naming convenetion to include instance type
resource "aws_s3_bucket" "ddve6" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}
