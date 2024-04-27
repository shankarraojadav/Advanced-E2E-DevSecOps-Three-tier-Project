module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "main"
  cidr = "10.0.0.0/16"

  azs = data.aws_availability_zones.zones.names
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets = ["10.0.64.0/19", "10.0.96.0/19"]

  public_subnet_tags = {
    "3 tier application" : "1"
  }

  private_subnet_tags = {
    "3 tier application" : "1"
  }

  
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "dev"
  }
}