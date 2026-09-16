# Build metadata

- **Repository:** <https://github.com/DIGG2ForTheWin/local-environment-setup-docs>
- **Published site:** <https://digg2forthewin.github.io/local-environment-setup-docs/> (MkDocs Material, built and deployed by `.github/workflows/docs.yml` on every push to `main`)
- **Build locally:** `pip install -r requirements.txt` then `mkdocs serve`

## Contents

| Path | Contents |
|---|---|
| `docs/00-build-guide.md` | Chronological step-by-step build guide with download links |
| `docs/01-*` … `docs/24-*` | Blue/Red Domibus AS4 gateways |
| `docs/25-*` … `docs/44-*` | sdk-core / DomiSMP 5.2.1.3 phase |
| `docs/assets/screenshots/` | Blue/Red build screenshots (Windows local time, CEST) |
| `docs/assets/sdk-core-screenshots/` | DomiSMP phase screenshots |
| `evidence/sdk-core/` | Sanitized text evidence (not published on the website) |
| `SHA256SUMS` | Checksums of all tracked files |

## History

- 2026-09-16: Documentation package created (Blue/Red set extended with the sdk-core / DomiSMP phase).
- 2026-09-16: Published to GitHub Pages; Mermaid rendering enabled.
- 2026-09-16: Full screenshot review; two images redacted (datasource password, admin hash) and Git history rewritten.
- 2026-09-16: Build guide added, download links added, runbook health check and several factual errors corrected.

## Security policy

Live DB/admin passwords, private keys and secret-bearing configuration files (`context.xml`, raw `domibus.properties`) are never committed. Only sanitized examples with placeholders are included.
