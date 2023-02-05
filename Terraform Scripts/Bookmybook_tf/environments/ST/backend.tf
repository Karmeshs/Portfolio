terraform {
  backend "s3" {
    encrypt = true
    bucket  = "bookmybook-infra-global"
    # dynamodb_table = "bookmybook-infra-global"
    key          = "New services/ST/infra.tfstate"
    region       = "eu-west-2" #PROD because bucket is in prod only
    profile      = "bookmybook"
    session_name = "Terraform"
    # role_arn = "Enter iam role arn if any"
  }
}
