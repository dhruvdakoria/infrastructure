
output "alb_url_api" {
  value       = module.infrastructure.aws_lb_api_dns_name
  description = "DNS Endpoint of the API"
}

output "alb_url_web" {
  value       = module.infrastructure.aws_lb_web_dns_name
  description = "DNS Endpoint of the WEB"
}

output "ec2_url" {
  value       = module.monitoring.ec2_public_ip
  description = "IP of the EC2 instance"
}

output "database_url" {
  value       = module.db.db_url
  description = "database url"
}


output "cdn_url" {
  value       = module.infrastructure.cdn_url
  description = "database url"
}