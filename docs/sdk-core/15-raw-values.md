# Raw values

This page collects values directly observed during the build, separated from recommendations or future design.

## VM and network

```text
hostname                       sdk-core
Ubuntu                         24.04.5 LTS
kernel on final boot           6.8.0-139-generic
ens34                          192.168.50.30/24
initial ens33 NAT              192.168.140.131/24
initial NAT gateway            192.168.140.2
```

## Data disk

```text
disk                           /dev/sdb 100G
partition                      /dev/sdb1
filesystem                     ext4
label                          sdk-core-data
UUID                           f07b76d6-2fee-4add-8902-5503a6d2e603
mount                          /data
reported filesystem size       98G
reported available             93G
```

## Runtime versions

```text
DomiSMP                        5.2.1.3
DomiSMP build time             2026-08-19 14:05:49Z
Tomcat                         10.1.59
Tomcat build                   Aug 13 2026 16:59:10 UTC
Java                           21.0.12.1+1-LTS
Java vendor                    Eclipse Adoptium
Connector/J                    8.4.0
MySQL                          8.0.46-0ubuntu0.24.04.4
```

## DomiSMP service account

```text
domismp:x:999:988::/opt/domismp:/usr/sbin/nologin
```

## Database

```text
schema                         smp
charset                        utf8mb3
collation                      utf8mb3_unicode_ci
table count                    50
DB auth plugin                 caching_sha2_password
```

## Seeded domain

```text
ID                             1
DOMAIN_CODE                    testdomain
VISIBILITY                     PUBLIC
SML_SUBDOMAIN                  test-domain
SML_SMP_ID                     DOMI-SMP-001
SML_REGISTERED                 true/0x01
```

## Seeded extension

```text
IDENTIFIER                     edelivery-oasis-smp-extension
IMPLEMENTATION_NAME            OasisSMPExtension
NAME                           Oasis SMP 1.0 and 2.0
VERSION                        1.0
```

## HTTP and deployment

First successful controlled start:

```text
WAR deployment                 23,983 ms
Tomcat startup                 25,116 ms
GET /smp/                      200
HEAD /smp/                     401
```

Clean restart after Logback fix:

```text
WAR deployment                 15,736 ms
Tomcat startup                 16,752 ms
GET /smp/                      200
```

Cold boot:

```text
service start                  2026-09-16 08:50:21 UTC
captured Java PID              1335
WAR deployment                 21,516 ms
Tomcat startup                 22,667 ms
GET /smp/                      200
```

## Selected DomiSMP defaults observed in logs

```text
smp.instance.name                              Test DomiSMP Instance
smp.keystore.filename                          smp-keystore.p12
smp.keystore.type                              PKCS12
smp.truststore.filename                        smp-truststore.p12
smp.truststore.type                            PKCS12
smp.ui.authentication.types                    PASSWORD
smp.user.login.maximum.attempt                 5
smp.user.login.suspension.time                 3600
smp.passwordPolicy.validDays                   90
smp.passwordPolicy.warning.beforeExpiration    15
smp.cluster.enabled                            false
smp.vault.enabled                              false
```

These are observed application defaults, not final SDK policy decisions.
