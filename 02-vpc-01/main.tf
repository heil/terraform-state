resource "aws_vpc" "kurs05-vk" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "kurs05-vk"
    Description = "Example public private VPC"
    Environment = "day-02"
  }
}

resource "aws_eip" "kurs05-vk" {
  vpc = true
}

resource "aws_internet_gateway" "kurs05-vk" {
  vpc_id = aws_vpc.kurs05-vk.id
}

resource "aws_subnet" "kurs05-vk-subnet-01" {
  vpc_id = aws_vpc.kurs05-vk.id

  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name        = "kurs05-vk-subnet-01"
    Description = "Public subnet-01 for kurs05-vk VPC"
    Environment = "day-02"
  }
}

resource "aws_route_table" "kurs05-vk" {
  vpc_id = aws_vpc.kurs05-vk.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kurs05-vk.id
  }

  tags = {
    Name        = "kurs05-vk"
    Description = "Route Table for public subnet kurs05-vk-subnet-01"
    Environment = "day-02"
  }
}

resource "aws_route_table_association" "kurs05-vk" {
  subnet_id      = aws_subnet.kurs05-vk-subnet-01.id
  route_table_id = aws_route_table.kurs05-vk.id
}

resource "aws_nat_gateway" "kurs05-vk" {
  allocation_id = aws_eip.kurs05-vk.id
  depends_on    = ["aws_internet_gateway.kurs05-vk"]
  subnet_id     = aws_subnet.kurs05-vk-subnet-01.id
}

resource "aws_subnet" "kurs05-vk-subnet-02" {
  vpc_id = aws_vpc.kurs05-vk.id

  cidr_block        = "10.10.2.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name        = "kurs05-vk-subnet-02"
    Description = "Private Subnet kurs05-vk-subnet-02 for VPC kurs05-vk"
    Environment = "day-02"
  }
}

resource "aws_route_table" "kurs05-vk-subnet-02" {
  vpc_id = aws_vpc.kurs05-vk.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.kurs05-vk.id
  }

  tags = {
    Name        = "Private Subnet"
    Description = "Route Table for private subnet kurs05-vk-subnet-02"
    Environment = "day-02"
  }
}

resource "aws_route_table_association" "kurs05-vk-subnet-02" {
  subnet_id      = aws_subnet.kurs05-vk-subnet-02.id
  route_table_id = aws_route_table.kurs05-vk-subnet-02.id
}

#add second private subnet with different availzone for further use
resource "aws_subnet" "kurs05-vk-subnet-03" {
  vpc_id = aws_vpc.kurs05-vk.id

  cidr_block        = "10.10.3.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name        = "kurs05-vk-subnet-03"
    Description = "Private Subnet kurs05-vk-subnet-03 for VPC kurs05-vk"
    Environment = "day-02"
  }
}

resource "aws_route_table" "kurs05-vk-subnet-03" {
  vpc_id = aws_vpc.kurs05-vk.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.kurs05-vk.id
  }

  tags = {
    Name        = "Private Subnet"
    Description = "Route Table for private subnet kurs05-vk-subnet-03"
    Environment = "day-02"
  }
}

resource "aws_route_table_association" "kurs05-vk-subnet-03" {
  subnet_id      = aws_subnet.kurs05-vk-subnet-03.id
  route_table_id = aws_route_table.kurs05-vk-subnet-03.id
}
