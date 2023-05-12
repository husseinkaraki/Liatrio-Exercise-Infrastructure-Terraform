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
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}



## IAM Policy Nodes and policies for Control Plane

resource "aws_iam_role" "eks" {
  name = var.iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


## IAM Policy Nodes and policies for Nodes
## TO DO - update name to include var env names otherwise youll have a conflict. 
##   name = "${var.env}-${var.eks_name}-eks-nodes"
resource "aws_iam_role" "nodes" {
  name = "${var.eks_name}-eks-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes" {
  for_each = var.node_iam_policies

  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

## Cloudwatch 
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name            = var.cloudwatch_log_stream_name
  log_group_name  = aws_cloudwatch_log_group.cloudwatch_log_group.name
}

## Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks, aws_cloudwatch_log_group.cloudwatch_log_group]
}



## Launch Template

resource "aws_launch_template" "eks_node_group_launch_template" {
  name = var.launch_template_name

  instance_type = var.instance_type

  capacity_reservation_specification {
    capacity_reservation_preference = var.capacity_reservation_preference
  }
  
  monitoring {
    enabled = var.monitoring_enabled
  } 

  ## prevents downtime
  lifecycle {
    create_before_destroy = true
  }

  # user_data = <<EOF
  #           #cloud-config
  #           scaling:
  #             desired_size: ${var.scaling_config_desired_size}
  #             max_size: ${var.scaling_config_max_size}
  #             min_size: ${var.scaling_config_min_size}
  #           EOF
  
}

## Nodes
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = var.subnet_ids

  # capacity_type  = each.value.capacity_type
  # instance_types = each.value.instance_types

  #allows you to override the default scaling configuration set in the launch template for that specific node group
  scaling_config {
    desired_size = var.scaling_config_max_size
    max_size     = var.scaling_config_max_size
    min_size     = var.scaling_config_min_size
  }

  launch_template {
    id = aws_launch_template.eks_node_group_launch_template.id
    version = "$Latest"
  }

  update_config {
    max_unavailable = 1
  }

  # labels = {
  #   role = each.key
  # }

  # cloudwatch_log_group = "/aws/eks/${var.cloudwatch_log_group_name}/${var.node_group_name}"

  depends_on = [aws_iam_role_policy_attachment.nodes]
}

## Get Authorization token to allow K8 provider to access EKS
data "aws_eks_cluster" "eks_cluster_data" {
  name = "${var.eks_name}"
}

data "aws_eks_cluster_auth" "aws_eks_cluster_auth_data" {
  name = "${data.aws_eks_cluster.eks_cluster_data.name}"
}

provider "kubernetes" {
  host                   = "${data.aws_eks_cluster.eks_cluster_data.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
}

resource "kubernetes_namespace" "liatrio_namespace" {
  metadata {
    name = var.liatrio_prod_namespace
  }
}