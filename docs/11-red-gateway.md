# Red gateway build

## Identity

```text
Hostname: red
VMnet3: 192.168.50.20/24
Role: second Domibus Access Point
```

Observed NAT address:

```text
192.168.140.130/24
```

## Resources

```text
8 GB RAM
4 processors
60 GB OS disk
200 GB data disk
```

## Storage

```text
/dev/sdb1
ext4
label domibus-data
```

UUID:

```text
559ba590-135c-4742-b1ce-583ab200b086
```

Mount:

```text
/data
```

## Java

```text
Temurin 21.0.12.1
```

## MySQL

```text
MySQL 8.0.46 Ubuntu
DB domibus_schema
schema version 5.2.1
119 tables
```

## Distribution transfer

The full Domibus distribution, sample/testing ZIP and Connector/J were copied from Blue to Red.

## Domibus user

Observed:

```text
domibus:x:999:988::/opt/domibus:/usr/sbin/nologin
```

Group:

```text
domibus:x:988
```

## Installation

Full distribution extracted under:

```text
/opt/domibus
```

Connector copied to:

```text
/opt/domibus/lib/mysql-connector-j-8.4.0.jar
```

Ownership set to:

```text
domibus:domibus
```

Observed file sizes:

```text
WAR ~129 MB
Connector ~2.5 MB
properties ~92 KB
keystore ~4.1 KB
```

## Data permissions

Directories under `/data/domibus` are owned by `domibus:domibus` with mode 750. `xander` could not freely list children, which was intentional. A write test as `domibus` passed.

## Red properties

```text
alias red_gw
DB localhost:3306
schema domibus_schema
driver com.mysql.cj.jdbc.Driver
user edelivery_user
payload /data/domibus/payloads
temp /data/domibus/tmp
```

H2 inactive.

Final JDBC URL contains `allowPublicKeyRetrieval=true`.

## Keystore

Private key alias:

```text
red_gw
```

JKS format retained.

## First manual start

Approximate successful start time:

```text
2026-09-15 20:24
```

Observed PID:

```text
2082
```

Port 8080 listening; root HTTP 302.

A generic error grep matched only the legitimate Quartz job name `errorLogCleanerJob`.

## Admin

The Red temporary admin password was obtained privately and changed immediately. It is not stored here.

## PMode

Initial/default ID:

```text
887795942874043123
```

Final custom PMode ID:

```text
887797339501778401
```

Upload timestamp:

```text
2026-09-15 20:29:40
```

Created/modified by `admin`.

## Blue -> Red proven receive

Message:

```text
331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
```

Red entity:

```text
887799205223657931
```

Status:

```text
RECEIVED
```

Red logs proved:

```text
rsa incoming security profile
blue_gw/red_gw certificates located
PMode exchange matched
receipt generated SUCCESS
nonRepudiation=true
PUSH processing
payload/profile validation
filesystem persistence
59-byte payload received
MESSAGE_RECEIVED
WS Plugin notified
message persisted in DB
message received SUCCESS PUSH
MESSAGE_RESPONSE_SENT
```

## Backend retrieval

Red listed the message as pending and retrieved the original `<hello>world</hello>` payload successfully.

## Red -> Blue proven send

Message:

```text
f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu
```

Red entity:

```text
887802313651713634
```

Final status:

```text
ACKNOWLEDGED
```

Logs proved:

```text
red_gw sender matched
blue_gw receiver matched
service/action/leg matched
payload validated
SEND_ENQUEUED
blue_gw used for encryption
red_gw used for signing
certificates valid
reliability check successful
SEND_ENQUEUED -> ACKNOWLEDGED
MESSAGE_SEND_SUCCESS
receipt SUCCESS
message sent SUCCESS PUSH
```

## systemd first start

```text
Main PID 4736
owner domibus:domibus
8080 owned by Java PID 4736
Root 302
```

## JDBC preventative fix

Blue's reboot failure revealed a shared configuration weakness. Before rebooting Red, the DB user was confirmed as `caching_sha2_password` and the active datasource URL was updated to include `allowPublicKeyRetrieval=true`.

The targeted Red edit matched only the active `domibus.datasource.url` line. Active-setting count was 1.

## Warm restart

```text
systemd active
Java PID 6941
Root 302
MSH 200
WS Plugin 200
```

Deployment:

```text
48,581 ms
```

## Final cold reboot

```text
systemd enabled
systemd active
Java PID 1361
owner domibus:domibus
MySQL active
/data mounted
8080 listening
Root 302
MSH 200
WS Plugin 200
Blue MSH 200
```

Deployment:

```text
71,512 ms
```

No current-boot DB/deployment failure was found.

## Screenshot evidence from the Red preparation

The archive captures the point where the second VM was made distinct from the first: guest machine identity/SSH host keys were regenerated, Windows detected the host-key change, Red's static host-only network was configured, the separate 200 GB data disk was initialized and mounted, and the same local-MySQL/schema baseline was established.

![Machine identity/SSH host-key regeneration work](assets/screenshots/20260915-192932.png)

![Windows warning after SSH host identity changed](assets/screenshots/20260915-193156.png)

![Red static networking](assets/screenshots/20260915-193448.png)

![Red data disk and persistent filesystem setup](assets/screenshots/20260915-201346.png)

