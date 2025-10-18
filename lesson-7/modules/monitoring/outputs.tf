output "grafana_admin_password" {
  value = "admin123"
  sensitive = true
}

output "grafana_url" {
  value = "http://localhost:3000"
}

output "prometheus_url" {
  value = "http://localhost:9090"
}