#!/bin/bash

# Deploy invoice-app
cd invoice-app
kubectl apply -f deployment.yaml
cd ..

# Deploy payment-provider
cd payment-provider
kubectl apply -f deployment.yaml
cd ..