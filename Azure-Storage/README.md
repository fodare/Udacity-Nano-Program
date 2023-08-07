### Azure Storage

These are some storage services Azure provides. Lesson overview below

- Data Storage Services:
  - Azure SQL Database
  - Azure Blob storage
- Create storage and uploading data.

- Creating an MS SQL database
  - Using AZ CLI

  ```python
  # Create  SQL server
  az sql server create \
    --admin-user {username} \
    --admin-password {password} \
    --name {servername} \
    --resource-group {resource group name} \
    --location {AZ region} \
    --enable-public-network true \
    --verbose

    # Create firewall rules

    # Rule so all azure resource can access the DB
    az sql server firewall-rule create \
    -g {resource group} \
    -s {SQL server name} \
    -n azureaccess \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0 \
    --verbose

    # Rule so your local machine can connect to the DB
    az sql server firewall-rule create \
    -g {resource group name} \
    -s {SQL server name} \
    -n clientip \
    --start-ip-address {your public ip address} \
    --end-ip-address {your public ip address} \
    --verbose

    # Create SQL database
    az sql db create \
    --name {database name} \
    --resource-group {resource group name} \
    --server {SQL server name} \
    --service-objective S0 \
    --verbose

    # Clean up DB
    az sql db delete \
    --name {DB name} \
    --resource-group {resource group name} \
    --server {SQL server name} \
    --verbose

    az sql server delete \
    --name {SQL server name} \
    --resource-group {resource group name} \
    --verbose
  ```

- Creating a Blob Storage

  - Using AZ CLI

  ```python
  az storage account create \
  --name {stroage account name} \
  --resource-group {resource group name} \
  --location {az region}

  az storage container create \
  --account-name {storage account name} \
  --name {container naae} \
  --auth-mode login \
  --public-access container
  ```
