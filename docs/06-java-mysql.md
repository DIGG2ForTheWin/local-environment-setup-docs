# Java and MySQL

## Java

Eclipse Temurin JDK 21 was installed on Blue, Red and sdk-core.

Path:

```text
/usr/lib/jvm/temurin-21-jdk-amd64
```

`JAVA_HOME`:

```text
/usr/lib/jvm/temurin-21-jdk-amd64
```

Observed version:

```text
21.0.12.1
2026-08-18 LTS
Temurin
```

## Heap

Domibus `setenv.sh` configures:

```text
-Xms4096m
-Xmx4096m
```

## MySQL topology

Blue and Red each run local MySQL. Domibus connects to:

```text
localhost:3306
```

The databases are not shared.

## Database

```text
domibus_schema
```

## User

```text
edelivery_user@localhost
```

## Grants

```sql
ALL PRIVILEGES ON domibus_schema.*
```

plus:

```sql
XA_RECOVER_ADMIN ON *.*
```

## Password handling

Real DB passwords are excluded. A previously exposed Blue password was rotated. Red's password was entered privately.

## Authentication plugin

Both machines were checked and use:

```text
caching_sha2_password
```

## Connector/J

```text
8.4.0
```

Installed:

```text
/opt/domibus/lib/mysql-connector-j-8.4.0.jar
```

Driver:

```text
com.mysql.cj.jdbc.Driver
```

## Final JDBC URL

```properties
domibus.datasource.url=jdbc:mysql://${domibus.database.serverName}:${domibus.database.port}/${domibus.database.schema}?useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
```

Other important active values:

```properties
domibus.database.serverName=localhost
domibus.database.port=3306
domibus.database.schema=domibus_schema
domibus.datasource.driverClassName=com.mysql.cj.jdbc.Driver
domibus.datasource.user=edelivery_user
```

The password exists in the live file but is intentionally omitted here.

## H2

H2 was not the active datasource. Historical shutdown logs can mention `org.h2.Driver` because the web application includes it.

## Hibernate

Configured dialect:

```text
org.hibernate.dialect.MySQLDialect
```

An explicit-dialect warning was observed and treated as non-fatal.

## Reboot authentication failure

The first Blue cold reboot failed Domibus webapp initialization with:

```text
Public Key Retrieval is not allowed
```

Tomcat remained alive, but Spring could not obtain the DB connection.

The final fix was:

```text
allowPublicKeyRetrieval=true
```

The same change was applied to Red before its cold reboot.

## Security scope

The lab also uses `useSSL=false`. This is an isolated localhost lab choice, not a production recommendation. Production DB connectivity should use an appropriately secured authentication and transport design.

## Screenshot-derived Java/MySQL details

The evidence shows MySQL bound to `127.0.0.1:3306`, which confirms that the database was intentionally local-only rather than exposed on VMnet3. The screenshots also preserve the Connector/J 8.4.0 manifest and the MySQL grants/connection checks.

### Screenshot evidence

![MySQL listener bound to loopback](assets/screenshots/20260915-202536.png)

*MySQL configuration and socket evidence showing the service bound to localhost.*

![edelivery_user grants and DB identity](assets/screenshots/20260915-204438.png)

*Database login and grants verification for `edelivery_user@localhost`.*

![Connector/J 8.4.0 manifest](assets/screenshots/20260915-205718.png)

*JAR manifest evidence for the installed Connector/J release.*

