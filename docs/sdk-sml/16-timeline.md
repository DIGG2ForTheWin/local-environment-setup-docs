# Timeline

Times are Windows local time (CEST) for screenshots, UTC in logs (e.g. systemd `12:26:42 UTC` = screenshot `14:28`).

1. Resume from `02-domismp-installed` with DomiSMP healthy.
2. Inspect DomiSMP domains, groups, extensions, resource definitions and participant count.
3. Confirm no SDK participant resources exist yet.
4. Inspect Domain and Keystore UI.
5. Identify vendor aliases `issuer` and `sample_key` and decide not to use them as SDK-lab identity.
6. Attempt an initial PKI location under `/data/domismp`; discover operator traversal restriction.
7. Remove the mistaken PKI location and use `/data/sdk-pki` instead.
8. Generate RSA-4096 SDK Lab SMP Root CA private key.
9. Issue initial root certificate.
10. Notice missing explicit CA Key Usage.
11. Preserve the original certificate and reissue with critical Certificate Sign + CRL Sign.
12. Generate RSA-3072 leaf key and CSR for `sdk-core SMP Signing`.
13. Sign leaf with `CA:FALSE`, critical Digital Signature, SKI/AKI.
14. Verify leaf against root with OpenSSL.
15. Export leaf + chain to PKCS#12 alias `sdk_lab_smp_signing`.
16. Verify PKCS#12 as PrivateKeyEntry with chain length 2.
17. Copy only the `.p12` to Windows installers directory.
18. Open DomiSMP Import keystore dialog.
19. Troubleshoot non-obvious file picker and read-only filename field.
20. Import PKCS#12 successfully.
21. Verify alias, subject, issuer, serial and X.509 extensions in UI.
22. Create DomiSMP domain `sdk-lab`, Public, response-signing alias `sdk_lab_smp_signing`.
23. Observe incomplete-domain banner.
24. Select only `edelivery-oasis-smp-1.0-servicegroup (smp-1)`.
25. Add `system` as `ADMIN` domain member.
26. Inspect identifier-behaviour properties; make no changes.
27. Inspect generic BDMSL integration defaults.
28. Inspect SML integration tab; keep all registration fields empty.
29. Note that response-signing cert and SML client cert are separate roles.
30. Decide not to touch real Digg SML.
31. Check sdk-core capacity: RAM, root disk, /data, free ports, MySQL.
32. Choose separate local DomiSML runtime on port 8081.
33. Download DomiSML 5.1.0.3 WAR and setup ZIP.
34. Verify both published MD5 checksums.
35. Inspect setup ZIP, WAR manifest, SQL, config, security files.
36. Inspect DomiSML MySQL DDL and large/indexed columns.
37. Decide on a `utf8mb3`/`utf8mb3_bin` schema before import.
38. Save secret-retrieval commands rather than secret values.
39. Create `sml_schema` and `sml_dbuser@localhost`.
40. A DB password is exposed in chat; it is later changed and never preserved in docs.
41. Import DDL successfully; validate 19 tables.
42. Import seed; validate 32 config rows and three vendor subdomains.
43. Validate actual `sml_dbuser` access.
44. Create `domisml` service account.
45. Create `/data/domisml/{logs,security,domisml-libs,tmp,backups}`.
46. Install separate Tomcat 10.1.59 under `/opt/domisml`.
47. Copy Connector/J 8.4.0 into DomiSML Tomcat.
48. Change DomiSML shutdown port to 8006 and HTTP port to 8081.
49. Create `/opt/domisml/classes` and `setenv.sh`.
50. Set 512m/1024m heap.
51. Copy `sml.config.properties` and `sml-logback.xml` to classpath.
52. Add `/data/domisml` log/library/security paths.
53. Fix ownership so `domisml` can read both config files.
54. Create initial JNDI datasource in global `context.xml`.
55. Run Tomcat `configtest.sh` successfully.
56. Deploy WAR as `edelivery-sml.war`.
57. First manual boot: Java, 8081, deployment and HTTP 200 all succeed.
58. Discover runtime security path still points at `/opt/smlconf/` from DB.
59. Update both `configurationDir` and `sml.security.folder` to `/data/domisml/security`.
60. Restart; file-not-found errors disappear.
61. New decryption failures show vendor ciphertext/key mismatch.
62. Confirm `signResponse=false` and `useProxy=false`.
63. Preserve vendor encryption key in backups.
64. Null unused `httpProxyPassword` and `keystorePassword`.
65. Restart and let DomiSML generate its own encryption key.
66. Identify remaining encrypted truststore properties by safe inventory.
67. Preserve those DB rows via restricted `mysqldump`.
68. Null `truststorePassword` and `truststorePassword.decrypted`.
69. Restart; decryption/security errors disappear.
70. Investigate why `/data/domisml/logs` remains empty.
71. Confirm custom Logback XML is actually loaded.
72. Confirm all file appenders are wired to root.
73. Use `lsof` to find active logs under `/tmp/hsperfdata_domisml/logs`.
74. Use `jcmd` to show `sml.log.folder` is not a JVM property.
75. Add `-Dsml.log.folder=/data/domisml/logs` to `JAVA_OPTS`.
76. Restart; verify JVM property and open files under `/data/domisml/logs`.
77. Remove old fallback `logs` subdirectory only after confirming no open handles.
78. Observe global JNDI pool warning `maxIdle < minIdle` and repeated pool creation for default webapps.
79. Back up secret-bearing global context.
80. Create app-specific `conf/Catalina/localhost/edelivery-sml.xml`.
81. Add `minIdle=2` and keep maxIdle 8 / maxTotal 20.
82. Restore clean global context and verify no global datasource.
83. Restart; HTTP 200, no pool warning, no datasource error.
84. Stop manual runtime.
85. Create and verify `domisml.service`.
86. Enable/start DomiSML under systemd.
87. Verify unit, Java PID, 8081, HTTP 200, logs and no warnings.
88. Check pre-reboot DomiSMP + DomiSML + MySQL + /data state.
89. Reboot `sdk-core`.
90. Reconnect over SSH.
91. Verify /data mounted, MySQL active.
92. Verify DomiSMP enabled/active, Java PID, 8080, HTTP 200, no current-boot errors.
93. Verify DomiSML enabled/active, Java PID, 8081, HTTP 200, no current-boot errors.
94. Verify both application log trees are writing.
95. Declare cold reboot proof PASS.
96. Reserve the next snapshot as `03-DomiSML-Installed` (not yet taken).
97. Stop before local DNS/SML SDK-specific integration.
