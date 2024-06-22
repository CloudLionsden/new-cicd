provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "example-subnet"
  }
}

# Create a route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-route-table"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Create a Security Group
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.name]

  tags = {
    Name = "example-instance"
  }
}
