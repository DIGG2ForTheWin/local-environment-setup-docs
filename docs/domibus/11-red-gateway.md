# Red gateway

## Identity

```text
Hostname: red
VMnet3: 192.168.50.20/24
Role: second Domibus Access Point
```

Red was created by **cloning the Blue VM** after Blue's Ubuntu base setup (about 19:29 CEST). It was then made a distinct machine: new hostname, machine-id and SSH host keys, its own static `ens34` address and its own data disk. Windows OpenSSH therefore warned that the host key had changed.

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

JKS format retained. The keystore file is the same vendor sample as on Blue and also contains `blue_gw`; Red's identity is selected by the alias setting. See [Cryptography and PMode](09-crypto-pmode.md#private-aliases).

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

## Messaging results (summary)

| Test | Red's role | Result |
|---|---|---|
| Blue -> Red | receiver | `RECEIVED`; receipt generated with non-repudiation; WS Plugin notified |
| Backend on Red | `listPendingMessages` + `retrieveMessage` | original `<hello>world</hello>` payload recovered |
| Red -> Blue | sender | `ACKNOWLEDGED`; encrypted for `blue_gw`, signed with `red_gw` |

Message IDs, entity IDs and full log evidence: [AS4 validation](12-as4-validation.md) and [Raw observed values](20-raw-values.md#red-blue-message).

## systemd and reboot (summary)

1. First systemd start: healthy (Main PID 4736, root HTTP 302).
2. **Preventive JDBC fix:** Blue's reboot failure showed a shared weakness, so before rebooting Red the account was confirmed as `caching_sha2_password` and `allowPublicKeyRetrieval=true` was added. A targeted edit matched only the active `domibus.datasource.url` line (count 1).
3. Warm restart and cold reboot passed; Red also reached Blue's MSH with HTTP 200 after reboot.

Full sequence, PIDs and deployment timings: [systemd and reboot validation](14-systemd-reboot.md#red-proactive-jdbc-fix).

## Screenshot evidence from the Red preparation

The archive captures the point where the second VM was made distinct from the first: guest machine identity/SSH host keys were regenerated, Windows detected the host-key change, Red's static host-only network was configured, the separate 200 GB data disk was initialized and mounted, and the same local-MySQL/schema baseline was established.

![Machine identity/SSH host-key regeneration work](../assets/screenshots/20260915-192932.png)

![Windows warning after SSH host identity changed](../assets/screenshots/20260915-193156.png)

![Red static networking](../assets/screenshots/20260915-193448.png)

![Red data disk and persistent filesystem setup](../assets/screenshots/20260915-201346.png)

