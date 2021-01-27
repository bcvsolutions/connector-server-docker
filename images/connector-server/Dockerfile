FROM centos:7

ENV RUNSCRIPTS_PATH /runscripts

RUN yum install -y epel-release && \
		yum install -y deltarpm && \
		yum update -y && \
		yum install -y python27 python-pip wget psmisc sudo java-11-openjdk-headless java-11-openjdk-devel xmlstarlet openssl git && \
		yum clean all

RUN pip install pywinrm
#RUN pip install pywinrm[kerberos]
RUN pip install pywinrm[credssp]

RUN git clone https://github.com/bcvsolutions/connector-server.git /opt/connector-server/

COPY ./dropin/connectorserver.properties /opt/connector-server/connid-connector-server/conf/connectorserver.properties

RUN chmod 750 /opt/connector-server/
RUN chmod 750 /opt/connector-server/connid-connector-server/bin/ \
/opt/connector-server/connid-connector-server/bundles/ \
/opt/connector-server/connid-connector-server/certs/ \
/opt/connector-server/connid-connector-server/conf/ \
/opt/connector-server/connid-connector-server/lib/ \
/opt/connector-server/connid-connector-server/logs/ \
/opt/connector-server/connid-connector-server/scripts/

RUN useradd -b /opt -m -s /bin/bash connector-server
RUN chmod 750 /opt/connector-server/
RUN chmod +x /opt/connector-server/connid-connector-server/bin/ConnectorServer.sh

RUN chown -R connector-server:connector-server /opt/connector-server 

COPY runscripts "$RUNSCRIPTS_PATH/"

RUN find "$RUNSCRIPTS_PATH/" -name "*.sh" -exec chmod -v u+x {} \;

CMD ["/bin/bash","-c","$RUNSCRIPTS_PATH/run.sh"]

EXPOSE 8759

