# Domibus AS4 Lab

A complete, version-controlled record of a manually built two-gateway Domibus/eDelivery AS4 laboratory running in VMware Workstation.

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

## Documentation map

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

The documentation now includes a reviewed screenshot archive from the actual build. It begins with VMware VMnet3 creation and VM provisioning, continues through Ubuntu/LVM/storage/network/MySQL/Domibus configuration, and ends with PMode/admin-recovery diagnostics. See the full [Screenshot Evidence Gallery](24-screenshot-evidence.md).

Two raw source screenshots contained generated Domibus administrator passwords and were intentionally excluded from the published assets.

![VMware VMnet3 configuration](assets/screenshots/20260915-175419.png)

![Domibus Administration Console](assets/screenshots/20260915-211602.png)

![Lab PMode endpoint verification](assets/screenshots/20260915-213818.png)



---

# sdk-core / DomiSMP extension

On 2026-09-16 the lab was extended with `sdk-core` (`192.168.50.30`) running DomiSMP 5.2.1.3 on Tomcat 10.1.59, Java 21 and MySQL 8. The installation is systemd-managed and cold-reboot proven. The known-good VMware checkpoint is `02-domismp-installed`.

Start with [Swedish SDK and DomiSMP concepts](25-sdk-and-domismp-concepts.md), then follow the build through [the sdk-core timeline](40-sdk-core-timeline.md) and [failures/fixes](34-domismp-failures-and-fixes.md).

![DomiSMP 5.2.1.3 landing page](assets/sdk-core-screenshots/20260916-103339-domismp-landing.png)
