output "vpc_id" {
    description = "ID of created VPC"
    value = aws_vpc.main.id
  
}

output "public_subnets" {
  description = "List of public subnets ID's"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnets ID's"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_eip" {
  description = "Elastic IP used for NAT gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_gateway_id" {
    description = "NAT gateway ID's"
    value = aws_nat_gateway.nat.id
  
}