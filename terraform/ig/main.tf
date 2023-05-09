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

resource "aws_route_table" "liatrio_ig_to_public_subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.liatrio_gw.id
  }

  tags = {
    Name = var.liatrio_public_rt_name_tag
  }
}

resource "aws_route_table_association" "route_table_association_subnet1" {
  subnet_id = var.public_subnet_1
  route_table_id = aws_route_table.liatrio_ig_to_public_subnet.id
}

resource "aws_route_table_association" "route_table_association_subnet2" {
  subnet_id = var.public_subnet_2
  route_table_id = aws_route_table.liatrio_ig_to_public_subnet.id
}