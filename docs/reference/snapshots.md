# VMware snapshots

Snapshots are the lab's rollback points. The names below are the **real** snapshots, read from each VM's VMware Snapshot Manager on 2026-09-16.

**▶ running** means the snapshot was taken while the VM was powered on; its memory state is included (green play icon in Snapshot Manager). **Powered off** means the VM was shut down cleanly first, which gives a filesystem-consistent snapshot.

## Blue

| # | Snapshot | Milestone | State | Build guide step |
|---|---|---|---|---|
| 00 | `00-Base-OS-Clone-Ready` | Ubuntu installed, LVM grown, updated. **Red was cloned from this state.** | powered off | [4](../build-guide.md#4-updates-vmware-tools-and-ssh-from-windows) |
| 01 | `01-Network-Storage-Ready`¹ | Static VMnet3 IP and the 200 GB `/data` disk | powered off | [7](../build-guide.md#7-add-the-200-gb-data-disk-data) |
| 02 | `02-Domibus-DB-Ready` | Java, MySQL, `domibus_schema` imported (119 tables) | powered off | [11](../build-guide.md#11-create-the-domibus-database) |
| 03 | `03-Blue-PMode-Ready` | Domibus installed, admin recovered, lab PMode uploaded | powered off | [13](../build-guide.md#13-certificates-and-pmode) |
| 03 | `03-Blue-PMode-Ready` (second) | Same milestone taken again | ▶ running | 13 |
| 04 | `04-Blue-AS4-Working` | Bidirectional AS4 and backend retrieval proven | ▶ running | [14](../build-guide.md#14-send-the-first-as4-messages-both-directions) |
| 05 | `05-Blue-Reboot-Safe` | systemd service, `allowPublicKeyRetrieval` fix, cold reboot passed | ▶ running | [15](../build-guide.md#15-run-domibus-as-a-service-and-prove-it-survives-a-reboot) |

Blue has **two** snapshots named `03-Blue-PMode-Ready`, one taken powered off and one while running. They are easy to confuse. Consider renaming the second one to make the difference visible, e.g. `03b-Blue-PMode-Ready-Running`.

## Red

| # | Snapshot | Milestone | State |
|---|---|---|---|
| 01 | `01-Network-Storage-Ready`¹ | Static IP `.20` and Red's own 200 GB `/data` disk | powered off |
| 02 | `02-Domibus-DB-Ready` | Java, MySQL, schema imported | powered off |
| 03 | `03-Red-PMode-Ready` | Domibus installed, Red PMode uploaded | ▶ running |
| 04 | `04-Red-AS4-Working` | Bidirectional AS4 and backend retrieval proven | ▶ running |
| 05 | `05-Red-Reboot-Safe` | systemd, JDBC fix, cold reboot passed | ▶ running |

Red has **no `00`** snapshot because it *is* a clone of Blue's `00-Base-OS-Clone-Ready`.

¹ The Snapshot Manager view truncates this name to `01-Network-Storage-Re…`; the full name is presumed to be `…-Ready`, in line with the other names. Check the *Name* field and correct this page if it differs.

## sdk-core

| # | Snapshot | Milestone | State |
|---|---|---|---|
| 01 | `01-Network-Ready` | Ubuntu base with static IP `192.168.50.30` | powered off |
| 02 | `02-domismp-installed` | 100 GB `/data`, DomiSMP 5.2.1.3 on Tomcat 10.1.59, `smp` DB, admin password changed, systemd, cold reboot passed | powered off |

sdk-core has no `00` snapshot.

### About `02-domismp-installed`

This is the clean boundary between the **generic DomiSMP/eDelivery installation** and the **Swedish SDK-specific SMP configuration**.

At snapshot time all of the following were proven:

- persistent `/data` mount;
- MySQL startup;
- complete 50-table DomiSMP DB;
- administrator bootstrap and password change;
- DomiSMP WAR deployment;
- Windows UI access;
- systemd service management;
- successful cold reboot;
- HTTP 200 on `/smp/`.

The application was stopped and the VM powered off before the snapshot. Afterwards the VM was powered on again and confirmed working.

Restoring it returns to the state **before**:

- SDK-specific domain creation;
- participant/service metadata work;
- SML/DNS integration;
- SDK certificate configuration;
- Tomcat hardening changes.

## Naming convention for new snapshots

Every Blue and Red snapshot, and sdk-core `01-Network-Ready`, uses the same pattern:

```text
NN-Title-Case-Words
```

- `NN` is a two-digit milestone number that increases along the VM's chain.
- Words are Title-Case and joined with hyphens.
- The VM role is included when the milestone is VM-specific (`03-Blue-PMode-Ready`, `04-Red-AS4-Working`).

sdk-core `02-domismp-installed` broke this pattern: it's all lowercase. When it was named, the convention was described only as "numbered short milestone names", and the Title-Case part wasn't carried over ([sdk-core failures and fixes §14](../sdk-core/10-failures-and-fixes.md#14-snapshot-naming-correction)).

**Use the original pattern from now on**, for example:

```text
03-SDK-Configured
04-SDK-Blue-Red-Discovery-Working
```

Optionally, rename the existing snapshot in VMware for consistency: **VM → Snapshot → Snapshot Manager**, select `02-domismp-installed`, change *Name* to `02-DomiSMP-Installed`, then update this page. Renaming a snapshot doesn't change its contents.

## Good practice

- Shut down cleanly before milestone snapshots (**powered off**) unless you specifically need the running memory state.
- Snapshots are not backups. They live next to the VM's disk files, and deleting the VM deletes them too. Keep database/config backups separately.
- The VMs contain credentials, so treat snapshot files as sensitive.
