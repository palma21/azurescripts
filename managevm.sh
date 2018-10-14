#!/bin/bash

AZURE_RESOURCE_GROUP=$2

if [ $1 == "start" ];
then
    if [ $AZURE_RESOURCE_GROUP == "all" ];
    then
        az vm start --ids $(az vm list --query "[].id" -o tsv) --no-wait
    else
        VM_NAMES=$(az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM deallocated'].{ name: name }" -o tsv)
        for NAME in $VM_NAMES
        do
            echo "Starting $NAME"
            az vm start -n $NAME -g $AZURE_RESOURCE_GROUP --no-wait
        done
    fi
fi

if [ $1 == "stop" ];
then
    if [ $AZURE_RESOURCE_GROUP == "all" ];
    then
        az vm deallocate --ids $(az vm list --query "[].id" -o tsv) --no-wait
    else
        VM_NAMES=$(az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM running'].{ name: name }" -o tsv)
        for NAME in $VM_NAMES
        do
            echo "Stopping $NAME"
            az vm deallocate -n $NAME -g $AZURE_RESOURCE_GROUP --no-wait
        done
    fi
fi

if [ $1 == "status" ];
then
    echo "Fetching Details..."
    if [ $AZURE_RESOURCE_GROUP == "all" ];
    then
        az vm list --show-details -o table
    else
        az vm list -g $AZURE_RESOURCE_GROUP --show-details -o table
    fi
    echo "Fetching Summary..."
    echo "Power Status of all VMs"
    echo "-----------------------"
    if [ $AZURE_RESOURCE_GROUP == "all" ];
    then
        # ToDo: Add RG to the output
        az vm list --show-details --query "[].{name: name, status: powerState}" -o table
    else
        az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[].{name: name, status: powerState}" -o table
    fi
fi


if [ $1 == "ip" ];
then
    az vm list -g $AZURE_RESOURCE_GROUP --show-details --query "[?powerState=='VM running'].{ name:name, ip: publicIps }" -o table
fi