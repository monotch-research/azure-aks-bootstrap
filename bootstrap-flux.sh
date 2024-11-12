#!/bin/bash

# Install kubectl
az aks install-cli

# Get cluster credentials
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install the SSH key
install -D -m 0600 <(printf -- "${KEY}") "${HOME}/.ssh/id_ed25519"

# Install flux CLI
curl -qs https://fluxcd.io/install.sh | bash

# Install flux controllers
flux install

# Bootstrap flux
flux bootstrap git \
  --url=ssh://git@github.com/monotch-research/azure-flux.git \
  --branch=main \
  --private-key-file="${HOME}/.ssh/id_ed25519" \
  --password="${PASS}" \
  --interval=10s \
  --path=clusters/aks

