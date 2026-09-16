# Commands

The commands below are a sanitized, chronological reconstruction. Passwords are never included.


## DomiSML capacity check

```bash
hostname
free -h
df -h /
df -h /data
sudo ss -ltnp | grep -E ':8080|:8081|:8082|:8443' || true
systemctl is-active mysql
```

## Download DomiSML

```bash
hostname
mkdir -p ~/dl/domisml
cd ~/dl/domisml

curl -fL \
  'https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/europa/ec/bdmsl/bdmsl-webapp/5.1.0.3/bdmsl-webapp-5.1.0.3.war' \
  -o bdmsl-webapp-5.1.0.3.war

curl -fL \
  'https://ec.europa.eu/digital-building-blocks/artifact/repository/eDelivery/eu/europa/ec/bdmsl/bdmsl-webapp/5.1.0.3/bdmsl-webapp-5.1.0.3-setup.zip' \
  -o bdmsl-webapp-5.1.0.3-setup.zip
```

## Verify artifacts

```bash
echo 'a4a3c145e67405c6c2dbf7ae110ccd5c  bdmsl-webapp-5.1.0.3.war' | md5sum -c -
echo '970a17bc8a709515499230659858c9a4  bdmsl-webapp-5.1.0.3-setup.zip' | md5sum -c -
```

## Inspect setup

```bash
unzip -l bdmsl-webapp-5.1.0.3-setup.zip
unzip -p bdmsl-webapp-5.1.0.3.war META-INF/MANIFEST.MF
```

Extract:

```bash
rm -rf extracted
mkdir -p extracted
unzip -q bdmsl-webapp-5.1.0.3-setup.zip -d extracted
```

Inspect config/DDL:

```bash
sed -n '1,320p' extracted/bdmsl-webapp-5.1.0.3/sml.config.properties
cat extracted/bdmsl-webapp-5.1.0.3/database-scripts/mysql-data.sql
sed -n '1,260p' extracted/bdmsl-webapp-5.1.0.3/database-scripts/mysql.ddl
```

## Create database

```sql
CREATE DATABASE sml_schema CHARACTER SET utf8mb3 COLLATE utf8mb3_bin;   -- utf8_bin is the same collation
CREATE USER 'sml_dbuser'@'localhost' IDENTIFIED BY '<PRIVATE_PASSWORD>';
GRANT ALL PRIVILEGES ON sml_schema.* TO 'sml_dbuser'@'localhost';
FLUSH PRIVILEGES;
```

Import:

```bash
sudo mysql sml_schema < mysql.ddl && sudo mysql sml_schema < mysql-data.sql   # seed only if DDL succeeded
```

Validate:

```bash
sudo mysql -NBe "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='sml_schema';"
mysql -u sml_dbuser -p -D sml_schema -e \
  "SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema='sml_schema';"
```

## Create runtime user and directories

```bash
sudo useradd --system --home /opt/domisml --shell /usr/sbin/nologin --user-group domisml

sudo mkdir -p \
  /opt/domisml \
  /data/domisml/logs \
  /data/domisml/security \
  /data/domisml/domisml-libs \
  /data/domisml/tmp \
  /data/domisml/backups

sudo chown -R domisml:domisml /opt/domisml /data/domisml
sudo chmod 750 /opt/domisml /data/domisml /data/domisml/*
```

## Install Tomcat and Connector/J

```bash
sudo tar -xzf ~/dl/domismp/apache-tomcat-10.1.59.tar.gz \
  --strip-components=1 -C /opt/domisml
sudo chown -R domisml:domisml /opt/domisml

sudo cp ~/dl/domismp/mysql-connector-j-8.4.0.jar /opt/domisml/lib/
sudo chown domisml:domisml /opt/domisml/lib/mysql-connector-j-8.4.0.jar
sudo chmod 640 /opt/domisml/lib/mysql-connector-j-8.4.0.jar
```

## Port changes

In `/opt/domisml/conf/server.xml`:

```text
8005 -> 8006
8080 -> 8081
```

## Classpath and JVM

Create `/opt/domisml/classes` and `/opt/domisml/bin/setenv.sh` with the settings recorded in the config reference.

## Security baseline files

```bash
sudo cp encriptionPrivateKey.private /data/domisml/security/
sudo cp keystore.jks /data/domisml/security/
sudo cp truststore.p12 /data/domisml/security/
sudo chown domisml:domisml /data/domisml/security/*
sudo chmod 600 /data/domisml/security/*
```

## Database security path update

```sql
UPDATE sml_schema.bdmsl_configuration
SET value='/data/domisml/security', last_updated_on=NOW()
WHERE property IN ('sml.security.folder','configurationDir');
```

## Clear unused sample passwords

```sql
UPDATE sml_schema.bdmsl_configuration
SET value=NULL, last_updated_on=NOW()
WHERE property IN ('httpProxyPassword','keystorePassword');
```

## Preserve and clear stale truststore password rows

Backup rows with `mysqldump --where=...` into `/data/domisml/backups/`, mode 600.

Then:

```sql
UPDATE sml_schema.bdmsl_configuration
SET value=NULL, last_updated_on=NOW()
WHERE property IN ('truststorePassword','truststorePassword.decrypted');
```

## Manual lifecycle

```bash
sudo -u domisml /opt/domisml/bin/startup.sh
sudo -u domisml /opt/domisml/bin/shutdown.sh 30 -force
```

## Logback diagnosis

```bash
PID=$(pgrep -f 'catalina.base=/opt/domisml' | head -1)
sudo readlink -f "/proc/$PID/cwd"
sudo lsof -p "$PID" | grep -E 'domisml(-security|-business)?[^/]*\.log'
sudo -u domisml /usr/lib/jvm/temurin-21-jdk-amd64/bin/jcmd "$PID" VM.system_properties
```

Fix in `setenv.sh`:

```text
-Dsml.log.folder=/data/domisml/logs
```

## App-specific JNDI

Create:

```text
/opt/domisml/conf/Catalina/localhost/edelivery-sml.xml
```

Restore global context from the pre-JNDI backup and set `minIdle=2` in the app-specific pool.

## systemd

```bash
sudo systemd-analyze verify /etc/systemd/system/domisml.service
sudo systemctl daemon-reload
sudo systemctl enable domisml
sudo systemctl start domisml
```

## Cold reboot proof

```bash
sudo reboot
```

After reconnect:

```bash
hostname
findmnt /data
systemctl is-active mysql
systemctl is-enabled domismp
systemctl is-active domismp
systemctl is-enabled domisml
systemctl is-active domisml
pgrep -af 'catalina.base=/opt/domismp'
pgrep -af 'catalina.base=/opt/domisml'
sudo ss -ltnp | grep -E ':8080|:8081'
curl -sS -o /dev/null -w 'DomiSMP HTTP %{http_code}\n' http://127.0.0.1:8080/smp/
curl -sS -o /dev/null -w 'DomiSML HTTP %{http_code}\n' http://127.0.0.1:8081/edelivery-sml/
```

## Final configuration reference (sanitized)

### DomiSMP SDK-lab domain

```text
Domain Code                  sdk-lab
Visibility                   Public
Response signature alias     sdk_lab_smp_signing
Resource type                edelivery-oasis-smp-1.0-servicegroup (smp-1)
Domain member                system / ADMIN
SML registration             not yet performed
```

### DomiSMP signing PKI

```text
Root CN     SDK Lab SMP Root CA
Leaf CN     sdk-core SMP Signing
Alias       sdk_lab_smp_signing
Leaf KU     Digital Signature
Leaf CA     false
```

### DomiSML `sml.config.properties`

```properties
sml.hibernate.dialect=org.hibernate.dialect.MySQLDialect
sml.datasource.jndi=java:comp/env/jdbc/edelivery
sml.jsp.servlet.class=org.apache.jasper.servlet.JspServlet
sml.log.folder=/data/domisml/logs
sml.libraries.folder=/data/domisml/domisml-libs
sml.security.folder=/data/domisml/security
log.configuration.file=/opt/domisml/classes/sml-logback.xml
sml.ws.servicemetadataservices.schema-validation-enabled=true
sml.ws.participantservices.schema-validation-enabled=true
sml.ws.bdmslservices.schema-validation-enabled=true
sml.ws.bdmsladminservices.schema-validation-enabled=true
```

### DomiSML `setenv.sh`

```sh
#!/bin/sh
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export CATALINA_PID=/opt/domisml/temp/tomcat.pid
export CLASSPATH=/opt/domisml/classes
JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dsml.log.folder=/data/domisml/logs"
export JAVA_OPTS
```

### DomiSML app-scoped JNDI

```xml
<Context>
  <Resource
      name="jdbc/edelivery"
      auth="Container"
      type="javax.sql.DataSource"
      factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
      driverClassName="com.mysql.cj.jdbc.Driver"
      url="jdbc:mysql://localhost:3306/sml_schema?useSSL=false&amp;allowPublicKeyRetrieval=true&amp;serverTimezone=UTC"
      username="sml_dbuser"
      password="<REDACTED_DB_PASSWORD>"
      maxTotal="20"
      maxIdle="8"
      minIdle="2"
      maxWaitMillis="10000"
      validationQuery="SELECT 1"
      testOnBorrow="true"
  />
</Context>
```

### DomiSML systemd

See [systemd & reboot](10-systemd-reboot.md#final-unit) or [`evidence/sdk-sml/configs/domisml.service`](https://github.com/DIGG2ForTheWin/local-environment-setup-docs/tree/main/evidence/sdk-sml/configs).
