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

resource "aws_internet_gateway" "liatrio_gw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.gw_name_tag
    }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.liatrio_gw.id
  }

  tags = {
    Name = var.liatrio_public_rt_name_tag
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.liatrio_nat.id
  }

  tags = {
    Name = var.liatrio_private_rt_name_tag
  }
}

resource "aws_route_table_association" "route_table_association_public_subnet1" {
  subnet_id = var.public_subnet_1
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "route_table_association_public_subnet2" {
  subnet_id = var.public_subnet_2
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "route_table_association_private_subnet1" {
  subnet_id = var.privae_subnet_1
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "route_table_association_private_subnet2" {
  subnet_id = var.privae_subnet_2
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "elastic_ip" {
  vpc = true

  tags = {
    Name = "liatrio-${var.eip_name}-nat"
  }
}

resource "aws_nat_gateway" "liatrio_nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = var.public_subnet_1

  tags = {
    Name = "liatrio-${var.nat_name}"
  }

  depends_on = [aws_internet_gateway.liatrio_gw]
} 