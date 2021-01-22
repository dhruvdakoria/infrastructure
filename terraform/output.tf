
output "alb_url_api" {
  value       = module.base-infra.aws_lb_api_dns_name
  description = "DNS Endpoint of the API Service"
}

output "alb_url_web" {
  value       = module.base-infra.aws_lb_web_dns_name
  description = "DNS Endpoint of the WEB Service"
}

output "alb_url_monitoring" {
  value       = module.base-infra.aws_lb_monitoring_dns_name
  description = "DNS Endpoint of the Monitoring Service"
}

# output "ec2_url" {
#   value       = module.monitoring.ec2_public_ip
#   description = "IP of the EC2 instance"
# }

output "database_url" {
  value       = module.database.db_url
  description = "database url"
}


output "cdn_url" {
  value       = module.base-infra.cdn_domain_name
  description = "database url"
}