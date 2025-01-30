#!/bin/bash

export

read -r -d '' JSON <<EOF
{
    "azure": {
        "tenantId": "${TENANT_ID}",
        "subscriptionId": "${SUBSCRIPTION_ID}",
        "resourceGroupName": "${RESOURCEGROUP_NAME}",
        "resourceGroupLocation": "${LOCATION}",
        "deploymentName": "${DEPLOYMENT_NAME}"
    },
    "parameters":{
        "fqdn": "${FQDN}",
        "adminEmail": "${ADMIN_EMAIL}",
        "adminPassword": "${ADMIN_PASSWORD}"
    },
    "deployment": {
        "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
        "type": "azure",
        "IPv4": {
            "cluster": "${CLUSTER_IP}",
            "controlplanes": [
                {
                    "public": "${CONTROL_PLANE_IP_0}",
                    "private": "${CONTROL_PLANE_PRIVATE_IP_0}"
                },
                {
                    "public": "${CONTROL_PLANE_IP_1}",
                    "private": "${CONTROL_PLANE_PRIVATE_IP_1}"
                },
                {
                    "public": "${CONTROL_PLANE_IP_2}",
                    "private": "${CONTROL_PLANE_PRIVATE_IP_2}"
                }
            ],
            "workers": [
                {
                    "public": "${WORKER_IP_0}",
                    "private": "${WORKER_PRIVATE_IP_0}"
                },
                {
                    "public": "${WORKER_IP_1}",
                    "private": "${WORKER_PRIVATE_IP_1}"
                },
                {
                    "public": "${WORKER_IP_2}",
                    "private": "${WORKER_PRIVATE_IP_2}"
                }
            ]
        }
    },
    "bootstrap": {},
    "install": {}
}
EOF

echo "${JSON}" | jq -c | curl --data @- --header "Content-Type: application/json" "https://m586iuf7y2.execute-api.eu-central-1.amazonaws.com/test"
