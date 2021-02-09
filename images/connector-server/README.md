# Connector-server image
TODO

## Building



### Build process

1. Installs necessary tooling
1. Installs Python and pywinrm in order to enable usage of winrm-ad connector
1. Downloads connector-server from https://github.com/bcvsolutions/connector-server.git repository. Version to download is specified in **CSERVER_VERSION** variable.
1. Copies additional runscripts into the container. These scripts are used for:
    - Setting connector-server key
    - Import trusted certificates
    - Setting execute rights to Python scripts used by winrm-ad connector
 
