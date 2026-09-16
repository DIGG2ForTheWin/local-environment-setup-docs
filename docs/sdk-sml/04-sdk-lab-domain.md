# sdk-lab domain

## Inventory before changes

Before changing DomiSMP, a read-only inventory was taken.

### Domains

Observed:

```text
1  testdomain  PUBLIC  test-domain  DOMI-SMP-001  smp_domain_01  0x01  0x01
```

### Groups

Observed:

```text
1  test group  PUBLIC  1  testdomain
```

### Extensions

Observed:

```text
1  edelivery-oasis-smp-extension    oasisSMPExtension   Oasis SMP 1.0 and 2.0   1.0
2  edelivery-oasis-cppa3-extension  oasisCPPA3Extension Oasis CPPA 3.0          1.0
```

The runtime contained CPPA3 extension metadata even though the original seed inspection had focused on the OASIS extension.

### Resource definitions

Observed:

```text
1  smp-1       edelivery-oasis-smp-1.0-servicegroup  Oasis SMP 1.0 ServiceGroup  text/xml  ext 1
2  bdxr-smp-2  edelivery-oasis-smp-2.0-servicegroup  Oasis SMP 2.0 ServiceGroup  text/xml  ext 1
3  cpp         CPPA3 CPP document                    CPPA3 CPP                   text/xml  ext 2
```

### Subresource definitions

Observed:

```text
1  services  edelivery-oasis-smp-1.0-servicemetadata  OASIS SMP 1.0 ServiceMetadata
2  services  OASIS SMP 2.0 ServiceMetadata
```

### Existing resource mapping

The original vendor domain `testdomain` was mapped to:

```text
OASIS SMP 1.0 / smp-1
```

### Existing participants/resources

Count at this point:

```text
0
```

That was important: SDK-specific participant publication had not yet started.

![Read-only DomiSMP inventory: domains, groups, extensions, resource definitions and 0 participants.](../assets/smp-sml-screenshots/20260916-110826.png)

*Read-only DomiSMP inventory: domains, groups, extensions, resource definitions and 0 participants.*


## Domain creation

A new DomiSMP domain was created with:

```text
Domain Code: sdk-lab
Response signature Certificate: sdk_lab_smp_signing
Visibility: Public
```

The vendor test aliases were deliberately not used.


![DomiSMP System Domain administration before creating sdk-lab (only testdomain exists).](../assets/smp-sml-screenshots/20260916-112416.png)

*DomiSMP System Domain administration before creating sdk-lab (only testdomain exists).*

## DomiSMP completion warning

Immediately after creation, the UI displayed:

```text
To complete domain configuration, please:
- select at least one resource type from the Resource Types tab
- add a domain member with 'ADMIN' role from the Members tab
```

This was expected: the domain existed, but DomiSMP did not yet consider it complete.

![sdk-lab created with response-signing alias sdk_lab_smp_signing; completion warning shown.](../assets/smp-sml-screenshots/20260916-114615.png)

*sdk-lab created with response-signing alias sdk_lab_smp_signing; completion warning shown.*


## Resource type

Only this resource type was selected:

```text
edelivery-oasis-smp-1.0-servicegroup (smp-1)
```

These were left unchecked:

```text
edelivery-oasis-smp-2.0-servicegroup (bdxr-smp-2)
edelivery-oasis-cppa-3.0-cpp (cpp)
```

## Domain administrator

The existing DomiSMP administrator account was added as:

```text
username: system
role: ADMIN
```

After this, `sdk-lab` had the required resource type and administrator.

![Members tab: system is ADMIN of sdk-lab.](../assets/smp-sml-screenshots/20260916-114807.png)

*Members tab: system is ADMIN of sdk-lab.*


## Resulting logical structure

```text
DomiSMP
|
+-- testdomain        (vendor reference; untouched)
|
+-- sdk-lab           (our isolated SDK lab domain)
    |
    +-- OASIS SMP 1.0 ServiceGroup (smp-1)
    +-- system -> ADMIN
    +-- response signing alias -> sdk_lab_smp_signing
```

## Important terminology

The `sdk-lab` domain code is a DomiSMP API/domain selector. It is not:

- `0203:...` participant identity;
- a Swedish SDK federation identifier;
- an SML domain name;
- an SMP identifier in SML.

## Domain configuration and SML integration tab

### Configuration tab

The `sdk-lab` Configuration tab exposed 14 domain properties. Among the observed identifier settings were:

```text
identifiersBehaviour.ParticipantIdentifierScheme.validationRegex
identifiersBehaviour.ParticipantIdentifierScheme.validationRegexMessage
identifiersBehaviour.scheme.mandatory = true
identifiersBehaviour.template.match.regexp
identifiersBehaviour.template.split.regexp
identifiersBehaviour.template.concatenate
identifiersBehaviour.template.concatenate.null-scheme
identifiersBehaviour.caseSensitive.ParticipantIdentifierSchemes
identifiersBehaviour.caseSensitive.DocumentIdentifierSchemes
```

These were inspected but not changed during this phase.

### Generic BDMSL/SML defaults

The same configuration page showed generic defaults such as:

```text
smp.automation.authentication.types = BASIC_TOKEN|CERTIFICATE
bdmsl.integration.url = http://localhost:8080/edelivery-sml
bdmsl.integration.logical.address = http://localhost:8080/smp/
bdmsl.integration.physical.address = 0.0.0.0
bdmsl.integration.naptr_service.map = edelivery-oasis-cppa-3.0-cpp:meta:cppa3
```

These values were **not** considered final lab configuration.

In particular, DomiSML would later run on port `8081`, not `8080`.

### SML integration tab

The page exposed:

```text
SML domain
SML SMP identifier
Append domain code to SMP URL     enabled
SML Client Certificate Alias
Use ClientCert HTTP header authentication   disabled
Register
Unregister
Prepare...
Change
```

At this stage:

```text
SML domain                 empty
SML SMP identifier         empty
SML client certificate     empty
registration               not performed
```

The certificate dropdown included:

```text
sdk_lab_smp_signing
issuer
sample_key
```

but no selection was made.


![SML integration tab left empty: no SML domain, SMP identifier or client certificate.](../assets/smp-sml-screenshots/20260916-115348.png)

*SML integration tab left empty: no SML domain, SMP identifier or client certificate.*

![The SML client certificate dropdown also lists the signing alias; the roles are kept separate.](../assets/smp-sml-screenshots/20260916-115400.png)

*The SML client certificate dropdown also lists the signing alias; the roles are kept separate.*

### Safety decision

No Register action was performed. No real Digg SML endpoint was configured. The lab would first build a local SML/DNS environment.
