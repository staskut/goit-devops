output "s3_bucket_name" {
    description = "Name for state in S3-bucket"
    value = data.aws_s3_bucket.terraform_state
  
}

output "dynamodb_table_name" {
    description = "Table name in  DynamoDB for locking states"
    value = aws_dynamodb_table.terraform_locks.name
  
}