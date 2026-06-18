# EA_PV16 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row matches model `EA_PV16` with title "The Portfolio Balance Mechanism and QE in the Euro Area", authors Priftis and Vogel, year 2016, DOI `10.1111/manc.12162`.
- First 80 Markdown lines were sniffed. They show the expected title and authors.
- Raw PDF exists at `raw/mmb_papers/The Portfolio Balance Mechanism and QE in the Euro Area.pdf`; the PDF body was not read, per task instruction.
- No appendix-normalization file was found at `docs/mmb_appendix_full_normalizations/EA_PV16.md`.

## Formula Quality

- Paper-side Markdown directly supports the long-bond pricing equations, debt composition identities, Ricardian household portfolio FOCs, QE channel equations, government budget equation, central-bank profit equation, cross-border long-bond extension, and NFA identity.
- The extracted Markdown says the detailed QUEST model with QE extension is in an appendix, but the available `full.md` does not include a full appendix with baseline QUEST equations. Full production, price-setting, wage-setting, final-good, fiscal closure, and steady-state derivations are therefore `needs_review`.
- Some OCR text contains character corruption, but the main displayed QE equations were readable enough for a first-pass transcription.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_PV16_rep.mod` was used only as `implementation_cross_check`.
- The implementation confirms coverage of `EA_bl`, `EA_blcb`, `EA_blnlc`, `EA_bs`, `EA_pbl`, `EA_dm`, `EA_eps_qe`, `EA_deltabl`, `EA_gamb`, `EA_kbl`, `EA_sbl`, `EA_rhoqe`, and `EA_tqe`.
- The implementation includes a nonlinear model block and many baseline QUEST equations, but those equations were not copied as paper-side math evidence.

## Deferred Issues

- Verify the full QUEST appendix or another paper-side source before promoting baseline real-side, price/wage, and fiscal closure equations beyond `needs_review`.
- Check the QE purchase rule and exact Taylor rule against the paper appendix or official model documentation; the first-pass archive uses implementation cross-checks and paper prose for those entries.
- Source-level formula audit against the PDF was not performed.
- Runtime validation was not performed.

## Translation Status

- English derivation was written first.
- Chinese derivation was translated from the English version and preserves equation numbers, file paths, model ID, DOI, and `needs_review` markers.
