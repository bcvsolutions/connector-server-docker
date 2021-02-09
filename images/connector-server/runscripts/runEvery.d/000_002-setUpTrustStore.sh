#!/bin/bash
echo "[$0] Set up trust store...";
echo "[$0] importing certificates from: $(ls $CERTS_PATH | tr '\n' ' ')";

for f in $(ls "$CERTS_PATH"); do
  echo "[$0] Importing certificate $f";
  keytool -importcert -file "$CERTS_PATH/$f" -alias "$f" -keystore $CSERVER_TRUSTSTORE -storepass changeit -noprompt
done