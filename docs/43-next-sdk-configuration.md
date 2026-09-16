# Next phase: Swedish SDK-specific configuration

The DomiSMP installation phase is complete. The next phase should start from snapshot:

```text
02-domismp-installed
```

## Do not jump directly to creating random SMP objects

The next work should first map Swedish SDK concepts to DomiSMP objects:

1. determine the DomiSMP domain model for the isolated SDK lab;
2. define participant identifier schemes;
3. define the OASIS SMP 1.0 resource/document identifiers required by SDK;
4. decide how the lab will emulate or integrate SML/DNS discovery;
5. create the certificate/trust model for the lab;
6. publish metadata for Blue and Red;
7. prove that discovery can lead to the correct AS4 Access Point endpoint;
8. only then reduce dependence on manually hard-coded peer endpoints.

## Digg values already identified for later use

SDK federation:

```text
urn:fdc:digg.se:edelivery:federation:sdk
```

Digg's SDK environment specifications describe:

```text
SMP: OASIS SMP 1.0
SML: DNS-based discovery
```

The exact environment, participant schemes, document identifiers, certificates and endpoints must be taken from the applicable current Digg technical specification when the lab phase starts.

## Current seeded test objects

Do not silently mistake vendor seed objects for SDK objects:

```text
testdomain
test group
OASIS SMP extension/resource definitions
```

They are useful for learning the DomiSMP UI but should be explicitly reviewed before reuse, modification or deletion.

## Recommended first action after this documentation checkpoint

Perform **read-only inspection** of DomiSMP:

```text
Domains
Extensions
Resource definitions
Groups
```

Capture screenshots and DB state before changing the seed model. This preserves a clear before/after record for the SDK configuration phase.
