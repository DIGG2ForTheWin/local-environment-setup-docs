# Security notes

## Repository secret policy

Never commit:

- MySQL passwords;
- Domibus admin passwords;
- generated temporary passwords;
- keystore/truststore passwords;
- private keys;
- raw sensitive copies of `domibus.properties`;
- terminal captures containing credentials.

## Sensitive properties file

The live file:

```text
/opt/domibus/conf/domibus/domibus.properties
```

contains sensitive values and was protected with mode:

```text
600
```

A raw copy should not be placed in Git.

## Dedicated service account

Domibus runs as:

```text
domibus
```

with shell:

```text
/usr/sbin/nologin
```

rather than root or the normal interactive account.

## Data permissions

Service data was intentionally kept restrictive (`domibus:domibus`, mode 750). Operator convenience was not considered a reason to weaken it.

## Admin credentials

Generated admin passwords were changed immediately after first login. The documentation records the recovery events but not the values.

## Database credentials

DB passwords are intentionally omitted. A password that appeared during setup was rotated.

## Host-only network

The AS4 lab network is:

```text
192.168.50.0/24
```

on VMware host-only VMnet3. It is not an Internet-facing production network.

## JDBC lab exception

Final JDBC parameters include:

```text
useSSL=false
allowPublicKeyRetrieval=true
```

This is a lab-specific choice for a local MySQL connection using `caching_sha2_password`. It should not be copied unchanged into an untrusted production network.

## JKS decision

The vendor JKS stores were retained for baseline compatibility. The Java warning recommending PKCS12 was not treated as a reason to change a working security component during initial bring-up.

## Certificate roles

Blue -> Red:

```text
sign: blue_gw
encrypt to: red_gw
```

Red -> Blue:

```text
sign: red_gw
encrypt to: blue_gw
```

## Sanitized configuration examples

If a template is committed, use placeholders such as:

```properties
domibus.datasource.password=<DB_PASSWORD>
```

Never replace placeholders with live secrets in version control.

## Screenshot-handling policy

The source screenshot archive contains two images that expose generated Domibus administrator passwords in terminal log output. Those two images were deliberately excluded from the GitHub-ready documentation assets. This is an important example of why raw troubleshooting screenshots must be reviewed before publication.

Published screenshots were selected/copy-reviewed for the same repository policy used for text: do not intentionally publish passwords, private keys or other reusable secrets.

### Safe screenshot evidence

![Keystore/truststore metadata inspection](assets/screenshots/20260915-213142.png)

*Certificate metadata is useful evidence; secret key material and passwords are not shown.*

