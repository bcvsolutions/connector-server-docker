#!/bin/bash
echo "[$0] Configuring Connector server password...";

if [ -z "${DOCKER_CONNECTOR_SRV_PASSFILE}" ]; then
    echo "[$0] DOCKER_CONNECTOR_SRV_PASSFILE not set";
else
    if [ -f "${DOCKER_CONNECTOR_SRV_PASSFILE}" ]; then
    csrvpass=$(cat "$DOCKER_CONNECTOR_SRV_PASSFILE");
    cd /opt/connector-server/connid-connector-server 
    ./bin/ConnectorServer.sh -setKey -key $csrvpass -properties conf/connectorserver.properties
    else
    echo "[$0] DOCKER_CONNECTOR_SRV_PASSFILE not readable.";
    fi
fi