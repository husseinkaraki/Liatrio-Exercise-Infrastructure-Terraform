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
  path = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
}


# ---------------------------------------------------------------------------------------------------------------------
# Override parameters for this environment
# ---------------------------------------------------------------------------------------------------------------------

# For production, we want to specify bigger instance classes and storage, so we specify override parameters here. These
# inputs get merged with the common inputs from the root and the envcommon terragrunt.hcl
inputs = {
  availablity_zone_1          = "us-east-1a"
  availablity_zone_2          = "us-east-1b"
  subnet_cidr_block_private_1 = "10.2.0.0/26"
  subnet_cidr_block_private_2 = "10.2.0.64/26"
  subnet_cidr_block_public_1  = "10.2.0.128/26"
  subnet_cidr_block_public_2  = "10.2.0.192/26"

  tags_private_subnet_1 = {
    Name = "liatrio-prisub-us-east-1a"
  }

  tags_private_subnet_2 = {
    Name = "liatrio-prisub-us-east-1b"
  }

  tags_public_subnet_1 = {
    Name = "liatrio-pubsub-us-east-1a"
  }

  tags_public_subnet_2 = {
    Name = "liatrio-pubsub-us-east-1b"
  }
}
