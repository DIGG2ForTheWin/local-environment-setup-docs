# DomiSMP systemd service and cold-reboot validation

## Why service management was delayed

The application was first proven manually. During the first manual shutdown, Tomcat stopped its connector but the JVM failed to exit. That finding directly influenced the final service design.

## Final unit

`/etc/systemd/system/domismp.service`:

```ini
[Unit]
Description=DomiSMP 5.2.1.3
After=network-online.target mysql.service data.mount
Wants=network-online.target
Requires=mysql.service
RequiresMountsFor=/data

[Service]
Type=forking
User=domismp
Group=domismp
WorkingDirectory=/opt/domismp
Environment=JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
Environment=CATALINA_HOME=/opt/domismp
Environment=CATALINA_BASE=/opt/domismp
Environment=CATALINA_PID=/opt/domismp/temp/tomcat.pid
ExecStart=/opt/domismp/bin/startup.sh
ExecStop=/opt/domismp/bin/shutdown.sh 30 -force
PIDFile=/opt/domismp/temp/tomcat.pid
Restart=on-failure
RestartSec=10
TimeoutStartSec=180
TimeoutStopSec=60
LimitNOFILE=65536
UMask=0027

[Install]
WantedBy=multi-user.target
```

`systemd-analyze verify` returned cleanly.

## Warm service check

After enabling/starting the unit:

```text
systemctl is-enabled domismp -> enabled
systemctl is-active domismp  -> active
```

Java remained owned by `domismp` and port 8080 remained owned by that Java process.

## Cold reboot

A full VM reboot was then performed.

Observed approximately one minute after boot:

```text
hostname: sdk-core
/data: /dev/sdb1 ext4 rw,relatime
MySQL: active
DomiSMP systemd: enabled + active
Java PID: 1335
Java owner: domismp
8080: LISTEN, owned by java
GET /smp/: HTTP 200
```

Systemd status:

```text
Active: active (running)
Main PID: 1335 (java)
Memory: 1.0G
```

Tomcat application log:

```text
Deployment of web application archive [/opt/domismp/webapps/smp.war]
has finished in [21,516] ms

Server startup in [22667] milliseconds
```

The current-boot systemd error search returned no result.

## Why the deployment grep against journalctl was empty

The unit starts `startup.sh`, which forks Tomcat. Systemd saw the service launch, while Tomcat application/deployment messages were written to `catalina.out`. Therefore an empty deployment grep in `journalctl -u domismp` was not a failure; the deployment proof was correctly collected from:

```text
/opt/domismp/logs/catalina.out
```

## Final verdict

```text
/data automount        PASS
MySQL boot             PASS
systemd enable         PASS
DomiSMP service boot   PASS
Java process           PASS
port 8080              PASS
HTTP /smp/             PASS
WAR deployment         PASS
current-boot errors    none observed
```
