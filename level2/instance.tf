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


resource "aws_security_group" "web-private" {
  name        = "${var.env_code}-web-private"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description     = "ssh from loadbalancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.level1.outputs.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_launch_configuration" "test" {
  name            = "${var.env_code}-launch-config"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web-private.id]
  user_data       = file("userdata.sh")
  key_name        = "balaji-tynybay"
}

resource "aws_autoscaling_group" "test" {
  name             = var.env_code
  desired_capacity = 2
  max_size         = 4
  min_size         = 2

  target_group_arns    = [aws_lb_target_group.test.arn]
  launch_configuration = aws_launch_configuration.test.name
  vpc_zone_identifier  = data.terraform_remote_state.level1.outputs.private_subnet_id

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}
