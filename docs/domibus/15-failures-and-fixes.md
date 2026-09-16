# Failures & fixes

The failures are intentionally documented because they explain the final configuration and provide a troubleshooting reference.

## 1. MySQL DDL import: ERROR 1419

**Symptom:** Domibus MySQL schema import failed while creating functions.

```text
ERROR 1419
```

**Cause:** binary logging restrictions around stored-function creation.

**Fix:** temporarily use:

```text
log_bin_trust_function_creators=1
```

Import the schema/data, then restore the value to `0`.

**Lesson:** temporary install-time relaxations should be reverted.

---

## 2. Blue first-start working-directory / FreeMarker warning

**Symptom:** early startup generated a FreeMarker-related warning.

**Fix:** restart from:

```text
/opt/domibus
```

**Permanent improvement:** systemd uses `WorkingDirectory=/opt/domibus`.

---

## 3. Stale Java process

**Symptom:** a stale JVM complicated early startup validation. Historical logs also showed RMI/JMX port 1199 already in use.

**Fix:** remove the stale process and stop trusting only `pgrep`.

Use PID file + `ps` + socket ownership.

---

## 4. JMX port 1199 warnings

Historical messages included:

```text
Failed to create local RMI registry on port 1199
Address already in use
```

This was an earlier lifecycle conflict, not the later reboot failure.

---

## 5. Quartz/Hikari shutdown timing

Historical shutdown logs showed Quartz firing after the datasource had closed:

```text
JobPersistenceException
HikariDataSource ... has been closed
```

This was observed during teardown and did not remain in the final running baseline.

---

## 6. JDBC/thread/ThreadLocal cleanup warnings

Tomcat shutdown/redeployment logs included warnings that JDBC drivers, threads or ThreadLocal values had not been cleanly removed. ActiveMQ shutdown-hook classloader warnings also appeared after the webapp had stopped.

The final state was judged by successful clean cold boots rather than by treating every teardown warning as a live-service failure.

---

## 7. JKS proprietary-format warning

Java suggested converting JKS to PKCS12.

**Decision:** keep JKS for the initial baseline.

**Reason:** vendor sample already used JKS; converting would add an unnecessary variable.

---

## 8. `xander` could not list all Domibus data directories

**Cause:** intentional `domibus:domibus` ownership and mode 750.

**Fix:** none. Permissions were not weakened.

---

## 9. Blue admin recovery

**Symptom:** Blue Admin Console user needed reset/recreation.

**Safety:** DB backup first:

```text
~/dl/backups/blue-before-admin-reset.sql
```

**Schema discovered:**

```text
TB_USER.ID_PK
TB_USER_ROLES.USER_ID
TB_USER_PASSWORD_HISTORY.USER_ID
```

**Fix:** remove related admin rows in dependency-safe order; let Domibus recreate the account; use generated temporary password once; change immediately.

The temporary password is not documented.

---

## 10. Credentials appeared during setup

Some temporary/database credentials appeared during interactive troubleshooting.

**Response:** change/rotate as appropriate.

**Repository rule:** document the event, not the secret value.

---

## 11. Red commands accidentally executed on Blue

**Symptom:** a Red preparation block was run on Blue.

Operations included Connector/J copy, recursive ownership, directory creation, permission application and a write test.

**Impact:** largely idempotent.

**Response:** full Blue audit verified hostname, IP, Java, `/data`, `blue_gw`, DB version/table count and PMode were intact.

**Lesson:** always run `hostname` before configuration/destructive commands.

---

## 12. First WS Plugin curl path failure

**Symptom:** a mangled/escaped `~` path caused the first curl to fail before a request was sent.

**Fix:** use absolute paths under `/home/xander/dl`.

---

## 13. Chat/Markdown command rendering

The transcript renderer sometimes displayed URLs as Markdown links and escaped characters such as `_`, `@`, `<` and `>`.

**Mitigation:** validate actual XML with ElementTree and interpret shell errors/output rather than the rendered transcript alone.

---

## 14. Wrong retrieval placeholder

First assumption:

```text
${messageID}
```

Actual vendor property:

```text
${ResponseParameter#messageID}
```

**Fix:** inspect with `grep -n '\${'` and replace the exact placeholder.

---

## 15. Shell prompt `$` pasted

Pasting:

```text
$ MID='...'
```

produced:

```text
$: command not found
```

**Fix:** omit the prompt symbol.

---

## 16. Duplicate `curl -sS`

One retrieval transcript contained `curl -sS curl -sS`. The intended request still produced the expected result in that session, but the duplicate token is not part of the canonical command.

---

## 17. systemd active but Domibus returned 404

This was the most important service-management failure.

**Observed after Blue reboot:**

```text
systemd active
Java running
MySQL active
/data mounted
8080 listening
```

but:

```text
/domibus/ 404
/domibus/services/msh 404
/domibus/services/wsplugin?wsdl 404
```

**Root cause logs:**

```text
Could not read the current database username
Public Key Retrieval is not allowed
Context [/domibus] startup failed due to previous errors
```

**Cause:** MySQL user used `caching_sha2_password`; JDBC used `useSSL=false` and did not allow Connector/J to retrieve the server RSA public key. It had worked before the reboot only because MySQL caches successful logins in memory; the reboot cleared that cache. Plain-language explanation: [Java and MySQL](06-java-mysql.md#reboot-authentication-failure).

**Fix:** add:

```text
allowPublicKeyRetrieval=true
```

**Result:** Blue and Red subsequently passed cold reboot.

**Lesson:** Tomcat health is not Domibus health.

---

## 18. Over-broad `sed` changed a commented replica URL

The first Blue edit changed both the active datasource and the commented replica example. The count of `allowPublicKeyRetrieval=true` was therefore 2.

There was no runtime effect because the replica line was commented, but it was cleaned up. Red later used a targeted expression matching only the active `domibus.datasource.url` line.

---

## 19. `/proc/$PID/environ` sudo/redirection issue

This command failed:

```bash
sudo tr '\0' '\n' < /proc/$PID/environ
```

because the shell performs input redirection before `sudo` runs.

Correct pattern:

```bash
sudo sh -c "tr '\0' '\n' < /proc/$PID/environ"
```

No functional impact occurred.

---

## 20. Health checks run too early

Domibus deployment can take roughly 30-70+ seconds. Observed deployments ranged from about 27 seconds to over 71 seconds.

**Lesson:** allow an application startup window, but persistent 404 after several minutes requires log inspection rather than indefinite waiting.

---

## 21. `errorLogCleanerJob` false positive

A generic grep for `error` matched the legitimate Quartz job name:

```text
errorLogCleanerJob
```

**Lesson:** interpret log matches in context.

---

## 22. Repeated/idempotent commands

Some ownership, connector-copy and directory-creation operations were repeated during troubleshooting. Where the target was already correct, these did not change the functional configuration.

## Why this failure history matters

It explains final practices such as:

- absolute paths in curl examples;
- `hostname` before changes;
- PID/socket validation;
- application-level health checks;
- targeted config edits;
- systemd `WorkingDirectory`;
- the JDBC public-key retrieval parameter;
- delaying systemd until AS4 worked manually.

## Screenshot-backed failures in this archive

Several failures documented above are visually preserved: the Ubuntu installation-media `/cdrom` unmount problem, Windows VMnet3 receiving an APIPA address before correction, SSH host-key change after VM identity work, MySQL `ERROR 1419`, password-policy/admin recovery diagnostics, and process/port checks used to distinguish a running JVM from a healthy application.

Two source screenshots (`21:50:42` and `21:50:48`) displayed temporary Domibus administrator passwords in clear text. They are intentionally **not copied into this repository**. Their non-secret diagnostic information is summarized in the documentation, but the credential values are omitted.

![Installer /cdrom unmount failure](../assets/screenshots/20260915-185147.png)

![Windows VMnet3 APIPA state](../assets/screenshots/20260915-193710.png)

![SSH host-key warning](../assets/screenshots/20260915-193156.png)

![MySQL ERROR 1419](../assets/screenshots/20260915-204536.png)

