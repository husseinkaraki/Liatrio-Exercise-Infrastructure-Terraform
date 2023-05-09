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

variable "gw_tags" {
  description = "The tags associated with the internet gateway."
  type        = map
}

variable "liatrio_public_rt_name_tag" {
  description = "The tags associated with the route table for the public subnets."
  type        = map
}
