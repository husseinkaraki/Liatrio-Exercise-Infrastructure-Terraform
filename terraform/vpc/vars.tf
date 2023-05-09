variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "vpc_cidr" {
  description = "The vpc cidr block size."
  type        = string
}

variable "subnet_cidr_block_private_1" {
  description = "The subnet cidr block size for the first private subnet."
  type        = string
}

variable "subnet_cidr_block_private_2" {
  description = "The subnet cidr block size for the second private subnet."
  type        = string
}

variable "subnet_cidr_block_public_1" {
  description = "The subnet cidr block size for the first public subnet."
  type        = string
}

variable "subnet_cidr_block_public_2" {
  description = "The subnet cidr block size for the second public subnet."
  type        = string
}

variable "availablity_zone_1" {
  description = "The availablity zone of the first subnet."
  type        = string
}

variable "availablity_zone_2" {
  description = "The availablity zone of the second subnet."
  type        = string
}

variable "tags_private_subnet_1" {
  description = "The tags associated with the first private subnet."
  type        = map
}

variable "tags_private_subnet_2" {
  description = "The tags associated with the second private subnet."
  type        = map
}

variable "tags_public_subnet_1" {
  description = "The tags associated with the first public subnet."
  type        = map
}

variable "tags_public_subnet_2" {
  description = "The tags associated with the second public subnet."
  type        = map
}