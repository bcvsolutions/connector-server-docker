# Connector-server image
Image with [connector-server](https://github.com/bcvsolutions/connector-server).

## Image versioning
Image version has the following scheme: CSERVER_VERSION-rIMAGE_VERSION.

- **CSERVER_VERSION** is version of [connector-server](https://github.com/bcvsolutions/connector-server) stripped from the beggining part. For example `bcv1.0`
- **IMAGE_VERSION** is an image release version written as a serial number, starting at 0.

Example
```
bcv1.0-r0 - first version
```

## Building
Simply cd to the directory which contains the Dockerfile and issue `docker build -t <image tag here> ./`.

### Build process

1. Installs necessary tooling
1. Installs Python3 and pywinrm3 in order to enable usage of winrm-ad connector
1. Downloads connector-server from https://github.com/bcvsolutions/connector-server.git repository. Version to download is specified in **CSERVER_VERSION**.
1. Copies additional runscripts into the container. These scripts are used for:
    - Setting connector-server key
    - Import trusted certificates
    - Setting execute rights to Python scripts used by winrm-ad connector

## Use

Image exposes port 8759 on which connector-server will be listening.

## Environment variables
- Mandatory
    - **DOCKER_CONNECTOR_SRV_PASSFILE** - points image to the location of the file containing connector-server password
- Optional
    - **LOG_LEVEL** - Set the log level of logger. Default level is INFO. Possible values are SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST, ALL, OFF

## Mounted files and volumes
- Mandatory
    - Volume containing connector-server password file
        - It should be mounted to target specified in **DOCKER_CONNECTOR_SRV_PASSFILE** which also has to be set in order to secure connector-server with password.
        - Example
        ```
        - type: bind
          source: ./cserver.pwfile
          target: /run/secrets/cserver.pwfile
          read_only: true
        ```
- Optional
    - Volume with connector bundles
        - Without this volume, the connector-server wont provide any connectors
        - Example
        ```
        - type: bind
          source: ./bundles
          target: /opt/connector-server/connid-connector-server/bundles
          read_only: true
        ```
    - Volume with trusted certificates
        - Truststore is rebuilt on each start of the image and all certificates in PEM format are imported from this volume
        - Example
        ```
        - type: bind
          source: ./certs
          target: /run/certs
          read_only: true
        ```
    - Volume with winrm CA certificate
        - Only to be used with winrm-ad connector. This certificate is only used when comunicating via winrm
        - Example
        ```
        - type: bind
          source: ./winrm_ca.pem
          target: /opt/connid-connector-server/certs/winrm_ca.pem
          read_only: true
        ```
    - Volume with python3 and Powershell scripts for winrm-ad connector
        - Must not be read-only - image sets execute rights to all pyrhon scripts in this directory and its subdirectories
        - Example
        ```
        - type: bind
          source: ./winrm_scripts
          target: /opt/connector-server/connid-connector-server/scripts/winrm_scripts
          read_only: false
        ```
## Logging
Connector-server logs to stdout with INFO level. Image rebuild is required to change this at the time. This will probably change with future versions.