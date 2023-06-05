data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


module "asg" {
  source = "../modules/asg"

  env_code          = "mumbai"
  ami_id            = data.aws_ami.ubuntu.id
  target_group_arn = module.lb.target_group_arn
  private_subnet_id = data.terraform_remote_state.level1.outputs.private_subnet_id
  lb_security_group_id = module.lb.lb_security_group_id
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id
}


