# Domibus + Swedish SDK Lab

A complete, version-controlled record of a manually built VMware Workstation laboratory containing two Domibus/eDelivery AS4 gateways plus an `sdk-core` DomiSMP node that forms the starting point for a Swedish Säker digital kommunikation (SDK) federation lab.

This repository explains the environment from first principles and preserves the final configuration, validation evidence, failures, fixes, operating procedures, and known-good state. It is written so that a reader who does not yet know what Domibus, AS4, PMode, an MSH, or the WS Plugin are can follow the lab from the bottom up.

The completed baseline contains two Domibus Access Points:

- **Blue** — `192.168.50.10`
- **Red** — `192.168.50.20`

Both run Domibus 5.2.1.3 on bundled Tomcat 10.1.54 with Eclipse Temurin JDK 21, local MySQL 8.0.46, dedicated `/data` payload storage, a host-only AS4 network, JKS keystores, custom PMode configuration, and systemd service management.

The baseline is proven to:

- start Domibus manually;
- start Domibus through systemd;
- survive complete VM reboots;
- mount `/data` automatically;
- connect to local MySQL after reboot;
- exchange signed and encrypted AS4 PUSH messages in both directions;
- generate and process non-repudiation receipts;
- reach `ACKNOWLEDGED` on the sender;
- reach `RECEIVED` on the receiver;
- expose received messages to the WS Plugin;
- list messages through `listPendingMessages`;
- retrieve the original business payload through `retrieveMessage`.

The validated business payload was:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```


## Start here

New to the lab? Follow **[Build it step by step](00-build-guide.md)**. It walks through the whole build in order, with exact download links, and links into the detailed chapters below.

Published site: <https://digg2forthewin.github.io/local-environment-setup-docs/>

## SDK-core / DomiSMP extension

The laboratory was extended on 2026-09-16 with a third VM:

- **sdk-core** — `192.168.50.30`
- **DomiSMP** — 5.2.1.3
- **Apache Tomcat** — 10.1.59
- **Eclipse Temurin JDK** — 21.0.12.1 LTS
- **MySQL** — 8.0.46
- **MySQL Connector/J** — 8.4.0
- **Database** — `smp`, 50 tables, `utf8mb3_unicode_ci`
- **Persistent storage** — `/dev/sdb1` mounted at `/data`
- **Service account** — `domismp`
- **systemd** — enabled, active and cold-boot proven
- **DomiSMP UI** — reachable from Windows at `http://192.168.50.30:8080/smp/`
- **Snapshot checkpoint** — `02-domismp-installed`

The generic DomiSMP baseline is complete, but it is **not yet claimed to be SDK-conformant**. SDK-specific domain, participant, SML/DNS, certificate and service-metadata configuration begins after the documented snapshot.

The DomiSMP build is documented in [SDK and DomiSMP concepts](25-sdk-and-domismp-concepts.md) through [Next SDK configuration](43-next-sdk-configuration.md).

## Documentation map

- [Build it step by step](00-build-guide.md)
- [Concepts](01-concepts.md)
- [Architecture](02-architecture.md)
- [Inventory and versions](03-inventory.md)
- [VMware and networking](04-vmware-network.md)
- [Ubuntu and storage](05-ubuntu-storage.md)
- [Java and MySQL](06-java-mysql.md)
- [Domibus installation](07-domibus-installation.md)
- [Database setup](08-database.md)
- [Cryptography and PMode](09-crypto-and-pmode.md)
- [Blue gateway](10-blue-gateway.md)
- [Red gateway](11-red-gateway.md)
- [AS4 validation](12-as4-validation.md)
- [systemd and reboot validation](13-systemd-and-reboot.md)
- [Failures and fixes](14-failures-and-fixes.md)
- [Security](15-security.md)
- [Operations runbook](16-operations-runbook.md)
- [Known-good evidence](17-evidence-and-known-good-state.md)
- [Glossary](18-glossary.md)
- [Next steps](19-next-steps.md)
- [Chronological timeline](20-chronological-timeline.md)
- [Command reference](21-command-reference.md)
- [Raw observed values](22-raw-observed-values.md)
- [SOAP extraction and test commands](23-soap-extraction-and-test-commands.md)
- [Screenshot Evidence](24-screenshot-evidence.md)
- [SDK and DomiSMP concepts](25-sdk-and-domismp-concepts.md)
- [sdk-core inventory](26-sdk-core-inventory.md)
- [sdk-core storage](27-sdk-core-storage.md)
- [DomiSMP distribution inspection](28-domismp-distribution-inspection.md)
- [DomiSMP database](29-domismp-database.md)
- [Tomcat and runtime](30-domismp-tomcat-runtime.md)
- [JNDI and DomiSMP configuration](31-domismp-configuration.md)
- [First startup and UI](32-domismp-first-start-ui.md)
- [systemd and cold reboot](33-domismp-systemd-reboot.md)
- [DomiSMP failures and fixes](34-domismp-failures-and-fixes.md)
- [sdk-core security](35-sdk-core-security.md)
- [sdk-core operations runbook](36-sdk-core-operations-runbook.md)
- [sdk-core known-good state](37-sdk-core-known-good-state.md)
- [sdk-core command reference](38-sdk-core-command-reference.md)
- [sdk-core raw observed values](39-sdk-core-raw-observed-values.md)
- [sdk-core chronological timeline](40-sdk-core-timeline.md)
- [sdk-core screenshot evidence](41-sdk-core-screenshot-evidence.md)
- [Snapshot baseline](42-sdk-core-snapshot-baseline.md)
- [Next SDK configuration](43-next-sdk-configuration.md)
- [References](44-references.md)

## Documentation philosophy

The lab was intentionally built manually rather than hidden behind an installation script. That means this repository preserves not only the final happy path but also the reasoning and failures that produced it.

Important examples include:

- MySQL `ERROR 1419` during schema import;
- a stale Java process and JMX port conflict;
- accidental Red-preparation commands executed on Blue;
- Blue admin account recovery through the database;
- SoapUI-property placeholder mismatch during message retrieval;
- shell-prompt and command-paste mistakes;
- a reboot where systemd and Java were healthy but Domibus returned HTTP 404;
- the root cause `Public Key Retrieval is not allowed`;
- the final JDBC `allowPublicKeyRetrieval=true` correction;
- an over-broad `sed` edit that also touched a commented replica URL;
- a `/proc/<pid>/environ` redirection permission mistake.

## Secret policy

No real passwords are intentionally stored here. The repository records credential-related events but replaces values with placeholders such as:

```text
<DB_PASSWORD>
<ADMIN_PASSWORD>
<KEYSTORE_PASSWORD>
```

Generated temporary admin passwords were changed immediately after first use.

On 2026-09-16 a review of the published screenshots found two images that still showed sensitive values: the Blue `domibus.properties` datasource password (`20260915-210800.png`) and the Blue admin bcrypt hash (`20260915-214922.png`). Both images were redacted and the Git history was rewritten so the originals are no longer in the repository.

## Historical-accuracy policy

This repository separates:

- **observed facts** from the live lab;
- **exact commands** retained from the setup conversation;
- **reconstructed procedures** where the final state is known but the literal earliest command transcript was not retained.

Where an exact command was not retained, the documentation marks the step as reconstructed rather than silently inventing it. The root-LVM expansion commands, once thought lost, were recovered from screenshot `20260915-185903` and are now documented in [Ubuntu and storage](05-ubuntu-storage.md).

## Visual evidence archive

The documentation now includes a reviewed screenshot archive from the actual build. It begins with VMware VMnet3 creation and VM provisioning, continues through Ubuntu/LVM/storage/network/MySQL/Domibus configuration, and ends with PMode/admin-recovery diagnostics. See the full [Screenshot Evidence Gallery](24-screenshot-evidence.md).

Two raw source screenshots contained generated Domibus administrator passwords and were intentionally excluded from the published assets. Two further published screenshots were redacted on 2026-09-16 (see *Secret policy*).

![VMware VMnet3 configuration](assets/screenshots/20260915-175419.png)

![Domibus Administration Console](assets/screenshots/20260915-211602.png)

![Lab PMode endpoint verification](assets/screenshots/20260915-213818.png)

