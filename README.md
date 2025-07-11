# K3s Container Orchestration untuk SummitEthic Software House

Proyek Ansible ini mengimplementasikan deployment otomatis untuk K3s Container Orchestration yang dioptimalkan untuk Software House dengan prinsip etika.

## 🚀 Quick Start

### Prerequisites
- Ansible >= 2.14
- Python >= 3.8
- SSH access ke semua node
- Ubuntu 22.04 LTS pada semua node

### Installation

1. Clone repository:
```bash
git clone https://github.com/summitethic/k3s-ansible-deployment.git
cd k3s-ansible-deployment
```

2. Update inventory:
```bash
vim inventory/production/hosts.yml
# Update IP addresses sesuai environment Anda
```

3. Configure variables:
```bash
vim inventory/production/group_vars/all.yml
# Sesuaikan konfigurasi
```

4. Run deployment:
```bash
./scripts/deploy.sh
```

## 📋 Features

- ✅ High Availability K3s cluster
- ✅ Redundant database services (PostgreSQL + Redis)
- ✅ Distributed storage dengan IPFS
- ✅ Comprehensive monitoring stack
- ✅ Automated backup & recovery
- ✅ Security hardening
- ✅ CI/CD ready

## 🏗️ Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Master Node   │     │  Worker Node 1  │     │  Worker Node 2  │
│  Control Plane  │────▶│   Applications  │────▶│   Applications  │
│       etcd      │     │    PostgreSQL   │     │    PostgreSQL   │
│  Ingress NGINX  │     │      Redis      │     │      Redis      │
└─────────────────┘     │       IPFS      │     │       IPFS      │
         │              └─────────────────┘     └─────────────────┘
         │                       │                       │
         └───────────────────────┴───────────────────────┘
                                 │
                    ┌────────────────────────┐
                    │    Monitoring Server   │
                    │  Prometheus + Grafana  │
                    │     Loki + AlertMgr    │
                    └────────────────────────┘
```

## 🔧 Configuration

### Resource Distribution (CLOUD VPS 20)
- Master Node: 6 vCPU, 12GB RAM
- Worker Nodes: 6 vCPU, 12GB RAM each
- Monitoring: 4 vCPU, 6GB RAM

### Service Ports
- K3s API: 6443
- HTTP/HTTPS: 80/443
- PostgreSQL: 5432
- Redis: 6379
- IPFS: 5001/8080
- Prometheus: 9090
- Grafana: 3000

## 🛡️ Security

- Network policies enabled
- RBAC configured
- Secrets management
- Regular security updates
- Firewall rules implemented

## 📊 Monitoring

Access monitoring dashboards:
- Grafana: http://monitoring.summitethic.id:3000
- Prometheus: http://monitoring.summitethic.id:9090

## 🔄 Backup & Recovery

### Manual Backup
```bash
./scripts/backup.sh
```

### Restore from Backup
```bash
ansible-playbook -i inventory/production/hosts.yml \
  playbooks/backup-restore.yml \
  --tags restore \
  -e "restore_timestamp=20240115_020000"
```

## 📝 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines.

## 📞 Support

For support, email devops@summitethic.id

## 🔐 Ansible Vault

### 20. Create vault file:
```bash
# Create vault password file
echo "your-secure-vault-password" > .vault_pass

# Create encrypted variables
ansible-vault create inventory/production/group_vars/vault.yml
```

### Vault variables (`vault.yml`):
```yaml
---
vault_postgresql_password: "SecurePostgresPassword123!"
vault_postgresql_replication_password: "ReplicationPass456!"
vault_redis_password: "RedisSecurePass789!"
vault_grafana_admin_password: "GrafanaAdmin123!"
vault_registry_password: "RegistryPass456!"
vault_backup_encryption_key: "BackupEncryptKey789!"
```

## 🎯 Usage Instructions

1. **Initial Setup:**
```bash
# Install dependencies
pip install ansible ansible-lint yamllint

# Validate syntax
ansible-playbook --syntax-check playbooks/site.yml

# Run in check mode
ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml --check
```

2. **Deploy Individual Components:**
```bash
# Deploy only cluster
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-cluster.yml

# Deploy only monitoring
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-monitoring.yml

# Deploy only applications
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-apps.yml
```

3. **Maintenance Tasks:**
```bash
# Update cluster
ansible-playbook -i inventory/production/hosts.yml playbooks/update-cluster.yml

# Scale applications
ansible-playbook -i inventory/production/hosts.yml playbooks/scale-apps.yml -e "replicas=3"

# Security patching
ansible-playbook -i inventory/production/hosts.yml playbooks/security-updates.yml
```

## 💡 Best Practices

1. **Always test in staging first**
2. **Use ansible-vault for sensitive data**
3. **Regular backup verification**
4. **Monitor resource utilization**
5. **Keep documentation updated**

---

Proyek Ansible ini menyediakan deployment yang fully automated, secure, dan production-ready untuk K3s Container Orchestration di SummitEthic Software House! 🚀
