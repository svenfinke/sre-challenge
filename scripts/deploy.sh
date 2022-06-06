#!/bin/bash

wait_for_rollout() {
    # Wait for rollout to be finished or run into a timeout
    ATTEMPTS=0
    ROLLOUT_STATUS_CMD="kubectl rollout status $1 -n $NAMESPACE"
    until $ROLLOUT_STATUS_CMD || $ATTEMPTS -eq $MAX_ATTEMPTS; do
        $ROLLOUT_STATUS_CMD
        ATTEMPTS=$(($ATTEMPTS + 1))
        sleep 2
    done
}

# Use the minikube docker daemon
# I switched to Docker for Desktop due to connectivity issues on the mac, so I don't need this step anymore
# eval $(minikube docker-env)

VERSION="1.0.0"
MAX_ATTEMPTS=60
NAMESPACE=default

# Build invoice-app
docker build -t invoice-app:$VERSION src/invoice-app
docker tag invoice-app:$VERSION invoice-app:latest

# Build payment-provider
docker build -t payment-provider:$VERSION src/payment-provider
docker tag payment-provider:$VERSION payment-provider:latest

# Deploy invoice-app
kubectl apply -f k8s/dev -n $NAMESPACE
kubectl rollout restart deployment/invoice-app -n $NAMESPACE
kubectl rollout restart deployment/payment-provider -n $NAMESPACE

wait_for_rollout "deployment/invoice-app"
wait_for_rollout "deployment/payment-provider"

echo "DEPLOYMENT done and rolled out."