# Architecture

## Logical flow

```mermaid
flowchart LR
    BlueBackend[Blue backend / curl]
    BlueWS[Blue WS Plugin]
    BlueAP[Blue Domibus]
    RedAP[Red Domibus]
    RedWS[Red WS Plugin]
    RedBackend[Red backend / curl]

    BlueBackend --> BlueWS
    BlueWS --> BlueAP
    BlueAP -->|signed + encrypted AS4 PUSH| RedAP
    RedAP -->|AS4 receipt| BlueAP
    RedAP --> RedWS
    RedWS --> RedBackend
```

The same components were proven in the opposite direction.

## Network

```mermaid
flowchart TB
    Windows[Windows host\n192.168.50.1/24]
    VMnet3[VMnet3\n192.168.50.0/24\nHost-only\nDHCP disabled]
    Blue[Blue\nens34 192.168.50.10]
    Red[Red\nens34 192.168.50.20]

    Windows --- VMnet3
    VMnet3 --- Blue
    VMnet3 --- Red
```

Each VM also has `ens33` attached to VMware NAT for downloads and package installation.

## Interface roles

```text
ens33 = VMware NAT
ens34 = VMnet3 host-only AS4/lab network
```

## Database topology

Each access point has its own MySQL instance and database.

```mermaid
flowchart LR
    Blue[Blue Domibus] --> BlueDB[(Blue MySQL\nlocalhost:3306)]
    Red[Red Domibus] --> RedDB[(Red MySQL\nlocalhost:3306)]
```

No shared database exists between Blue and Red.

## Storage topology

Each gateway has an approximately 60 GB OS disk plus a separate approximately 200 GB data disk.

The data disk is mounted at:

```text
/data
```

Domibus payloads:

```text
/data/domibus/payloads
```

Temporary storage:

```text
/data/domibus/tmp
```

## Runtime stack

```mermaid
flowchart TB
    Systemd[systemd]
    Java[Temurin Java 21 / Tomcat 10.1.54]
    Domibus[Domibus 5.2.1.3 WAR]
    MySQL[MySQL 8.0.46]
    Data["/data/domibus/payloads"]

    Systemd --> Java
    Java --> Domibus
    Domibus --> MySQL
    Domibus --> Data
```

## Health-model lesson

The first Blue reboot proved that all of the following can be true:

```text
systemd active
Java alive
port 8080 listening
MySQL active
/data mounted
```

while Domibus itself is broken. The webapp failed to deploy and returned HTTP 404 because the DB authentication step failed.

Therefore final health means:

```text
process health
+ database health
+ filesystem health
+ application endpoint health
```

## Screenshot-derived architecture evidence

The VMware screenshots confirm that the private AS4 network was implemented as a dedicated custom VMnet rather than as an abstract diagram only. The VM creation screenshots also show the use of SCSI virtual disks and a 60 GB OS disk, while later terminal screenshots show the independent 200 GB data disk used for `/data`.

### Screenshot evidence

![VMware Virtual Network Editor showing VMnet3](../assets/screenshots/20260915-175419.png)

*VMware Virtual Network Editor with the custom VMnet3 `192.168.50.0/24` network.*

![VM virtual disk controller selection](../assets/screenshots/20260915-182513.png)

*VM creation using the recommended LSI Logic SCSI controller.*

![60 GB virtual OS disk configuration](../assets/screenshots/20260915-182543.png)

*The VM wizard configuring a 60 GB virtual disk as a single file.*

