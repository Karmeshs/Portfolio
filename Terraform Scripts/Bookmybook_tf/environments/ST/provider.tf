# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region  = "us-west-2"
  profile = "bookmybook"
  #   version = "value"+9
  #   assume_role {role_arn = ""}
}