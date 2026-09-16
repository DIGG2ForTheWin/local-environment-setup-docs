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

The DomiSMP build is documented in [SDK and DomiSMP concepts](docs/25-sdk-and-domismp-concepts.md) through [Next SDK configuration](docs/43-next-sdk-configuration.md).

## Documentation map

- [Concepts](docs/01-concepts.md)
- [Architecture](docs/02-architecture.md)
- [Inventory and versions](docs/03-inventory.md)
- [VMware and networking](docs/04-vmware-network.md)
- [Ubuntu and storage](docs/05-ubuntu-storage.md)
- [Java and MySQL](docs/06-java-mysql.md)
- [Domibus installation](docs/07-domibus-installation.md)
- [Database setup](docs/08-database.md)
- [Cryptography and PMode](docs/09-crypto-and-pmode.md)
- [Blue gateway](docs/10-blue-gateway.md)
- [Red gateway](docs/11-red-gateway.md)
- [AS4 validation](docs/12-as4-validation.md)
- [systemd and reboot validation](docs/13-systemd-and-reboot.md)
- [Failures and fixes](docs/14-failures-and-fixes.md)
- [Security](docs/15-security.md)
- [Operations runbook](docs/16-operations-runbook.md)
- [Known-good evidence](docs/17-evidence-and-known-good-state.md)
- [Glossary](docs/18-glossary.md)
- [Next steps](docs/19-next-steps.md)
- [Chronological timeline](docs/20-chronological-timeline.md)
- [Command reference](docs/21-command-reference.md)
- [Raw observed values](docs/22-raw-observed-values.md)
- [SOAP extraction and test commands](docs/23-soap-extraction-and-test-commands.md)
- [Screenshot Evidence](docs/24-screenshot-evidence.md)
- [SDK and DomiSMP concepts](docs/25-sdk-and-domismp-concepts.md)
- [sdk-core inventory](docs/26-sdk-core-inventory.md)
- [sdk-core storage](docs/27-sdk-core-storage.md)
- [DomiSMP distribution inspection](docs/28-domismp-distribution-inspection.md)
- [DomiSMP database](docs/29-domismp-database.md)
- [Tomcat and runtime](docs/30-domismp-tomcat-runtime.md)
- [JNDI and DomiSMP configuration](docs/31-domismp-configuration.md)
- [First startup and UI](docs/32-domismp-first-start-ui.md)
- [systemd and cold reboot](docs/33-domismp-systemd-reboot.md)
- [DomiSMP failures and fixes](docs/34-domismp-failures-and-fixes.md)
- [sdk-core security](docs/35-sdk-core-security.md)
- [sdk-core operations runbook](docs/36-sdk-core-operations-runbook.md)
- [sdk-core known-good state](docs/37-sdk-core-known-good-state.md)
- [sdk-core command reference](docs/38-sdk-core-command-reference.md)
- [sdk-core raw observed values](docs/39-sdk-core-raw-observed-values.md)
- [sdk-core chronological timeline](docs/40-sdk-core-timeline.md)
- [sdk-core screenshot evidence](docs/41-sdk-core-screenshot-evidence.md)
- [Snapshot baseline](docs/42-sdk-core-snapshot-baseline.md)
- [Next SDK configuration](docs/43-next-sdk-configuration.md)
- [References](docs/44-references.md)

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

Temporary or exposed credentials were changed or rotated where appropriate.

## Historical-accuracy policy

This repository separates:

- **observed facts** from the live lab;
- **exact commands** retained from the setup conversation;
- **reconstructed procedures** where the final state is known but the literal earliest command transcript was not retained.

The earliest Ubuntu/LVM command transcript is incomplete in the retained project context. Those gaps are explicitly marked rather than silently invented.

## Visual evidence archive

The documentation now includes a reviewed screenshot archive from the actual build. It begins with VMware VMnet3 creation and VM provisioning, continues through Ubuntu/LVM/storage/network/MySQL/Domibus configuration, and ends with PMode/admin-recovery diagnostics. See the full [Screenshot Evidence Gallery](docs/24-screenshot-evidence.md).

Two raw source screenshots contained generated Domibus administrator passwords and were intentionally excluded from the published assets.

![VMware VMnet3 configuration](docs/assets/screenshots/20260915-175419.png)

![Domibus Administration Console](docs/assets/screenshots/20260915-211602.png)

![Lab PMode endpoint verification](docs/assets/screenshots/20260915-213818.png)

