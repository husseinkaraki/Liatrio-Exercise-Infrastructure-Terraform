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
  path = "${dirname(find_in_parent_folders())}/_envcommon/lb.hcl"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

inputs = {
 load_balancer_name = "liatrio-prod-lb"
 public_subnet_1 = dependency.vpc.outputs.public_subnet_1
 public_subnet_2 = dependency.vpc.outputs.public_subnet_1
 target_group_name = "liatrio-prod-exercist-tg"
 security_group_name = "liatrio-prod-sg"
}