# Define the AWS provider
provider "aws" {
  region = "ap-southeast-1" # Replace with your desired region
}

# Create the VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "11.0.0.0/16" # Replace with your desired VPC CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a public subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "11.0.1.0/24" # Replace with your desired public subnet CIDR block
  availability_zone       = "ap-southeast-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true          # Enable auto-assign public IP addresses
}

# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a route in the public route table to route traffic to the internet via the internet gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"   # This route will route all traffic (0.0.0.0/0) to the internet gateway
  gateway_id             = aws_internet_gateway.example_igw.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Output the VPC ID and public subnet ID for reference
output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
