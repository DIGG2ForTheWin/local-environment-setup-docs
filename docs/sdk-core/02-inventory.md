# Inventory

This page records the observed `sdk-core` VM state before and after the DomiSMP installation.

## Identity and networking

Observed initial inventory:

```text
hostname: sdk-core
Ubuntu: 24.04.5 LTS (Noble)
ens33 NAT: 192.168.140.131/24
ens34 host-only: 192.168.50.30/24
default route: 192.168.140.2 via ens33
SSH: listening on IPv4 and IPv6 port 22
```

The host-only address used by Windows and the other lab VMs is:

```text
192.168.50.30
```

## CPU/RAM/disk model

The VM uses the same general design as the Domibus gateways: an OS disk plus a separate persistent data disk.

Initial OS layout:

```text
/dev/sda                 60G
/dev/sda2                 2G ext4 /boot
/dev/sda3                58G LVM PV
root logical volume      58G ext4 /
root filesystem          ~57G usable
```

The added data disk is:

```text
/dev/sdb                100G
/dev/sdb1               100G ext4
label                    sdk-core-data
UUID                     f07b76d6-2fee-4add-8902-5503a6d2e603
mount                    /data
```

Cold-boot evidence later reported `/dev/sdb1` as approximately 98 GiB filesystem size with ~93 GiB available.

## Java

Observed:

```text
Eclipse Temurin JDK 21
JVM version: 21.0.12.1+1-LTS
JAVA_HOME: /usr/lib/jvm/temurin-21-jdk-amd64
```

Tomcat's final `setenv.sh` makes this Java home explicit.

## MySQL

Observed:

```text
MySQL 8.0.46-0ubuntu0.24.04.4
service: active
bind: localhost only
127.0.0.1:3306
127.0.0.1:33060
```

The localhost-only binding is deliberate for this lab because DomiSMP and MySQL are on the same VM.

## DomiSMP runtime inventory

Final baseline:

| Component | Value |
|---|---|
| DomiSMP | 5.2.1.3 |
| WAR | `/opt/domismp/webapps/smp.war` |
| Tomcat | 10.1.59 |
| Java | Temurin 21.0.12.1 LTS |
| MySQL | 8.0.46 |
| Connector/J | 8.4.0 |
| DB | `smp` |
| DB tables | 50 |
| DB charset | `utf8mb3` |
| DB collation | `utf8mb3_unicode_ci` |
| Linux service user | `domismp` |
| DomiSMP HTTP context | `/smp/` |
| HTTP port | 8080 |
| Persistent root | `/data/domismp` |
| systemd unit | `/etc/systemd/system/domismp.service` |
| Snapshot | `02-domismp-installed` |

## Dedicated service user

Created as a system account:

```text
domismp:x:999:988::/opt/domismp:/usr/sbin/nologin
```

The `nologin` shell is intentional. Interactive administration is done as `xander` with `sudo`; the application runs as `domismp`.
