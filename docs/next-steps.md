# Next steps

## Where the lab is now

| Part | State | Latest snapshot |
|---|---|---|
| **Part 1: Blue & Red** (Domibus 5.2.1.3) | Complete. AS4 proven in both directions, backend retrieval, systemd, cold reboot. | `05-Blue-Reboot-Safe`, `05-Red-Reboot-Safe` |
| **Part 2: sdk-core** (DomiSMP 5.2.1.3) | Generic DomiSMP installed, systemd-managed and cold-reboot proven. | `02-domismp-installed` |
| **Part 3: sdk-core** (SMP signing + DomiSML 5.1.0.3) | Lab signing PKI, DomiSMP domain `sdk-lab`, local DomiSML on :8081, both apps cold-reboot proven. **No SML registration, DNS or participants yet.** | none yet: take `03-DomiSML-Installed` |

All snapshots: [VMware snapshots](reference/snapshots.md).

!!! tip "Do this first"
    Power off `sdk-core` cleanly and take the snapshot **`03-DomiSML-Installed`**, so the next phase starts from a known-good rollback point.

Completed and proven so far:

- VMware host-only network and static addressing for all three VMs;
- Ubuntu storage with a separate `/data` disk on every VM;
- Java 21 and local MySQL 8 on every VM;
- Domibus 5.2.1.3 on Blue and Red: DB schema, keystore/truststore, PMode;
- Blue → Red and Red → Blue AS4, with backend retrieval in both directions;
- DomiSMP 5.2.1.3 on sdk-core: `utf8mb3` schema, JNDI datasource, admin password changed;
- SDK-lab SMP root CA and response-signing certificate `sdk_lab_smp_signing`, imported into DomiSMP;
- DomiSMP domain `sdk-lab` (OASIS SMP 1.0, `system` as ADMIN);
- DomiSML 5.1.0.3 on sdk-core with its own DB, Tomcat, deployment encryption key, logs on `/data` and app-scoped JNDI;
- systemd services and cold-reboot validation on all three VMs.

---

## Next: local DNS + SML integration

The vendor defaults in DomiSMP still point at `localhost:8080`, and the SML integration tab is empty on purpose. Nothing real (Digg OPEN-TEST/QA/production) is touched; the lab builds its own discovery chain.

### What has not happened yet

- no local authoritative DNS server for the SDK-lab discovery zone;
- no DomiSML subdomain for the SDK lab (only the vendor `*.test.edelivery.local` seed subdomains exist);
- no dedicated SML client certificate (it must be a different identity from `sdk_lab_smp_signing`);
- DomiSMP `sdk-lab` not registered with DomiSML;
- no participant published to SML/DNS;
- no Blue/Red endpoint metadata published in DomiSMP;
- no Blue/Red lookup through DNS → SMP;
- no CertPub integration.

### Target chain

```text
0203:blue.sdk-lab.test  /  0203:red.sdk-lab.test     (lab participant IDs)
            |
            v
   local DNS zone  <-- published by -- DomiSML (:8081)
            |
            v
   DomiSMP sdk-lab (:8080)  --> Access Point metadata
            |
            v
   Blue / Red Domibus AS4 endpoints
```

### Suggested order

1. Choose the lab DNS zone and install a local authoritative DNS server that DomiSML can update.
2. Create an SDK-lab subdomain in DomiSML, replacing the vendor seed subdomains for this purpose.
3. Create an SML client certificate from the lab PKI and configure DomiSML to trust it.
4. Fill in DomiSMP `sdk-lab` → *SML integration* (SML domain, SMP identifier, client certificate with the DomiSML URL on port **8081**), then **Register**.
5. Publish service groups/metadata for `0203:blue.sdk-lab.test` and `0203:red.sdk-lab.test` pointing at the Blue/Red MSH endpoints.
6. Prove a lookup: participant ID → DNS → DomiSMP → endpoint.
7. Only then reduce the Blue/Red dependence on hard-coded PMode endpoints.
8. Snapshot: `04-SML-DNS-Discovery-Working`.

### Digg values for later alignment

SDK federation:

```text
urn:fdc:digg.se:edelivery:federation:sdk
```

Digg's SDK environment specifications describe:

```text
SMP: OASIS SMP 1.0
SML: DNS-based discovery
```

Take exact participant schemes, document identifiers, certificates and endpoints from the current Digg specification. Links are in [References](reference/references.md#digg-saker-digital-kommunikation).

---

## Later

### Test client VM

A dedicated Kali or other client VM can later replace some Windows-host/manual `curl` workflows. Document it as its own part once it exists.

### Automation

Only introduce automation after the manual baseline is frozen, for example:

- repeatable health checks;
- message-generation helpers;
- backup scripts;
- observability;
- CI-style integration tests.

The manual baseline and its snapshots remain the recovery reference.

### Production-hardening topics

- TLS-secured DB connectivity (instead of `useSSL=false` + `allowPublicKeyRetrieval=true`);
- one private key per Access Point instead of the shared sample keystore, plus certificate lifecycle management;
- replace remaining DomiSML vendor sample keystore/truststore files with lab/federation material;
- secret management;
- firewall policy;
- HTTPS/reverse proxy for Domibus, DomiSMP and DomiSML;
- removing the default Tomcat webapps on sdk-core (`manager`, `host-manager`, `docs`, `examples`) in both Tomcats;
- log retention;
- DB backup/restore;
- payload retention;
- monitoring;
- OS hardening;
- resource tuning (two JVMs share sdk-core's ~5.7 GiB RAM);
- HA/cluster design.
