# Logging

## Symptom

DomiSML was healthy and HTTP 200, but:

```text
/data/domisml/logs
```

was initially empty.

The custom `sml-logback.xml` was readable and DomiSML logs confirmed that it had been selected:

```text
Set log configuration file /opt/domisml/classes/sml-logback.xml
Set log configuration properties from the file ...
```

The XML itself correctly wired three rolling file appenders:

```text
LoggerSecurityImpl
LoggerBusinessImpl
file
```

plus stdout.

The root logger referenced all of them.

## Logback path expression

The vendor XML used:

```text
${sml.log.folder:-logs}
```

for:

```text
domisml.log
domisml-business.log
domisml-security.log
```

## Root cause

`jcmd VM.system_properties` showed that neither:

```text
sml.log.folder
log.configuration.file
```

was a JVM system property.

`lsof` then revealed the real file handles:

```text
/tmp/hsperfdata_domisml/logs/domisml.log
/tmp/hsperfdata_domisml/logs/domisml-business.log
/tmp/hsperfdata_domisml/logs/domisml-security.log
```

The Java process working directory at that moment was:

```text
/tmp/hsperfdata_domisml
```

Therefore the `${sml.log.folder:-logs}` expression had fallen back to a **relative** `logs` directory.


![lsof shows the DomiSML logs open under /tmp/hsperfdata_domisml/logs; jcmd shows no sml.log.folder JVM property.](../assets/smp-sml-screenshots/20260916-141448.png)

*lsof shows the DomiSML logs open under /tmp/hsperfdata_domisml/logs; jcmd shows no sml.log.folder JVM property.*

## Fix

The property was promoted to a JVM startup property in `/opt/domisml/bin/setenv.sh`:

```sh
JAVA_OPTS="$JAVA_OPTS -Dsml.log.folder=/data/domisml/logs"
```

After restart:

```text
jcmd => sml.log.folder=/data/domisml/logs
```

and `lsof` showed:

```text
/data/domisml/logs/domisml.log
/data/domisml/logs/domisml-business.log
/data/domisml/logs/domisml-security.log
```


![After adding -Dsml.log.folder: the JVM property is set and the log files are open under /data/domisml/logs.](../assets/smp-sml-screenshots/20260916-141723.png)

*After adding -Dsml.log.folder: the JVM property is set and the log files are open under /data/domisml/logs.*

## Empty business/security files

At the time of validation:

```text
domisml.log           populated
domisml-business.log  0 bytes
domisml-security.log  0 bytes
```

This was accepted because no BUSINESS or SECURITY marker events had occurred yet.

## Cleanup

The old fallback files under:

```text
/tmp/hsperfdata_domisml/logs
```

were confirmed to have no open JVM handles and were removed.


![Old fallback directory removed after confirming no open handles; active logs stay on /data.](../assets/smp-sml-screenshots/20260916-142011.png)

*Old fallback directory removed after confirming no open handles; active logs stay on /data.*

The parent `/tmp/hsperfdata_domisml` directory was deliberately left alone because the JVM uses it for performance data.

## Why the working directory was `/tmp/hsperfdata_domisml`

DomiSML was started manually with `sudo -u domisml`, which keeps an unusual working directory. Under systemd the unit sets `WorkingDirectory=/opt/domisml`, but the explicit JVM property is still the right fix: log locations should never depend on the directory the service happens to start from.
