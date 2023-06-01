terraform {
  backend "s3" {
    bucket         = "balaji-my-tf-test-bucket"
    key            = "level2.tfstate"
    region         = "us-west-2"
    dynamodb_table = "balaji-terraform-remote-state"

  }
}

provider "aws" {
  region = "us-west-2"
}
