variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}
variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
}

variable "iam_role_name" {
  description = "The name of the IAM role that manages the EKS cluster."
  type = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the cloudwatch log group name."
  type = string
}

variable "cloudwatch_log_stream_name" {
  description = "The name of the cloudwatch log stream name."
  type = string
}



variable "subnet_ids" {
  description = "List of private subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
}

variable "node_group_name" {
  description = "Name of the node group."
  type        = string
}

variable "launch_template_name" {
  description = "The name of the launch template."
  type        = string
}

variable "instance_type" {
  description = "Instance size / type "
  type        = string
}

variable "capacity_reservation_preference" {
  description = "Types of instances like on-demand / spot. "
  type        = string
}

variable "scaling_config_desired_size" {
  description = "Desired size for scale."
  type        = number
}

variable "scaling_config_max_size" {
  description = "Max size for scale."
  type        = number
}

variable "scaling_config_min_size" {
  description = "Min size for scale."
  type        = number
}

variable "monitoring_enabled" {
  description = "Enable monitoring."
  type        = bool
}
