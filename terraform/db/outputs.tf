output "db_url" {
  value       = aws_db_instance.postgresql.address
  description = "DNS Endpoint of the instance"
}