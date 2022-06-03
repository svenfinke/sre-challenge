#!/bin/bash

# Use the minikube docker daemon
# I switched to Docker for Desktop due to connectivity issues on the mac, so I don't need this step anymore
# eval $(minikube docker-env)

cd src

# Build invoice-app
cd invoice-app
docker build -t invoice-app .
cd ..

# Build payment-provider
cd payment-provider
docker build -t payment-provider .
cd ..