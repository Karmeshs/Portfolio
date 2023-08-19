provider "aws" {
  region  = "us-east-1"
  profile = "paris"
  assume_role {
    role_arn       = "arn:aws:iam::513764098111:role/paris-amsterdam"
  }
}

