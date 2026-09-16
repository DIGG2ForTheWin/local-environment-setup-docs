# sdk-core DomiSMP operations runbook

## Basic status

```bash
hostname
systemctl is-active mysql
systemctl is-enabled domismp
systemctl is-active domismp
findmnt /data
```

Expected hostname:

```text
sdk-core
```

## Verify the Java process

Do not infer health from systemd alone:

```bash
ps -ef | grep '[o]rg.apache.catalina.startup.Bootstrap'
```

Expected owner:

```text
domismp
```

## Verify port ownership

```bash
sudo ss -ltnp | grep ':8080'
```

Expected owner/process:

```text
java
```

## HTTP health

```bash
curl -sS -o /dev/null -w 'SMP HTTP %{http_code}\n' \
  http://127.0.0.1:8080/smp/
```

Known-good result:

```text
SMP HTTP 200
```

## Application deployment proof

```bash
sudo grep -E \
'Deployment of web application archive.*smp.war|Server startup in' \
/opt/domismp/logs/catalina.out | tail -20
```

## Current service errors

```bash
sudo journalctl -b -u domismp --no-pager | \
grep -Ei 'error|exception|failed|severe|caused by' | tail -80
```

Remember that Tomcat/DomiSMP application messages live primarily in `catalina.out` and `/data/domismp/logs/edelivery-smp.log`.

## DomiSMP log

```bash
sudo tail -n 120 /data/domismp/logs/edelivery-smp.log
```

## Start/stop/restart

```bash
sudo systemctl start domismp
sudo systemctl stop domismp
sudo systemctl restart domismp
```

The service's `ExecStop` uses Tomcat's force fallback after 30 seconds because a manual shutdown was observed to leave a non-daemon executor alive.

## Manual lifecycle for troubleshooting

Only use manual startup when systemd is stopped and no Java process remains:

```bash
sudo systemctl stop domismp
ps -ef | grep '[o]rg.apache.catalina.startup.Bootstrap' || true
sudo ss -ltnp | grep ':8080' || true
```

Then:

```bash
sudo -u domismp /opt/domismp/bin/startup.sh
```

Manual forced stop:

```bash
sudo -u domismp /opt/domismp/bin/shutdown.sh 30 -force
```

## Thread dump for a stuck JVM

```bash
PID=$(sudo cat /opt/domismp/temp/tomcat.pid)   # sudo: /opt/domismp is mode 750
sudo -u domismp \
  /usr/lib/jvm/temurin-21-jdk-amd64/bin/jcmd "$PID" Thread.print
```

## DB validation

```bash
sudo mysql -NBe \
"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='smp';"
```

Known-good count:

```text
50
```

## UI access from Windows

```text
http://192.168.50.30:8080/smp/
```

## Reboot validation

After a reboot, validate **all** of the following rather than only `systemctl`:

```text
/data mounted
MySQL active
DomiSMP service active
Java process present
8080 owned by Java
GET /smp/ = 200
WAR deployment completed in catalina.out
no current-boot fatal DB/JNDI/deployment errors
```
