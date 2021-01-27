#!/bin/bash

# Those are defaults if not set from outside. Defaults on empty string.
if [ -z "${JAVA_XMS}" ]; then
  JAVA_XMS="512M";
fi
if [ -z "${JAVA_XMX}" ]; then
  JAVA_XMX="1024M";
fi
if [ -z "${CSERVER_TRUSTSTORE}" ]; then
  CSERVER_TRUSTSTORE="/opt/connector-server/connid-connector-server/conf/truststore.jks"
fi

JAVA_HOME="/usr/lib/jvm/java-openjdk";
JAVA_OPTS="-Xms${JAVA_XMS} -Xmx${JAVA_XMX} -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Djava.util.logging.config.file=conf/logging.properties";

if [ -z "${DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE}" ]; then
    echo "[$0] DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE not set";
else
    if [ -f "${DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE}" ]; then
    trustStorePassword=$(cat "$DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE");  
    JAVA_OPTS="$JAVA_OPTS -Djavax.net.ssl.trustStore=$CSERVER_TRUSTSTORE -Djavax.net.ssl.trustStorePassword=$trustStorePassword";
    else
    echo "[$0] DOCKER_CONNECTOR_SRV_TRUSTSTORE_PASSFILE not readable.";
    fi
fi


# *_ADD variables are the way to customize JAVA_OPTS and CATALINA_OPTS.
# Empty-string variables are treated as if they did not exist.
if [ ! -z "${JAVA_OPTS_ADD}" ]; then
  JAVA_OPTS="$JAVA_OPTS $JAVA_OPTS_ADD";
fi

# *_OVR variables are hard override parameters
# When hard override is specified, it is taken from ENV as it is - even if it is
# an empty string!
if [ ! -z "${CSERVER_OPTS_OVR+x}" ]; then
  CSERVER_OPTS="$CSERVER_OPTS_OVR";
fi
if [ ! -z "${JAVA_OPTS_OVR+x}" ]; then
  JAVA_OPTS="$JAVA_OPTS_OVR";
fi

# If you need to do something extra special, you can script it yourself.
# Files are taken from startConnectorServer.d/ in alphabetical order and SOURCED into this bash.
# Sourcing allows you to operate one the whole env if you need - this is a difference
# from runOnce.d and runEvery.d scripts which are just executed, not sourced.
# This is invoked every time the container starts.
echo "[$0] Sourcing files in order: $(ls $RUNSCRIPTS_PATH/startConnectorServer.d | tr '\n' ' ')";
for f in $(ls "$RUNSCRIPTS_PATH/startConnectorServer.d"); do
  echo "[$0] Sourcing file $f";
  . "$RUNSCRIPTS_PATH/startConnectorServer.d/$f";
done

export JAVA_HOME
cd /opt/connector-server/connid-connector-server

CLASSPATH=lib/framework/connector-framework.jar:\
lib/framework/connector-framework-internal.jar:\
lib/framework/groovy-all.jar:\
lib/framework/slf4j-api.jar:\
lib/framework/slf4j-logging.jar:\
lib/framework/logback-core.jar:\
lib/framework/logback-classic.jar\
lib/jackson-core-2.9.8.jar\
lib/jackson-databind-2.9.8\
lib/jackson-annotations-2.9.8.jar

sudo -Eu connector-server java $JAVA_OPTS -classpath "$CLASSPATH" org.identityconnectors.framework.server.Main -run -properties /opt/connector-server/connid-connector-server/conf/connectorserver.properties $CSERVER_OPTS