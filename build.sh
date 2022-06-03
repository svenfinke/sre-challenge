#!/bin/bash

# Use the minikube docker daemon
eval $(minikube docker-env)

cd src

# Build invoice-app
cd invoice-app
docker build -t invoice-app .
cd ..

# Build payment-provider
cd payment-provider
docker build -t payment-provider .
cd ..