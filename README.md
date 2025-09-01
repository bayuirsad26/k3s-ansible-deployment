# K3s Container Orchestration for Software Houses

Production-ready K3s Kubernetes cluster deployment automation using Ansible. Features high availability, comprehensive monitoring, automated backups, security hardening, and complete CI/CD readiness with PostgreSQL, Redis, and IPFS integration.

## 🚀 Quick Start

### Prerequisites
- Ansible >= 2.14
- Python >= 3.8
- SSH access to all nodes
- Ubuntu 22.04 LTS on all nodes

### Installation

1. **Clone repository:**
```bash
git clone https://github.com/YOUR_USERNAME/k3s-ansible-deployment.git
cd k3s-ansible-deployment
```

2. **Copy example files:**
```bash
# Copy inventory template
cp inventory/production/hosts.yml.example inventory/production/hosts.yml

# Copy variables template  
cp inventory/production/group_vars/all.yml.example inventory/production/group_vars/all.yml
```

3. **Configure your environment:**
```bash
# Update with your server IP addresses
vim inventory/production/hosts.yml

# Update with your domain and settings
vim inventory/production/group_vars/all.yml
```

4. **Generate secure vault:**
```bash
# Create encrypted vault with random passwords
./scripts/generate_vault.sh
```

5. **Run deployment:**
```bash
./scripts/deploy.sh
```

## 📋 Features

- ✅ High Availability K3s cluster
- ✅ Redundant database services (PostgreSQL + Redis)
- ✅ Distributed storage with IPFS
- ✅ Comprehensive monitoring stack (Prometheus + Grafana)
- ✅ Centralized logging with Loki
- ✅ Automated backup & recovery
- ✅ Security hardening & network policies
- ✅ Auto-scaling with HPA
- ✅ SSL certificates with Let's Encrypt
- ✅ CI/CD ready infrastructure

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

### Minimum Hardware Requirements
- **Master Node**: 2 vCPU, 4GB RAM, 50GB disk
- **Worker Nodes**: 2 vCPU, 4GB RAM, 50GB disk (each)
- **Monitoring Server**: 2 vCPU, 4GB RAM, 100GB disk

### Recommended for Production
- **Master Node**: 4+ vCPU, 8GB+ RAM, 100GB+ SSD
- **Worker Nodes**: 4+ vCPU, 8GB+ RAM, 100GB+ SSD (each)
- **Monitoring Server**: 4+ vCPU, 8GB+ RAM, 200GB+ SSD

### Default Service Ports
- K3s API: 6443
- HTTP/HTTPS: 80/443
- PostgreSQL: 5432
- Redis: 6379
- IPFS API: 5001
- IPFS Gateway: 8080
- Prometheus: 9090
- Grafana: 3000

## 🛡️ Security Features

- Network policies for pod-to-pod communication
- RBAC (Role-Based Access Control) configured
- Pod Security Standards enforced
- Secrets management with Ansible Vault
- Automatic security updates
- Firewall rules with UFW
- Fail2ban for intrusion prevention
- SSL/TLS certificates via Let's Encrypt

## 📊 Monitoring & Observability

### Monitoring Stack
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization dashboards
- **Loki**: Centralized log aggregation
- **AlertManager**: Alert routing and management

### Access Dashboards
- Grafana: `https://grafana.YOUR_DOMAIN`
- Prometheus: `https://prometheus.YOUR_DOMAIN`

### Pre-configured Dashboards
- Kubernetes cluster overview
- Node resource utilization
- Application performance metrics
- Database performance monitoring
- Network and storage metrics

## 🔄 Backup & Recovery

### Automated Backups
- Daily etcd cluster backups
- PostgreSQL database dumps
- Configuration backups
- Configurable retention policies

### Manual Backup
```bash
./scripts/backup.sh
```

### Restore from Backup
```bash
ansible-playbook -i inventory/production/hosts.yml \
  playbooks/backup-restore.yml \
  --tags restore \
  -e "restore_timestamp=YYYYMMDD_HHMMSS"
```

## 🎯 Deployment Options

### Full Stack Deployment
```bash
# Deploy everything (recommended for new setups)
./scripts/deploy.sh
```

### Component-specific Deployment
```bash
# Deploy only K3s cluster
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-cluster.yml

# Deploy only monitoring stack
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-monitoring.yml

# Deploy only applications
ansible-playbook -i inventory/production/hosts.yml playbooks/deploy-apps.yml
```

### Maintenance Tasks
```bash
# Update cluster components
ansible-playbook -i inventory/production/hosts.yml playbooks/update-cluster.yml

# Scale applications
ansible-playbook -i inventory/production/hosts.yml playbooks/scale-apps.yml -e "replicas=3"

# Security updates
ansible-playbook -i inventory/production/hosts.yml playbooks/security-updates.yml
```

## 📝 Configuration Checklist

### Before Deployment
- [ ] Update server IP addresses in `inventory/production/hosts.yml`
- [ ] Configure your domain name in `all.yml`
- [ ] Set your email address for Let's Encrypt certificates
- [ ] Adjust resource limits based on your hardware
- [ ] Configure SSH key paths
- [ ] Verify network CIDR ranges match your infrastructure
- [ ] Generate secure vault passwords
- [ ] Test SSH connectivity to all nodes

### Post Deployment
- [ ] Verify all pods are running: `kubectl get pods --all-namespaces`
- [ ] Check node status: `kubectl get nodes`
- [ ] Access Grafana dashboard
- [ ] Test application deployments
- [ ] Verify backup jobs are working
- [ ] Review monitoring alerts

## 🔐 Secrets Management

### Vault Setup
The project uses Ansible Vault for secrets management. All sensitive data is encrypted.

```bash
# Generate new vault with secure random passwords
./scripts/generate_vault.sh

# Edit vault manually
ansible-vault edit inventory/production/group_vars/vault.yml

# View vault contents
ansible-vault view inventory/production/group_vars/vault.yml
```

### Required Secrets
- Database passwords (PostgreSQL, Redis)
- Application admin passwords (Grafana)
- Encryption keys (JWT, API, Backup)
- SSL certificate passwords (if using custom certs)

## 🚀 Application Deployment

### Custom Applications
Update the application roles to deploy your own services:

```bash
# Frontend application
roles/frontend/tasks/main.yml

# Backend API
roles/backend/tasks/main.yml
```

### Container Registry
Configure your private container registry in `all.yml`:
```yaml
registry_url: "registry.yourdomain.com"
registry_username: "admin"
registry_password: "{{ vault_registry_password }}"
```

## 🛠️ Troubleshooting

### Common Issues

1. **Node fails to join cluster:**
```bash
# Check K3s service
sudo systemctl status k3s

# Check logs
sudo journalctl -u k3s -f
```

2. **Pods stuck in Pending:**
```bash
# Check node resources
kubectl top nodes

# Check pod events
kubectl describe pod <pod-name> -n <namespace>
```

3. **Database connection issues:**
```bash
# Check database pods
kubectl get pods -n databases

# Check database logs
kubectl logs -f -n databases postgresql-0
```

### Debugging Commands
```bash
# Cluster status
kubectl cluster-info

# Node details
kubectl get nodes -o wide

# All pods status
kubectl get pods --all-namespaces -o wide

# Recent events
kubectl get events --sort-by='.lastTimestamp'

# Resource usage
kubectl top nodes
kubectl top pods --all-namespaces
```

## 📚 Documentation

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Configuration Reference](docs/CONFIGURATION.md) - All configuration options
- [Security Guide](docs/SECURITY.md) - Security best practices
- [Backup Guide](docs/BACKUP.md) - Backup and recovery procedures
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md).

### Development Setup
```bash
# Install development dependencies
pip install ansible ansible-lint yamllint

# Run syntax checks
ansible-playbook --syntax-check playbooks/site.yml

# Run linting
ansible-lint playbooks/

# Test in check mode
ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml --check
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Security Notice

**Important**: This repository contains infrastructure code. Never commit:
- Real IP addresses or hostnames
- Passwords, API keys, or tokens
- SSH private keys
- Production configuration files
- Unencrypted vault files

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/YOUR_USERNAME/k3s-ansible-deployment/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/YOUR_USERNAME/k3s-ansible-deployment/discussions)
- 📖 **Documentation**: [Project Wiki](https://github.com/YOUR_USERNAME/k3s-ansible-deployment/wiki)

## 🌟 Acknowledgments

- [K3s](https://k3s.io/) - Lightweight Kubernetes distribution
- [Ansible](https://ansible.com/) - Infrastructure automation
- [Prometheus](https://prometheus.io/) - Monitoring and alerting
- [Grafana](https://grafana.com/) - Visualization platform

---

Made with ❤️ for the DevOps community
