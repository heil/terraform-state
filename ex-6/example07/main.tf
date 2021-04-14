resource "aws_vpc" "kurs-06-jf" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "kurs-06-jf"
    Description = "Example public VPC"
    Environment = "day-01"
  }
}

resource "aws_eip" "kurs-06-jf" {
  vpc = true
}

resource "aws_internet_gateway" "kurs-06-jf" {
  vpc_id = aws_vpc.kurs-06-jf.id
}

resource "aws_subnet" "kurs-06-jf-subnet-01" {
  vpc_id = aws_vpc.kurs-06-jf.id

  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name        = "kurs-06-jf-subnet-01"
    Description = "Public subnet-01 for kurs-06-jf VPC"
    Environment = "day-01"
  }
}

resource "aws_route_table" "kurs-06-jf" {
  vpc_id = aws_vpc.kurs-06-jf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kurs-06-jf.id
  }

  tags = {
    Name        = "kurs-06-jf"
    Description = "Route Table for public subnet kurs-06-jf-subnet-01"
    Environment = "day-01"
  }
}

resource "aws_route_table_association" "kurs-06-jf" {
  subnet_id      = aws_subnet.kurs-06-jf-subnet-01.id
  route_table_id = aws_route_table.kurs-06-jf.id
}

resource "aws_nat_gateway" "kurs-06-jf" {
  allocation_id = aws_eip.kurs-06-jf.id
  depends_on    = ["aws_internet_gateway.kurs-06-jf"]
  subnet_id     = aws_subnet.kurs-06-jf-subnet-01.id
}