# Udacity Nano degree Program

- Program: Cloud developer using Microsoft Azure
- Link: [Here](https://www.udacity.com/course/cloud-developer-using-microsoft-azure-nanodegree--nd081)

## Sections

### Compute Services

- Creating resource group

  - See `ComputeService-Tasks` for terraform template.
  - Via AZ CLI.

  ```python
    az login

    az account list-locations -o table

    az group create --name {resource group name} --location {location where rg is to be hosted}
    ```

- Creating VM and configuring an NginX reverse proxy.
  - Using AZ CLI

  ```python
  az vm create \
   --resource-group "resource-group-west" \
   --name "linux-vm-west" \
   --location "westus2" \
   --image "UbuntuLTS" \
   --size "Standard_B1ls" \
   --admin-username "adminUser" \
   --generate-ssh-keys \
   --verbose

   az vm open-port \
    --port "80" \
    --resource-group "resource-group-west" \
    --name "linux-vm-west"

    sudo apt-get -y update && sudo apt-get -y install nginx python3-venv
    cd /etc/nginx/sites-available
    sudo unlink /etc/nginx/sites-enabled/default
    sudo vim reverse-proxy.conf

    server {
    listen 80;
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
     }

     sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

     sudo service nginx restart

     az group delete -n resource-group-west
    ```

  - see main.tf for terraform template

- Creating an App service
  - See main.tf for terraform template
  - Using AZ CLI

  ```python
  az login 
  cd {project dir}
  az webapp up \

    --resource-group resource-group-west \
    --name {App name} \
    --sku F1 \
    --verbose

    # Update APP

    az webapp up \
    --name {app name} \
    --verboses
  ```
