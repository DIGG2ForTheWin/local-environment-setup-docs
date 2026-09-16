# Configuration

## Configuration strategy

The vendor sample supports either direct JDBC properties or an application-server datasource. The lab chose **Tomcat JNDI** so the DB password did not need to appear in `smp.config.properties`.

## `smp.config.properties`

Installed on Tomcat's classpath:

```text
/opt/domismp/lib/smp.config.properties
```

Relevant final values:

```properties
smp.jdbc.hibernate.dialect=org.hibernate.dialect.MySQLDialect
smp.datasource.jndi=java:comp/env/jdbc/eDeliverySmpDs
smp.security.folder=/data/domismp/security
smp.log.folder=/data/domismp/logs
smp.log.configuration.file=/opt/domismp/lib/smp-logback.xml
smp.libraries.folder=/data/domismp/ext-lib
smp.locale.folder=/data/domismp/locales
```

The direct JDBC properties remained commented.

File ownership/mode:

```text
domismp:domismp
640
```

## Tomcat datasource

A datasource was added inside `/opt/domismp/conf/context.xml`:

```xml
<Resource
    name="jdbc/eDeliverySmpDs"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
    driverClassName="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/smp?useSSL=false&amp;allowPublicKeyRetrieval=true&amp;serverTimezone=UTC"
    username="smp"
    password="<SMP_DB_PASSWORD>"
    maxTotal="30"
    maxIdle="10"
    maxWaitMillis="10000"
    validationQuery="SELECT 1"
    testOnBorrow="true"
/>
```

The real password is intentionally excluded from this repository.

## Why `allowPublicKeyRetrieval=true` is present

The MySQL account uses `caching_sha2_password`. The lab already encountered Connector/J public-key retrieval behaviour on the Domibus gateways, so the DomiSMP datasource was configured correctly before the first reboot rather than waiting for the same failure to recur.

This is acceptable in the isolated localhost lab with `useSSL=false`. It is not a production-security recommendation.

## `context.xml` protection

Because `context.xml` contains the DB password:

```text
owner: domismp:domismp
mode: 600
```

A factory backup was made before the edit:

```text
/opt/domismp/conf/context.xml.factory
```

The backup predates the secret-bearing datasource block.

## Logback configuration

Copied to:

```text
/opt/domismp/lib/smp-logback.xml
```

An early startup exposed a path problem described in the failures page. The final configuration uses absolute paths:

```xml
<file>/data/domismp/logs/edelivery-smp.log</file>
<fileNamePattern>/data/domismp/logs/edelivery-smp-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
```

## Tomcat config validation

`configtest.sh` completed successfully and reported:

```text
Server initialization in [1790] milliseconds
```

with Tomcat 10.1.59 and Temurin 21.
