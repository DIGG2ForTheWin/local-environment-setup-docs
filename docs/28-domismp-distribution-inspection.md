# DomiSMP distribution inspection

The installation was intentionally not treated as “copy WAR and hope”. The downloaded artifacts were inspected before touching MySQL or Tomcat.

## Selected release

The EC current-release page identified DomiSMP **5.2.1.3** as the current security patch released 2026-08-19. The lab already had the two required artifacts on Windows:

```text
smp-5.2.1.3.war
smp-5.2.1.3-setup.zip
```

They were copied to:

```text
/home/xander/dl/domismp/
```

## WAR manifest

Observed:

```text
Manifest-Version: 1.0
Created-By: Maven WAR Plugin 3.5.1
Java-Version: 17
Build-Jdk-Spec: 21
WebLogic-Application-Version: v5.2.1.3
```

The runtime used Java 21.

## Setup bundle contents

The setup archive contained 47 entries including:

```text
database-scripts/
  mysql.ddl
  mysql-data.sql
  mysql-drop.ddl
  oracle.ddl
  oracle-data.sql
  oracle-drop.ddl
  migration from 3.0.x to 4.0.0/
  migration from 4.0.x to 4.1.0/
  migration from 4.1.0 to 4.1.1/
  migration from 4.1.1 to 4.2/
  migration from 4.2 to 5.0/
  migration from 5.0 to 5.1/
  migration from 5.1 to 5.2/

smp.config.properties
smp-logback.xml
SMP-samples-soapui-project.xml
LICENCE-EUPL-v1.2.pdf
readme.txt
```

Because this was a **fresh install**, only `mysql.ddl` and `mysql-data.sql` were appropriate. No migration script was used.

## Vendor README findings

The supplied README stated that the setup ZIP contains:

- DB initialization and migration scripts to run before deployment;
- `smp.config.properties`, which must be available on the classpath;
- sample security material;
- a SoapUI sample project.

SoapUI was not installed as part of the lab tooling.

## Sample configuration findings

The sample properties selected the MySQL Hibernate dialect and recommended a JNDI datasource on Tomcat:

```properties
smp.jdbc.hibernate.dialect=org.hibernate.dialect.MySQLDialect
smp.datasource.jndi=java:comp/env/jdbc/eDeliverySmpDs
```

It also showed a direct JDBC alternative. The lab deliberately chose JNDI so the DB password did not need to be stored in `smp.config.properties`.

## Fresh seed data

`mysql-data.sql` creates:

- `system` user with `SYSTEM_ADMIN` role;
- `user` user with `USER` role;
- `testdomain`;
- `test group`;
- OASIS SMP extension metadata;
- resource/subresource definitions for OASIS SMP 1.0.

The two seeded UI credentials use the same bcrypt hash. The default administrator bootstrap password was used once later and immediately changed.

## Generator-comment anomaly

The first line of `mysql.ddl` said:

```text
This is [CREATE] database script for DomiSML version: [5.2.1.3].
```

The package, table names, WAR manifest and setup bundle were unquestionably DomiSMP. This was treated as a generated comment typo, not as evidence of the wrong artifact.
