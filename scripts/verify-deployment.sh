#!/bin/bash
set -e

echo "🔍 Verifying K3s Cluster Deployment"
echo "==================================="

# Check cluster nodes
echo "📊 Checking cluster nodes..."
kubectl get nodes -o wide

# Check system pods
echo "📦 Checking system pods..."
kubectl get pods -n kube-system

# Check applications
echo "🚀 Checking applications..."
kubectl get pods -n applications

# Check databases
echo "💾 Checking databases..."
kubectl get pods -n databases

# Check storage
echo "🗄️ Checking storage..."
kubectl get pods -n storage

# Check ingress
echo "🌐 Checking ingress..."
kubectl get ingress --all-namespaces

# Check services
echo "🔌 Checking services..."
kubectl get svc --all-namespaces

# Check PVCs
echo "💿 Checking persistent volumes..."
kubectl get pvc --all-namespaces

echo "✅ Verification complete!"
