terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "tf-s3-opportunitity-zeal"
    dynamodb_table = "tf-dynamo-lock"
    region         = "us-east-1"
    key            = "tfstates/production.tfstate"
    role_arn       = "arn:aws:iam::513764098111:role/paris-amsterdam"
    profile        = "paris"
    session_name   = "terraform"
  }
}
