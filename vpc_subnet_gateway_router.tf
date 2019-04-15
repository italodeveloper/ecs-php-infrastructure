#Criando rede VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "172.21.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "terraform_vpc"
  }
}

# Cirando Subnets
resource "aws_subnet" "terraform_subnet_public_1" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"

  tags {
    Name = "terraform_subnet_public_1"
  }
}

resource "aws_subnet" "terraform_subnet_public_2" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags {
    Name = "terraform_subnet_public_2"
  }
}

resource "aws_subnet" "terraform_subnet_public_3" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2c"

  tags {
    Name = "terraform_subnet_public_3"
  }
}

#Criando subnets privadas para banco de dados e/ou cache
resource "aws_subnet" "terraform_subnet_private_1" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.40.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags {
    Name = "terraform_subnet_private_1"
  }
}

resource "aws_subnet" "terraform_subnet_private_2" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.50.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"

  tags {
    Name = "terraform_subnet_private_2"
  }
}

resource "aws_subnet" "terraform_subnet_private_3" {
  vpc_id                  = "${aws_vpc.terraform_vpc.id}"
  cidr_block              = "172.21.60.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2c"

  tags {
    Name = "terraform_subnet_private_3"
  }
}

# Criando o Gateway de Internet
resource "aws_internet_gateway" "terraform_internet_gateway" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  tags {
    Name = "terraform_internet_gateway"
  }
}

# Associando Roteador com o Gateway
resource "aws_route_table" "terraform_route_public" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform_internet_gateway.id}"
  }

  tags {
    Name = "terraform_route_public"
  }
}

# Acossiando o routeador com as subnets publicas para acesso externo
resource "aws_route_table_association" "terraform_public_1" {
  subnet_id      = "${aws_subnet.terraform_subnet_public_1.id}"
  route_table_id = "${aws_route_table.terraform_route_public.id}"
}

resource "aws_route_table_association" "terraform_public_2" {
  subnet_id      = "${aws_subnet.terraform_subnet_public_2.id}"
  route_table_id = "${aws_route_table.terraform_route_public.id}"
}

resource "aws_route_table_association" "terraform_public_3" {
  subnet_id      = "${aws_subnet.terraform_subnet_public_3.id}"
  route_table_id = "${aws_route_table.terraform_route_public.id}"
}
