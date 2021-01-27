#!/bin/bash
echo "[$0] Copying winrm scripts...";

mkdir -p /opt/connector-server/connid-connector-server/scripts/winrm_scripts
cp -R /run/winrm_scripts/* /opt/connector-server/connid-connector-server/scripts/winrm_scripts/
chmod +x /opt/connector-server/connid-connector-server/scripts/winrm_scripts/*