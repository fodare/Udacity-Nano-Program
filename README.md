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

- Task 1: Creating a test policy

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

  - Task 1: Creating tagging-policy

    - [x] Write a policy definition to deny the creation of resources that to not have tags.
      - see `task1Policy.json` for sample policy.

      - ```python
        az policy definition create -n tagging-policy --display-name tagging-policy --rules task1Policy.json

        az policy assignment create --policy tagging-policy 
        ```

    - [x] Apply the policy definition to the subscription with the name `tagging-policy`.
    - [x] Use `az policy assignment list` and take a screenshot of the policy.

  - Task 2: Packer Template

    - [x] See `task1Image.json` for sample packer image

    - [x] Create a resource group

    - ```python
      # create resource group
      az group create -l westus -n test-rg

      packer build {image template.json}

      az image list -o table
      ```

  - Task 3: Terraform Template
  - [x] `Task1-Terraform` for sample template

### Azure CI-CD

Automating Continuous integration

- Git

- Makefile

  - ```python
    # Check the make utulity is  installed
    which make

    # Create a Makefile
    touch Makefile
    # See sample tmeplate in CI-CD directory.
    ```

- Create virtual env

  ```python
  # Check python is installed
  python3 --version

  # install virtualenv
  pip install  virtualenv

  # Create virtual env
  virtualenv env

  # Activate virtual env
  source env/bin/activate

  # Freeze dependencies
  pip freeze > requirements.txt

  # Deactivate virtual env
  deactivate
  ```

- See `SampleClick.py` for a sample click CLI tool.
- See `test_hello.py` for sample pytest template.
