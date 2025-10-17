tags = {
  Environment = "dev"
  Project     = "lesson-9"
  ManagedBy   = "terraform"
}

aws_region = "eu-west-2"

vpc_name = "my-vpc"

vpc_cidr_block = "10.0.0.0/16"

availability_zones = ["eu-west-2a", "eu-west-2b"]

public_subnets_cidrs = ["10.0.1.0/24","10.0.2.0/24"]

private_subnets_cidrs = ["10.0.11.0/24","10.0.12.0/24"]

cluster_name = "eks-cluster-demo"

