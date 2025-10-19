#!/bin/bash
echo "🔍 Running health checks..."
kubectl get pods -n sri-rajeswari-provisions
echo "✅ Health checks completed!"
