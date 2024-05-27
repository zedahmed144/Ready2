
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    "Network"        = "private"
  }
}

// Create a security group for the grafana server
resource "aws_security_group" "grafana" {
  name        = "${var.env}-${var.name}"
  description = "Allow employee access to Grafana UI"
  vpc_id      = var.vpc_id

  ingress {
    description = "" //Should restrict to a VPN
    from_port   = 443
    to_port     = 443
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
    "Name" = "${var.env}-${var.name}"
  }
}
