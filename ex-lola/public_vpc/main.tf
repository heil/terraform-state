resource "aws_vpc" "lola-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "lola-vpc"
    Description = "Example public VPC"
    Environment = "day-01"
  }
}

resource "aws_eip" "lola-vpc" {
  vpc = true
}

resource "aws_internet_gateway" "lola-vpc" {
  vpc_id = aws_vpc.lola-vpc.id
}

resource "aws_subnet" "lola-vpc-subnet-01" {
  vpc_id = aws_vpc.lola-vpc.id

  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name        = "lola-vpc-subnet-01"
    Description = "Public subnet-01 for lola-vpc VPC"
    Environment = "day-01"
  }
}

resource "aws_route_table" "lola-vpc" {
  vpc_id = aws_vpc.lola-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lola-vpc.id
  }

  tags = {
    Name        = "lola-vpc"
    Description = "Route Table for public subnet lola-vpc-subnet-01"
    Environment = "day-01"
  }
}

resource "aws_route_table_association" "lola-vpc" {
  subnet_id      = aws_subnet.lola-vpc-subnet-01.id
  route_table_id = aws_route_table.lola-vpc.id
}

resource "aws_nat_gateway" "lola-vpc" {
  allocation_id = aws_eip.lola-vpc.id
  depends_on    = ["aws_internet_gateway.lola-vpc"]
  subnet_id     = aws_subnet.lola-vpc-subnet-01.id
}
