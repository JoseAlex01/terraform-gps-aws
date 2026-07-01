output "ec2_public_ip" {
  description = "IP pública fija Elastic IP de la EC2"
  value       = aws_eip.app.public_ip
}

output "ec2_private_ip" {
  description = "IP privada de la EC2"
  value       = aws_instance.app.private_ip
}

output "provider_linux_user" {
  description = "Usuario Linux creado para el proveedor"
  value       = var.provider_ssh_public_key != "" ? var.provider_linux_user : "no-creado"
}

output "rds_endpoint" {
  description = "Endpoint privado de RDS MariaDB"
  value       = aws_db_instance.mariadb.address
}

output "rds_port" {
  description = "Puerto RDS MariaDB"
  value       = aws_db_instance.mariadb.port
}

output "rds_engine" {
  description = "Motor y versión RDS desplegada"
  value       = "${aws_db_instance.mariadb.engine} ${aws_db_instance.mariadb.engine_version_actual}"
}

output "s3_backups_bucket" {
  description = "Bucket S3 para backups/históricos"
  value       = aws_s3_bucket.backups.bucket
}

output "cloudwatch_dashboard_name" {
  description = "Dashboard CloudWatch creado"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "sns_alerts_topic_arn" {
  description = "SNS Topic para alarmas CloudWatch"
  value       = aws_sns_topic.alerts.arn
}
