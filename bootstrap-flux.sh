#!/bin/bash

# Install kubectl
az aks install-cli

# Get cluster credentials
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install flux CLI
curl -s https://fluxcd.io/install.sh | bash

# Install flux controllers
flux install