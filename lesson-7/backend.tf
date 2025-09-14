# terraform {
#   backend "s3" {
#     bucket         = "kut-terraform-state-bucket-001001"# Назва S3-бакета
#     key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
#     region         = "eu-west-2"                    # Регіон AWS
#     dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB
#     encrypt        = true                           # Шифрування файлу стейту
#   }
# }
#
#
