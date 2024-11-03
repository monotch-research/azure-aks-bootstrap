#!/bin/bash

# Install kubectl
az aks install-cli

# Install namespace
kubectl create ns proof
