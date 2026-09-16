# PKI

## Why a new PKI was created

DomiSMP already contained vendor test aliases such as `issuer` and `sample_key`. These were not appropriate for our lab identity. A separate lab root and leaf signing certificate were therefore generated outside the DomiSMP runtime tree.

The final PKI root directory is:

```text
/data/sdk-pki
```

owned by:

```text
xander:xander
```

with mode `700`.

Subdirectories:

```text
/data/sdk-pki/root
/data/sdk-pki/smp-signing
```

both mode `700`.

## Why `/data/sdk-pki` is outside `/data/domismp`

An initial attempt placed PKI files below `/data/domismp/pki`. The parent `/data/domismp` was intentionally `domismp:domismp` mode `750`, so the interactive `xander` user could not traverse it. A stray key generated from the wrong working directory was deleted.

The PKI was moved to a separate operator-controlled tree to keep the root private key out of the application runtime hierarchy.

## Root CA

Files:

```text
/data/sdk-pki/root/sdk-lab-smp-root-ca.key.pem
/data/sdk-pki/root/sdk-lab-smp-root-ca.crt.pem
```

Private-key properties:

```text
RSA 4096
mode 600
```

Subject and issuer:

```text
C=SE, O=SDK Lab, OU=eDelivery, CN=SDK Lab SMP Root CA
```

Serial:

```text
03572F68D6E0338BF05A7AD0F11E5B461A65AAD0
```

Validity:

```text
2026-09-16 09:33:51 GMT
through
2036-09-13 09:33:51 GMT
```

SHA-256 fingerprint:

```text
FE:E1:66:53:81:A2:FA:0F:5F:02:69:38:60:E2:49:1E:FF:FA:82:FF:DF:D3:66:04:57:DE:BA:87:47:40:2F:26
```

Extensions:

```text
Basic Constraints (critical): CA:TRUE, pathlen:1
Key Usage (critical): Certificate Sign, CRL Sign
SKI: 18:3A:F9:6C:CA:34:50:09:BF:A4:1C:FB:46:0F:29:2C:39:7A:6E:D9
```

### Root certificate correction

The first root certificate was issued without an explicit Key Usage extension. Rather than accept that, the certificate was reissued with the same private key and the proper CA extensions.

The old certificate was preserved as:

```text
/data/sdk-pki/root/sdk-lab-smp-root-ca.crt.pem.before-ext-fix
```

This is an example of correcting certificate semantics without regenerating the root key unnecessarily.

## SMP signing leaf

Files:

```text
/data/sdk-pki/smp-signing/sdk-lab-smp-signing.key.pem
/data/sdk-pki/smp-signing/sdk-lab-smp-signing.csr.pem
/data/sdk-pki/smp-signing/sdk-lab-smp-signing.ext
/data/sdk-pki/smp-signing/sdk-lab-smp-signing.crt.pem
```

Private key:

```text
RSA 3072
mode 600
```

Subject:

```text
C=SE, O=SDK Lab, OU=eDelivery, CN=sdk-core SMP Signing
```

Issuer:

```text
C=SE, O=SDK Lab, OU=eDelivery, CN=SDK Lab SMP Root CA
```

Serial:

```text
64B9F463D430DE4C1DAEDDB25B511A3083CDB447
```

Validity:

```text
2026-09-16 09:34:26 GMT
through
2028-12-19 09:34:26 GMT
```

SHA-256 fingerprint:

```text
96:3B:D5:2B:A6:D2:8C:14:69:93:20:30:D4:7B:DC:95:D0:26:EE:0A:29:CC:9F:DB:B6:C8:80:34:37:E4:DF:ED
```

Extensions:

```text
Basic Constraints: CA:FALSE
Key Usage (critical): Digital Signature
SKI: 0D:5D:A6:D1:CC:D7:95:89:08:9A:D6:39:76:7E:B0:B2:4D:05:4D:9C
AKI: matches the root SKI
```

Verification:

```text
openssl verify -CAfile <root-cert> <leaf-cert>
=> OK
```

## PKCS#12 import bundle

Created:

```text
/data/sdk-pki/smp-signing/sdk-lab-smp-signing.p12
```

Mode:

```text
600
```

Alias:

```text
sdk_lab_smp_signing
```

`keytool` verification proved:

```text
PrivateKeyEntry
certificate chain length 2
leaf -> SDK Lab SMP Root CA
```

The PKCS#12 export password is intentionally not documented.

A copy was moved to Windows for browser-based DomiSMP import:

```text
E:\VMs\Domibus-Lab\Installers\sdk-lab-smp-signing.p12
```

Only the `.p12` bundle was copied. The root private key remained on `sdk-core`.
