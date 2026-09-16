# Concepts

## What SDK means in this lab

In this project, **SDK means Säker digital kommunikation**, the Swedish secure digital communication ecosystem coordinated by Digg. It does **not** mean “software development kit”.

The already completed Blue and Red VMs prove the AS4/eDelivery transport layer. They can exchange signed and encrypted AS4 PUSH messages in both directions. The `sdk-core` VM introduces the discovery/metadata side of the architecture.

## Why DomiSMP is present

DomiSMP is the European Commission reference Service Metadata Publisher implementation. An SMP publishes service metadata describing how a participant can be reached. In an eDelivery four-corner model, a sending Access Point can use discovery metadata instead of relying only on a manually hard-coded peer endpoint.

Digg's current SDK environment material describes SMP as a shared eDelivery component containing metadata about a participant organisation, used to address messages to the receiving Access Point. Digg states that SDK uses **OASIS SMP 1.0** in its environments, together with an SML/DNS discovery layer.

## What this phase did — and did not do

This phase intentionally stopped at a **generic, known-good DomiSMP baseline**. It established:

- a dedicated `sdk-core` VM;
- persistent storage under `/data`;
- DomiSMP 5.2.1.3;
- Tomcat 10.1.59;
- Java 21;
- local MySQL 8;
- an initialized DomiSMP schema;
- JNDI database connectivity;
- the DomiSMP web UI;
- administrator access with the vendor bootstrap password changed;
- systemd management;
- a successful cold reboot;
- VMware snapshot `02-domismp-installed`.

It **did not yet** create the final Swedish SDK domain/participant model, integrate an SML/DNS zone, install the final SDK certificates, or publish Blue/Red SDK service metadata. Therefore the correct description is:

```text
DomiSMP/eDelivery discovery foundation: proven
Swedish SDK-specific SMP configuration: not started yet
```

## Lab topology at this checkpoint

```text
Windows host
  VMnet3: 192.168.50.1/24

             host-only VMnet3 192.168.50.0/24

  Blue Domibus             Red Domibus              sdk-core
  192.168.50.10            192.168.50.20            192.168.50.30
  AS4 Access Point         AS4 Access Point         DomiSMP 5.2.1.3
  MySQL local              MySQL local              MySQL local
  /data payloads           /data payloads           /data DomiSMP state
```

Blue and Red still use their already validated custom PMode endpoints. DomiSMP has not yet replaced those manual routing assumptions.

## Official terminology to keep straight

- **AP / Access Point** — sends/receives AS4 messages. Blue and Red fill this role in the current lab.
- **SMP / Service Metadata Publisher** — publishes participant/service metadata. `sdk-core` now hosts DomiSMP.
- **SML / Service Metadata Locator** — enables dynamic location of the participant's SMP through DNS-based discovery.
- **SDK Address Book** — an SDK service for organisations/functional addresses; it is not the SMP itself.
- **CertPub** — certificate publication service used in SDK architecture; not configured in this phase.

## Federation identifier for later work

Digg publishes the SDK federation identifier:

```text
urn:fdc:digg.se:edelivery:federation:sdk
```

This value is recorded here for later SDK-specific configuration. It was **not applied to the generic DomiSMP baseline**.
