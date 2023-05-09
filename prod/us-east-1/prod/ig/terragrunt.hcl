# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. This loads up the env.hcl and region.hcl config files. 
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/ig.hcl"
}

locals {

}

dependency "vpc" {
    config_path = find_in_parent_folders("vpc")
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  public_subnet_1 = dependency.vpc.outputs.public_subnet_1
  public_subnet_2 = dependency.vpc.outputs.public_subnet_2
  
  gw_tags = {
    Name = "liatrio-ig-prod"
  }

  liatrio_public_rt_name_tag = {
    Name = "liatrio-prod-public-rt"
  }

}