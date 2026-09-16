# Cryptography and PMode

## Keystore and truststore

Domibus uses:

```text
/opt/domibus/conf/domibus/keystores/gateway_keystore.jks
/opt/domibus/conf/domibus/keystores/gateway_truststore.jks
```

## Store format

The stores are JKS. Java warns that JKS is proprietary and suggests PKCS12. For the baseline they were deliberately not converted because the vendor sample already worked with JKS and changing store format during initial bring-up would introduce another variable.

## Private aliases

Blue:

```text
blue_gw
```

Red:

```text
red_gw
```

## Trusted certificates

Observed subjects:

```text
CN=blue_gw,O=edelivery,C=BE
CN=red_gw,O=edelivery,C=BE
```

Observed serials:

```text
blue_gw: 1724922034
red_gw:  1724922226
```

## Security profile

The message leg uses:

```text
rsa
```

Logs showed:

```text
Using security profile [rsa] configured in the PMode leg [pushTestcase1tc1Action]
```

## Blue -> Red cryptography

Blue selected:

```text
encryption certificate: red_gw
signing certificate: blue_gw
```

Live evidence:

```text
During the process of [encrypting], the certificate with the alias [red_gw] will be used
Receiver certificate exists and is valid [red_gw]
During the process of [signing], the certificate with the alias [blue_gw] will be used
Sender certificate exists and is valid [blue_gw]
```

## Red -> Blue cryptography

Red selected:

```text
encryption certificate: blue_gw
signing certificate: red_gw
```

The reverse logs confirmed both certificates were found and valid.

## Service and action

External request values:

```text
Service value: bdx:noprocess
Service type: tc1
Action: TC1Leg1
```

Internal PMode match:

```text
service: testService1
action: tc1Action
leg: pushTestcase1tc1Action
```

## MSH endpoints

Blue:

```text
http://192.168.50.10:8080/domibus/services/msh
```

Red:

```text
http://192.168.50.20:8080/domibus/services/msh
```

## Blue PMode

Working file:

```text
~/dl/pmodes/domibus-gw-lab-blue.xml
```

Local/root party:

```text
blue_gw
```

Remote party:

```text
red_gw
```

The sample security structure was preserved while endpoints/local party values were customized.

Upload evidence:

```text
PModeProvider - Updating the PMode
PMode Configuration successfully updated
```

PMode/cache ID:

```text
887790301781046774
```

DB timestamp:

```text
2026-09-15 20:01:42
```

Created/modified by:

```text
admin
```

## Red PMode

Initial/default PMode ID:

```text
887795942874043123
```

Final custom lab PMode ID:

```text
887797339501778401
```

Upload timestamp:

```text
2026-09-15 20:29:40
```

Created/modified by:

```text
admin
```

## Party ID mapping

SOAP requests continued to use:

```text
domibus-blue
domibus-red
```

while the PMode party names were:

```text
blue_gw
red_gw
```

The live message logs proved that Domibus maps these values successfully.

## Why the EC sample request structure was reused

The vendor SoapUI project was treated as the authoritative request-shape source. Request bodies were extracted from its XML instead of hand-inventing envelopes. This reduced risk around namespaces, PartyInfo, roles, service/action, PayloadInfo, and SOAP action values.

## Screenshot-derived cryptography/PMode evidence

The screenshots show the gateway keystore and truststore being inspected with `keytool`, followed by direct examination of the Blue PMode XML. They also record the exact lab endpoints inserted into the PMode and the XML well-formedness check before upload.

### Screenshot evidence

![Gateway keystore/truststore inspection](assets/screenshots/20260915-213142.png)

*`keytool` output used to verify gateway cryptographic entries and trusted certificates.*

![Blue PMode XML party/service/security structure](assets/screenshots/20260915-213325.png)

*The customized Blue PMode being inspected in the terminal.*

![Blue and Red MSH endpoint verification](assets/screenshots/20260915-213818.png)

*Exact lab endpoint values and the XML well-formedness check before PMode use.*

