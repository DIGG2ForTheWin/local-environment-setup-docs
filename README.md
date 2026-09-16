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

New to the lab? Follow **[Build it step by step](docs/build-guide.md)**. It walks through the whole build in order, with exact download links, and links into the detailed chapters below.

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

The DomiSMP build is documented in **Part 2 — sdk-core** ([Concepts](docs/sdk-core/01-concepts.md) to [Screenshots](docs/sdk-core/17-screenshots.md)). **Part 3 — SMP signing & DomiSML** ([Concepts](docs/sdk-sml/01-concepts.md) to [Screenshots](docs/sdk-sml/17-screenshots.md)) adds a lab signing PKI, the DomiSMP `sdk-lab` domain and a local DomiSML on port 8081. What comes next is in [Next steps](docs/next-steps.md). All VMware snapshots are listed in [VMware snapshots](docs/reference/snapshots.md).

## Documentation map

**Start here**

- [Build it step by step](docs/build-guide.md)
- [Next steps](docs/next-steps.md)

**Part 1 — Blue & Red (Domibus)**

- [Concepts](docs/domibus/01-concepts.md)
- [Architecture](docs/domibus/02-architecture.md)
- [Inventory](docs/domibus/03-inventory.md)
- [VMware & network](docs/domibus/04-vmware-network.md)
- [Storage](docs/domibus/05-storage.md)
- [Java & MySQL](docs/domibus/06-java-mysql.md)
- [Installation](docs/domibus/07-installation.md)
- [Database](docs/domibus/08-database.md)
- [Crypto & PMode](docs/domibus/09-crypto-pmode.md)
- [Blue gateway](docs/domibus/10-blue-gateway.md)
- [Red gateway](docs/domibus/11-red-gateway.md)
- [AS4 validation](docs/domibus/12-as4-validation.md)
- [SOAP test commands](docs/domibus/13-soap-test-commands.md)
- [systemd & reboot](docs/domibus/14-systemd-reboot.md)
- [Failures & fixes](docs/domibus/15-failures-and-fixes.md)
- [Security](docs/domibus/16-security.md)
- [Runbook](docs/domibus/17-runbook.md)
- [Known-good state](docs/domibus/18-known-good-state.md)
- [Commands](docs/domibus/19-commands.md)
- [Raw values](docs/domibus/20-raw-values.md)
- [Timeline](docs/domibus/21-timeline.md)
- [Screenshots](docs/domibus/22-screenshots.md)

**Part 2 — sdk-core (DomiSMP)**

- [Concepts](docs/sdk-core/01-concepts.md)
- [Inventory](docs/sdk-core/02-inventory.md)
- [Storage](docs/sdk-core/03-storage.md)
- [Distribution](docs/sdk-core/04-distribution.md)
- [Database](docs/sdk-core/05-database.md)
- [Tomcat runtime](docs/sdk-core/06-tomcat-runtime.md)
- [Configuration](docs/sdk-core/07-configuration.md)
- [First start & UI](docs/sdk-core/08-first-start-ui.md)
- [systemd & reboot](docs/sdk-core/09-systemd-reboot.md)
- [Failures & fixes](docs/sdk-core/10-failures-and-fixes.md)
- [Security](docs/sdk-core/11-security.md)
- [Runbook](docs/sdk-core/12-runbook.md)
- [Known-good state](docs/sdk-core/13-known-good-state.md)
- [Commands](docs/sdk-core/14-commands.md)
- [Raw values](docs/sdk-core/15-raw-values.md)
- [Timeline](docs/sdk-core/16-timeline.md)
- [Screenshots](docs/sdk-core/17-screenshots.md)

**Part 3 — sdk-core (SMP signing & DomiSML)**

- [Concepts](docs/sdk-sml/01-concepts.md)
- [PKI](docs/sdk-sml/02-pki.md)
- [SMP keystore](docs/sdk-sml/03-smp-keystore.md)
- [sdk-lab domain](docs/sdk-sml/04-sdk-lab-domain.md)
- [Database](docs/sdk-sml/05-database.md)
- [Tomcat runtime](docs/sdk-sml/06-tomcat-runtime.md)
- [Security path & keys](docs/sdk-sml/07-security-path-and-keys.md)
- [Logging](docs/sdk-sml/08-logging.md)
- [JNDI](docs/sdk-sml/09-jndi.md)
- [systemd & reboot](docs/sdk-sml/10-systemd-reboot.md)
- [Failures & fixes](docs/sdk-sml/11-failures-and-fixes.md)
- [Security](docs/sdk-sml/12-security.md)
- [Runbook](docs/sdk-sml/13-runbook.md)
- [Known-good state](docs/sdk-sml/14-known-good-state.md)
- [Commands](docs/sdk-sml/15-commands.md)
- [Timeline](docs/sdk-sml/16-timeline.md)
- [Screenshots](docs/sdk-sml/17-screenshots.md)

**Reference**

- [VMware snapshots](docs/reference/snapshots.md)
- [Glossary](docs/reference/glossary.md)
- [References](docs/reference/references.md)

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

Where an exact command was not retained, the documentation marks the step as reconstructed rather than silently inventing it. The root-LVM expansion commands, once thought lost, were recovered from screenshot `20260915-185903` and are now documented in [Ubuntu and storage](docs/domibus/05-storage.md).

## Visual evidence archive

The documentation now includes a reviewed screenshot archive from the actual build. It begins with VMware VMnet3 creation and VM provisioning, continues through Ubuntu/LVM/storage/network/MySQL/Domibus configuration, and ends with PMode/admin-recovery diagnostics. See the full [Screenshot Evidence Gallery](docs/domibus/22-screenshots.md).

Two raw source screenshots contained generated Domibus administrator passwords and were intentionally excluded from the published assets. Two further published screenshots were redacted on 2026-09-16 (see *Secret policy*).

![VMware VMnet3 configuration](docs/assets/screenshots/20260915-175419.png)

![Domibus Administration Console](docs/assets/screenshots/20260915-211602.png)

![Lab PMode endpoint verification](docs/assets/screenshots/20260915-213818.png)

