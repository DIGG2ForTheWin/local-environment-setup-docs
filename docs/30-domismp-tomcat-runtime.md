# Tomcat and DomiSMP runtime installation

## Dedicated runtime identity

A non-login system account was created:

```bash
sudo useradd \
  --system \
  --home /opt/domismp \
  --shell /usr/sbin/nologin \
  --user-group \
  domismp
```

Observed result:

```text
domismp:x:999:988::/opt/domismp:/usr/sbin/nologin
```

## Runtime tree

Tomcat was installed into:

```text
/opt/domismp
```

Persistent application state stayed under `/data/domismp`.

## Tomcat version

Apache Tomcat **10.1.59** was installed and verified:

```text
Server version: Apache Tomcat/10.1.59
Server built:   Aug 13 2026 16:59:10 UTC
Server number:  10.1.59.0
JVM Version:    21.0.12.1+1-LTS
JVM Vendor:     Eclipse Adoptium
```

DomiSMP 5.2.1.x is the modern Tomcat 10.1/Java 21 line.

## WAR deployment name

The downloaded WAR was copied as:

```text
/opt/domismp/webapps/smp.war
```

This gives the context path:

```text
/smp
```

Observed WAR size:

```text
82M
```

## Connector/J

The VM did not initially contain Connector/J 8.4.0. A previously verified copy was transferred from Blue:

```text
/home/xander/dl/domismp/mysql-connector-j-8.4.0.jar
```

There was a small operator error here: ownership was attempted on `/opt/domismp/lib/mysql-connector-j-8.4.0.jar` **before the JAR had actually been copied into Tomcat**, producing:

```text
chown: cannot access '/opt/domismp/lib/mysql-connector-j-8.4.0.jar': No such file or directory
```

The missing copy step was then performed and the final file was:

```text
/opt/domismp/lib/mysql-connector-j-8.4.0.jar
2.5M
owner domismp:domismp
mode 640
```

Tomcat's version script then reported:

```text
mysql-connector-j-8.4.0.jar: 8.4.0
```

## Explicit Java settings

Before `setenv.sh`, Tomcat's script showed a generic:

```text
JRE_HOME: /usr
```

A dedicated `/opt/domismp/bin/setenv.sh` was created:

```sh
#!/bin/sh

export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export CATALINA_PID=/opt/domismp/temp/tomcat.pid

JAVA_OPTS="$JAVA_OPTS -Xms1024m -Xmx2048m"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
export JAVA_OPTS
```

Final version output used the exact Temurin path.

## Permission observation

Checking `/opt/domismp/webapps/smp.war` as `xander` initially returned `Permission denied` because `/opt/domismp` was intentionally mode 750 for `domismp`. This was not treated as a missing WAR. Verification was repeated using `sudo -u domismp`.
