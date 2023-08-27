# flask-ml-service

A sample Flask application to showcase the Azure Pipeline.

## Environment

Python 3.7

## Steps

- Setup virtual environment and activate virtual environment.

    ```python
    make setup

    source venv/bin/activate
    ```

- Install packages.

    ```python
    make install
    ```

- Create an app service and initially deploy your app.

    ```python
    # Make sure you have a service principal account.
    az login --service-principal --username {app id} --password {SP secret} --tenant {tenantID}

    az group create -l westus -n test-rg

    az webapp up -n {desired app service name} -g {resource group name}
    ```

- Create and azure pipeline. Checkout `azure-pipelines-for-self-hosted-agent.yml` for a sample pipeline template
