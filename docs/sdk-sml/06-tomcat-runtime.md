# Tomcat runtime

## Service account

Created:

```text
user:  domisml
uid:   996 (observed)
group: domisml
gid:   987 (observed)
home:  /opt/domisml
shell: /usr/sbin/nologin
```

## Persistent directories

Created under `/data/domisml`:

```text
/data/domisml/logs
/data/domisml/security
/data/domisml/domisml-libs
/data/domisml/tmp
/data/domisml/backups
```

Ownership:

```text
domisml:domisml
```

Mode used on directories:

```text
750
```

## Tomcat

A separate copy of Apache Tomcat 10.1.59 was extracted to:

```text
/opt/domisml
```

The same verified Connector/J 8.4.0 JAR used elsewhere in the lab was copied to:

```text
/opt/domisml/lib/mysql-connector-j-8.4.0.jar
```

Mode:

```text
640
```

## Ports

DomiSML Tomcat was separated from DomiSMP:

```text
DomiSMP shutdown port  8005
DomiSMP HTTP           8080

DomiSML shutdown port  8006
DomiSML HTTP           8081
```

The active DomiSML connector became:

```xml
<Connector port="8081" protocol="HTTP/1.1" ... />
```

The presence of a default Tomcat example line containing `8443` was not treated as proof that an HTTPS listener was active.

## `setenv.sh`

Final important values:

```sh
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export CATALINA_PID=/opt/domisml/temp/tomcat.pid
export CLASSPATH=/opt/domisml/classes

JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dsml.log.folder=/data/domisml/logs"
export JAVA_OPTS
```

The `sml.log.folder` JVM property was added later during Logback troubleshooting; see the logging chapter.

## Classpath configuration

Created:

```text
/opt/domisml/classes
```

Installed there:

```text
sml.config.properties
sml-logback.xml
```

Both were made readable by `domisml`.


![Editing /opt/domisml/classes/sml.config.properties: MySQL dialect, JNDI name and log folder.](../assets/smp-sml-screenshots/20260916-122322.png)

*Editing /opt/domisml/classes/sml.config.properties: MySQL dialect, JNDI name and log folder.*

## Effective application config

Final important values:

```properties
sml.hibernate.dialect=org.hibernate.dialect.MySQLDialect
sml.datasource.jndi=java:comp/env/jdbc/edelivery
sml.jsp.servlet.class=org.apache.jasper.servlet.JspServlet
sml.log.folder=/data/domisml/logs
sml.libraries.folder=/data/domisml/domisml-libs
sml.security.folder=/data/domisml/security
log.configuration.file=/opt/domisml/classes/sml-logback.xml
```

Schema-validation flags stayed enabled.

## WAR deployment

The verified release WAR was deployed as:

```text
/opt/domisml/webapps/edelivery-sml.war
```

which produced the application context:

```text
/edelivery-sml/
```

and URL:

```text
http://192.168.50.30:8081/edelivery-sml/
```
