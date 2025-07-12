#!/bin/bash
set -e

REPLICAS=${1:-3}
NAMESPACE=${2:-applications}

echo "📈 Scaling applications to ${REPLICAS} replicas in ${NAMESPACE} namespace"

# Scale frontend
kubectl scale deployment frontend-app --replicas=${REPLICAS} -n ${NAMESPACE}

# Scale backend
kubectl scale deployment backend-api --replicas=${REPLICAS} -n ${NAMESPACE}

# Wait for rollout
echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment/frontend-app -n ${NAMESPACE}
kubectl rollout status deployment/backend-api -n ${NAMESPACE}

echo "✅ Scaling complete!"
kubectl get deployments -n ${NAMESPACE}
