#!/bin/bash
echo "[$0] Setting logging level ...";

cd /opt/connector-server/connid-connector-server/conf

# Set log level
if [ -z "${LOG_LEVEL}" ]; then
  echo "[$0] LOG_LEVEL not set, using default from the template.";
else
  echo "[$0] Setting LOG_LEVEL to $LOG_LEVEL";
  sed -i "s#.*.level=.*#.level=$LOG_LEVEL#" logging.properties;
fi