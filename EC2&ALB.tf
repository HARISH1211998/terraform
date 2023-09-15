provider "aws" {
  region = ""
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-12345678"  
}

data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = "subnet-12345678"
}

resource "aws_security_group" "ec2_security_group" {
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.existing_subnet.id]

  security_groups = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "my-alb"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"    
  subnet_id              = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "my-ec2-instance"
  }
}
