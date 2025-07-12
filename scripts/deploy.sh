#!/bin/bash
set -e

echo "🚀 Starting SummitEthic K3s Cluster Deployment"
echo "============================================"

# Install Ansible collections
echo "📦 Installing required Ansible collections..."
ansible-galaxy collection install -r requirements.yml

# Run pre-deployment checks
echo "🔍 Running pre-deployment checks..."
ansible-playbook -i inventory/production/hosts.yml playbooks/pre-checks.yml

# Deploy the cluster
echo "🎯 Deploying K3s cluster..."
ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml

# Verify deployment
echo "✅ Verifying deployment..."
ansible-playbook -i inventory/production/hosts.yml playbooks/verify-deployment.yml

echo "✨ Deployment completed successfully!"
