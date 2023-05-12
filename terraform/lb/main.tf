terraform {
  # Live modules pin exact Terraform version; generic modules let consumers pin the version.
  # The latest version of Terragrunt (v0.36.0 and above) recommends Terraform 1.1.4 or above.
  required_version = "= 1.4.6"

  # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_lb" "liatrio_prod_lb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  
  subnets            = [var.public_subnet_1, var.public_subnet_2]
  security_groups    = [aws_security_group.liatrio-alb-sg.id]
  
  enable_deletion_protection = false
  enable_http2               = true
}

resource "aws_lb_listener" "liatrio_prod_lb_listener" {
  load_balancer_arn = aws_lb.liatrio_prod_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.liatrio_prod_tg_exercist.arn
  }
}

resource "aws_lb_target_group" "liatrio_prod_tg_exercist" {
  name               = var.target_group_name
  port               = 8080
  protocol           = "HTTP"
  target_type        = "ip"
  vpc_id             = var.vpc_id
  
  health_check {
    path     = "/"
    interval = 30
    timeout  = 10
  }
}

resource "aws_security_group" "liatrio-alb-sg" {
  name = var.security_group_name
  description = "Allow HTTP inbound traffic"
  vpc_id = var.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
