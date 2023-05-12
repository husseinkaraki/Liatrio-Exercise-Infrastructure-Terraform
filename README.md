# Project Description

The Terraform / Terragrunt infrastructure used by the Liatrio Exercise project to deploy a cloud environment in AWS. The pipeline behavior defaults to applying changes to `prod` but the terraform and pipeline can easily be modified to support multiple environments. 

## Development 

- Use [Terragrunt Template](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) as sample. 
- Create S3 Bucket
- Create policy for S3 bucket for the github actions pipeline user karakidevmaster.
- Update Values in project
- Add VPC component and subnets
- Add Internet Gateway, route table, and associations
- Add EKS Cluster and dependencies

## Deploy

Main branch deploys all the modules per a specific environment, per a specific region. Since we have only 1 environemnt, and 1 region, its defaulted to `prod/us-east-1`. 

## Notes
- NAT Gateway terraform is combined with the Internet Gateway terraform.
- For the `aws_launch_template` the lifecycle property `create_before_destroy` to prevent downtime. This can be useful in situations where you need to replace or update an existing resource without causing downtime.
