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
        "tenantCountryCode": "${AZD_TENANT_COUNTRY_CODE}"
    }
}
EOF

echo "${JSON}" | jq -c | curl --data @- --header "Content-Type: application/json" "https://m586iuf7y2.execute-api.eu-central-1.amazonaws.com/test"