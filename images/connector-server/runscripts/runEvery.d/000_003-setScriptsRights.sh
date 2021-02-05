#!/bin/bash
echo "[$0] Setting execute rights for connector server scripts ...";

find /opt/connector-server/connid-connector-server/scripts -type f -exec chmod +x {} \;