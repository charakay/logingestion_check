# Azure Diagnostic Settings Checker

A Bash script to audit diagnostic settings across multiple Azure subscriptions and resource types, generating a comprehensive CSV report of which resources are sending logs to Log Analytics workspaces.

## Overview

This script iterates through specified Azure subscriptions and checks whether diagnostic settings are enabled for various resource types. It identifies which resources are configured to send logs to Log Analytics (LA) workspaces and exports the results to a CSV file for analysis.

## Features

- ✅ Multi-subscription support
- ✅ Checks 25+ Azure resource types
- ✅ Identifies Log Analytics workspace configurations
- ✅ CSV output for easy analysis and reporting
- ✅ Error logging for troubleshooting
- ✅ Handles missing or inaccessible resources gracefully

## Prerequisites

- **Azure CLI** - Must be installed and authenticated
  - Install: [Azure CLI Installation Guide](https://docs.microsoft.com/cli/azure/install-azure-cli)
  - Login: `az login`
- **jq** - JSON processor for parsing Azure CLI output
  - Install on Ubuntu/Debian: `sudo apt-get install jq`
  - Install on macOS: `brew install jq`
  - Install on Windows: Download from [jq website](https://stedolan.github.io/jq/)
- **Bash** - Version 4.0 or higher recommended
- **Azure Permissions** - Reader access (minimum) to the subscriptions being audited

## Supported Resource Types

The script checks the following Azure resource types:

- Azure Kubernetes Service (AKS)
- PostgreSQL Flexible Servers
- Virtual Machines
- Azure Firewalls
- Front Door
- Application Gateways
- CDN Profiles
- Azure Data Explorer (Kusto)
- Event Hub Namespaces
- Virtual Networks
- Virtual Machine Scale Sets
- Log Analytics Workspaces
- Stream Analytics Jobs
- Recovery Services Vaults
- Network Security Groups
- Public IP Addresses
- Storage Accounts
- Key Vaults
- SQL Servers
- MySQL Servers
- App Services
- Cosmos DB
- Traffic Manager Profiles
- Entra Identity

## Installation

1. Clone or download the script:
```bash
wget https://your-repo/diagnostic_checker.sh
# or
curl -O https://your-repo/diagnostic_checker.sh
```

2. Make the script executable:
```bash
chmod +x diagnostic_checker.sh
```

3. Edit the script to add your subscription IDs:
```bash
nano diagnostic_checker.sh
```

## Configuration

Before running the script, update the `SUBSCRIPTIONS` array with your Azure subscription IDs:

```bash
SUBSCRIPTIONS=(
    "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
    "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
)
```

### Optional Configuration

You can modify these variables at the top of the script:

- `OUTPUT_CSV` - Name of the output CSV file (default: `diagnostic_settings_results.csv`)
- `ERROR_LOG` - Name of the error log file (default: `errors.log`)
- `SUPPORTED_RESOURCE_TYPES` - Add or remove resource types to check

## Usage

Run the script:

```bash
./diagnostic_checker.sh
```

The script will:
1. Iterate through each subscription
2. Query resources of each supported type
3. Check diagnostic settings for each resource
4. Write results to CSV and errors to log file

### Example Output

Progress will be displayed in the terminal:
```
Checking subscription: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  Checking resources of type: Microsoft.ContainerService/managedClusters
    Processing: /subscriptions/.../resourceGroups/.../providers/Microsoft.ContainerService/managedClusters/my-aks
  Checking resources of type: Microsoft.Compute/virtualMachines
    Processing: /subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/my-vm
...
Completed. Results in: diagnostic_settings_results.csv
Errors in: errors.log
```

## Output Files

### CSV Report (`diagnostic_settings_results.csv`)

Contains the following columns:

| Column | Description |
|--------|-------------|
| `subscription_id` | Azure subscription ID |
| `resource_id` | Full resource ID |
| `resource_type` | Azure resource type |
| `diagnostic_enabled` | Whether diagnostic settings exist (`true`/`false`) |
| `sending_to_LA` | Whether logs are sent to Log Analytics (`yes`/`no`) |
| `workspace_id` | Log Analytics workspace ID (if configured) |

Example:
```csv
subscription_id,resource_id,resource_type,diagnostic_enabled,sending_to_LA,workspace_id
xxx-xxx,/subscriptions/.../my-aks,Microsoft.ContainerService/managedClusters,true,yes,/subscriptions/.../workspaces/my-workspace
```

### Error Log (`errors.log`)

Contains any errors encountered during execution, such as:
- Authentication failures
- Permission issues
- Resource access errors
- API failures

## Troubleshooting

### Common Issues

**Authentication Errors**
```bash
# Re-authenticate with Azure
az login
az account list
```

**Permission Denied**
- Ensure you have at least Reader role on the subscriptions
- Check that diagnostic settings can be read (may require Monitoring Reader role)

**jq Command Not Found**
```bash
# Install jq
sudo apt-get install jq  # Ubuntu/Debian
brew install jq          # macOS
```

**Script Hangs or Runs Slowly**
- Large subscriptions may take time to process
- Consider reducing the number of resource types
- Run during off-peak hours

## Performance Considerations

- Processing time depends on the number of subscriptions, resource types, and resources
- Large environments may take 30+ minutes to complete
- Consider running in a screen/tmux session for long-running operations

## License

This script is provided as-is without warranty. Modify and use at your own risk.

## Contributing

To add support for additional resource types, update the `SUPPORTED_RESOURCE_TYPES` array with the appropriate Azure resource type identifier.

## Author

Created for Azure infrastructure auditing and compliance reporting.

## Version History

- **v1.0** - Initial release with 25 resource types supported
