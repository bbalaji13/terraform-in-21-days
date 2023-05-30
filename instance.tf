resource "aws_instance" "web-public" {
  ami                         = "ami-0c65adc9a5c1b5d7c"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "balaji-tynybay"
  vpc_security_group_ids      = [aws_security_group.web-public.id]
  subnet_id                   = aws_subnet.public[0].id

  tags = {
    Name = "${var.env_code}-public"
  }
}

resource "aws_security_group" "web-public" {
  name        = "${var.env_code}-web-public"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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



resource "aws_instance" "web-private" {
  ami                         = "ami-0c65adc9a5c1b5d7c"
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  key_name                    = "balaji-tynybay"
  vpc_security_group_ids      = [aws_security_group.web-private.id]
  subnet_id                   = aws_subnet.private[0].id

  tags = {
    Name = "${var.env_code}-private"
  }
}

resource "aws_security_group" "web-private" {
  name        = "${var.env_code}-web-private"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
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
