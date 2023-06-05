data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "balaji-my-tf-test-bucket"
    key    = "level1.tfstate"
    region = "us-west-2"
  }
}

