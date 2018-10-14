#!/bin/bash

AZURE_RESOURCE_GROUP=$2

if [ $1 == "delete" ];
then
    if [ $AZURE_RESOURCE_GROUP == "all" ];
    then
        az group delete --name $(az group list --query "[].name" -o tsv) --no-wait
    else
        GROUP_NAMES="${@:2}"
        for NAME in $GROUP_NAMES
        do
            echo "Deleting $NAME"
            az group delete --name $NAME --no-wait
        done
    fi
else
    echo "no valid action"
fi

