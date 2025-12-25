#!/bin/bash
# Azure Cost Check Script
# This script helps identify expensive resources and optimize costs

echo "=== Azure Resource Cost Check ==="
echo ""

# Check if logged in
echo "1. Checking Azure login status..."
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "   ❌ Not logged in. Run: az login"
    exit 1
fi
echo "   ✅ Logged in"
echo ""

# Get current subscription
SUBSCRIPTION=$(az account show --query name -o tsv)
echo "2. Current Subscription: $SUBSCRIPTION"
echo ""

# List all resource groups
echo "3. Resource Groups:"
az group list --output table
echo ""

# List all VMs
echo "4. Virtual Machines:"
az vm list --output table
echo ""

# List all disks (this will show the Premium SSD)
echo "5. All Managed Disks (checking for Premium SSD):"
az disk list --output table --query "[].{Name:name, ResourceGroup:resourceGroup, Type:sku.name, Size:diskSizeGb, Location:location, State:diskState}" -o table
echo ""

# Find Premium SSD disks specifically
echo "6. Premium SSD Disks (expensive!):"
az disk list --query "[?sku.name=='Premium_LRS'].{Name:name, ResourceGroup:resourceGroup, Size:diskSizeGb, Location:location}" -o table
echo ""

# Check VM states (running VMs cost more)
echo "7. VM Power States:"
az vm list --show-details --query "[].{Name:name, ResourceGroup:resourceGroup, PowerState:powerState, Location:location}" -o table
echo ""

# Cost optimization recommendations
echo "=== Cost Optimization Recommendations ==="
echo ""
echo "💡 Tips to reduce costs:"
echo "   1. Delete Premium SSD disks if not needed (use Standard HDD instead)"
echo "   2. Deallocate VMs when not in use: az vm deallocate -g <rg> -n <vm-name>"
echo "   3. Delete unused resources: terraform destroy"
echo "   4. Check for orphaned disks (disks not attached to any VM)"
echo ""

# Find orphaned disks
echo "8. Checking for orphaned disks (not attached to any VM):"
VM_IDS=$(az vm list --query "[].id" -o tsv)
if [ -z "$VM_IDS" ]; then
    echo "   No VMs found. All disks might be orphaned!"
    az disk list --query "[].{Name:name, ResourceGroup:resourceGroup, Type:sku.name, Size:diskSizeGb}" -o table
else
    echo "   Checking disk attachments..."
    # This is a simplified check - you may need to manually verify
    az disk list --query "[].{Name:name, ResourceGroup:resourceGroup, Type:sku.name, ManagedBy:managedBy}" -o table
fi
echo ""

echo "=== Next Steps ==="
echo "To delete a Premium SSD disk:"
echo "  az disk delete --resource-group <rg-name> --name <disk-name> --yes"
echo ""
echo "To deallocate a VM (stops compute charges):"
echo "  az vm deallocate --resource-group <rg-name> --name <vm-name>"
echo ""
echo "To destroy all Terraform resources:"
echo "  cd $(pwd)"
echo "  terraform destroy"


