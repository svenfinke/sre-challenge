#!/bin/bash

cd k8s/dev

# Deploy invoice-app
kubectl apply -f deployment_payment-provider.yaml
kubectl apply -f deployment_invoice-app.yaml

# Deploy services
kubectl apply -f service_invoice-app.yaml
kubectl apply -f service_payment-provider.yaml