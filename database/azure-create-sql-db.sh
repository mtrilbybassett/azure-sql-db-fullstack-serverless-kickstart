#!/bin/bash
set -euo pipefail

# Load values from .env file
FILE="../.env"
if [[ -f $FILE ]]; then
	echo "Loading from $FILE" 
    eval $(egrep "^[^#;]" $FILE | tr '\n' '\0' | xargs -0 -n1 | sed 's/^/export /')
else
	echo "Enviroment file not detected."
	echo "Please make sure there is a .env file in the sample root folder and run the script again."
	exit 1
fi

echo "Deploying Azure SQL Database in Location '$location', Resournce Group: '$resourceGroup'...";
azureSQLSRV="zv6qimpc6cbrg"
azureSQLDB="todo_v2"
azureSQLServer=$(az deployment group create \
    --name "sql-db-deploy-2.0" \
    --resource-group $resourceGroup \
    --template-file azure-sql-db.arm.json \
    --parameters \
        databaseServer=$azureSQLSRV \
        databaseName=$azureSQLDB \
        location=$location \
    --query properties.outputs.databaseServer.value \
    -o tsv \
    )

echo "Azure SQL Database available at";
echo "- Location: $location"
echo "- Server: $azureSQLServer"
echo "- Database: $azureSQLDB"
echo "Done."