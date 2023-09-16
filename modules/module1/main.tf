provider "aws" {
  region = "ap-southeast-1"  # Replace with your desired AWS region
}

# Define the SSL certificate data source (replace with your certificate ARN)
data "aws_acm_certificate" "expand_ssl_certificate" {
  domain = "*.expand.network"  # Replace with your domain or wildcard
}

resource "aws_instance" "expand_ec2" {
  ami           = "ami-0df7a207adb9748c7"  # Replace with your desired AMI
  instance_type = "t2.medium"             # Replace with your desired instance type
  subnet_id     = "subnet-0ba82a4bb12052bf5"  # Replace with your VPC subnet ID
  security_groups = ["sg-06ba7f99c3b6a4322"]  # Replace with your existing security group ID(s)
  key_name      = "Api-key-generation"  # Replace with your key pair name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo service nginx start
  EOF

  tags = {
    Name = "Expand-network"
  }
}

resource "aws_lb" "expand_alb" {
  name               = "expand-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0ba82a4bb12052bf5", "subnet-078a8e647acac2c5f"]  # Replace with your VPC subnet ID(s)
  security_groups    = ["sg-0a196abab1bbfefed"]     # Replace with your existing security group ID(s)

  enable_http2 = true
}

resource "aws_lb_target_group" "expand_target_group" {
  name     = "expand-target-group"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "vpc-082d7307c5b7f973c"  # Replace with your VPC ID
}

resource "aws_lb_listener" "expand_listener" {
  load_balancer_arn = aws_lb.expand_alb.arn
  port              = 443  # Listen on HTTPS (port 443)
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"  # Choose an appropriate SSL policy

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_certificate" "expand_ssl_certificate" {
  listener_arn    = aws_lb_listener.expand_listener.arn
  certificate_arn = data.aws_acm_certificate.expand_ssl_certificate.arn
}

resource "aws_lb_listener_rule" "expand_rule" {
  listener_arn = aws_lb_listener.expand_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expand_target_group.arn
  }

  condition {
    host_header {
      values = ["*"]  # Match any host header value
    }
  }
}
