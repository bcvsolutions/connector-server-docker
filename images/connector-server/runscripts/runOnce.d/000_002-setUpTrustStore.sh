#!/bin/bash
echo "[$0] Set up trust store...";

echo "[$0] importing certificates from: $(ls $CERTS_PATH | tr '\n' ' ')";

if [ -z "${DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE}" ]; then
    echo "[$0] DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE not set";
else
    if [ -f "${DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE}" ]; then
    trustStorePassword=$(cat "$DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE");  
    else
    echo "[$0] DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE not readable.";
    fi
fi

for f in $(ls "$CERTS_PATH"); do
  echo "[$0] Importing certificate $f";
  keytool -importcert -file "$CERTS_PATH/$f" -alias "$f" -keystore $CSERVER_TRUSTSTORE -storepass $trustStorePassword -noprompt
done