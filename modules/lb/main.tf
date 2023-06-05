resource "aws_security_group" "load_balancer" {
  name        = "${var.env_code}-load-balancer-security-group"
  description = "Security group for load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}-Load_balancer_security_group"
  }
}


resource "aws_lb" "load_balancer" {
  name               = "${var.env_code}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = var.public_subnet_id

  tags = {
    Environment = "${var.env_code}-loadbalancer"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    path                = "/"
    port                = "traffic-port"
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
