# Infraestructura AWS para plataforma de rastreo GPS

Esta plantilla despliega:

- VPC propia.
- 2 subredes públicas para EC2.
- 2 subredes privadas para RDS.
- EC2 con Rocky Linux 9.
- Usuario Linux opcional para el proveedor mediante clave pública SSH.
- Elastic IP para IP pública fija.
- Amazon RDS for MariaDB 10.11.x privado.
- Security Group de aplicación.
- Security Group de RDS permitiendo MariaDB solo desde EC2.
- Backups automáticos de RDS.
- Protección contra borrado accidental en RDS.
- CloudWatch Dashboard con CPU/memoria EC2 y CPU/memoria RDS.
- CloudWatch Alarms y SNS opcional por email.
- CloudWatch Agent en EC2 para publicar memoria y uso de disco.

## Requisitos

1. Terraform instalado.
2. AWS CLI configurado.
3. Key Pair creado previamente en AWS EC2.
4. Suscripción/uso permitido de la AMI Rocky Linux 9 en la región seleccionada.
5. Clave pública SSH del proveedor si deseas crearle usuario Linux.

## Uso

Copiar el archivo de ejemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Editar:

```bash
nano terraform.tfvars
```

Cambiar especialmente:

- `allowed_ssh_cidr`
- `ec2_key_name`
- `db_password`
- `provider_ssh_public_key`
- `aws_region`
- `cloudwatch_alarm_email`

Inicializar Terraform:

```bash
terraform init
```

Validar:

```bash
terraform validate
```

Revisar plan:

```bash
terraform plan
```

Aplicar:

```bash
terraform apply
```

## Verificar versión MariaDB disponible

Antes de aplicar, valida que la versión configurada exista en tu región:

```bash
aws rds describe-db-engine-versions \
  --engine mariadb \
  --engine-version 10.11 \
  --query 'DBEngineVersions[].EngineVersion' \
  --output table
```

Si `10.11.18` no aparece en tu región, cambia `rds_engine_version` en `terraform.tfvars` por la última versión 10.11.x disponible.

## Acceso del proveedor

Terraform crea un usuario Linux en EC2 si `provider_ssh_public_key` tiene valor.

Ejemplo de conexión:

```bash
ssh proveedor@IP_ELASTICA_EC2
```

El usuario puede tener sudo si `provider_sudo_enabled = true`. Recomendación: dejar sudo activo durante la instalación y luego desactivarlo.

## Acceso a RDS

RDS no es público. Solo la EC2 puede conectarse al puerto 3306.

El proveedor debe conectarse desde la EC2 usando:

```bash
mysql -h ENDPOINT_RDS -u gpsadmin -p
```

No se recomienda abrir RDS a Internet.

## CloudWatch

La dashboard incluye:

- CPU EC2.
- Memoria EC2 mediante CloudWatch Agent.
- CPU RDS.
- Memoria libre RDS.
- Conexiones RDS.
- Espacio libre RDS.

Si configuras `cloudwatch_alarm_email`, AWS enviará un correo de confirmación de SNS. Debes confirmarlo para recibir alarmas.

## Escalamiento

Para escalar EC2:

```hcl
ec2_instance_type = "t3.large"
```

Para escalar RDS:

```hcl
rds_instance_class = "db.t3.large"
```

Antes de aplicar en producción:

```bash
terraform plan
```

Verifica que sea modificación y no destrucción. RDS tiene `deletion_protection` y `prevent_destroy` para reducir riesgos.
