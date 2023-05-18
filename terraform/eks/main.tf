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


# ## IAM Policy Nodes and policies for Control Plane
# ## TODO revisit principal / service if problems occur
# resource "aws_iam_role" "eks" {
#   name = var.iam_role_name

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }


# ## IAM Policy Nodes and policies for Nodes
# ## TO DO - update name to include var env names otherwise youll have a conflict. 
# ##   name = "${var.env}-${var.eks_culster_name}-eks-nodes"
# resource "aws_iam_role" "nodes" {
#   name = "${var.eks_culster_name}-eks-nodes"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "nodes" {
#   for_each = var.node_iam_policies

#   policy_arn = each.value
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "eks" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks.name
# }

# ## Cloudwatch 
# resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
#   name              = var.cloudwatch_log_group_name
#   retention_in_days = 7
# }

# resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
#   name            = var.cloudwatch_log_stream_name
#   log_group_name  = aws_cloudwatch_log_group.cloudwatch_log_group.name
# }

# ## Cluster
# resource "aws_eks_cluster" "eks_cluster" {
#   name     = var.eks_culster_name
#   version  = var.eks_version
#   role_arn = aws_iam_role.eks.arn

#   vpc_config {
#     endpoint_private_access = false
#     endpoint_public_access  = true

#     subnet_ids = var.subnet_ids
#   }

#   depends_on = [aws_iam_role_policy_attachment.eks, aws_cloudwatch_log_group.cloudwatch_log_group]
# }



# ## Launch Template

# resource "aws_launch_template" "eks_node_group_launch_template" {
#   name = var.launch_template_name

#   instance_type = var.instance_type

#   capacity_reservation_specification {
#     capacity_reservation_preference = var.capacity_reservation_preference
#   }
  
#   monitoring {
#     enabled = var.monitoring_enabled
#   } 

#   ## prevents downtime
#   lifecycle {
#     create_before_destroy = true
#   }

#   # user_data = <<EOF
#   #           #cloud-config
#   #           scaling:
#   #             desired_size: ${var.scaling_config_desired_size}
#   #             max_size: ${var.scaling_config_max_size}
#   #             min_size: ${var.scaling_config_min_size}
#   #           EOF
  
# }

# ## Nodes
# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = var.node_group_name
#   node_role_arn   = aws_iam_role.nodes.arn

#   subnet_ids = var.subnet_ids

#   # capacity_type  = each.value.capacity_type
#   # instance_types = each.value.instance_types

#   #allows you to override the default scaling configuration set in the launch template for that specific node group
#   scaling_config {
#     desired_size = var.scaling_config_max_size
#     max_size     = var.scaling_config_max_size
#     min_size     = var.scaling_config_min_size
#   }

#   launch_template {
#     id = aws_launch_template.eks_node_group_launch_template.id
#     version = "$Latest"
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # labels = {
#   #   role = each.key
#   # }

#   # cloudwatch_log_group = "/aws/eks/${var.cloudwatch_log_group_name}/${var.node_group_name}"

#   depends_on = [aws_iam_role_policy_attachment.nodes]
# }

# ## Get Authorization token to allow K8 provider to access EKS
# data "aws_eks_cluster" "eks_cluster_data" {
#   name = "${var.eks_culster_name}"
# }

# data "aws_eks_cluster_auth" "aws_eks_cluster_auth_data" {
#   name = "${data.aws_eks_cluster.eks_cluster_data.name}"
# }

# provider "kubernetes" {
#   host                   = "${data.aws_eks_cluster.eks_cluster_data.endpoint}"
#   cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)}"
#   token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
# }

# resource "kubernetes_namespace" "liatrio_namespace" {
#   metadata {
#     name = var.liatrio_prod_namespace
#   }
# }

# ## 2nd Try

# ## AWS Load Balancer Controller

# provider "helm" {
#   kubernetes {
#     host                   = "${data.aws_eks_cluster.eks_cluster_data.endpoint}"
#   cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)}"
#   token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
#   }
# }


# resource "helm_release" "lbc" {
#   count           = var.load_balancer_controller_enabled ? 1 : 0
#   name            = "aws-load-balancer-controller"
#   chart           = "aws-load-balancer-controller"
#   # version         = null
#   repository      = "https://aws.github.io/eks-charts"
#   namespace       = "kube-system"
#   cleanup_on_fail = true

#   dynamic "set" {
#     for_each = {
#       "clusterName"                                               = var.eks_name
#       "serviceAccount.name"                                       = "aws-load-balancer-controller"
#       "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = aws_iam_role.irsa.arn[0]
#     }
#     content {
#       name  = set.key
#       value = set.value
#     }
#   }
# }

# resource "aws_iam_policy" "lbc" {
#   count       = var.load_balancer_controller_enabled ? 1 : 0
#   name        = var.load_balancer_controller_iam_policy_name
#   description = format("Allow aws-load-balancer-controller to manage AWS resources")
#   path        = "/"
#   policy      = file("./policy.json")
# }

# # IAM Role and Policy for Service Account
# resource "aws_iam_role" "irsa" {
#   count = var.service_account_iam_role_enabled ? 1 : 0
#   name  = var.service_account_iam_role_name ## TODO : edit to include environement var. 
#   path  = "/"
#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"f
#       Effect = "Allow"
#       Principal = {
#         AWS = var.principal_arn ##TODO 
#       }
#       Condition = {
#         StringEquals = {
#           format("%s:sub", var.oidc_url) = local.oidc_fully_qualified_subjects
#         }
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "irsa" {
#   policy_arn = aws_iam_policy.lbc.arn
#   role       = aws_iam_role.irsa.name



########################################################################################################################

########################################################################################################################


resource "aws_security_group" "eks_security_group" {
    name        = "liatrio prod eks cluster sg"
    description = "Allow traffic"
    vpc_id      = var.vpc_id

    ingress {
      description      = "World"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    # tags = merge({
    #   Name = "EKS ${var.env_name}",
    #   "kubernetes.io/cluster/${local.eks_name}": "owned"
    # }, var.tags)
  }
  
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.eks_name
  cluster_version = var.eks_version
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_additional_security_group_ids = [aws_security_group.eks_security_group.id]

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
      ami_type               = "AL2_x86_64"
      disk_size              = 50
      instance_types         = ["t3.medium", "t3.large"]
      vpc_security_group_ids = [aws_security_group.eks_security_group.id]
    }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
}

module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "liatrio_eks_lb_role"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

data "aws_eks_cluster_auth" "aws_eks_cluster_auth_data" {
  name = module.eks.cluster_name
}

# provider "kubernetes" {
#   host                   = "${data.aws_eks_cluster.eks_cluster_data.endpoint}"
#   cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)}"
#   token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
# }


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_certificate_authority_data.0.data
  token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   args        = ["eks", "get-token", "--cluster-name", var.eks_name]
  #   command     = "aws"
  # }
}


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = module.eks.cluster_certificate_authority_data.0.data
    token                  = "${data.aws_eks_cluster_auth.aws_eks_cluster_auth_data.token}"
    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   args        = ["eks", "get-token", "--cluster-name", var.eks_name]
    #   command     = "aws"
    # }
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = "us-east-1"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.eks_name
  }
}