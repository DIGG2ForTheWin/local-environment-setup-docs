# Security

## Secrets are intentionally excluded

This repository does not contain:

- the live `smp@localhost` MySQL password;
- the changed DomiSMP administrator password;
- secret-bearing `/opt/domismp/conf/context.xml`;
- future production certificates/private keys.

Sanitized configuration examples use:

```text
<SMP_DB_PASSWORD>
<ADMIN_PASSWORD>
```

## Credential events

Two credential events are retained as history without preserving private values:

1. A literal instruction placeholder was briefly used as the DB password and was immediately rotated.
2. The vendor bootstrap administrator password was used once and immediately changed.

## File permissions

Security-sensitive runtime files/directories use restrictive ownership:

```text
/opt/domismp                   domismp:domismp, restricted traversal
/opt/domismp/conf/context.xml  domismp:domismp, 600
smp.config.properties          domismp:domismp, 640
smp-logback.xml                domismp:domismp, 640
Connector/J                    domismp:domismp, 640
/data/domismp/*                domismp:domismp, 750 directories
```

## MySQL exposure

MySQL listens on localhost only. This removes any need for a network-exposed database service inside the host-only lab.

## Plain HTTP is lab-only

The current UI is reached at:

```text
http://192.168.50.30:8080/smp/
```

The browser correctly marks it as not secure. This is an isolated baseline, not the final SDK transport/security design. HTTPS, certificate handling, mTLS and SDK-specific trust requirements belong to the next phase.

## `allowPublicKeyRetrieval=true`

The JNDI URL contains:

```text
useSSL=false
allowPublicKeyRetrieval=true
```

This was chosen specifically for the local MySQL lab with `caching_sha2_password`. It avoids the public-key retrieval failure previously encountered on Domibus. It should not be copied blindly to a production deployment.

## Default Tomcat applications

The extracted Tomcat installation still contains standard applications such as:

```text
ROOT
manager
host-manager
docs
examples
```

They were left unchanged while establishing a reproducible baseline. Future hardening should review whether they are required and remove/disable unnecessary applications.

## DomiSMP runtime observations

The startup log currently shows API certificate authentication and basic-token support available in the application configuration. That is an observed capability, not proof that final SDK certificate/authentication policy is configured.

## Snapshot is not a secret backup substitute

`02-domismp-installed` is a VM rollback point. It is not a replacement for controlled database/configuration backup and should be protected like any VM image that may contain credentials.
