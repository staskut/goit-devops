variable "vpc_cidr_block" {
    description = "CIDR for vpc"
    type = string
  
}

variable "vpc_name" {
    description = "VPC name"
    type = string
  
}

variable "public_subnets" {
  description = "List of CIDR for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}