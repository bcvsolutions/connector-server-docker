#!/bin/bash
echo "[$0] Setting execute rights for connector server scripts ...";

find /opt/connector-server/connid-connector-server/scripts -maxdepth 5 -exec chown -v root:connector-server {} \;
find /opt/connector-server/connid-connector-server/scripts -maxdepth 5 -type d -exec chmod -v 755 {} \;
find /opt/connector-server/connid-connector-server/scripts -maxdepth 5 -type f -exec chmod -v 644 {} \;
find /opt/connector-server/connid-connector-server/scripts -maxdepth 5 -name "*.py" -type f -exec chmod -v +x {} \;