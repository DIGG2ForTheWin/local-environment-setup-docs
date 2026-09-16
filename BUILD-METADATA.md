# Build metadata

- **Repository:** <https://github.com/DIGG2ForTheWin/local-environment-setup-docs>
- **Published site:** <https://digg2forthewin.github.io/local-environment-setup-docs/> (MkDocs Material, built and deployed by `.github/workflows/docs.yml` on every push to `main`)
- **Build locally:** `pip install -r requirements.txt` then `mkdocs serve`

## Contents

| Path | Contents |
|---|---|
| `docs/build-guide.md` | Chronological step-by-step build guide with download links |
| `docs/next-steps.md` | Current state and next phase (Swedish SDK configuration) |
| `docs/domibus/` | Part 1: Blue/Red Domibus AS4 gateways (22 pages) |
| `docs/sdk-core/` | Part 2: sdk-core / DomiSMP 5.2.1.3 (17 pages, same page names as Part 1 where topics match) |
| `docs/reference/` | VMware snapshots, glossary, external references |
| `docs/assets/screenshots/` | Blue/Red build screenshots (Windows local time, CEST) |
| `docs/assets/sdk-core-screenshots/` | DomiSMP phase screenshots |
| `evidence/sdk-core/` | Sanitized text evidence (not published on the website) |
| `SHA256SUMS` | Checksums of all tracked files |

## History

- 2026-09-16: Documentation package created (Blue/Red set extended with the sdk-core / DomiSMP phase).
- 2026-09-16: Published to GitHub Pages; Mermaid rendering enabled.
- 2026-09-16: Full screenshot review; two images redacted (datasource password, admin hash) and Git history rewritten.
- 2026-09-16: Build guide added, download links added, runbook health check and several factual errors corrected.
- 2026-09-16: Pages reorganised into `domibus/`, `sdk-core/` and `reference/` with consistent names; Next steps pages merged; real VMware snapshot names documented; old URLs redirect to the new pages.

## Security policy

Live DB/admin passwords, private keys and secret-bearing configuration files (`context.xml`, raw `domibus.properties`) are never committed. Only sanitized examples with placeholders are included.
