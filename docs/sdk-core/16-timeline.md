# Timeline

## VM inventory and storage

1. Confirm `sdk-core` hostname and Ubuntu 24.04.5 LTS.
2. Confirm NAT on `ens33` and host-only `192.168.50.30/24` on `ens34`.
3. Confirm Temurin JDK 21 and MySQL 8.0.46 already installed.
4. Confirm no existing SDK/SMP/Domibus artifacts under `/home/xander`, `/opt` or `/data`.
5. Add a new 100 GB SCSI disk as `/dev/sdb`.
6. Partition as GPT `/dev/sdb1`.
7. Format ext4 with label `sdk-core-data`.
8. Mount at `/data` by UUID `f07b76d6-2fee-4add-8902-5503a6d2e603`.
9. Create baseline/stage/DomiSMP directories.
10. Observe harmless `lost+found` permission message.

## Package selection and inspection

11. Select DomiSMP 5.2.1.3.
12. Reuse already downloaded `smp-5.2.1.3.war` and `smp-5.2.1.3-setup.zip` from Windows.
13. Copy both to `/home/xander/dl/domismp`.
14. Inspect archive types and setup contents.
15. Confirm fresh MySQL DDL/data scripts and upgrade migration directories.
16. Inspect WAR manifest and confirm version/build JDK metadata.
17. Extract setup bundle for inspection.
18. Inspect `readme.txt`, `smp.config.properties`, `smp-logback.xml`, `mysql.ddl`, `mysql-data.sql`.
19. Choose Tomcat JNDI rather than direct JDBC properties.

## Database

20. Create `smp` DB and `smp@localhost` account.
21. Accidentally use placeholder text as password.
22. Immediately rotate to a private password.
23. Verify `caching_sha2_password`.
24. First import using `utf8mb4` fails at DDL line 699 with `ERROR 1071`.
25. Seed script still runs, leaving a misleading partial 50-table state.
26. Inspect DDL around line 699 and identify unique index on `varchar(1024) CERTIFICATE_ID`.
27. Confirm `utf8mb4_unicode_ci` database charset.
28. Drop partial DB.
29. Recreate with `utf8mb3_unicode_ci`.
30. Re-import DDL successfully.
31. Verify the previously failing certificate unique index exists.
32. Import seed data.
33. Validate 50 tables, seeded users, domain and OASIS SMP extension.
34. Validate login as `smp@localhost`.

## Tomcat and application

35. Create `domismp` system account.
36. Create final persistent `/data/domismp` directories and assign ownership.
37. Install Apache Tomcat 10.1.59 under `/opt/domismp`.
38. Verify Tomcat/Java versions.
39. Deploy WAR as `/opt/domismp/webapps/smp.war`.
40. Transfer Connector/J 8.4.0 from Blue.
41. Attempt `chown` before copying JAR into Tomcat; receive “No such file”.
42. Copy JAR to `/opt/domismp/lib` and verify 8.4.0.
43. Copy/configure `smp.config.properties` and `smp-logback.xml`.
44. Configure JNDI datasource in Tomcat `context.xml`.
45. Protect secret-bearing `context.xml` as mode 600.
46. Run Tomcat config test successfully.
47. Create `setenv.sh` with explicit Temurin JAVA_HOME, PID file and heap settings.

## First startup and corrections

48. Start Tomcat manually as `domismp`.
49. Verify Java process and port 8080.
50. Confirm DomiSMP JNDI datasource initialization.
51. Confirm WAR deployment and HTTP 200.
52. Observe early Logback relative-path failure before final application logging initializes.
53. Confirm `/data/domismp/logs/edelivery-smp.log` nevertheless exists.
54. Edit Logback to use explicit `/data/domismp/logs` paths.
55. Attempt graceful shutdown.
56. Connector stops, but JVM remains; shutdown script times out.
57. Capture thread dump showing a remaining non-daemon scheduled executor (`pool-2-thread-1`).
58. Terminate the already-stopped application's leftover JVM and clear stale PID.
59. Restart after Logback fix.
60. Confirm no Logback path error, HTTP 200, clean deployment.

## UI/admin

61. Open DomiSMP from Windows at `192.168.50.30:8080/smp/`.
62. Confirm DomiSMP 5.2.1.3 landing page.
63. Open public resources UI and login page.
64. Inspect `system` credential DB row and confirm active SYSTEM_ADMIN mapping.
65. Use vendor bootstrap administrator credential once.
66. Change administrator password immediately to a private policy-compliant value.

## systemd and cold boot

67. Create `domismp.service` with MySQL and `/data` dependencies.
68. Use `shutdown.sh 30 -force` in `ExecStop` because of observed shutdown hang.
69. Verify unit and enable/start it.
70. Validate Java/8080/HTTP under systemd.
71. Reboot the VM.
72. Confirm `/data`, MySQL, service, Java, port 8080 and HTTP 200 all return automatically.
73. Confirm `smp.war` deployment in 21,516 ms and Tomcat startup in 22,667 ms.
74. Confirm no current-boot unit errors.

## Baseline checkpoint

75. Replace a long descriptive snapshot name with a numbered short name. It ended up lowercase, unlike the earlier `NN-Title-Case` snapshots ([VMware snapshots](../reference/snapshots.md#naming-convention-for-new-snapshots)).
76. Power down cleanly for snapshot.
77. Create VMware snapshot:

```text
02-domismp-installed
```

78. Power on again and confirm services remain healthy.
79. Stop here before any Swedish SDK-specific SMP configuration.
