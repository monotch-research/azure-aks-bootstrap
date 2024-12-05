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

# Wait for namespace
kubectl get ns cri | grep Active
while [ $? -eq 1 ]; do echo "Waiting for flux provisioning to complete" && sleep 1 && kubectl get ns cri | grep Active; done

# Run ecr-cred-helper
kubectl create job -n ecr-cred-helper bootstrap --from cronjob/ecr-cred-helper

# Wait for ecr secret
kubectl get secret -n cri  | grep eu-west-1-ecr-registry
while [ $? -eq 1 ]; do echo "Waiting for ecr-cred-helper to complete" && sleep 1 && kubectl get secret -n cri  | grep eu-west-1-ecr-registry; done

# Git clone
## Create empty known hosts file
touch ${HOME}/.ssh/known_hosts
## Install github signature
if [ ! -n "$(grep "^github.com " ${HOME}/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts 2>/dev/null; fi;

## Fix private key missing LF
echo "" >> ${HOME}/.ssh/id_ed25519
## Remove passphrase from private key
ssh-keygen -p -P ${PASS} -N "" -f ${HOME}/.ssh/id_ed25519 -y

## Shallow clone flux repository
git clone --depth=1 git@github.com:monotch-research/azure-flux.git ${HOME}/azure-flux

# Helm install
helm upgrade -n cri --install cri ${HOME}/azure-flux/charts/dxp-cri \
  --set "fqdn=${INTERCHANGEFQDN}" \
  --set "admin.email=${ADMINPORTALUSER}" \
  --set "admin.password=${ADMINPORTALPASS}"

# Sleep for ever (in order to exec into container)
# sleep infinity
