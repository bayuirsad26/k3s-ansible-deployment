#!/bin/bash
set -e

# Check if hosts.yml exists
if [ ! -f "inventory/production/hosts.yml" ]; then
    echo "❌ Error: hosts.yml not found!"
    echo "📝 Please copy inventory/production/hosts.yml.example to inventory/production/hosts.yml"
    echo "   and update it with your server details."
    exit 1
fi

# Check if vault file exists
if [ ! -f "inventory/production/group_vars/vault.yml" ]; then
    echo "❌ Error: vault.yml not found!"
    echo "🔐 Please create your vault file using: ./scripts/generate_vault.sh"
    exit 1
fi

echo "🚀 Starting K3s Cluster Deployment"
echo "=================================="

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
