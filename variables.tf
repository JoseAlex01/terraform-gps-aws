variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto usado como prefijo de recursos"
  type        = string
  default     = "gps-tracking"
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR principal de la VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR de subredes públicas"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR de subredes privadas para RDS"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "IP pública autorizada para SSH. Cambiar por tu IP /32"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_app_ports" {
  description = "Puertos públicos que usará la aplicación"
  type        = list(number)
  default     = [80, 443]
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2 inicial para la aplicación"
  type        = string
  default     = "t3.medium"
}

variable "ec2_key_name" {
  description = "Nombre del key pair existente en AWS para SSH del administrador"
  type        = string
}

variable "root_volume_size" {
  description = "Tamaño del disco raíz de EC2 en GB"
  type        = number
  default     = 80
}

variable "provider_linux_user" {
  description = "Usuario Linux que se creará para el proveedor en la EC2"
  type        = string
  default     = "proveedor"
}

variable "provider_ssh_public_key" {
  description = "Clave pública SSH del proveedor. Si se deja vacío, no se crea el usuario del proveedor. Formato: ssh-rsa/ssh-ed25519 ..."
  type        = string
  default     = ""
  sensitive   = true
}

variable "provider_sudo_enabled" {
  description = "Permite sudo al usuario Linux del proveedor. Recomendado temporalmente durante instalación; luego se puede desactivar."
  type        = bool
  default     = true
}

variable "rds_instance_class" {
  description = "Clase inicial de RDS MariaDB"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_engine_version" {
  description = "Versión de Amazon RDS for MariaDB. Verificar disponibilidad en la región antes de aplicar."
  type        = string
  default     = "10.11.18"
}

variable "rds_allocated_storage" {
  description = "Almacenamiento inicial RDS en GB"
  type        = number
  default     = 100
}

variable "rds_max_allocated_storage" {
  description = "Máximo autoescalable de almacenamiento RDS en GB"
  type        = number
  default     = 500
}

variable "db_name" {
  description = "Nombre inicial de la base de datos"
  type        = string
  default     = "gpsdb"
}

variable "db_username" {
  description = "Usuario administrador inicial de MariaDB"
  type        = string
  default     = "gpsadmin"
}

variable "db_password" {
  description = "Contraseña del usuario administrador de MariaDB"
  type        = string
  sensitive   = true
}

variable "backup_retention_days" {
  description = "Días de retención de backups automáticos de RDS"
  type        = number
  default     = 7
}

variable "enable_rds_multi_az" {
  description = "Activa Multi-AZ para RDS. Para inicio económico dejar false."
  type        = bool
  default     = false
}

variable "cloudwatch_alarm_email" {
  description = "Correo para recibir alarmas CloudWatch vía SNS. Si se deja vacío, no se crea suscripción."
  type        = string
  default     = ""
}

variable "ec2_cpu_alarm_threshold" {
  description = "Umbral de alarma CPU EC2 en porcentaje"
  type        = number
  default     = 75
}

variable "ec2_memory_alarm_threshold" {
  description = "Umbral de alarma memoria EC2 en porcentaje, métrica publicada por CloudWatch Agent"
  type        = number
  default     = 80
}

variable "rds_cpu_alarm_threshold" {
  description = "Umbral de alarma CPU RDS en porcentaje"
  type        = number
  default     = 75
}

variable "rds_freeable_memory_alarm_bytes" {
  description = "Umbral de alarma de memoria libre RDS en bytes. Ejemplo 536870912 = 512 MB"
  type        = number
  default     = 536870912
}
