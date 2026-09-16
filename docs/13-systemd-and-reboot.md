# systemd and reboot validation

## Why systemd was delayed

Domibus remained a manual process until bidirectional AS4 messaging and backend retrieval were proven. This separated protocol/PMode/crypto failures from service-manager/boot-order failures.

## Unit file

Path:

```text
/etc/systemd/system/domibus.service
```

Contents:

```ini
[Unit]
Description=Domibus 5.2.1.3
After=network-online.target mysql.service data.mount
Wants=network-online.target
Requires=mysql.service
RequiresMountsFor=/data

[Service]
Type=forking
User=domibus
Group=domibus
WorkingDirectory=/opt/domibus

Environment=JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
Environment=CATALINA_HOME=/opt/domibus
Environment=CATALINA_BASE=/opt/domibus
Environment=CATALINA_PID=/run/domibus/tomcat.pid

RuntimeDirectory=domibus
RuntimeDirectoryMode=0750

ExecStart=/opt/domibus/bin/startup.sh
ExecStop=/opt/domibus/bin/shutdown.sh 60

PIDFile=/run/domibus/tomcat.pid

Restart=on-failure
RestartSec=10

TimeoutStartSec=180
TimeoutStopSec=90

LimitNOFILE=65536
UMask=0027

[Install]
WantedBy=multi-user.target
```

### Why these settings

- **`Type=forking` + `PIDFile`**: `startup.sh` launches the Tomcat JVM in the background and exits straight away. `forking` tells systemd to expect that. The PID file, written by Tomcat because `CATALINA_PID` is set, tells systemd which process is the real service.
- **`After=… mysql.service data.mount`, `Requires=mysql.service`, `RequiresMountsFor=/data`**: start only after the database and the payload disk are available.
- **`WorkingDirectory=/opt/domibus`**: avoids the FreeMarker working-directory problem ([failure 2](14-failures-and-fixes.md#2-blue-first-start-working-directory-freemarker-warning)).
- **`RuntimeDirectory=domibus`**: systemd creates `/run/domibus` (owned by `domibus`) on every boot, because `/run` is emptied at reboot.
- **`UMask=0027`**: new files are not world-readable.

!!! note "Logs"
    Because Tomcat forks, Domibus deployment messages go to `/opt/domibus/logs/catalina.out`, not to `journalctl -u domibus`. Check both when diagnosing a start.

## Verify and enable

```bash
sudo systemd-analyze verify /etc/systemd/system/domibus.service
sudo systemctl daemon-reload
sudo systemctl enable domibus
sudo systemctl start domibus
```

`systemd-analyze verify` returned no errors.

## Blue first systemd start

```text
Active: active (running)
Main PID: 4158 (java)
startup.sh: SUCCESS
PID file: 4158
owner: domibus:domibus
8080 owner: java PID 4158
Root HTTP: 302
```

## Red first systemd start

```text
Active: active (running)
Main PID: 4736 (java)
owner: domibus:domibus
8080 owner: java PID 4736
Root HTTP: 302
```

## Direct Java verification

The operator explicitly requested proof that the Java process itself was running. Validation used:

```bash
pgrep -a java
```

plus the more authoritative:

```bash
PID=$(sudo cat /run/domibus/tomcat.pid)
ps -o user,group,pid,ppid,cmd -p "$PID"
sudo ss -ltnp | grep ':8080'
```

The final model checks that the systemd MainPID, PID file and listening-socket PID all match.

## Blue first reboot

After reboot:

```text
hostname blue
domibus enabled
domibus active
Java PID 1179 alive
owner domibus
MySQL active
/data mounted
ens34 192.168.50.10/24
8080 listening
Red MSH 200
```

but:

```text
Root 404
MSH 404
WS Plugin 404
```

Waiting another minute did not fix it.

## Root cause

Tomcat started, but Domibus failed Spring initialization because Connector/J could not authenticate to MySQL:

```text
Could not read the current database username
Public Key Retrieval is not allowed
Context [/domibus] startup failed due to previous errors
```

## Blue JDBC fix

Added:

```text
allowPublicKeyRetrieval=true
```

Warm restart then produced:

```text
systemd active
Java PID 1868
Root 302
MSH 200
WS Plugin 200
```

Fresh deployment:

```text
55,882 ms
```

## Blue final cold reboot

```text
domibus enabled
domibus active
Java PID 1215
owner domibus:domibus
MySQL active
/data mounted
8080 listening
Root 302
MSH 200
WS Plugin 200
```

Fresh deployment:

```text
70,531 ms
```

Current-boot DB/deployment check: PASS.

## Red proactive JDBC fix

Before rebooting Red, its DB plugin was confirmed as:

```text
caching_sha2_password
```

Its active URL was updated with `allowPublicKeyRetrieval=true`.

Warm restart:

```text
systemd active
Java PID 6941
Root 302
MSH 200
WS Plugin 200
```

Deployment:

```text
48,581 ms
```

## Red final cold reboot

```text
domibus enabled
domibus active
Java PID 1361
owner domibus:domibus
MySQL active
/data mounted
8080 listening
Root 302
MSH 200
WS Plugin 200
Blue MSH 200
```

Deployment:

```text
71,512 ms
```

Current-boot DB/deployment check: PASS.

## Startup timing

Observed deployment durations across the build include approximately:

```text
27,306 ms
33,032 ms
40,798 ms
45,120 ms
48,581 ms
55,882 ms
70,531 ms
71,512 ms
```

Health checks therefore need enough time for the webapp to initialize.

## Final boot-health criteria

```text
systemd enabled
systemd active
PID file exists
Java PID alive
owner domibus
MySQL active
/data mounted
8080 listening
Root 302
MSH 200
WS Plugin 200
peer MSH reachable
no current-boot DB/deployment failure
```

## Screenshot relationship to the later systemd phase

The supplied screenshot ZIP ends before the final systemd/cold-reboot work that occurred later in the session. It still preserves the manual-process baseline that systemd replaced: Java/Tomcat process inspection, port 8080 checks and application startup logs. The final systemd and reboot figures in this chapter therefore come from the later terminal transcript rather than from this screenshot bundle.

![Manual Java/Tomcat process inspection](assets/screenshots/20260915-212944.png)

*The pre-systemd manual baseline used for later service-manager comparison.*

