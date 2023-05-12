variable "load_balancer_name" {
  description = "The name of the load balancer."
  type        = string
}

variable "public_subnet_1" {
  description = "The first public subnet."
  type        = string
}

variable "public_subnet_2" {
  description = "The second public subnet."
  type        = string
}

variable "target_group_name" {
  description = "The name of the target group. "
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group associated with the load balancer."
  type        = string
}

variable "vpc_id" {
  description = "The id of the vpc for the target group."
  type        = string
}
