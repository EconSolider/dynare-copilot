# MMB Paper Derivations Archive

This folder stores source-backed MMB derivation Markdown exported from the private `dsge-evaluation` build pipeline.

## Contents

- `derivations/<MODEL_ID>/`: English and Chinese formula/derivation Markdown for each model entry, plus extraction notes and machine-readable source manifests.
- `metadata/model_metadata.csv`: one row per archived model derivation.
- `metadata/source_metadata.csv`: one row per deduplicated MinerU paper Markdown source.
- `metadata/excluded_or_missing.csv`: MMB rows not archived here and why.
- `metadata/sha256_manifest.csv`: checksums for files committed in this corpus.

## Copyright Boundary

`dynare-copilot` is a public repository. Full MinerU `full.md` paper text is therefore **not vendored here**. Metadata records the private `dsge-evaluation` source Markdown relative path and SHA256 hash so the private source can be matched and audited without redistributing full paper text.

## Snapshot

- Archived model derivations: 161
- Deduplicated paper Markdown sources referenced: 124
- Excluded or missing MMB rows: 8
- Source repo for raw paper Markdown/PDF provenance: `dsge-evaluation`
- Generated date: 2026-06-17

## Notes

All entries are first-pass archive material unless their per-model notes say otherwise. Most entries retain `needs_review` status because formula-level PDF checks and Dynare runtime validation were not part of this extraction pass.
