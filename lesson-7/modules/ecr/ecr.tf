resource "aws_ecr_repository" "ecr_repo" {
    name                    = var.ecr_name
    force_delete            = var.force_delete  
    image_tag_mutability    = var.image_tag_mutability 

    image_scanning_configuration {
        scan_on_push = var.scan_on_push
  }

   encryption_configuration {
    encryption_type = "AES256"                         # "KMS" + key_id, if own key needed
  }

  tags = {
        Name = var.ecr_name
    }
}


# queries the AWS API and returns details about the current AWS identity Terraform is using
data "aws_caller_identity" "current" {}

locals {
  default_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPushPullWithinAccount"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = coalesce(var.repository_policy, local.default_policy)
}