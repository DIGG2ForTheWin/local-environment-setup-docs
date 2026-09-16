# Next steps

## Current baseline is complete

Completed and proven:

- VMware host-only network;
- static Blue/Red addressing;
- Ubuntu storage;
- Java;
- MySQL;
- Domibus 5.2.1.3;
- DB schema;
- keystore/truststore use;
- PMode;
- Blue -> Red AS4;
- Red -> Blue AS4;
- backend retrieval both directions;
- systemd;
- cold reboot validation.

## Snapshot names proposed during the project

```text
03-Blue-PMode-Ready
03-Red-PMode-Ready
04-Blue-AS4-Working
04-Red-AS4-Working
05-Blue-Reboot-Safe
05-Red-Reboot-Safe
```

These names were recommended. This documentation does not falsely claim every suggested snapshot was taken if the conversation never explicitly confirmed it.

## sdk-core

Next phase is the third Ubuntu VM `sdk-core`.

Planned work:

- audit hostname/network/storage;
- verify Java;
- verify MySQL;
- identify existing SMP artifacts;
- install/configure SMP if required;
- document the SMP role from first principles;
- integrate it into the eDelivery lab.

## Kali/test client

A dedicated Kali or other client VM can later replace some Windows-host/manual curl workflows. That phase should be documented separately once it exists.

## Automation

Only after the manual baseline is frozen should automation be introduced, for example:

- repeatable health checks;
- message-generation helpers;
- backup scripts;
- observability;
- CI-style integration tests.

The manual baseline should remain the recovery reference.

## Production-hardening topics for later

- TLS-secured DB connectivity;
- certificate lifecycle management;
- secret management;
- firewall policy;
- HTTPS/reverse proxy;
- log retention;
- DB backup/restore;
- payload retention;
- monitoring;
- OS hardening;
- resource tuning;
- HA/cluster design;
- SMP/SML integration where relevant.

## Screenshot boundary of the completed evidence set

The supplied screenshot archive covers the build through the Blue PMode/admin-recovery phase. It does not yet contain the later sdk-core/SMP work. That makes this archive a useful visual freeze of the Blue/Red foundation before the next subsystem is introduced.

![Blue PMode endpoint validation near the end of the screenshot archive](assets/screenshots/20260915-213818.png)



## Update: sdk-core baseline completed

The next-step item to introduce an SMP/discovery component has now begun. `sdk-core` runs DomiSMP 5.2.1.3 and is preserved at VMware snapshot `02-domismp-installed`. The Swedish SDK-specific configuration itself remains the next phase; see [Next SDK configuration](43-next-sdk-configuration.md).
