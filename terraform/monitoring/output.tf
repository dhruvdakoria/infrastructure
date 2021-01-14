output "ec2_public_ip" {
  description = "List of IPS"
  value       = aws_instance.monitoring.public_ip
}


output "ec2_private_ip" {
  description = "List of IPS"
  value       = aws_instance.monitoring.private_ip
}

output "aws_security_group_monitoring_vm_id" {
  value       = aws_security_group.monitoring_vm.id
}