# variable "kubeconfig" {
#   description = "Шлях до kubeconfig файлу"
#   type        = string
# }

variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for deploying Jenkins"
  type        = string
  default     = "jenkins"
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN from EKS cluster"
  type        = string
}

variable "oidc_provider_url" {
  type = string
}

// github credentials
variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
variable "github_user" {
  description = "GitHub username"
  type        = string
}
variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "jenkins_sa_name" {
  description = "The name of the Jenkins Service Account."
  type        = string
}