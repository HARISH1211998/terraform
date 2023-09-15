provider "aws" {
  region = "ap-southeast-1"  # Replace with your desired AWS region
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-082d7307c5b7f973c"  # Replace with your existing VPC ID
}

data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = "subnet-0ba82a4bb12052bf5"  # Replace with your existing subnet ID
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

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0acb5e61d5d7b19c8"  # Replace with your desired AMI ID
  instance_type          = "t2.micro"     # Replace with your desired instance type
  subnet_id              = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "terraform-Test-Ec2-instance"
  }
}
