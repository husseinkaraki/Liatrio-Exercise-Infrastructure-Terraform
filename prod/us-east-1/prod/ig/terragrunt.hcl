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
  path = "${dirname(find_in_parent_folders())}/_envcommon/ig.hcl"
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  public_subnet_1 = dependency.vpc.outputs.public_subnet_1
  public_subnet_2 = dependency.vpc.outputs.public_subnet_2
  private_subnet_1 = dependency.vpc.outputs.private_subnet_1
  private_subnet_2 = dependency.vpc.outputs.private_subnet_2
  gw_name_tag = "liatrio-ig-prod"

  liatrio_public_rt_name_tag = "liatrio-prod-public-rt"
  liatrio_private_rt_name_tag = "liatrio-prod-private-rt"
  eip_name = "liatrio-eip-prod"
  nat_name = "liatrio-nat-prod"

}