#!/bin/bash
echo "🚀 Deploying to Kubernetes..."
kubectl apply -f kubernetes/manifests/
echo "✅ Deployment completed!"
