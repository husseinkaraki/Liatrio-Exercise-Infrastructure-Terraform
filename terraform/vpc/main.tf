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

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "liatrio-prod-vpc"
  }
}

resource "aws_subnet" "private_subnet_1" {
  # count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = var.availablity_zone_1
  cidr_block              = var.subnet_cidr_block_private_1
  map_public_ip_on_launch = false
  tags = var.tags_private_subnet_1
}

resource "aws_subnet" "private_subnet_2" {
  # count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = var.availablity_zone_2
  cidr_block              = var.subnet_cidr_block_private_2
  map_public_ip_on_launch = false
  tags = var.tags_private_subnet_2
}

resource "aws_subnet" "public_subnet_1" {
  # count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = var.availablity_zone_1
  cidr_block              = var.subnet_cidr_block_public_1
  map_public_ip_on_launch = false
  tags = var.tags_public_subnet_1
}

resource "aws_subnet" "public_subnet_2" {
  # count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  availability_zone       = var.availablity_zone_2
  cidr_block              = var.subnet_cidr_block_public_2
  map_public_ip_on_launch = false
  tags = var.tags_public_subnet_2
}
