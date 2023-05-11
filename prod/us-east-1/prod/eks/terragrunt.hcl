# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks.hcl"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

inputs = {

  iam_role_name = "liatrio-eks-cluster-role"
  cloudwatch_log_group_name = "liatro-prod-log-group"
  cloudwatch_log_stream_name = "liatrio-prod-log-stream"
  
  eks_name = "liatrio-eks-prod"

  node_iam_policies = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  eks_version = "1.25"
  subnet_ids  = tolist([dependency.vpc.outputs.private_subnet_1, dependency.vpc.outputs.private_subnet_2])

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      scaling_config = {
        desired_size = 1
        max_size     = 1
        min_size     = 0
      }
    }
  }
}