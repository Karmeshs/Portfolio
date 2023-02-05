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
  region  = "eu-west-2" #PROD 
  profile = "bookmybook"
  #   version = "value"
  #   assume_role {role_arn = ""}
}