variable "vpc_id" {
  description = "The ID of the vpc to attach to."
  type        = string
}

variable "public_subnet_1" {
  description = "The ID of the first public subnet the route table is associated with."
  type        = string
}

variable "public_subnet_2" {
  description = "The ID of the second public subnet the route table is associated with."
  type        = string
}

variable "private_subnet_1" {
  description = "The ID of the first private subnet the route table is associated with."
  type        = string
}

variable "private_subnet_2" {
  description = "The ID of the second private subnet the route table is associated with."
  type        = string
}

variable "gw_name_tag" {
  description = "The name tag associated with the internet gateway."
  type        = string
}

variable "liatrio_public_rt_name_tag" {
  description = "The name tag associated with the route table for the public subnets."
  type        = string
}

variable "liatrio_private_rt_name_tag" {
  description = "The name tag associated with the route table for the private subnets."
  type        = string
}

variable "eip_name" {
  description = "The name tag for the Elastic IP."
  type        = string
}

variable "nat_name" {
  description = "The name tag for the NAT gateway."
  type        = string
}