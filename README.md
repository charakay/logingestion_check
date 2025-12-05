# Azure Diagnostic Settings Checker

This repository contains a Bash script (`logingestion.sh`) that audits Azure resources across multiple subscriptions and verifies whether **Diagnostic Settings** are configured and whether logs are being sent to a **Log Analytics Workspace (LAW)**.

The script is useful for:
- Compliance checks  
- Monitoring validation  
- Incident response readiness  
- Ensuring all workloads are sending logs to LA  

---

## 🔍 Overview

The script performs the following tasks:

1. Iterates through a list of Azure subscriptions.  
2. Scans each subscription for a predefined set of Azure resource types.  
3. Checks each resource for Diagnostic Settings.  
4. Identifies whether logs are being ingested into a Log Analytics Workspace.  
5. Outputs a structured CSV report.  
6. Logs all errors to an error log.

---

## 📁 Files Generated

### **diagnostic_settings_results.csv**
Contains the final output, showing log ingestion status per resource.

### **errors.log**
Captures failures such as:
- Permission issues  
- API errors  
- Invalid resource types  

---

## 🧰 Prerequisites

Ensure the following tools are installed before running the script:

### **Azure CLI**
```bash
brew install azure-cli
jq (for JSON parsing)
bash
Copy code
brew install jq
Login to Azure
bash
Copy code
az login
You must have at least Reader access on the subscriptions being scanned.

⚙️ Configuration
Before running, modify the script to include your subscription IDs:

bash
Copy code
SUBSCRIPTIONS=(
    "your-subscription-id-1"
    "your-subscription-id-2"
)
Resource types are defined inside the SUPPORTED_RESOURCE_TYPES array.
You may add or remove resource types depending on your environment.

🚀 Usage
1. Make the script executable:
bash
Copy code
chmod +x logingestion.sh
2. Run the script:
bash
Copy code
./logingestion.sh
3. After completion, view outputs:
bash
Copy code
cat diagnostic_settings_results.csv
cat errors.log
📄 CSV Output Fields
Column	Description
subscription_id	Azure subscription ID
resource_id	Full Azure resource identifier
resource_type	Azure resource provider type
diagnostic_enabled	Whether Diagnostic Settings exist (true/false)
sending_to_LA	Whether logs are being sent to Log Analytics
workspace_id	The LAW workspace ID (if configured)

Example row:

bash
Copy code
1234-5678-9012,/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/vm1,Microsoft.Compute/virtualMachines,true,yes,/subscriptions/.../workspaces/law1
🛠 Customization
Modify resource types
Add/remove items in:

bash
Copy code
SUPPORTED_RESOURCE_TYPES=(
    "Microsoft.Compute/virtualMachines"
    "Microsoft.Network/networkSecurityGroups"
    "Microsoft.Storage/storageAccounts"
    ...
)
Modify subscriptions
bash
Copy code
SUBSCRIPTIONS=(
    "sub-1"
    "sub-2"
    "sub-3"
)
Change output filenames
Edit these variables:

bash
Copy code
OUTPUT_CSV="diagnostic_settings_results.csv"
ERROR_LOG="errors.log"
⚠️ Error Handling
All errors are logged in:

lua
Copy code
errors.log
Common errors include:

Missing permissions

Azure CLI failure

Unsupported resource types

API throttling

🧪 Testing
You can test a single subscription by modifying:

bash
Copy code
SUBSCRIPTIONS=("your-subscription-id")
You can also reduce scanning time by temporarily limiting resource types:

bash
Copy code
SUPPORTED_RESOURCE_TYPES=("Microsoft.Compute/virtualMachines")
📘 Example Script Snippet
bash
Copy code
SUPPORTED_RESOURCE_TYPES=(
    "Microsoft.Compute/virtualMachines"
    "Microsoft.Network/networkSecurityGroups"
    "Microsoft.Storage/storageAccounts"
)
🤝 Contributions
Pull requests are welcome.
For major changes, create an issue to discuss your ideas first.

📄 License
This project is licensed under the MIT License.

