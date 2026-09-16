# sdk-core command reference

These are the canonical commands from the successful DomiSMP baseline. Password-bearing commands are intentionally sanitized.

## Identity

```bash
hostname
ip -br addr
ip route
```

## Storage

```bash
findmnt /data
df -h /data
sudo find /data -maxdepth 2 -type d -printf '%M %u:%g %p\n' | sort
```

## DomiSMP database state

```bash
sudo mysql -NBe \
"SELECT SCHEMA_NAME,DEFAULT_CHARACTER_SET_NAME,DEFAULT_COLLATION_NAME
 FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='smp';"

sudo mysql -NBe \
"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='smp';"
```

## Seeded users/domain

```bash
sudo mysql -NBe \
"SELECT ID,USERNAME,ACTIVE,APPLICATION_ROLE
 FROM smp.SMP_USER ORDER BY ID;"

sudo mysql -NBe \
"SELECT ID,DOMAIN_CODE,VISIBILITY,SML_SUBDOMAIN,SML_SMP_ID,SML_REGISTERED
 FROM smp.SMP_DOMAIN;"
```

## Tomcat version

```bash
sudo -u domismp /opt/domismp/bin/version.sh
```

## Configuration validation

```bash
sudo -u domismp /opt/domismp/bin/configtest.sh
```

## Service management

```bash
sudo systemctl daemon-reload
sudo systemd-analyze verify /etc/systemd/system/domismp.service
sudo systemctl enable --now domismp
sudo systemctl restart domismp
sudo systemctl status domismp
```

## Process and port

```bash
ps -ef | grep '[o]rg.apache.catalina.startup.Bootstrap'
sudo ss -ltnp | grep ':8080'
```

## HTTP

```bash
curl -sS -o /dev/null -w 'SMP HTTP %{http_code}\n' \
  http://127.0.0.1:8080/smp/
```

## Deployment logs

```bash
sudo grep -E \
'Deployment of web application archive.*smp.war|Server startup in' \
/opt/domismp/logs/catalina.out | tail -20
```

## Thread dump

```bash
PID=$(sudo cat /opt/domismp/temp/tomcat.pid)   # sudo: /opt/domismp is mode 750
sudo -u domismp \
  /usr/lib/jvm/temurin-21-jdk-amd64/bin/jcmd "$PID" Thread.print
```

## Manual start/forced stop

```bash
sudo -u domismp /opt/domismp/bin/startup.sh
sudo -u domismp /opt/domismp/bin/shutdown.sh 30 -force
```

## Sanitized JNDI resource

```xml
<Resource
    name="jdbc/eDeliverySmpDs"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
    driverClassName="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/smp?useSSL=false&amp;allowPublicKeyRetrieval=true&amp;serverTimezone=UTC"
    username="smp"
    password="<SMP_DB_PASSWORD>"
    maxTotal="30"
    maxIdle="10"
    maxWaitMillis="10000"
    validationQuery="SELECT 1"
    testOnBorrow="true"
/>
```
