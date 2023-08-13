# Udacity Nano degree Program

- Program: Cloud DevOps using Microsoft Azure.
- Link: [Here](https://www.udacity.com/course/cloud-devops-using-microsoft-azure-nanodegree--nd082)

## Sections

### Azure Infrastructure fundamentals

Task: Creating a test Ubuntu VM.

- See `main.tf` for terraform template.

- Using AZ CLI

```python
# Create resource group
az group create -l westus -n test-rg

# Create VM
az vm create --resource-group {resource group name} -n test-vm --ssh-key-values "~/.ssh/azure_rsa.pub" --admin-username adminuser --image UbuntuLTS --output json --verbose

# View Vm details
az vm show --name {vm name} --resource-group {resource group name}

# Delete VM
az vm delete -g {resource group name} -n {vm name}

# Delete resource group
az group delete -n {resource group name}
```

### Azure security best practice

Task: Creating a test policy

- See file `TestPolicy.json` for a custom policy definition

  - Using AZ CLI

    ```python
    # Create policy
    az ploicy definition create -n {policy name} --display-name {policy display name} --rules {policy json file}

    # Assign policy
    az policy assignment create --policy {policy name that was created}

    # Unassign policy
    az policy assignment delete --name {assignment name}

    # Delete plicy definition
    az policy definition delete --name {definition name}
    ```
