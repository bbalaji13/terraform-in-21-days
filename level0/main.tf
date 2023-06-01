resource "aws_s3_bucket" "remote_state" {
  bucket = "balaji-my-tf-test-bucket"
  force_destroy = true
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "balaji-terraform-remote-state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
