# Blue gateway build

## Identity

```text
Hostname: blue
VMnet3: 192.168.50.10/24
Role: first Domibus Access Point
```

## Resources

```text
8 GB RAM
4 processors
60 GB OS disk
200 GB data disk
```

## Network

```text
ens33 = NAT
ens34 = 192.168.50.10/24
```

## Storage

Data partition:

```text
/dev/sdb1
ext4
label domibus-data
```

UUID:

```text
beb019ea-7a39-4095-8755-07b76de94779
```

Mount:

```text
/data
```

Directories:

```text
/data/domibus/payloads
/data/domibus/tmp
/data/stage
/data/baseline
/data/garage
/data/fs_plugin_data
```

## Java

```text
Eclipse Temurin JDK 21
JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
```

## MySQL

```text
DB: domibus_schema
user: edelivery_user@localhost
schema version: 5.2.1
tables: 119
```

## Domibus

Installed under:

```text
/opt/domibus
```

Dedicated user:

```text
domibus
```

Connector/J:

```text
/opt/domibus/lib/mysql-connector-j-8.4.0.jar
```

## Blue properties

```text
server: localhost
port: 3306
schema: domibus_schema
driver: com.mysql.cj.jdbc.Driver
user: edelivery_user
alias: blue_gw
payload: /data/domibus/payloads
temp: /data/domibus/tmp
```

Final JDBC URL:

```text
jdbc:mysql://${domibus.database.serverName}:${domibus.database.port}/${domibus.database.schema}?useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
```

## First-start problems

An early Blue start produced a FreeMarker/working-directory warning. Restarting from `/opt/domibus` fixed it.

A stale JVM was also encountered during early startup troubleshooting. Later validation used the actual PID file and port owner rather than trusting the first `pgrep` result.

## Admin recovery

Blue's admin account required recovery through the database.

Backup:

```text
~/dl/backups/blue-before-admin-reset.sql
```

Approximate size:

```text
214 KB
```

Domibus recreated the admin user and logged a temporary generated password. The value is intentionally omitted and was changed immediately.

## PMode

File:

```text
~/dl/pmodes/domibus-gw-lab-blue.xml
```

Endpoints:

```text
Blue: http://192.168.50.10:8080/domibus/services/msh
Red:  http://192.168.50.20:8080/domibus/services/msh
```

PMode ID:

```text
887790301781046774
```

## Accidental Red commands on Blue

A Red preparation block was accidentally executed on Blue. It recopied Connector/J, recursively set `/opt/domibus` ownership, recreated/chowned/chmodded data directories, and performed a write test. These actions were effectively idempotent in the existing Blue state.

A full audit confirmed:

```text
hostname blue
ens34 192.168.50.10
Java correct
/data mounted
private alias blue_gw
DB 5.2.1
119 tables
PMode retained
```

No meaningful damage was found.

## Blue -> Red proven send

Message ID:

```text
331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
```

Blue entity:

```text
887799183390676475
```

Final status:

```text
ACKNOWLEDGED
```

Blue logs proved:

```text
PMode match
payload profile valid
property profile valid
PAYLOAD_SUBMITTED
PAYLOAD_PROCESSED
59-byte payload saved
payload compressed
SEND_ENQUEUED
red_gw used for encryption
blue_gw used for signing
receiver certificate valid
sender certificate valid
reliability check successful
SEND_ENQUEUED -> ACKNOWLEDGED
MESSAGE_SEND_SUCCESS
receipt received SUCCESS
message sent SUCCESS PUSH
```

## Red -> Blue proven receive

Message ID:

```text
f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu
```

Blue receiver entity:

```text
887802330217584117
```

Status:

```text
RECEIVED
```

Blue generated a successful receipt, persisted the payload, notified the WS Plugin, and logged `Message received [SUCCESS] [PUSH] from [domibus-red] to [domibus-blue]`.

## Blue backend retrieval

Blue listed the reverse message through `listPendingMessages`, then retrieved it through `retrieveMessage`.

Decoded payload:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```

## First systemd start

Observed:

```text
Main PID 4158
process java
owner domibus:domibus
port 8080 owned by PID 4158
Root HTTP 302
```

## First cold reboot failure

After reboot:

```text
systemd active
Java PID 1179 alive
MySQL active
/data mounted
ens34 192.168.50.10/24
8080 listening
Red MSH reachable with 200
```

but:

```text
Root 404
MSH 404
WS Plugin 404
```

Logs showed:

```text
Public Key Retrieval is not allowed
Context [/domibus] startup failed due to previous errors
```

## JDBC correction

Added:

```text
allowPublicKeyRetrieval=true
```

The first broad `sed` also changed a commented replica example. That was cleaned up so the active setting count was exactly 1.

## Warm restart after fix

```text
systemd active
Java PID 1868 alive
Root 302
MSH 200
WS Plugin 200
```

Fresh deployment:

```text
55,882 ms
```

## Final cold reboot

```text
systemd enabled
systemd active
Java PID 1215
owner domibus:domibus
MySQL active
/data mounted
8080 listening
Root 302
MSH 200
WS Plugin 200
```

Fresh deployment:

```text
70,531 ms
```

Current boot check found no Domibus DB/deployment failure.

## Screenshot evidence from the Blue build

The screenshot archive gives a nearly continuous visual history of Blue: initial hostname/interface/disk audit, LVM expansion, software/service verification, data-disk creation, MySQL schema import, Domibus archive inspection, properties customization, first startup, Admin Console reachability, process/port checks, certificate inspection, PMode preparation and the later admin-account database recovery.

![Initial Blue host/network/storage audit](assets/screenshots/20260915-185605.png)

![Blue root-volume expansion](assets/screenshots/20260915-185903.png)

![Blue database validation](assets/screenshots/20260915-204817.png)

![Blue Domibus first browser login page](assets/screenshots/20260915-211602.png)

![Blue keystore/truststore verification](assets/screenshots/20260915-213142.png)

![Blue lab PMode endpoint validation](assets/screenshots/20260915-213818.png)

