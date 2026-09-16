# Database setup

## SQL distribution

```text
domibus-msh-sql-distribution-1.21.zip
```

Download: <https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/domibus/domibus-msh-sql-distribution/1.21/domibus-msh-sql-distribution-1.21.zip>

Extracted under:

```text
~/dl/sql-dist
```

Relevant path:

```text
~/dl/sql-dist/sql-scripts/5.2.1/mysql/
```

Important scripts:

```text
mysql-5.2.1.ddl
mysql-5.2.1-data.ddl
```

Multitenancy/helper scripts were also present.

## Database and user

Both gateways use:

```text
DB: domibus_schema
user: edelivery_user@localhost
```

## Grants

```sql
ALL PRIVILEGES ON domibus_schema.*
```

plus:

```sql
XA_RECOVER_ADMIN ON *.*
```

## Import failure: ERROR 1419

The initial schema import hit MySQL `ERROR 1419` while creating functions because binary logging restrictions were active.

### Temporary workaround

Temporarily enable:

```text
log_bin_trust_function_creators=1
```

Import the Domibus schema/data, then restore:

```text
log_bin_trust_function_creators=0
```

The relaxed setting was not intentionally left enabled.

## Validation

Both databases were checked after import.

```text
119 tables
TB_VERSION.VERSION = 5.2.1
```

Expected seed rows were present.

## Blue admin recovery

Blue's Admin Console account required recovery.

### Backup

Before modification:

```text
~/dl/backups/blue-before-admin-reset.sql
```

Approximate size:

```text
214 KB
```

### Relevant schema relationships discovered

```text
TB_USER.ID_PK
TB_USER_ROLES.USER_ID
TB_USER_PASSWORD_HISTORY.USER_ID
```

### Recovery behavior

Admin-related child rows and the admin row were removed in dependency-safe order. Domibus recreated the admin account at startup with `DEFAULT_PASSWORD=1` and logged a generated temporary password.

The generated value is intentionally excluded from the repository.

The operator logged in, changed the password immediately, logged out, and logged back in with the new password.

Useful log search:

```bash
sudo grep -RInaF 'Default password for user [admin] is' \
  /opt/domibus/logs | tail -1
```

This command can expose a credential and should be treated as sensitive.

## Red admin

Red also generated a temporary administrator password. It was obtained locally and changed immediately. The value is not documented.

## Screenshot-derived database evidence

The screenshots add a visual audit trail for the schema load: SQL distribution scripts were inspected first, MySQL was confirmed to listen only on loopback, the application user/grants were checked, the first import hit MySQL `ERROR 1419`, and the final database showed the expected `TB_VERSION` table plus a 119-table schema. The `log_bin_trust_function_creators` value was explicitly returned to `0` after the import.

### Screenshot evidence

![Domibus MySQL SQL script inspection](assets/screenshots/20260915-203743.png)

*The supplied Domibus SQL scripts being inspected before import.*

![Initial ERROR 1419 during import](assets/screenshots/20260915-204536.png)

*The first import failure caused by MySQL binary-log/stored-function restrictions.*

![Successful schema/version/grant validation](assets/screenshots/20260915-204817.png)

*Post-import validation showing Domibus schema state and reset of `log_bin_trust_function_creators`.*

![TB_VERSION and application tables](assets/screenshots/20260915-204955.png)

*Direct evidence that the Domibus version table exists in `domibus_schema`.*

