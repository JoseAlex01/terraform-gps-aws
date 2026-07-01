#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y vim wget curl git htop firewalld unzip
systemctl enable --now firewalld

# Instalación de CloudWatch Agent para Rocky/RHEL.
rpm -Uvh --replacepkgs https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm

# Usuario Linux para proveedor. El acceso SSH queda restringido por Security Group a allowed_ssh_cidr.
if [ -n "${provider_ssh_public_key}" ]; then
  if ! id "${provider_linux_user}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${provider_linux_user}"
  fi

  mkdir -p "/home/${provider_linux_user}/.ssh"
  echo "${provider_ssh_public_key}" > "/home/${provider_linux_user}/.ssh/authorized_keys"
  chown -R "${provider_linux_user}:${provider_linux_user}" "/home/${provider_linux_user}/.ssh"
  chmod 700 "/home/${provider_linux_user}/.ssh"
  chmod 600 "/home/${provider_linux_user}/.ssh/authorized_keys"

  if [ "${provider_sudo_enabled}" = "true" ]; then
    usermod -aG wheel "${provider_linux_user}"
  fi
fi

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<CWAGENT
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "CWAgent",
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available_percent"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": ["/"]
      }
    }
  }
}
CWAGENT

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

systemctl enable amazon-cloudwatch-agent
