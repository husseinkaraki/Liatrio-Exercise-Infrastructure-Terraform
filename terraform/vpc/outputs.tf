output "vpc_id" {
  description  = "The ID of the VPC."
  value        = aws_vpc.main_vpc.id
}

output "public_subnet_1" {
  description  = "The ID of the first public subnet."
  value        = aws_subnet.public_subnet_1.id
}

output "public_subnet_2" {
  description  = "The ID of the first second subnet."
  value        = aws_subnet.public_subnet_2.id
}

output "private_subnet_1" {
  description  = "The ID of the first private subnet."
  value        = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
  description  = "The ID of the second private subnet."
  value        = aws_subnet.private_subnet_2.id
}

output "default_security_group_id" {
  description  = "The ID of the security group created by default on VPC creation."
  value        = aws_vpc.main_vpc.default_security_group_id
}
