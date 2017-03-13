## Outputs for reference

output "The Rancher Server URL is" {
  value = "http://${var.env_name}.${var.dns_zone}:8080"
}
