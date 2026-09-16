# Ubuntu and storage

## Ubuntu

Blue and Red use Ubuntu Server 24.04.5 LTS. SSH was enabled for remote administration.

## OS disk and LVM

Each gateway has an approximately 60 GB OS virtual disk. The initial Ubuntu LVM root did not consume the entire disk, so the root logical volume/filesystem was extended until `/` was approximately 57 GB total.

The literal earliest LVM command transcript is not retained in the current project context. The verified end state is therefore documented without inventing exact historical commands.

## Data disk

Second SCSI virtual disk:

```text
/dev/sdb
```

Approximate size:

```text
200 GB
```

Partition:

```text
/dev/sdb1
```

Partition table:

```text
GPT
```

Filesystem:

```text
ext4
```

Label:

```text
domibus-data
```

Mount point:

```text
/data
```

## UUIDs

Blue:

```text
beb019ea-7a39-4095-8755-07b76de94779
```

Red:

```text
559ba590-135c-4742-b1ce-583ab200b086
```

## fstab form

```fstab
UUID=<VM-SPECIFIC-UUID> /data ext4 defaults,nofail 0 2
```

systemd recognizes the mount as:

```text
data.mount
```

## Directories

```text
/data/domibus/payloads
/data/domibus/tmp
/data/stage
/data/baseline
/data/garage
/data/fs_plugin_data
```

## Ownership and permissions

Domibus service directories:

```text
owner: domibus
group: domibus
mode: 750
```

A write test as `domibus` succeeded.

The normal `xander` user could not freely list some child directories. That was expected because permissions were intentionally restrictive. They were not loosened for convenience.

## Reboot proof

After final reboots, both systems showed `/data` mounted from `/dev/sdb1` as ext4 with read/write options.

## systemd relationship

The final Domibus unit includes:

```ini
After=network-online.target mysql.service data.mount
RequiresMountsFor=/data
```

This makes the payload filesystem part of the service startup dependency chain.

## Screenshot-derived storage details

The screenshots preserve the actual storage workflow. The root LVM was expanded and the filesystem resized, the second 200 GB VMware disk appeared as `/dev/sdb`, a GPT partition `/dev/sdb1` was created, ext4 was created with label `domibus-data`, UUID-based `/etc/fstab` persistence was configured, and `/data` was unmounted/remounted to prove the persistent definition. The directory tree for payloads, temporary files, staging, baseline, garage and filesystem-plugin data was then created.

One Ubuntu-installation screenshot also records a benign installation-media shutdown issue: the installer reported `Failed unmounting cdrom.mount - /cdrom` and requested removal of the installation medium. The VM's virtual CD/DVD configuration was then adjusted before normal boot.

### Screenshot evidence

![Ubuntu installer asking to remove installation medium](assets/screenshots/20260915-185147.png)

*The installer could not unmount `/cdrom` until the virtual installation medium was disconnected.*

![Root LVM/filesystem expansion](assets/screenshots/20260915-185903.png)

*The root LVM/filesystem being expanded to use the available OS disk.*

![Additional 200 GB data disk visible in lsblk](assets/screenshots/20260915-200627.png)

*`lsblk` showing the separate 200 GB VMware virtual disk.*

![Data disk partitioning and filesystem creation](assets/screenshots/20260915-200824.png)

*GPT partition creation on `/dev/sdb` before ext4 formatting.*

![Persistent /data mount verification](assets/screenshots/20260915-201008.png)

*`/data` successfully remounted from `/dev/sdb1` using the persistent configuration.*

