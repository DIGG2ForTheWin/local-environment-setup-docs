# Known-good state

This is the rollback target represented by VMware snapshot:

```text
02-domismp-installed
```

## Host and network

```text
hostname: sdk-core
host-only IP: 192.168.50.30/24
VMnet: VMnet3 / 192.168.50.0/24
```

## Storage

```text
/data -> /dev/sdb1
filesystem: ext4
UUID: f07b76d6-2fee-4add-8902-5503a6d2e603
filesystem size: ~98G
```

## Runtime

```text
DomiSMP 5.2.1.3
Tomcat 10.1.59
Temurin 21.0.12.1+1-LTS
Connector/J 8.4.0
MySQL 8.0.46
```

## Database

```text
schema: smp
charset: utf8mb3
collation: utf8mb3_unicode_ci
tables: 50
user: smp@localhost
plugin: caching_sha2_password
```

Seed objects still present:

```text
system (SYSTEM_ADMIN)
user (USER)
testdomain
test group
edelivery-oasis-smp-extension
```

The `system` bootstrap password has been changed.

## Configuration

```text
JNDI: java:comp/env/jdbc/eDeliverySmpDs
DomiSMP security: /data/domismp/security
DomiSMP logs: /data/domismp/logs
extensions: /data/domismp/ext-lib
locales: /data/domismp/locales
```

## Service state after cold boot

Observed:

```text
mysql: active
domismp: enabled
domismp: active
Java PID: 1335 (on the captured boot)
Java owner: domismp
8080: listening
/smp/: HTTP 200
```

Deployment timings on the captured cold boot:

```text
smp.war deployment: 21,516 ms
Tomcat server startup: 22,667 ms
```

## Warnings accepted in baseline

The baseline still contains a Spring/Commons Logging discovery warning. No functional failure was associated with it, so no vendor library was removed merely to silence it.

## Explicit non-goals at this snapshot

The following are **not** yet configured:

- final SDK SMP domain/participant model;
- SML/DNS integration;
- SDK production/QA certificate model;
- CertPub integration;
- Blue/Red discovery through this SMP;
- final HTTPS/mTLS exposure;
- removal/hardening of default Tomcat webapps.

This boundary is intentional and is why the snapshot is named `02-domismp-installed`; the SDK milestone will be `03-SDK-Configured`. All snapshots: [VMware snapshots](../reference/snapshots.md).
