#!/bin/bash
set -e

echo "🧹 Cleaning up test resources..."

# Remove test namespaces
kubectl delete namespace test --ignore-not-found=true

# Clean up failed pods
kubectl delete pods --field-selector=status.phase=Failed --all-namespaces

# Clean up completed jobs
kubectl delete jobs --field-selector=status.successful=1 --all-namespaces

# Clean up old replicasets
kubectl get replicaset --all-namespaces -o json | \
  jq -r '.items[] | select(.spec.replicas == 0) | "\(.metadata.namespace) \(.metadata.name)"' | \
  while read ns rs; do
    kubectl delete replicaset -n $ns $rs
  done

echo "✅ Cleanup complete!"
