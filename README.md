# Project Description

The Terraform / Terragrunt infrastructure used by the Liatrio Exercise project to deploy a cloud environment in AWS. 

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