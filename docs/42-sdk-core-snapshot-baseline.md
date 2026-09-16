# VMware snapshot baseline

## Naming convention

The established project convention uses numbered, short, hyphenated milestone names. Earlier snapshots used `00-...` and `01-...` style names.

The DomiSMP checkpoint therefore uses:

```text
02-domismp-installed
```

## Why the snapshot was taken here

This is the clean boundary between:

```text
generic DomiSMP/eDelivery installation
```

and:

```text
Swedish SDK-specific SMP configuration
```

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

## Snapshot procedure

The VM was cleanly stopped before taking the snapshot. The application was stopped and the VM powered off so the snapshot represented a filesystem-consistent milestone rather than a random in-memory execution state.

After creating `02-domismp-installed`, the VM was powered on again and the user confirmed everything was still working.

## What restoring this snapshot means

Restoring this checkpoint should return to the state **before**:

- SDK-specific domain creation;
- participant/service metadata work;
- SML/DNS integration;
- SDK certificate configuration;
- future Tomcat hardening changes.

Because the VM contains credentials, the snapshot itself should be treated as sensitive infrastructure data.
