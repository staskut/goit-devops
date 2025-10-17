output "ecr_repo_url" {
    description = "Ecr repository URL"
    value = aws_ecr_repository.ecr_repo.repository_url
  
}