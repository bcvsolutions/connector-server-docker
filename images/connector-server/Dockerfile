FROM centos:7

ENV RUNSCRIPTS_PATH /runscripts
ENV CSERVER_VERSION cs1.4.5.1-cf1.4.3.0-bcv1.0
ENV CSERVER_TRUSTSTORE /opt/connector-server/connid-connector-server/conf/truststore.jks

RUN yum install -y epel-release && \
		yum install -y deltarpm && \
		yum update -y && \
		yum install -y python39 python-pip wget psmisc sudo java-11-openjdk-headless java-11-openjdk-devel xmlstarlet openssl git && \
		yum clean all && \
		pip install -Iv pywinrm==0.3.0 && \ 
		pip install -Iv pywinrm[credssp]==0.3.0 && \
		pip install -Iv cryptography==2.7
 
RUN git clone --depth 1 --branch $CSERVER_VERSION https://github.com/bcvsolutions/connector-server.git /opt/connector-server/ && \
 	chmod 750 /opt/connector-server/ \
	/opt/connector-server/connid-connector-server/bin/ \
	/opt/connector-server/connid-connector-server/bundles/ \
	/opt/connector-server/connid-connector-server/certs/ \
	/opt/connector-server/connid-connector-server/conf/ \
	/opt/connector-server/connid-connector-server/lib/ \
	/opt/connector-server/connid-connector-server/logs/ \
	/opt/connector-server/connid-connector-server/scripts/ && \
	useradd -b /opt -m -s /bin/bash connector-server && \
	chmod +x /opt/connector-server/connid-connector-server/bin/ConnectorServer.sh
	
COPY ./dropin/connectorserver.properties /opt/connector-server/connid-connector-server/conf/connectorserver.properties
COPY runscripts "$RUNSCRIPTS_PATH/"

RUN chown -R connector-server:connector-server /opt/connector-server && \
find "$RUNSCRIPTS_PATH/" -name "*.sh" -exec chmod -v u+x {} \;

CMD ["/bin/bash","-c","$RUNSCRIPTS_PATH/run.sh"]

EXPOSE 8759