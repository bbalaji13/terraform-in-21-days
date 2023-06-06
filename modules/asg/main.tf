resource "aws_security_group" "web-private" {
  name        = "${var.env_code}-web-private"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "ssh from loadbalancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.lb_security_group_id]
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
  name                 = "${var.env_code}-launch-config"
  image_id             = var.ami_id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.web-private.id]
  user_data            = file("${path.module}/userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
}

resource "aws_autoscaling_group" "test" {
  name             = var.env_code
  desired_capacity = 2
  max_size         = 4
  min_size         = 2

  target_group_arns    = [var.target_group_arn]
  launch_configuration = aws_launch_configuration.test.name
  vpc_zone_identifier  = var.private_subnet_id

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}
