# Concepts

This part continues on `sdk-core` (192.168.50.30) from snapshot `02-domismp-installed`, where Part 2 ended: DomiSMP 5.2.1.3 installed, systemd-managed and cold-boot proven, but with no SDK-specific configuration. The state at that point is in [sdk-core known-good state](../sdk-core/13-known-good-state.md).

Part 3 adds:

- a lab PKI and signing certificate for DomiSMP responses;
- the DomiSMP domain `sdk-lab`;
- a local **DomiSML** (the eDelivery SML implementation) on port 8081, next to DomiSMP;
- systemd management and a cold reboot with both applications running.

It stops before DNS, SML registration and participant publication; see [Next steps](../next-steps.md).

## Words used in this part

| Term | Plain meaning |
|---|---|
| **SMP** (DomiSMP) | The "phone book entry": metadata saying which Access Point a participant uses. |
| **SML** (DomiSML) | The "phone book index": registers which SMP holds a participant, and publishes that in DNS. |
| **Response signing certificate** | The key DomiSMP uses to sign the metadata it returns, so senders can trust it. |
| **SML client certificate** | A *different* role: the key DomiSMP uses to authenticate to the SML when registering. |
| **Domain (DomiSMP)** | A technical grouping inside DomiSMP (`sdk-lab`), not a DNS domain or participant ID. |

## SDK discovery model being reproduced

The lab is modelling the discovery chain conceptually as:

```text
Participant Identifier
        |
        v
      DNS / SML
        |
        v
       SMP
        |
        v
Access Point metadata
        |
        v
AS4 Access Point
```

The current Blue/Red Domibus pair already proved AS4 transport directly. This continuation adds the service-metadata/discovery side without pretending that the lab is enrolled in the real Swedish federation.

## Isolation decision

The DomiSMP `SML integration` tab exposed registration controls and certificate selection. We deliberately did **not** point those fields at Digg OPEN-TEST, QA, or production infrastructure.

Instead, the decision was:

```text
Build a local DomiSML + local DNS layer on sdk-core
```

and only later return to the DomiSMP SML-integration tab.

## Component layout reached by the end

```text
sdk-core 192.168.50.30
|
+-- MySQL 8.0.46
|   +-- smp        (DomiSMP)
|   +-- sml_schema (DomiSML)
|
+-- DomiSMP 5.2.1.3
|   +-- /opt/domismp
|   +-- Tomcat 10.1.59
|   +-- :8080/smp/
|   +-- /data/domismp/...
|
+-- DomiSML 5.1.0.3
    +-- /opt/domisml
    +-- separate Tomcat 10.1.59
    +-- :8081/edelivery-sml/
    +-- /data/domisml/...
```

## Separation decisions

DomiSML was intentionally given:

- its own Linux service account `domisml`;
- its own Tomcat base `/opt/domisml`;
- its own shutdown port `8006`;
- its own HTTP port `8081`;
- its own MySQL schema `sml_schema`;
- its own MySQL account `sml_dbuser@localhost`;
- its own `/data/domisml` storage tree;
- its own systemd unit;
- a smaller heap (`512m` initial, `1024m` max) because DomiSMP is on the same VM.

## Identifier model decisions

The lab naming proposed for future participants is:

```text
Blue: 0203:blue.sdk-lab.test
Red:  0203:red.sdk-lab.test
```

These are lab-only identifiers. They are not Digg-issued production identities.

The DomiSMP domain code chosen was:

```text
sdk-lab
```

This is a **DomiSMP technical domain code**, not a participant identifier and not a federation ID.

## SMP standard selection

Only the DomiSMP resource type:

```text
edelivery-oasis-smp-1.0-servicegroup (smp-1)
```

was selected for `sdk-lab`.

OASIS SMP 2.0 and CPPA3 were intentionally left unselected for this SDK-lab domain at this stage.
