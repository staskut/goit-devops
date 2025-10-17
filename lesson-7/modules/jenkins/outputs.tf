output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

output "jenkins_sa_name" {
  description = "The name of the Jenkins Service Account."
  value       = kubernetes_service_account.jenkins_sa.metadata.0.name
}