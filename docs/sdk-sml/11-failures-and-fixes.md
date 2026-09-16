# Failures & fixes

This chapter deliberately preserves the mistakes and dead ends because they explain why the final configuration looks the way it does.

## 1. PKI directory under `/data/domismp` was inaccessible to `xander`

**Symptom:** operator could not traverse the application-owned tree.

**Cause:** `/data/domismp` was correctly restricted to `domismp:domismp` mode 750.

**Fix:** move operator PKI to `/data/sdk-pki` rather than weaken DomiSMP permissions.

---

## 2. Root CA certificate initially lacked explicit Key Usage

**Symptom:** root cert had CA semantics but did not meet the desired extension profile.

**Fix:** reissue the certificate using the same private key with critical `Certificate Sign, CRL Sign`; preserve the previous cert as `.before-ext-fix`.

---

## 3. DomiSMP file picker was not obvious

**Symptom:** clicking the import field did not behave like a normal file input; inspected filename field was read-only.

**Lesson:** UI display fields are not necessarily upload controls. Inspect hidden `input[type=file]` rather than trying to type a path into a read-only field.

---

## 4. DomiSMP domain incomplete after creation

**Symptom:** orange banner required a resource type and ADMIN member.

**Fix:** select only `smp-1`, add `system` as ADMIN.

---

## 5. Risk of confusing response-signing cert with SML client cert

**Symptom:** `sdk_lab_smp_signing` appeared in the SML-client certificate dropdown.

**Decision:** do not reuse it blindly. Keep trust roles distinct and defer SML client-auth identity until local SML is ready.

---

## 6. DomiSML sample secret values were present in seed SQL

**Risk:** copying them into documentation would preserve secret-bearing values unnecessarily.

**Fix:** store retrieval/change commands instead of values and redact all actual password/ciphertext data.

---

## 7. A DomiSML DB password was exposed in chat

**Risk:** any password placed in chat should be treated as compromised.

**Fix:** the password was changed (confirmed 2026-09-16) and the value is never reproduced here. Runtime configuration examples contain placeholders only.

---

## 8. DomiSML runtime read `/opt/smlconf/` despite classpath config

**Symptom:** `AccessDeniedException`, missing keystore/truststore/key, decrypt failures.

**Cause:** the database carried active `configurationDir` and `sml.security.folder` values pointing to `/opt/smlconf/`.

**Fix:** update both DB values to `/data/domisml/security`.

---

## 9. Vendor key and vendor ciphertext did not match the active deployment

**Symptom:** after fixing the path, failures changed from file-not-found to `IllegalBlockSizeException`, `BadPaddingException`, then AEAD tag mismatch.

**Fix:** preserve vendor key, clear unused sample password fields, let DomiSML create its own encryption key, identify and safely clear stale truststore ciphertext after restricted backup.

---

## 10. `adminPassword` must not be treated like encrypted ciphertext

Safe inventory showed it was a BCrypt hash.

**Decision:** leave it untouched.

---

## 11. DomiSML logs went to `/tmp/hsperfdata_domisml/logs`

**Symptom:** `/data/domisml/logs` was empty although Logback XML was loaded.

**Evidence:** `lsof` showed the actual open files in `/tmp/hsperfdata_domisml/logs` and `jcmd` showed no `sml.log.folder` JVM property.

**Fix:** add `-Dsml.log.folder=/data/domisml/logs` to `JAVA_OPTS`.

---

## 12. Logback fix cleanup

The old fallback directory was removed only after confirming no JVM file descriptors referenced it. The parent `hsperfdata` directory was left intact.

---

## 13. Global Tomcat JNDI created unnecessary pools

**Symptom:** pool warning appeared while several default Tomcat webapps were deployed.

**Cause:** the datasource lived in global `conf/context.xml`.

**Fix:** move the resource to `conf/Catalina/localhost/edelivery-sml.xml` and restore clean global context.

---

## 14. JDBC pool `maxIdle` warning

**Symptom:** Tomcat adjusted `maxIdle` because default `minIdle` was larger.

**Fix:** set `minIdle=2`, keeping `maxIdle=8` and `maxTotal=20`.

---

## 15. Checking a protected file as `xander` produced `Permission denied`

`/opt/domisml/bin/setenv.sh` was intentionally protected. A plain `grep` as `xander` failed.

**Lesson:** verify privileged application files through `sudo` or runtime state. The `jcmd` JVM output proved the property was active.

---

## 16. Do not infer health from systemd only

The lab repeatedly verified Java PID, ports, HTTP, DB behavior and logs in addition to systemd state. This caught earlier classes of problems that a green unit alone would miss.

---

## 17. Error grep against the journal gave false confidence

**Symptom:** after the reboot, `journalctl -u domisml/domismp | grep SEVERE|ERROR|…` reported no errors.

**Cause:** Tomcat forks; application messages go to `catalina.out`, not the systemd journal, so the grep could not have found them.

**Fix:** judge health from HTTP responses plus a `catalina.out` search since the last Tomcat start ([Runbook](13-runbook.md#current-boot-errors)). The same issue was found and fixed in the Domibus and DomiSMP runbooks.

---

## 18. Snapshot name drifted to lowercase again

The package proposed `03-domisml-installed`. The lab convention is `NN-Title-Case`, so the planned name is **`03-DomiSML-Installed`** ([VMware snapshots](../reference/snapshots.md)).
