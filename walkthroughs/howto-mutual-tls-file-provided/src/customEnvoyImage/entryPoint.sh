#!/bin/bash

# $1=Secret Name
getSecret() {
    aws secretsmanager get-secret-value --secret-id $1 --region $AWS_DEFAULT_REGION | jq -r .SecretString > /keys/${1}.pem
    echo "Added $1 to container"
}

getCertificates() {
    if [[ $CERTIFICATE_NAME = "client" ]];
    then
        getSecret "ca_cert"
        getSecret "client_key"
        getSecret "client_cert_chain"
    fi
    if [[ $CERTIFICATE_NAME = "server" ]];
    then
        getSecret "server_key"
        getSecret "server_cert_chain"
        getSecret "ca_cert"
    fi
}

# Get the appropriate certificates
getCertificates
# Start Envoy
/usr/bin/agent
