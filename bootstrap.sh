#!/bin/bash

# Install kubectl
az aks install-cli

# Get cluster credentials
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install namespace as proof of kubernetes interaction
kubectl create ns bootstrapped
