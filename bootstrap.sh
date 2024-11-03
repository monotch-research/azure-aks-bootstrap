#!/bin/bash

# Install kubectl
echo "Installing kubectl..."
az aks install-cli

# Get cluster credentials
echo "Configuring kubectl for ${MANAGEDCLUSTERNAME} in ${RESOURCEGROUP}..."
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install namespace as proof of kubernetes interaction
echo "Creating namespace using kubectl..."
kubectl create ns bootstrapped
