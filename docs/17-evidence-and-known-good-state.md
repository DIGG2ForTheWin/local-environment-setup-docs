# Known-good state and evidence

## Blue

```text
Hostname: blue
Internal IP: 192.168.50.10/24
Domibus: 5.2.1.3
Tomcat: 10.1.54
Java: Temurin 21
MySQL: 8.0.46 Ubuntu
DB: domibus_schema
Schema: 5.2.1
Tables: 119
PMode ID: 887790301781046774
Active private alias: blue_gw (sample keystore also holds red_gw)
Payload: /data/domibus/payloads
systemd: enabled
Cold reboot: PASS
```

Final cold-boot evidence:

```text
Java PID 1215
Root 302
MSH 200
WS Plugin 200
WAR deployment 70,531 ms
```

## Red

```text
Hostname: red
Internal IP: 192.168.50.20/24
Domibus: 5.2.1.3
Tomcat: 10.1.54
Java: Temurin 21
MySQL: 8.0.46 Ubuntu
DB: domibus_schema
Schema: 5.2.1
Tables: 119
PMode ID: 887797339501778401
Active private alias: red_gw (sample keystore also holds blue_gw)
Payload: /data/domibus/payloads
systemd: enabled
Cold reboot: PASS
```

Final cold-boot evidence:

```text
Java PID 1361
Root 302
MSH 200
WS Plugin 200
Blue MSH 200
WAR deployment 71,512 ms
```

## Blue -> Red message

```text
MessageId: 331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
Blue entity: 887799183390676475
Red entity: 887799205223657931
ConversationId: 332db852-b145-11f1-98c5-000c29b65d5b@domibus.eu
Sender final state: ACKNOWLEDGED
Receiver state: RECEIVED
Backend retrieval: PASS
```

## Red -> Blue message

```text
MessageId: f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu
Red entity: 887802313651713634
Blue entity: 887802330217584117
ConversationId: f021f3a1-b146-11f1-a7a7-000c298c283d@domibus.eu
Sender final state: ACKNOWLEDGED
Receiver state: RECEIVED
Backend retrieval: PASS
```

## Payload

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```

Base64:

```text
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGhlbGxvPndvcmxkPC9oZWxsbz4=
```

Payload filenames observed:

```text
Blue -> Red receive:
062db1df-aa6f-49a9-9623-edeb3f4b24a5.payload

Red -> Blue receive:
0cd9843c-2d64-4b9f-aa6d-ae5c8e3e7f03.payload
```

## PMode evidence

Blue:

```text
ID 887790301781046774
2026-09-15 20:01:42
created/modified admin
```

Red:

```text
ID 887797339501778401
2026-09-15 20:29:40
created/modified admin
```

## Crypto evidence

Blue -> Red:

```text
encrypt red_gw
sign blue_gw
receipt SUCCESS
nonRepudiation true
```

Red -> Blue:

```text
encrypt blue_gw
sign red_gw
receipt SUCCESS
nonRepudiation true
```

## Baseline conclusion

Proven layers:

```text
VMware
Ubuntu
network
persistent storage
Java
MySQL
Domibus
PMode
certificate selection
signing
encryption
AS4 PUSH
receipt handling
message status
backend pending queue
backend retrieval
systemd
cold reboot
```

## Screenshot evidence incorporated into the known-good baseline

The archive directly supports the infrastructure and application prerequisites in this chapter: VMnet3 topology, static guest addressing, persistent data storage, MySQL schema state, Connector/J version, Domibus web reachability, keystore/truststore presence and PMode endpoint configuration. The later bidirectional message IDs and cold-reboot results remain transcript-derived evidence because those events occurred after this screenshot bundle ended.

![VMnet3 topology evidence](assets/screenshots/20260915-175419.png)

![Database/schema evidence](assets/screenshots/20260915-204817.png)

![Domibus web application evidence](assets/screenshots/20260915-211602.png)

![PMode endpoint evidence](assets/screenshots/20260915-213818.png)

