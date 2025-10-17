# S3-bucket
# resource "aws_s3_bucket" "terraform_state" {
#     bucket = var.bucket_name
#
#     tags = {
#         Name         = "Terraform State Bucket"
#         Environment  = "lesson-9"
#     }
#
# }

data "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}

# versioning for S3-bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
    bucket = data.aws_s3_bucket.terraform_state.bucket

    versioning_configuration {
      status = "Enabled"
    }
  
}

# ownership for S3-bucket
resource "aws_s3_bucket_ownership_controls" "terraform_state_ownership" {
    bucket = data.aws_s3_bucket.terraform_state.bucket
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  
}