# Project Description

The Terraform / Terragrunt infrastructure used by the Liatrio Exercise project. 

## Development 

- Use [Terragrunt Template](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) as sample. 
- Create S3 Bucket
- Create policy for S3 bucket for the github actions pipeline user karakidevmaster.
- Update Values in project
- Build VPC component
- Build Subnets
- Build/Edit Route Tables to make subnets private


## Deploy

Main branch deploys all the modules per a specific environment, per a specific region. Since we have only 1 environemnt, and 1 region, its defaulted to `prod/us-east-1`. 