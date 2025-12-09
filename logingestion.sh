#!/bin/bash

# ===============================
# CONFIGURATION
# ===============================

# Subscriptions to check
SUBSCRIPTIONS=(
    #add your subscription IDs here, bash array format
)

# Resource types to check
SUPPORTED_RESOURCE_TYPES=(
 "Microsoft.ContainerService/managedClusters"
    "Microsoft.DBforPostgreSQL/flexibleServers"
    "Microsoft.Compute/virtualMachines"
    "Microsoft.Network/azureFirewalls"
    "Microsoft.Network/frontdoors"
    "Microsoft.Network/applicationGateways"
    "Microsoft.Cdn/profiles"
    "Microsoft.Kusto/clusters"
    #"Microsoft.EventHub/namespaces"
    #"Microsoft.Network/virtualNetworks"
    "Microsoft.Compute/virtualMachineScaleSets"
    "Microsoft.OperationalInsights/workspaces"
    "Microsoft.StreamAnalytics/streamingJobs"
    "Microsoft.RecoveryServices/vaults"
    "Microsoft.ContainerService/managedClusters"
    #"Microsoft.Network/networkSecurityGroups"
    "Microsoft.Network/publicIPAddresses"
    "Microsoft.Storage/storageAccounts"
    "Microsoft.KeyVault/vaults"
    "Microsoft.Sql/servers"
    "Microsoft.DBforMySQL/servers"
    "Microsoft.Web/sites"
    "Microsoft.DocumentDB/databaseAccounts"
    #"Microsoft.Network/trafficManagerProfiles"
    "Microsoft.Entra/identity"
)

OUTPUT_CSV="diagnostic_settings_results.csv"
ERROR_LOG="errors.log"

# ===============================
# INITIALIZE OUTPUT FILES
# ===============================
echo "subscription_id,resource_id,resource_type,diagnostic_enabled,sending_to_LA,workspace_id" > "$OUTPUT_CSV"
echo "" > "$ERROR_LOG"

# ===============================
# MAIN LOOP
# ===============================
for SUB in "${SUBSCRIPTIONS[@]}"; do
    echo "Checking subscription: $SUB"

    # Set subscription
    az account set --subscription "$SUB" 2>>"$ERROR_LOG"
    if [ $? -ne 0 ]; then
        echo "ERROR: Cannot set subscription $SUB" >> "$ERROR_LOG"
        continue
    fi

    # Loop over resource types
    for TYPE in "${SUPPORTED_RESOURCE_TYPES[@]}"; do
        echo "  Checking resources of type: $TYPE"

        RESOURCES=$(az resource list --subscription "$SUB" --resource-type "$TYPE" --query "[].id" -o tsv 2>>"$ERROR_LOG")

        for RES_ID in $RESOURCES; do
            echo "    Processing: $RES_ID"

            # Check diagnostic settings for the resource
            DIAG=$(az monitor diagnostic-settings list --resource "$RES_ID" -o json 2>>"$ERROR_LOG")
            if [ $? -ne 0 ]; then
                echo "ERROR: Failed to query diagnostic settings for $RES_ID" >> "$ERROR_LOG"
                continue
            fi

            HAS_DIAG=$(echo "$DIAG" | jq 'length > 0')

            if [ "$HAS_DIAG" = "true" ]; then
                # Extract LA workspace ID (if configured)
                LA_WS=$(echo "$DIAG" \
                    | jq -r '.[] | select(.workspaceId != null) | .workspaceId' \
                    | head -n 1)

                if [ -n "$LA_WS" ]; then
                    SENDING_LA="yes"
                else
                    SENDING_LA="no"
                fi
            else
                LA_WS=""
                SENDING_LA="no"
            fi

            # Write to CSV
            echo "$SUB,$RES_ID,$TYPE,$HAS_DIAG,$SENDING_LA,$LA_WS" >> "$OUTPUT_CSV"
        done
    done
done

echo "Completed. Results in: $OUTPUT_CSV"
echo "Errors in: $ERROR_LOG"
