# Inventory and versions

## Virtual machines

### Blue

```text
Hostname: blue
Role: Domibus Access Point
VMnet3: 192.168.50.10/24
```

### Red

```text
Hostname: red
Role: Domibus Access Point
VMnet3: 192.168.50.20/24
```

Observed Red NAT address:

```text
192.168.140.130/24
```

### sdk-core

A third Ubuntu VM exists for the later SDK/SMP phase. It is deliberately not mixed into the completed Blue/Red baseline.

## VM resources

Blue and Red were provisioned with approximately:

```text
RAM: 8 GB
Processors: 4
OS disk: 60 GB
Data disk: 200 GB
```

## Operating system

```text
Ubuntu Server 24.04.5 LTS
```

ISO:

```text
ubuntu-24.04.5-live-server-amd64.iso
```

Download: <https://releases.ubuntu.com/24.04/ubuntu-24.04.5-live-server-amd64.iso> (checksums: <https://releases.ubuntu.com/24.04/SHA256SUMS>)

## Base tools

Observed:

```text
Python 3.12.3
open-vm-tools 13.0.10.0
SSH installed/enabled
```

## Java

```text
Eclipse Temurin JDK 21
JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
```

Installed from the Adoptium apt repository (package `temurin-21-jdk`): <https://adoptium.net/installation/linux/>

Observed runtime:

```text
21.0.12.1
2026-08-18 LTS
Temurin
```

## MySQL

```text
MySQL 8.0.46 Ubuntu
```

Installed from the Ubuntu archive: `sudo apt install mysql-server`.

## Domibus

```text
5.2.1.3
```

Distribution:

```text
domibus-msh-distribution-5.2.1.3-JEE10-tomcat-full.zip
```

Download: <https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.2.1.3-JEE10/domibus-msh-distribution-5.2.1.3-JEE10-tomcat-full.zip>

Release page: <https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467110244/Domibus>

Approximate archive size:

```text
145 MB
```

An older 5.2.1.2 archive existed during preparation, but the final environment uses 5.2.1.3.

## Sample/testing distribution

```text
domibus-msh-distribution-5.2.1.3-JEE10-sample-configuration-and-testing.zip
```

Download: <https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-distribution/5.2.1.3-JEE10/domibus-msh-distribution-5.2.1.3-JEE10-sample-configuration-and-testing.zip>

Approximate size:

```text
100 KB
```

## SQL distribution

```text
domibus-msh-sql-distribution-1.21.zip
```

Download: <https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-sql-distribution/1.21/domibus-msh-sql-distribution-1.21.zip>

Approximate size:

```text
1.7 MB
```

Relevant path after extraction:

```text
~/dl/sql-dist/sql-scripts/5.2.1/mysql/
```

Important files:

```text
mysql-5.2.1.ddl
mysql-5.2.1-data.ddl
multitenancy scripts
scripts/
```

## Tomcat

Bundled version:

```text
10.1.54
```

## JDBC driver

```text
MySQL Connector/J 8.4.0
```

File:

```text
mysql-connector-j-8.4.0.jar
```

Download (Maven Central): <https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar>

Installed:

```text
/opt/domibus/lib/mysql-connector-j-8.4.0.jar
```

Manifest verified as 8.4.0.

## Domibus paths

```text
/opt/domibus/bin/startup.sh
/opt/domibus/bin/shutdown.sh
/opt/domibus/bin/setenv.sh
/opt/domibus/lib
/opt/domibus/webapps/domibus.war
/opt/domibus/conf/domibus/domibus.properties
/opt/domibus/conf/domibus/domains/default/default-domibus.properties
/opt/domibus/conf/domibus/super-domibus.properties
/opt/domibus/conf/domibus/keystores/gateway_keystore.jks
/opt/domibus/conf/domibus/keystores/gateway_truststore.jks
/opt/domibus/logs
```

Observed Red file sizes during installation:

```text
domibus.war ~129 MB
Connector/J ~2.5 MB
domibus.properties ~92 KB
keystore ~4.1 KB
```

## setenv.sh

Important JVM options:

```text
-Xms4096m
-Xmx4096m
-Ddomibus.config.location=/opt/domibus/conf/domibus
```

## Ubuntu phased updates

At one point apt showed four phased netplan upgrades deferred. No failed services were present. This did not affect the final baseline.

## Screenshot-derived inventory details

The evidence archive adds several concrete inventory observations: the VM wizard used a 60 GB OS disk, the running Ubuntu guests exposed VMware virtual disks through `lsblk`, SSH and `open-vm-tools` were active, Python 3.12.3 was present, and the Connector/J JAR manifest identified version 8.4.0.

### Screenshot evidence

![Blue base-service and version audit](assets/screenshots/20260915-190716.png)

*Blue base audit showing SSH/open-vm-tools state, Python, networking and filesystem information.*

![Connector/J manifest inspection](assets/screenshots/20260915-205718.png)

*Manifest inspection of the MySQL Connector/J 8.4.0 JAR.*

