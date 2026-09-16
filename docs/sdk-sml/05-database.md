# Database

## Capacity check before installation

`sdk-core` was checked before adding another Tomcat:

```text
RAM total:        ~5.7 GiB
RAM available:    ~3.9 GiB
Swap:             4.0 GiB, unused
Root:             57G total, 47G available
/data:            98G total, 93G available
8080:             occupied by DomiSMP Java
8081/8082/8443:   not actively listening
MySQL:            active
```

This supported a second Tomcat with a smaller heap.

## Downloaded artifacts

| File | Download |
|---|---|
| `bdmsl-webapp-5.1.0.3.war` | [download](https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/europa/ec/bdmsl/bdmsl-webapp/5.1.0.3/bdmsl-webapp-5.1.0.3.war) |
| `bdmsl-webapp-5.1.0.3-setup.zip` | [download](https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/europa/ec/bdmsl/bdmsl-webapp/5.1.0.3/bdmsl-webapp-5.1.0.3-setup.zip) |


DomiSML release used:

```text
5.1.0.3
```

Files:

```text
bdmsl-webapp-5.1.0.3.war
bdmsl-webapp-5.1.0.3-setup.zip
```

The WAR was approximately 84 MB and the setup ZIP approximately 83 KB.

## Integrity check

Published MD5 values were checked successfully:

```text
WAR       a4a3c145e67405c6c2dbf7ae110ccd5c
setup ZIP 970a17bc8a709515499230659858c9a4
```

Both returned `OK`.

## WAR manifest

Observed:

```text
Manifest-Version: 1.0
Created-By: Maven WAR Plugin 3.5.1
Java-Version: 17
Build-Jdk-Spec: 21
WebLogic-Application-Version: v5.1.0.3
```

## Setup bundle contents

Important files included:

```text
database-scripts/mysql.ddl
database-scripts/mysql-data.sql
database-scripts/mysql-drop.ddl
database-scripts/migration/...
SML-soapui-project-Examples.xml
encriptionPrivateKey.private
keystore.jks
keystore.p12
truststore.p12
sml.config.properties
sml-logback.xml
```

The SoapUI project was treated as reference material only; SoapUI was not adopted as the lab runtime tool.

## `sml.config.properties` baseline

The vendor file included:

```properties
sml.hibernate.dialect=org.hibernate.dialect.MySQLDialect
sml.datasource.jndi=java:comp/env/jdbc/edelivery
sml.jsp.servlet.class=org.apache.jasper.servlet.JspServlet
sml.log.folder=./logs/
sml.libraries.folder=./domisml-libs/
sml.ws.servicemetadataservices.schema-validation-enabled=true
sml.ws.participantservices.schema-validation-enabled=true
sml.ws.bdmslservices.schema-validation-enabled=true
sml.ws.bdmsladminservices.schema-validation-enabled=true
```

## Seed configuration inspection

The MySQL seed contained many operational properties including:

```text
dnsClient.server                 127.0.0.1
dnsClient.publisherPrefix        publisher
dnsClient.enabled                true
dnsClient.show.entries           true
dnsClient.SIG0Enabled            false
configurationDir                 /opt/smlconf/
authorization.smp.certSubjectRegex
authentication.bluecoat.enabled  true
```

It also contained password/hash/ciphertext fields. Their values are intentionally omitted from this package.

## Seeded SML subdomains

The vendor seed created:

```text
1  peppol.test.edelivery.local   test.edelivery.local  all  all
2  ehealth.test.edelivery.local  test.edelivery.local  all  all
3  isaitb.test.edelivery.local   test.edelivery.local  all  all
```

These are vendor examples, not the future SDK-lab DNS zone.

## Schema inspection and charset decision

The DomiSML DDL explicitly declared `CHARACTER SET utf8 COLLATE utf8_bin` on its tables/columns.

Examples included large columns such as:

```text
varchar(512)
varchar(1024)
varchar(4000)
```

and unique/index constraints on participant, certificate and SMP identifiers.

Because the earlier DomiSMP build had already exposed the risk of using `utf8mb4` with vendor DDL that assumes three-byte UTF-8, DomiSML was created directly as:

```text
utf8mb3 / utf8mb3_bin
```

(`utf8_bin` in the vendor DDL is MySQL 8's alias for `utf8mb3_bin`.)

## Database creation

Final schema/account:

```text
schema: sml_schema
user:   sml_dbuser@localhost
plugin: caching_sha2_password
```

The real password is not documented.

DDL import completed without error.

Validated table count:

```text
19
```

After importing `mysql-data.sql`:

```text
configuration rows: 32
seeded subdomains: 3
```

The actual application DB user was tested with `mysql -u sml_dbuser -p -D sml_schema` and could query the schema.

## Exposed password incident

During interactive creation, a DB password was entered in the chat transcript, so it had to be treated as compromised. **The password was changed** (confirmed 2026-09-16). This documentation stores neither the exposed password nor the new one.
