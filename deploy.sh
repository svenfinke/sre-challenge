#!/bin/bash

cd k8s/dev

# Deploy invoice-app
kubectl apply -f deployment_payment-provider.yaml
kubectl apply -f deployment_invoice-app.yaml