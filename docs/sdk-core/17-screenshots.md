# Screenshots

Five screenshots from the DomiSMP phase were supplied and preserved in this repository.

## 2026-09-16 09:42 — data layout

Shows the `/data` tree and the 98G ext4 filesystem. It also captures the harmless `lost+found` permission message that was intentionally not “fixed” by weakening permissions.

![sdk-core data layout](../assets/sdk-core-screenshots/20260916-094224-sdk-core-data-layout.png)

## 2026-09-16 10:33 — DomiSMP landing page

Windows reaches `192.168.50.30:8080/smp/`. The application identifies itself as DomiSMP 5.2.1.3 with build time 2026-08-19 14:05:49Z.

![DomiSMP landing](../assets/sdk-core-screenshots/20260916-103339-domismp-landing.png)

## 2026-09-16 10:35 — public resources UI

Shows the DomiSMP resources/search UI before SDK-specific resources were published.

![DomiSMP resources](../assets/sdk-core-screenshots/20260916-103526-domismp-public-resources.png)

## 2026-09-16 10:38 — login page

Shows the UI login form used for the seeded `system` administrator account.

![DomiSMP login](../assets/sdk-core-screenshots/20260916-103822-domismp-login.png)

## 2026-09-16 10:45 — post-bootstrap UI

Shows the DomiSMP UI after bootstrap/admin work in the same session. The private replacement password is not present in the image or documentation.

![DomiSMP after bootstrap](../assets/sdk-core-screenshots/20260916-104549-domismp-post-bootstrap.png)

## Evidence limitations

The screenshots do not cover every terminal command. Exact outputs for the cold reboot and major troubleshooting incidents are preserved in the repository folder [`evidence/sdk-core/`](https://github.com/DIGG2ForTheWin/local-environment-setup-docs/tree/main/evidence/sdk-core) (on GitHub, not part of this website) and in the corresponding Markdown chapters.

The Blue/Red screenshots are on [Screenshot evidence](../domibus/22-screenshots.md).
