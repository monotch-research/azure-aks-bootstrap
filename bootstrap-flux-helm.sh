#!/bin/bash

# Install kubectl
az aks install-cli

# Get cluster credentials
az aks get-credentials -g ${RESOURCEGROUP} -n ${MANAGEDCLUSTERNAME}

# Install the SSH key
install -D -m 0600 <(printf -- "${KEY}") "${HOME}/.ssh/id_ed25519"

# Install flux CLI
curl -qs https://fluxcd.io/install.sh | bash

# Install helm CLI
curl -qs https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install flux controllers
flux install

# Bootstrap flux
flux bootstrap git \
  --url=ssh://git@github.com/monotch-research/azure-flux.git \
  --branch=main \
  --private-key-file="${HOME}/.ssh/id_ed25519" \
  --password="${PASS}" \
  --interval=10s \
  --path=clusters/aks \
  --silent

# Git clone
## create empty known hosts file
touch ${HOME}/.ssh/known_hosts
## install github signature
if [ ! -n "$(grep "^github.com " ${HOME}/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts 2>/dev/null; fi;

## fix private key missing LF
echo "" >> ${HOME}/.ssh/id_ed25519
## remove passphrase from private key
ssh-keygen -p -P ${PASS} -N "" -f ${HOME}/.ssh/id_ed25519 -y

## clone flux repository
git clone git@github.com:monotch-research/azure-flux.git ${HOME}/azure-flux

# Sleep for ever (in order to exec into container)
sleep infinity
