# Known-good state

## Host

```text
hostname: sdk-core
host-only IP: 192.168.50.30/24
```

## Storage

```text
/data -> /dev/sdb1
ext4
UUID: f07b76d6-2fee-4add-8902-5503a6d2e603
```

## MySQL

```text
active after cold reboot
```

### DomiSMP schema

```text
DB: smp
charset: utf8mb3
collation: utf8mb3_unicode_ci
```

### DomiSML schema

```text
DB: sml_schema
charset: utf8mb3
collation: utf8mb3_bin (vendor DDL writes utf8_bin, the same collation)
tables: 19
seed configuration rows: 32
```

## DomiSMP

```text
version: 5.2.1.3
Tomcat: 10.1.59
Java: Temurin 21
port: 8080
context: /smp/
systemd: enabled + active
HTTP after reboot: 200
```

SDK-specific DomiSMP state:

```text
domain: sdk-lab
visibility: Public
response signing alias: sdk_lab_smp_signing
resource type: OASIS SMP 1.0 / smp-1
member: system -> ADMIN
SML registration: NOT performed
participants: not yet published in this continuation
```

## DomiSML

```text
version: 5.1.0.3
Tomcat: 10.1.59
Java: Temurin 21
port: 8081
context: /edelivery-sml/
systemd: enabled + active
HTTP after reboot: 200
```

Runtime paths:

```text
/opt/domisml
/data/domisml/logs
/data/domisml/security
/data/domisml/domisml-libs
/data/domisml/backups
```

Security folder:

```text
/data/domisml/security
```

Deployment encryption key:

```text
/data/domisml/security/encriptionPrivateKey.private
owner domisml:domisml
```

Log files:

```text
/data/domisml/logs/domisml.log
/data/domisml/logs/domisml-business.log
/data/domisml/logs/domisml-security.log
```

App-scoped JNDI:

```text
/opt/domisml/conf/Catalina/localhost/edelivery-sml.xml
java:comp/env/jdbc/edelivery
```

## PKI

Root CA private key remains outside the runtime tree:

```text
/data/sdk-pki/root/sdk-lab-smp-root-ca.key.pem
```

DomiSMP signing alias:

```text
sdk_lab_smp_signing
```

## Reboot proof

```text
PASS
```

Both applications were proven after a full VM reboot.

## Snapshot boundary

This state is ready for the next sdk-core snapshot. Following the lab's `NN-Title-Case` convention, its name is:

```text
03-DomiSML-Installed
```

As of 2026-09-16 the sdk-core Snapshot Manager still showed only `01-Network-Ready` and `02-domismp-installed`, so this snapshot has **not been taken yet**.
