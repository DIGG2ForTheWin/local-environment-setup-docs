# Security

## Never included

This part intentionally excludes:

- the DomiSMP administrator password;
- the DomiSMP database password;
- the DomiSML database password;
- the PKCS#12 export password;
- vendor password/ciphertext values from DomiSML seed SQL;
- any secret content from DomiSML truststore-password backups;
- any private key bytes.

## Exposed DB password incident

A DomiSML DB password was typed into the chat during setup. It was treated as compromised and **has been changed** (confirmed 2026-09-16). The documentation does not repeat either value.

## Safe documentation patterns

Examples use:

```text
<REDACTED_DB_PASSWORD>
<PRIVATE_PASSWORD>
<REDACTED>
```

Queries that inspect secret-bearing rows return only states such as:

```text
<NULL>
<EMPTY>
<SET length=N>
<BCRYPT HASH>
```

## Private keys

This ZIP documents private-key **paths and properties**, not key material.

The lab root private key remains on the VM at:

```text
/data/sdk-pki/root/sdk-lab-smp-root-ca.key.pem
```

It is not copied into this repository.

## Screenshots

The included screenshots were reviewed for this documentation phase. Obvious unrelated screenshots were excluded. No screenshot containing the exposed DomiSML DB password was included. Before publishing, all 64 screenshots were reviewed again image by image on 2026-09-16: no passwords, hashes or private keys are visible (password queries print only `<NULL>`/`<SET length=N>`/`<BCRYPT HASH>`, and the context XML prints the username as `<configured>`). The only full PEM certificates shown are DomiSMP's public vendor sample certificates. The browser tab bar was cropped from seven browser screenshots because it showed an unrelated document title.
