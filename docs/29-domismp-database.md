# DomiSMP MySQL database

This phase produced one of the most important troubleshooting lessons in the build: **database defaults matter to generated indexes**.

## Database/user design

Chosen local database model:

```text
Database: smp
User:     smp@localhost
Engine:   MySQL 8.0.46
Auth:     caching_sha2_password
```

MySQL remained bound to localhost.

The JNDI URL later includes `allowPublicKeyRetrieval=true` from the start, to avoid the reboot-time login failure seen on the Domibus gateways ([why](06-java-mysql.md#reboot-authentication-failure)).

## Credential-handling mistake and immediate correction

During initial account creation, the literal placeholder text from the instruction was accidentally used as the DB password. Because that value appeared in the transcript, it was immediately replaced with a new private password before continuing.

The repository intentionally does **not** preserve either the exposed placeholder value or the replacement secret.

Final account verification showed:

```text
smp  localhost  caching_sha2_password
```

## First schema attempt: failure

The database was initially created as:

```sql
CREATE DATABASE smp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Running the shipped schema failed:

```text
ERROR 1071 (42000) at line 699:
Specified key was too long; max key length is 3072 bytes
```

### Exact failing DDL

Around line 699:

```sql
alter table SMP_CERTIFICATE
   add constraint UK3x3rvf6hkim9fg16caurkgg6f unique (CERTIFICATE_ID);
```

`SMP_CERTIFICATE.CERTIFICATE_ID` is `varchar(1024)`.

With `utf8mb4`, the theoretical index width is:

```text
1024 characters × 4 bytes = 4096 bytes
```

which exceeds InnoDB's 3072-byte key limit.

With 3-byte UTF-8:

```text
1024 × 3 = 3072 bytes
```

which exactly fits.

## Important partial-import complication

The shell commands had been entered as two separate imports:

```bash
sudo mysql smp < mysql.ddl
sudo mysql smp < mysql-data.sql
```

The DDL stopped at line 699, but the second command still ran. This left a misleading state:

```text
50 tables visible
seeded users visible
seeded domain visible
```

That state was **not accepted** as healthy because constraints/indexes after the failing line had not been created.

## Clean rebuild

The partially built DB was dropped and recreated using:

```sql
DROP DATABASE smp;

CREATE DATABASE smp
  CHARACTER SET utf8mb3
  COLLATE utf8mb3_unicode_ci;
```

MySQL emitted two deprecation warnings for `utf8mb3`; these were accepted because the goal was to match the shipped vendor schema's index requirements, not design a new application schema.

The DDL then completed with no error.

## Proof that the previously failing index exists

Observed:

```text
SMP_CERTIFICATE 0 UK3x3rvf6hkim9fg16caurkgg6f 1 CERTIFICATE_ID ... BTREE
```

That verification was critical: it proves the import passed the exact statement that had failed earlier.

## Seed import and final validation

After a clean DDL import:

```bash
sudo mysql smp < mysql-data.sql
```

Final observations:

```text
Database:  smp
Charset:   utf8mb3
Collation: utf8mb3_unicode_ci
Tables:    50
```

Seeded users:

```text
1  system  active  SYSTEM_ADMIN
2  user    active  USER
```

Seeded domain:

```text
1  testdomain  PUBLIC  test-domain  DOMI-SMP-001  registered
```

Seeded extension:

```text
edelivery-oasis-smp-extension
OasisSMPExtension
Oasis SMP 1.0 and 2.0
1.0
```

Application-account test:

```text
table_count = 50
```

using `mysql -u smp -p -D smp ...`.

## Final rule

Do not “repair” the failed `utf8mb4` import in place. The known-good baseline is the clean `utf8mb3` recreation followed by a complete DDL and data import.
