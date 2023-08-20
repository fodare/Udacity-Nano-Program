# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction

This is a sample solution template for the Udacity Deploying a scalable IaaS web server in Azure project.

## Dependencies

1. Create an Azure Account
2. Install Azure's command line tool.
3. Install packer.
4. Install Terraform

## Getting started

- Clone this repo.

- Navigate to project root directory and open the project in your favourite CLI tool e.g `terminal`

- Create AZ session using your service principal account.

  - ```python
    # Make sure you have a service principal account.
    az login --service-principal --username {app id} --password {SP secret} --tenant {tenantID}
    ```

- Create a resource group.

  - ```python
    # Resource group will be used when create a packer image
    az group create -l {az region. e.g westus} -n {resource group name}
    ```

- Build packer image.

  - ```python
    # Fill in the export command below. It's needed for the `task1Image.json` template.

    # export clientID={enter sp client id}
    # export clientSecret={enter sp secret}
    # export subId={enter sp subscription id}
    # export tenant_id={enter sp tenant id}

    packer build task1Image.json

    az image list -o table
    ```

- Provision load balancer and VM(s).

  - ```python
    # export terraform envioment variables
    # export ARM_SUBSCRIPTION_ID="....."
    # export ARM_TENANT_ID="...."
    # export ARM_CLIENT_ID="....."
    # export ARM_CLIENT_SECRET="....."

    # Config values can be found in the file `var.tf`
    # Modify values if you need to change default settings.

    terraform init

    terraform validate

    terraform plan

    terraform apply

    az vm list -o table
    ```
