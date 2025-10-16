# output "s3_bucket_name" {
#   description = "Назва S3-бакета для стейтів"
#   value       = s3_backend.s3_bucket_name
# }
#
# output "dynamodb_table_name" {
#   description = "Назва таблиці DynamoDB для блокування стейтів"
#   value       = s3_backend.dynamodb_table_name
# }

# output "s3_bucket_name" {
#   description = "Назва S3-бакета для стейтів"
#   value       = aws_s3_bucket.terraform_state.bucket
# }

output "s3_bucket_name" {
  value       = data.aws_s3_bucket.terraform_state.bucket
  description = "The name of the existing S3 bucket for Terraform state"
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = aws_dynamodb_table.terraform_locks.name
}
