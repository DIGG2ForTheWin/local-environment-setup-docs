# Chronological build timeline

This timeline consolidates the retained milestones in order. For a hands-on walkthrough of the same order with download links, see [Build it step by step](00-build-guide.md).

!!! info "Clocks"
    Times in brackets such as *(17:54 local)* come from screenshot filenames, in Windows local time (CEST, UTC+2). Times from logs or the database are UTC. See [Raw observed values](22-raw-observed-values.md#important-timestamps).

## Infrastructure phase

1. Create VMware host-only VMnet3 `192.168.50.0/24` with DHCP disabled *(17:54 local)*.
2. Create the **Blue** VM: approximately 8 GB RAM, 4 processors, 60 GB LSI Logic SCSI OS disk *(18:25 local)*.
3. Install Ubuntu Server 24.04.5 with SSH; disconnect the installation ISO after the `/cdrom` unmount message *(18:50–18:52 local)*.
4. Extend Blue's root LVM to approximately 57 GB with `lvextend -l +100%FREE -r` *(18:59 local)*.
5. Update packages; verify SSH, open-vm-tools and Python *(19:04–19:14 local)*.
6. **Clone Blue to create Red**; regenerate Red's machine identity and SSH host keys; Windows OpenSSH reports the changed host key *(19:29–19:31 local)*.
7. Configure Red `ens34` as `192.168.50.20/24` with netplan *(19:34 local)*.
8. Configure the Windows VMnet3 adapter as `192.168.50.1/24`; it had shown an APIPA `169.254.x` address before *(19:37 local)*.
9. Configure Blue `ens34` as `192.168.50.10/24`; keep `ens33` on NAT on both VMs.
10. Add a 200 GB data disk to Blue: GPT `/dev/sdb1`, ext4, label `domibus-data`, mounted at `/data` by UUID *(20:06–20:10 local)*.
11. Repeat the data disk on Red *(20:12–20:17 local)*.
12. Create Domibus payload/temp and staging directories on both.

## Runtime phase

13. Install Eclipse Temurin JDK 21.
14. Verify Java 21.0.12.1 Temurin.
15. Install MySQL.
16. Download Connector/J 8.4.0 and verify manifest.
17. Download Domibus 5.2.1.3 JEE10 Tomcat full distribution.
18. Download 5.2.1.3 sample configuration/testing ZIP.
19. Download SQL distribution 1.21.

## Database phase

20. Create `domibus_schema`.
21. Create `edelivery_user@localhost`.
22. Grant DB privileges plus `XA_RECOVER_ADMIN`.
23. Begin schema import.
24. Hit MySQL `ERROR 1419`.
25. Temporarily enable `log_bin_trust_function_creators=1`.
26. Complete DDL/data import.
27. Restore the setting to 0.
28. Validate 119 tables and `TB_VERSION.VERSION=5.2.1`.

## Blue Domibus phase

29. Create dedicated `domibus` user/group.
30. Extract Domibus to `/opt/domibus`.
31. Copy Connector/J into `/opt/domibus/lib`.
32. Preserve factory properties backup.
33. Configure MySQL datasource, alias `blue_gw`, payload/temp paths.
34. Verify Blue keystore/private alias.
35. Start Domibus manually.
36. Encounter working-directory/FreeMarker warning and stale-Java confusion.
37. Restart from `/opt/domibus` and verify healthy HTTP.
38. Recover Blue admin account after taking DB backup.
39. Change generated temporary admin password immediately.
40. Customize/upload Blue PMode.
41. Blue PMode DB ID becomes `887790301781046774` at `2026-09-15 20:01:42`.

## Red Domibus phase

42. Copy Domibus distribution/sample/Connector from Blue to Red.
43. Create Red `domibus` account and extract to `/opt/domibus`.
44. Configure Red datasource, alias `red_gw`, payload/temp paths.
45. Verify Red JKS private alias.
46. Start Red around 20:24; observed PID 2082.
47. Change generated Red admin password.
48. Customize/upload Red PMode.
49. Red final PMode ID becomes `887797339501778401` at `2026-09-15 20:29:40`.
50. Verify Blue <-> Red host-only reachability and MSH endpoints.

## WS Plugin discovery

51. Download exact WS Plugin WSDL on Blue.
52. Confirm SOAP 1.2 and target namespace `http://eu.domibus.wsplugin/`.
53. Inspect vendor SoapUI project; keep SoapUI itself out of the runtime toolchain.
54. Extract exact SOAP request from XML using Python.

## Blue -> Red AS4 test

55. First curl attempt fails due to path mangling; no request is sent.
56. Use absolute paths and submit successfully.
57. Receive HTTP 200 and MessageId `331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu`.
58. Blue entity ID `887799183390676475`.
59. Blue encrypts for `red_gw`, signs with `blue_gw`.
60. Red receives/persists payload as entity `887799205223657931`.
61. Red generates non-repudiation receipt.
62. Blue reliability check succeeds and status becomes `ACKNOWLEDGED`.
63. Red status is `RECEIVED`.
64. Extract `listPendingMessages` and `retrieveMessage` vendor requests.
65. Discover retrieve placeholder is `${ResponseParameter#messageID}`, not `${messageID}`.
66. Red lists exact message as pending.
67. Red retrieves payload successfully.
68. Base64 decodes to `<hello>world</hello>`.

## Red -> Blue AS4 test

69. Extract reverse `sendResponse` request.
70. Validate From `domibus-red`, To `domibus-blue`, correct service/action, no unresolved variables.
71. Submit successfully.
72. MessageId `f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu`.
73. Red entity `887802313651713634`.
74. Blue receiver entity `887802330217584117`.
75. Red encrypts for `blue_gw`, signs with `red_gw`.
76. Blue receives/persists and returns receipt.
77. Red becomes `ACKNOWLEDGED`; Blue is `RECEIVED`.
78. Blue lists pending message and retrieves original payload.

## systemd phase

79. Create `domibus.service` on Blue.
80. Validate unit; enable/start.
81. Prove MainPID 4158 is Java, owned by `domibus`, listening on 8080, root 302.
82. Create identical service on Red.
83. Prove MainPID 4736 and equivalent healthy state.

## Blue reboot failure and fix

84. Reboot Blue.
85. systemd/Java/MySQL/data/8080 look healthy, but all `/domibus` URLs return 404.
86. Wait additional time; still 404.
87. Inspect logs.
88. Find `Public Key Retrieval is not allowed` and `/domibus` startup failure.
89. Confirm DB account uses `caching_sha2_password`.
90. Add `allowPublicKeyRetrieval=true` to active JDBC URL.
91. Initial broad edit also changes commented replica example; clean it up.
92. Restart Blue; root 302, MSH 200, WS Plugin 200.
93. Reboot Blue again.
94. Final Blue cold boot passes with PID 1215 and 70,531 ms deployment.

## Red reboot-proofing

95. Confirm Red DB user also uses `caching_sha2_password`.
96. Add `allowPublicKeyRetrieval=true` to Red active URL using targeted edit.
97. Warm restart passes with PID 6941 and 48,581 ms deployment.
98. Reboot Red.
99. Final Red cold boot passes with PID 1361 and 71,512 ms deployment.
100. Red reaches Blue MSH with HTTP 200 after reboot.

## Final state

Blue and Red are now:

```text
bidirectional AS4 proven
backend retrieval proven
systemd-managed
cold-reboot proven
```

## Screenshot timeline

A complete chronological screenshot index is available in [Screenshot evidence](24-screenshot-evidence.md). The archive materially improves the timeline by supplying visual checkpoints from VMware network creation at 17:54 through Domibus/admin diagnostics at 21:51.

![Beginning of visual timeline: VMnet3](assets/screenshots/20260915-175419.png)

![Late visual timeline: post-recovery startup logs](assets/screenshots/20260915-215137.png)

