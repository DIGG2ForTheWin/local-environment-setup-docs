# Runbook

## Basic host status

```bash
hostname
findmnt /data
systemctl is-active mysql
systemctl is-enabled domismp
systemctl is-active domismp
systemctl is-enabled domisml
systemctl is-active domisml
```

Expected hostname:

```text
sdk-core
```

## Verify both Java processes

```bash
pgrep -af 'catalina.base=/opt/domismp' || true
pgrep -af 'catalina.base=/opt/domisml' || true
```

## Verify listeners

```bash
sudo ss -ltnp | grep -E ':8080|:8081'
```

Expected:

```text
*:8080  DomiSMP Java
*:8081  DomiSML Java
```

## HTTP health

```bash
curl -sS -o /dev/null -w 'DomiSMP HTTP %{http_code}\n' \
  http://127.0.0.1:8080/smp/

curl -sS -o /dev/null -w 'DomiSML HTTP %{http_code}\n' \
  http://127.0.0.1:8081/edelivery-sml/
```

Known-good:

```text
200 / 200
```

## DomiSMP logs

```bash
sudo tail -n 150 /data/domismp/logs/edelivery-smp.log
sudo tail -n 150 /opt/domismp/logs/catalina.out
```

## DomiSML logs

```bash
sudo tail -n 150 /data/domisml/logs/domisml.log
sudo tail -n 150 /opt/domisml/logs/catalina.out
```

## DomiSML open application logs

```bash
PID=$(pgrep -f 'catalina.base=/opt/domisml' | head -1)
sudo lsof -p "$PID" 2>/dev/null | grep '/data/domisml/logs/'
```

## DomiSML JVM log-folder property

```bash
PID=$(pgrep -f 'catalina.base=/opt/domisml' | head -1)
sudo -u domisml \
  /usr/lib/jvm/temurin-21-jdk-amd64/bin/jcmd "$PID" VM.system_properties | \
  grep '^sml\.log\.folder='
```

Expected:

```text
sml.log.folder=/data/domisml/logs
```

## Start/stop

```bash
sudo systemctl restart domismp
sudo systemctl restart domisml
```

Manual DomiSML troubleshooting only after stopping systemd:

```bash
sudo systemctl stop domisml
sudo -u domisml /opt/domisml/bin/startup.sh
sudo -u domisml /opt/domisml/bin/shutdown.sh 30 -force
```

## Current-boot errors

Tomcat application errors go to `catalina.out`, not the systemd journal. Search only the part of `catalina.out` written since the last Tomcat start:

```bash
for app in domismp domisml; do
  echo "=== $app ==="
  sudo awk '/Server version name:/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' \
    /opt/$app/logs/catalina.out | \
  grep -Ei 'SEVERE|Exception|Caused by|Access denied|Communications link failure|Public Key Retrieval|Can not decrypt|BadPadding|AEADBadTag' \
  || echo "[PASS] no errors since last start"
done
```

`Server version name:` is the first line Tomcat writes on every start, so everything after its last occurrence belongs to the current run.

## DomiSML DB count

```bash
sudo mysql -NBe \
"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='sml_schema';"
```

Known-good:

```text
19
```

## DomiSMP domain UI

```text
http://192.168.50.30:8080/smp/
```

Current SDK-lab domain:

```text
sdk-lab
```

## DomiSML URL

```text
http://192.168.50.30:8081/edelivery-sml/
```

## Reboot health checklist

After reboot, verify all of:

```text
/data mounted
MySQL active
DomiSMP enabled + active
DomiSML enabled + active
both Java PIDs present
8080 and 8081 owned by Java
GET /smp/ = 200
GET /edelivery-sml/ = 200
no errors in catalina.out since last start
application logs writing to /data
```
