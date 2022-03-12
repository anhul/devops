output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.postgres_db.address
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.postgres_db.port
}
