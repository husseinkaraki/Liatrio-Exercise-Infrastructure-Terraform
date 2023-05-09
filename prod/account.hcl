# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "liatrio"
  aws_account_id = "883045599619" 
  aws_profile    = "prod"
}
