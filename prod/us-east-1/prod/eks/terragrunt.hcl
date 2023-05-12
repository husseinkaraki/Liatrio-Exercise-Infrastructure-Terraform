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
  cloudwatch_log_group_name = "liatrio-prod-log-group"
  cloudwatch_log_stream_name = "liatrio-prod-log-stream"
  
  eks_name = "liatrio-eks-prod"
  eks_version = "1.25"

  node_iam_policies = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  subnet_ids  = tolist([dependency.vpc.outputs.private_subnet_1, dependency.vpc.outputs.private_subnet_2])

  node_group_name = "general-node-group"
  launch_template_name = "liatrio-eks-prod-nodegroup-launch-template"
  instance_type = "t3.medium"
  capacity_reservation_preference  = "open"
  scaling_config_desired_size = 1
  scaling_config_max_size     = 2
  scaling_config_min_size     = 1
  monitoring_enabled = true
  liatrio_prod_namespace = "liatrio-main-ns"
}