# Screenshot evidence gallery

This chapter indexes the reviewed screenshot archive supplied for the lab. The images are presented as supporting evidence, not as a substitute for the command/text documentation. Captions describe what is visibly supported by each image or by its immediate sequence.

!!! warning "Sensitive screenshots intentionally omitted"
    Two source screenshots captured at `21:50:42` and `21:50:48` displayed generated Domibus administrator passwords in clear text. They are **not** included in this repository. Their diagnostic significance is documented in the admin-recovery and security chapters without reproducing the credentials.

## How to read the timestamps

Asset names use the screenshot capture timestamp: `20260915-HHMMSS.png`. Application logs visible inside screenshots often use UTC, so their internal log time can differ from the desktop capture time.

## VMware network and VM provisioning

### 17:54:19

<img src="assets/screenshots/20260915-175419.png" alt="VMware Virtual Network Editor showing the custom VMnet3 host-only network on 192.168.50.0/24." width="900">

*VMware Virtual Network Editor showing the custom VMnet3 host-only network on 192.168.50.0/24.*

### 18:25:13

<img src="assets/screenshots/20260915-182513.png" alt="VM creation: recommended LSI Logic SCSI controller selected." width="900">

*VM creation: recommended LSI Logic SCSI controller selected.*

### 18:25:23

<img src="assets/screenshots/20260915-182523.png" alt="VM creation: SCSI virtual disk type selected." width="900">

*VM creation: SCSI virtual disk type selected.*

### 18:25:43

<img src="assets/screenshots/20260915-182543.png" alt="VM creation: 60 GB virtual OS disk configured as a single file." width="900">

*VM creation: 60 GB virtual OS disk configured as a single file.*

## Ubuntu installation, base services and root-volume preparation

### 18:50:46

<img src="assets/screenshots/20260915-185046.png" alt="Build evidence captured at 18:50:46 during the ubuntu installation, base services and root-volume preparation phase." width="900">

*Build evidence captured at 18:50:46 during the ubuntu installation, base services and root-volume preparation phase.*

### 18:51:47

<img src="assets/screenshots/20260915-185147.png" alt="Ubuntu installer could not unmount /cdrom and requested removal of the installation medium." width="900">

*Ubuntu installer could not unmount /cdrom and requested removal of the installation medium.*

### 18:52:42

<img src="assets/screenshots/20260915-185242.png" alt="VM hardware settings used to disconnect/change the virtual installation media." width="900">

*VM hardware settings used to disconnect/change the virtual installation media.*

### 18:54:25

<img src="assets/screenshots/20260915-185425.png" alt="Build evidence captured at 18:54:25 during the ubuntu installation, base services and root-volume preparation phase." width="900">

*Build evidence captured at 18:54:25 during the ubuntu installation, base services and root-volume preparation phase.*

### 18:56:05

<img src="assets/screenshots/20260915-185605.png" alt="Initial Blue hostname, interface, disk and root-filesystem audit." width="900">

*Initial Blue hostname, interface, disk and root-filesystem audit.*

### 18:59:03

<img src="assets/screenshots/20260915-185903.png" alt="Blue root LVM/filesystem expansion to use the available OS disk." width="900">

*Blue root LVM/filesystem expansion to use the available OS disk.*

### 19:04:09

<img src="assets/screenshots/20260915-190409.png" alt="iperf3 package configuration prompt; daemon/autostart was deliberately not enabled." width="900">

*iperf3 package configuration prompt; daemon/autostart was deliberately not enabled.*

### 19:07:16

<img src="assets/screenshots/20260915-190716.png" alt="Base service/version audit showing SSH, open-vm-tools, Python and networking." width="900">

*Base service/version audit showing SSH, open-vm-tools, Python and networking.*

### 19:09:44

<img src="assets/screenshots/20260915-190944.png" alt="SSH service state and socket/process evidence." width="900">

*SSH service state and socket/process evidence.*

### 19:10:28

<img src="assets/screenshots/20260915-191028.png" alt="Build evidence captured at 19:10:28 during the ubuntu installation, base services and root-volume preparation phase." width="900">

*Build evidence captured at 19:10:28 during the ubuntu installation, base services and root-volume preparation phase.*

### 19:11:35

<img src="assets/screenshots/20260915-191135.png" alt="APT update showing four phased netplan-related upgrades deferred." width="900">

*APT update showing four phased netplan-related upgrades deferred.*

### 19:14:06

<img src="assets/screenshots/20260915-191406.png" alt="Post-reboot baseline audit of network, services and filesystem." width="900">

*Post-reboot baseline audit of network, services and filesystem.*

### 19:29:32

<img src="assets/screenshots/20260915-192932.png" alt="Guest identity/SSH host-key regeneration work for a distinct cloned VM." width="900">

*Guest identity/SSH host-key regeneration work for a distinct cloned VM.*

## Cloned-VM identity and host-only networking

### 19:31:56

<img src="assets/screenshots/20260915-193156.png" alt="Windows OpenSSH host-key-changed warning after guest identity work." width="900">

*Windows OpenSSH host-key-changed warning after guest identity work.*

### 19:34:48

<img src="assets/screenshots/20260915-193448.png" alt="Guest static host-only networking and route verification." width="900">

*Guest static host-only networking and route verification.*

### 19:37:10

<img src="assets/screenshots/20260915-193710.png" alt="Windows VMnet3 adapter temporarily using APIPA 169.254.79.25/16 before manual correction." width="900">

*Windows VMnet3 adapter temporarily using APIPA 169.254.79.25/16 before manual correction.*

### 19:42:16

<img src="assets/screenshots/20260915-194216.png" alt="Build evidence captured at 19:42:16 during the cloned-vm identity and host-only networking phase." width="900">

*Build evidence captured at 19:42:16 during the cloned-vm identity and host-only networking phase.*

### 19:50:04

<img src="assets/screenshots/20260915-195004.png" alt="Build evidence captured at 19:50:04 during the cloned-vm identity and host-only networking phase." width="900">

*Build evidence captured at 19:50:04 during the cloned-vm identity and host-only networking phase.*

## Persistent data-disk creation and mounts

### 20:06:27

<img src="assets/screenshots/20260915-200627.png" alt="lsblk evidence of the separate 200 GB VMware data disk." width="900">

*lsblk evidence of the separate 200 GB VMware data disk.*

### 20:08:24

<img src="assets/screenshots/20260915-200824.png" alt="GPT partitioning of /dev/sdb for the Domibus data volume." width="900">

*GPT partitioning of /dev/sdb for the Domibus data volume.*

### 20:08:37

<img src="assets/screenshots/20260915-200837.png" alt="ext4 creation, UUID discovery and persistent-mount preparation." width="900">

*ext4 creation, UUID discovery and persistent-mount preparation.*

### 20:08:47

<img src="assets/screenshots/20260915-200847.png" alt="/data mount and directory-tree verification." width="900">

*/data mount and directory-tree verification.*

### 20:09:56

<img src="assets/screenshots/20260915-200956.png" alt="Build evidence captured at 20:09:56 during the persistent data-disk creation and mounts phase." width="900">

*Build evidence captured at 20:09:56 during the persistent data-disk creation and mounts phase.*

### 20:10:08

<img src="assets/screenshots/20260915-201008.png" alt="Persistent /data mount remount test succeeded." width="900">

*Persistent /data mount remount test succeeded.*

### 20:12:31

<img src="assets/screenshots/20260915-201231.png" alt="Red storage inventory showing OS and 200 GB data disks." width="900">

*Red storage inventory showing OS and 200 GB data disks.*

### 20:13:46

<img src="assets/screenshots/20260915-201346.png" alt="Red data disk formatting/UUID/fstab workflow." width="900">

*Red data disk formatting/UUID/fstab workflow.*

### 20:13:56

<img src="assets/screenshots/20260915-201356.png" alt="Creation of the Domibus/stage/baseline/garage/fs_plugin_data directory tree." width="900">

*Creation of the Domibus/stage/baseline/garage/fs_plugin_data directory tree.*

### 20:14:04

<img src="assets/screenshots/20260915-201404.png" alt="Build evidence captured at 20:14:04 during the persistent data-disk creation and mounts phase." width="900">

*Build evidence captured at 20:14:04 during the persistent data-disk creation and mounts phase.*

### 20:17:13

<img src="assets/screenshots/20260915-201713.png" alt="Build evidence captured at 20:17:13 during the persistent data-disk creation and mounts phase." width="900">

*Build evidence captured at 20:17:13 during the persistent data-disk creation and mounts phase.*

## MySQL listener/base package preparation

### 20:25:36

<img src="assets/screenshots/20260915-202536.png" alt="MySQL configuration/socket check showing localhost binding on 127.0.0.1:3306." width="900">

*MySQL configuration/socket check showing localhost binding on 127.0.0.1:3306.*

## Domibus database schema and grants

### 20:37:43

<img src="assets/screenshots/20260915-203743.png" alt="Inspection of Domibus MySQL SQL scripts before import." width="900">

*Inspection of Domibus MySQL SQL scripts before import.*

### 20:37:48

<img src="assets/screenshots/20260915-203748.png" alt="Build evidence captured at 20:37:48 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:37:48 during the domibus database schema and grants phase.*

### 20:37:55

<img src="assets/screenshots/20260915-203755.png" alt="Build evidence captured at 20:37:55 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:37:55 during the domibus database schema and grants phase.*

### 20:38:04

<img src="assets/screenshots/20260915-203804.png" alt="Build evidence captured at 20:38:04 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:38:04 during the domibus database schema and grants phase.*

### 20:38:13

<img src="assets/screenshots/20260915-203813.png" alt="Build evidence captured at 20:38:13 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:38:13 during the domibus database schema and grants phase.*

### 20:38:21

<img src="assets/screenshots/20260915-203821.png" alt="Build evidence captured at 20:38:21 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:38:21 during the domibus database schema and grants phase.*

### 20:38:28

<img src="assets/screenshots/20260915-203828.png" alt="Build evidence captured at 20:38:28 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:38:28 during the domibus database schema and grants phase.*

### 20:38:44

<img src="assets/screenshots/20260915-203844.png" alt="Build evidence captured at 20:38:44 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:38:44 during the domibus database schema and grants phase.*

### 20:44:38

<img src="assets/screenshots/20260915-204438.png" alt="edelivery_user database identity and grants verification." width="900">

*edelivery_user database identity and grants verification.*

### 20:45:36

<img src="assets/screenshots/20260915-204536.png" alt="Initial MySQL schema import failure with ERROR 1419." width="900">

*Initial MySQL schema import failure with ERROR 1419.*

### 20:48:17

<img src="assets/screenshots/20260915-204817.png" alt="Successful DB validation after workaround; schema/version/grants and trust setting checked." width="900">

*Successful DB validation after workaround; schema/version/grants and trust setting checked.*

### 20:49:35

<img src="assets/screenshots/20260915-204935.png" alt="Build evidence captured at 20:49:35 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:49:35 during the domibus database schema and grants phase.*

### 20:49:46

<img src="assets/screenshots/20260915-204946.png" alt="Build evidence captured at 20:49:46 during the domibus database schema and grants phase." width="900">

*Build evidence captured at 20:49:46 during the domibus database schema and grants phase.*

### 20:49:55

<img src="assets/screenshots/20260915-204955.png" alt="Direct proof that TB_VERSION exists in domibus_schema." width="900">

*Direct proof that TB_VERSION exists in domibus_schema.*

## Domibus distributions, samples and JDBC driver

### 20:53:55

<img src="assets/screenshots/20260915-205355.png" alt="Domibus schema validation showing 119 tables and version information." width="900">

*Domibus schema validation showing 119 tables and version information.*

### 20:55:37

<img src="assets/screenshots/20260915-205537.png" alt="Inspection of the full Domibus 5.2.1.3 Tomcat distribution archive." width="900">

*Inspection of the full Domibus 5.2.1.3 Tomcat distribution archive.*

### 20:55:49

<img src="assets/screenshots/20260915-205549.png" alt="Build evidence captured at 20:55:49 during the domibus distributions, samples and jdbc driver phase." width="900">

*Build evidence captured at 20:55:49 during the domibus distributions, samples and jdbc driver phase.*

### 20:56:03

<img src="assets/screenshots/20260915-205603.png" alt="Build evidence captured at 20:56:03 during the domibus distributions, samples and jdbc driver phase." width="900">

*Build evidence captured at 20:56:03 during the domibus distributions, samples and jdbc driver phase.*

### 20:56:14

<img src="assets/screenshots/20260915-205614.png" alt="Build evidence captured at 20:56:14 during the domibus distributions, samples and jdbc driver phase." width="900">

*Build evidence captured at 20:56:14 during the domibus distributions, samples and jdbc driver phase.*

### 20:56:27

<img src="assets/screenshots/20260915-205627.png" alt="Build evidence captured at 20:56:27 during the domibus distributions, samples and jdbc driver phase." width="900">

*Build evidence captured at 20:56:27 during the domibus distributions, samples and jdbc driver phase.*

### 20:56:43

<img src="assets/screenshots/20260915-205643.png" alt="Sample configuration/testing ZIP inventory including PMode, keystores and SoapUI project." width="900">

*Sample configuration/testing ZIP inventory including PMode, keystores and SoapUI project.*

### 20:56:57

<img src="assets/screenshots/20260915-205657.png" alt="Filtered sample archive paths relevant to PMode and cryptographic stores." width="900">

*Filtered sample archive paths relevant to PMode and cryptographic stores.*

### 20:57:18

<img src="assets/screenshots/20260915-205718.png" alt="MySQL Connector/J JAR manifest showing release 8.4.0." width="900">

*MySQL Connector/J JAR manifest showing release 8.4.0.*

## Domibus configuration and first startup

### 21:00:07

<img src="assets/screenshots/20260915-210007.png" alt="Initial inspection of supplied Domibus properties/configuration." width="900">

*Initial inspection of supplied Domibus properties/configuration.*

### 21:00:19

<img src="assets/screenshots/20260915-210019.png" alt="Build evidence captured at 21:00:19 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:00:19 during the domibus configuration and first startup phase.*

### 21:00:28

<img src="assets/screenshots/20260915-210028.png" alt="Build evidence captured at 21:00:28 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:00:28 during the domibus configuration and first startup phase.*

### 21:00:38

<img src="assets/screenshots/20260915-210038.png" alt="Build evidence captured at 21:00:38 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:00:38 during the domibus configuration and first startup phase.*

### 21:00:49

<img src="assets/screenshots/20260915-210049.png" alt="Build evidence captured at 21:00:49 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:00:49 during the domibus configuration and first startup phase.*

### 21:00:59

<img src="assets/screenshots/20260915-210059.png" alt="Build evidence captured at 21:00:59 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:00:59 during the domibus configuration and first startup phase.*

### 21:01:11

<img src="assets/screenshots/20260915-210111.png" alt="Build evidence captured at 21:01:11 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:01:11 during the domibus configuration and first startup phase.*

### 21:01:26

<img src="assets/screenshots/20260915-210126.png" alt="Build evidence captured at 21:01:26 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:01:26 during the domibus configuration and first startup phase.*

### 21:01:42

<img src="assets/screenshots/20260915-210142.png" alt="Build evidence captured at 21:01:42 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:01:42 during the domibus configuration and first startup phase.*

### 21:01:52

<img src="assets/screenshots/20260915-210152.png" alt="Build evidence captured at 21:01:52 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:01:52 during the domibus configuration and first startup phase.*

### 21:02:12

<img src="assets/screenshots/20260915-210212.png" alt="Build evidence captured at 21:02:12 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:02:12 during the domibus configuration and first startup phase.*

### 21:02:26

<img src="assets/screenshots/20260915-210226.png" alt="Build evidence captured at 21:02:26 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:02:26 during the domibus configuration and first startup phase.*

### 21:02:37

<img src="assets/screenshots/20260915-210237.png" alt="Build evidence captured at 21:02:37 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:02:37 during the domibus configuration and first startup phase.*

### 21:02:48

<img src="assets/screenshots/20260915-210248.png" alt="Build evidence captured at 21:02:48 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:02:48 during the domibus configuration and first startup phase.*

### 21:03:00

<img src="assets/screenshots/20260915-210300.png" alt="Build evidence captured at 21:03:00 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:03:00 during the domibus configuration and first startup phase.*

### 21:03:15

<img src="assets/screenshots/20260915-210315.png" alt="Build evidence captured at 21:03:15 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:03:15 during the domibus configuration and first startup phase.*

### 21:03:25

<img src="assets/screenshots/20260915-210325.png" alt="Build evidence captured at 21:03:25 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:03:25 during the domibus configuration and first startup phase.*

### 21:04:05

<img src="assets/screenshots/20260915-210405.png" alt="Tomcat/Java runtime version checks." width="900">

*Tomcat/Java runtime version checks.*

### 21:04:12

<img src="assets/screenshots/20260915-210412.png" alt="Build evidence captured at 21:04:12 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:04:12 during the domibus configuration and first startup phase.*

### 21:08:00

<img src="assets/screenshots/20260915-210800.png" alt="Editing Domibus properties for the lab configuration." width="900">

*Editing Domibus properties for the lab configuration.*

### 21:08:42

<img src="assets/screenshots/20260915-210842.png" alt="Continued Domibus properties customization." width="900">

*Continued Domibus properties customization.*

### 21:14:19

<img src="assets/screenshots/20260915-211419.png" alt="Domibus startup-log inspection during first application bring-up." width="900">

*Domibus startup-log inspection during first application bring-up.*

### 21:14:25

<img src="assets/screenshots/20260915-211425.png" alt="Webapp/process verification after startup." width="900">

*Webapp/process verification after startup.*

### 21:15:48

<img src="assets/screenshots/20260915-211548.png" alt="Startup-log filtering to verify deployment state." width="900">

*Startup-log filtering to verify deployment state.*

### 21:15:54

<img src="assets/screenshots/20260915-211554.png" alt="Recent startup log showing Domibus/Tomcat initialization activity." width="900">

*Recent startup log showing Domibus/Tomcat initialization activity.*

### 21:16:02

<img src="assets/screenshots/20260915-211602.png" alt="Domibus Administration Console login page reachable in a browser." width="900">

*Domibus Administration Console login page reachable in a browser.*

### 21:16:17

<img src="assets/screenshots/20260915-211617.png" alt="Windows-side network/HTTP verification against the Domibus VM." width="900">

*Windows-side network/HTTP verification against the Domibus VM.*

### 21:17:33

<img src="assets/screenshots/20260915-211733.png" alt="Build evidence captured at 21:17:33 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:17:33 during the domibus configuration and first startup phase.*

### 21:17:44

<img src="assets/screenshots/20260915-211744.png" alt="Build evidence captured at 21:17:44 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:17:44 during the domibus configuration and first startup phase.*

### 21:17:57

<img src="assets/screenshots/20260915-211757.png" alt="Build evidence captured at 21:17:57 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:17:57 during the domibus configuration and first startup phase.*

### 21:18:06

<img src="assets/screenshots/20260915-211806.png" alt="Build evidence captured at 21:18:06 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:18:06 during the domibus configuration and first startup phase.*

### 21:18:12

<img src="assets/screenshots/20260915-211812.png" alt="Build evidence captured at 21:18:12 during the domibus configuration and first startup phase." width="900">

*Build evidence captured at 21:18:12 during the domibus configuration and first startup phase.*

## Runtime troubleshooting and payload configuration

### 21:20:26

<img src="assets/screenshots/20260915-212026.png" alt="MySQL/network listener validation during application troubleshooting." width="900">

*MySQL/network listener validation during application troubleshooting.*

### 21:21:47

<img src="assets/screenshots/20260915-212147.png" alt="Build evidence captured at 21:21:47 during the runtime troubleshooting and payload configuration phase." width="900">

*Build evidence captured at 21:21:47 during the runtime troubleshooting and payload configuration phase.*

### 21:22:10

<img src="assets/screenshots/20260915-212210.png" alt="Domibus payload/storage-related property inspection." width="900">

*Domibus payload/storage-related property inspection.*

### 21:22:20

<img src="assets/screenshots/20260915-212220.png" alt="Further payload/storage configuration inspection." width="900">

*Further payload/storage configuration inspection.*

### 21:28:31

<img src="assets/screenshots/20260915-212831.png" alt="Blue runtime status/log audit." width="900">

*Blue runtime status/log audit.*

### 21:29:44

<img src="assets/screenshots/20260915-212944.png" alt="Java/Tomcat process, filesystem and log verification on Blue." width="900">

*Java/Tomcat process, filesystem and log verification on Blue.*

## Certificates and PMode configuration

### 21:31:42

<img src="assets/screenshots/20260915-213142.png" alt="Gateway keystore/truststore inspection with keytool." width="900">

*Gateway keystore/truststore inspection with keytool.*

### 21:33:25

<img src="assets/screenshots/20260915-213325.png" alt="Blue PMode XML inspection: parties, services, actions and legs." width="900">

*Blue PMode XML inspection: parties, services, actions and legs.*

### 21:33:45

<img src="assets/screenshots/20260915-213345.png" alt="Blue PMode XML inspection continued." width="900">

*Blue PMode XML inspection continued.*

### 21:33:56

<img src="assets/screenshots/20260915-213356.png" alt="Blue PMode XML structure and reliability/security sections." width="900">

*Blue PMode XML structure and reliability/security sections.*

### 21:34:06

<img src="assets/screenshots/20260915-213406.png" alt="PMode payload/property/security configuration inspection." width="900">

*PMode payload/property/security configuration inspection.*

### 21:34:18

<img src="assets/screenshots/20260915-213418.png" alt="PMode reliability/error-handling configuration inspection." width="900">

*PMode reliability/error-handling configuration inspection.*

### 21:34:33

<img src="assets/screenshots/20260915-213433.png" alt="PMode response/leg configuration inspection." width="900">

*PMode response/leg configuration inspection.*

### 21:34:43

<img src="assets/screenshots/20260915-213443.png" alt="PMode endpoint and leg configuration inspection." width="900">

*PMode endpoint and leg configuration inspection.*

### 21:34:49

<img src="assets/screenshots/20260915-213449.png" alt="PMode grep/validation checks." width="900">

*PMode grep/validation checks.*

### 21:38:18

<img src="assets/screenshots/20260915-213818.png" alt="Final Blue lab PMode endpoint verification and XML well-formedness check." width="900">

*Final Blue lab PMode endpoint verification and XML well-formedness check.*

## Admin-account/database recovery

### 21:42:19

<img src="assets/screenshots/20260915-214219.png" alt="Controlled Domibus stop/process/port checks during admin-account recovery." width="900">

*Controlled Domibus stop/process/port checks during admin-account recovery.*

### 21:43:37

<img src="assets/screenshots/20260915-214337.png" alt="Build evidence captured at 21:43:37 during the admin-account/database recovery phase." width="900">

*Build evidence captured at 21:43:37 during the admin-account/database recovery phase.*

### 21:47:34

<img src="assets/screenshots/20260915-214734.png" alt="Database backup/admin recovery verification work." width="900">

*Database backup/admin recovery verification work.*

### 21:49:12

<img src="assets/screenshots/20260915-214912.png" alt="Domibus TB_USER/TB_USER_ROLES/TB_USER_PASSWORD_HISTORY structure inspection." width="900">

*Domibus TB_USER/TB_USER_ROLES/TB_USER_PASSWORD_HISTORY structure inspection.*

### 21:49:22

<img src="assets/screenshots/20260915-214922.png" alt="Admin-related database table structure inspection continued." width="900">

*Admin-related database table structure inspection continued.*

### 21:49:29

<img src="assets/screenshots/20260915-214929.png" alt="Admin-related DB schema/row structure verification." width="900">

*Admin-related DB schema/row structure verification.*

## Post-recovery Domibus startup validation

### 21:51:12

<img src="assets/screenshots/20260915-215112.png" alt="Post-recovery Domibus startup log; version 5.2.1.3-JEE10 and datasource initialization visible." width="900">

*Post-recovery Domibus startup log; version 5.2.1.3-JEE10 and datasource initialization visible.*

### 21:51:37

<img src="assets/screenshots/20260915-215137.png" alt="Post-recovery Spring/Domibus initialization log continuation." width="900">

*Post-recovery Spring/Domibus initialization log continuation.*
