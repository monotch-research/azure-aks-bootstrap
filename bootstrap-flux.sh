#!/bin/bash

# Install kubectl
az aks install-cli

# Get cluster credentials
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install flux CLI
curl -s https://fluxcd.io/install.sh | bash

# Install flux controllers
flux install

# Bootstrap flux
flux bootstrap git \
  --url=ssh://git@git@github.com/monotch-research/azure-flux.git \
  --branch=main \
  --private-key-file="${KEY}" \
  --password="${PASS}" \
  --interval=10s \
  --path=clusters/aks
