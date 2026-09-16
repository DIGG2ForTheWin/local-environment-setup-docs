# Failures & fixes

This page intentionally keeps the failures. They are part of the reproducible build history and explain why the final configuration looks the way it does.

## 1. `lost+found` permission denied

**Symptom**

```text
find: '/data/lost+found': Permission denied
```

**Cause:** normal ext4 `lost+found` ownership (`root:root`) while running `find` as `xander`.

**Fix:** none. Later inspection can use `sudo find`. Permissions were not weakened.

---

## 2. Literal password placeholder accidentally used

**Symptom:** the initial `CREATE USER` command used the instruction placeholder literally as the DB password.

**Impact:** the placeholder appeared in the transcript and therefore could not be treated as private.

**Fix:** immediately run `ALTER USER` with a new private password, then continue. The replacement password is not documented.

**Lesson:** placeholder text must be replaced before executing credential commands.

---

## 3. MySQL `ERROR 1071`: key too long

**Symptom**

```text
ERROR 1071 (42000) at line 699:
Specified key was too long; max key length is 3072 bytes
```

**Exact statement**

```sql
alter table SMP_CERTIFICATE
   add constraint UK3x3rvf6hkim9fg16caurkgg6f unique (CERTIFICATE_ID);
```

`CERTIFICATE_ID` is `varchar(1024)`.

**Cause:** the DB had been created as `utf8mb4`, making the potential index width 4096 bytes. The shipped DDL needs the 3-byte UTF-8 width for this 1024-character unique key.

**Fix:** drop the partial DB and recreate as:

```text
utf8mb3 / utf8mb3_unicode_ci
```

Then import the DDL from zero.

**Proof:** the previously failing unique index appeared in `SHOW INDEX`.

---

## 4. Seed script ran after failed DDL

**Symptom:** 50 tables plus seeded users/domain were visible even after the DDL failure.

**Cause:** `mysql-data.sql` was a second shell command and ran even though the prior DDL command failed.

**Risk:** false confidence in a partially constrained schema.

**Fix:** reject the partial state; drop and rebuild from zero.

---

## 5. `Permission denied` checking the WAR

**Symptom**

```text
ls: cannot access '/opt/domismp/webapps/smp.war': Permission denied
```

**Cause:** `/opt/domismp` intentionally restricted to `domismp` (750).

**Fix:** verify as `domismp` or through `sudo`; do not open permissions.

---

## 6. Connector/J copied to sdk-core but not yet into Tomcat

**Symptom**

```text
chown: cannot access '/opt/domismp/lib/mysql-connector-j-8.4.0.jar': No such file or directory
```

**Cause:** the JAR had been copied from Blue to `/home/xander/dl/domismp/`, but the subsequent copy into `/opt/domismp/lib/` was skipped.

**Fix:** perform the missing `sudo cp`, then set owner/mode.

---

## 7. Early Logback path error

**Symptom**

```text
Failed to create parent directories for [/home/xander/dl/domismp/logs/edelivery-smp.log]
openFile(logs/edelivery-smp.log,true) call failed
```

**Cause:** during early logging initialization, the relative `logs` fallback was resolved against the shell working directory before the final DomiSMP property path was fully in effect.

**Observation:** later in the same startup, `/data/domismp/logs/edelivery-smp.log` was successfully created and used.

**Fix:** change `smp-logback.xml` to absolute paths under `/data/domismp/logs` for both active and rolled files.

**Result:** clean restart with no path errors.

---

## 8. Tomcat shutdown timed out while JVM remained

**Symptom**

```text
Tomcat did not stop in time.
PID file was not removed.
```

At the same time:

```text
port 8080: closed
Java PID 2417: still alive
```

**Thread-dump evidence:** most remaining infrastructure threads were daemon threads. One notable thread was:

```text
"pool-2-thread-1" ...
java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(...)
```

It was not marked `daemon`, while `DestroyJavaVM` was waiting.

**Interpretation:** web serving had stopped, but a non-daemon scheduled executor kept the JVM alive.

**Recovery:** signal the already-shutting-down JVM, then force-kill only after it remained stuck. Remove the stale PID file before restarting.

**Permanent service fix:** use:

```text
shutdown.sh 30 -force
```

in `ExecStop`, preserving a graceful attempt before the force fallback.

---

## 9. Error grep false positive

Searching:

```text
SEVERE|ERROR|Exception|...
```

returned lines containing:

```text
error-messages_en.json
```

These were normal localisation-file log entries, not exceptions.

**Lesson:** grep output still needs semantic interpretation.

---

## 10. `HEAD /smp/` returned 401 while `GET /smp/` returned 200

**Observation:** `curl -I` produced 401, while a normal GET and browser access returned 200.

**Decision:** judge health from the browser/GET path plus successful deployment logs rather than assume all HTTP methods share the same security behaviour.

---

## 11. Bootstrap password was not obvious in current docs

**Situation:** the seed SQL stores bcrypt hashes only; the current release page did not expose the plaintext bootstrap value.

**Approach:** inspect the credential row first, avoid repeated guesses because the application was configured for five failed attempts, then test the historically documented vendor default once.

**Result:** login succeeded; the password was immediately changed.

---

## 12. Commons Logging warning after cold boot

Observed:

```text
Standard Commons Logging discovery in action with spring-jcl:
please remove commons-logging.jar from classpath in order to avoid potential conflicts
```

**Decision:** do not delete a vendor-bundled library merely to silence a warning when the application is healthy. Record it for future investigation if it becomes operationally relevant.

---

## 13. Deployment lines absent from `journalctl`

**Symptom:** systemd unit logs contained service start messages but no DomiSMP WAR deployment lines.

**Cause:** Tomcat application messages go to `catalina.out` in this installation.

**Fix:** use both systemd state and Tomcat application logs for health checks.

---

## 14. Snapshot naming correction

A long descriptive snapshot name was initially suggested. It was replaced with a numbered short milestone name:

```text
02-domismp-installed
```

**Follow-up (2026-09-16):** the Snapshot Manager shows that every earlier snapshot, on Blue, on Red and sdk-core `01-Network-Ready`, uses **Title-Case** words (`NN-Title-Case`), so the lowercase `02-domismp-installed` is the one inconsistent name. Future snapshots should use the original pattern, e.g. `03-SDK-Configured`. See [VMware snapshots](../reference/snapshots.md#naming-convention-for-new-snapshots).
