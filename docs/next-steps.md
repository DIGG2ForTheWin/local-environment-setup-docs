# Next steps

## Where the lab is now

| Part | State | Latest snapshot |
|---|---|---|
| **Blue & Red** (Domibus 5.2.1.3) | Complete. AS4 proven in both directions, backend retrieval, systemd, cold reboot. | `05-Blue-Reboot-Safe`, `05-Red-Reboot-Safe` |
| **sdk-core** (DomiSMP 5.2.1.3) | Generic DomiSMP installed, systemd-managed and cold-reboot proven. **Not yet configured for Swedish SDK.** | `02-domismp-installed` |

All snapshots: [VMware snapshots](reference/snapshots.md).

Completed and proven so far:

- VMware host-only network and static addressing for all three VMs;
- Ubuntu storage with a separate `/data` disk on every VM;
- Java 21 and local MySQL 8 on every VM;
- Domibus 5.2.1.3 on Blue and Red: DB schema, keystore/truststore, PMode;
- Blue → Red and Red → Blue AS4, with backend retrieval in both directions;
- DomiSMP 5.2.1.3 on sdk-core: `utf8mb3` schema, JNDI datasource, admin password changed;
- systemd services and cold-reboot validation on all three VMs.

---

## Next: Swedish SDK-specific SMP configuration

Start from sdk-core snapshot `02-domismp-installed`.

### Don't jump straight to creating random SMP objects

First map the Swedish SDK concepts to DomiSMP objects:

1. Decide the DomiSMP domain model for the isolated SDK lab.
2. Define the participant identifier schemes.
3. Define the OASIS SMP 1.0 resource/document identifiers that SDK requires.
4. Decide how the lab will emulate or integrate SML/DNS discovery.
5. Create the certificate/trust model for the lab.
6. Publish metadata for Blue and Red.
7. Prove that discovery leads to the correct AS4 Access Point endpoint.
8. Only then reduce dependence on the manually hard-coded peer endpoints in the Blue/Red PModes.

### Digg values already identified

SDK federation:

```text
urn:fdc:digg.se:edelivery:federation:sdk
```

Digg's SDK environment specifications describe:

```text
SMP: OASIS SMP 1.0
SML: DNS-based discovery
```

Take the exact environment, participant schemes, document identifiers, certificates and endpoints from the current Digg technical specification when this phase starts. Links are in [References](reference/references.md#digg-saker-digital-kommunikation).

### Don't mistake the vendor seed objects for SDK objects

DomiSMP still contains its vendor seed data:

```text
testdomain
test group
OASIS SMP extension/resource definitions
```

They are useful for learning the DomiSMP UI but should be explicitly reviewed before reuse, modification or deletion.

### Recommended first action

Do a **read-only inspection** of DomiSMP:

```text
Domains
Extensions
Resource definitions
Groups
```

Capture screenshots and DB state before changing the seed model, so the SDK configuration phase has a clear before/after record. When the phase is done, take the snapshot `03-SDK-Configured` (see [snapshot naming](reference/snapshots.md#naming-convention-for-new-snapshots)).

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
- secret management;
- firewall policy;
- HTTPS/reverse proxy for Domibus and DomiSMP;
- removing the default Tomcat webapps on sdk-core (`manager`, `host-manager`, `docs`, `examples`);
- log retention;
- DB backup/restore;
- payload retention;
- monitoring;
- OS hardening;
- resource tuning;
- HA/cluster design;
- SMP/SML integration where relevant.
