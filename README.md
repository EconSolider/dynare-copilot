# dynare-copilot

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)
![Dynare](https://img.shields.io/badge/Dynare-7.1-blue)

**English** | [中文](./README_zh-CN.md) | [日本語](./README_ja.md)

> A Claude Code skill that takes your macroeconomic intuition — "I want a New Keynesian model with a financial accelerator," "replicate Smets-Wouters 2007" — and turns it into a working, validated Dynare `.mod` file with steady state solved and IRFs in hand.
>
> Its core job is to enforce the workflow experienced modelers follow anyway: **derive first, translate second, validate incrementally** — so timing errors, naming conflicts, and steady-state algebra mistakes get caught before they become wrong results. Concretely, it gives you:
>
> - **A vetted starting point, never a blank page** — a built-in dual reference library (149 MMB replication models for economic structure + 89 Pfeifer examples for Dynare syntax) means every model starts from working code.
> - **A tool that sharpens with use** — every model you finish is archived and consulted on future tasks; every bug you hit is logged with its fix, so the same trap is never debugged twice.
> - **Paper-ready output** — every IRF is delivered as a publication-quality vector figure, ready to drop into your manuscript.
>
> No timing pitfalls. No silent errors. No blank page.
>
> *Enjoy the world of macroeconomics.*

---

## Contents

- [Requirements](#requirements)
- [Installation](#installation-about-1-minute)
- [Update](#update)
- [Uninstall](#uninstall)
- [Quick Start](#quick-start)
- [Supported Tasks](#supported-tasks)
- [How It Works](#how-it-works)
- [Output Structure](#output-structure)
- [Repository Structure](#repository-structure)
- [Advanced](#advanced)
- [Join the Project](#join-the-project)
- [Acknowledgements](#acknowledgements)
- [License](#license)

---

## Requirements

| What you want to do                                     | What you need                                                        |
| ------------------------------------------------------- | -------------------------------------------------------------------- |
| Let it **write / edit / inspect** `.mod` files   | Only [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) |
| **Run** the generated `.mod` files yourself     | Also install [Dynare 7.1](https://www.dynare.org/) + MATLAB or Octave    |
| Let it **run automatically and iterate on errors** | Also install a MATLAB MCP server in VSCode                           |

> You can still use it without MATLAB: it can write models and inspect errors, but it will not run Dynare for you.
>
> Providing the specific paper can greatly reduce response time and token usage.
>
> 🔌 **New to MCP?** If you've never connected MATLAB (or Stata) to Claude Code before, follow the step-by-step beginner's guide: **[Connecting MATLAB / Stata to Claude Code (MCP Setup Guide)](./docs/mcp-setup-guide.md)**. It assumes zero prior setup and covers installing Claude Code, wiring up the MATLAB MCP that powers the automatic run-debug loop above, and the Stata MCP.

## Installation (about 1 minute)

First install Claude Code. See the [official installation guide](https://docs.claude.com/en/docs/claude-code/overview); a common method is `npm install -g @anthropic-ai/claude-code`. Then:

1. In a terminal, enter any project directory and run `claude` to start Claude Code.
2. In the Claude Code conversation, paste the following two commands **one line at a time**:

   ```text
   /plugin marketplace add EconSolider/dynare-copilot
   /plugin install dynare-copilot@econsolider-skills
   ```

   The first line registers this repository as a plugin marketplace, and the second line installs the `dynare-copilot` plugin.
3. Done. If typing `/` shows the dynare-mod skill in the menu, the installation succeeded.

## Update

To pull the latest version after installing, run these two commands in Claude Code, **one line at a time**:

```text
/plugin marketplace update econsolider-skills
/plugin update dynare-copilot@econsolider-skills
```

The first line refreshes the marketplace metadata from the repository; the second line upgrades the installed plugin to the latest released `version`. Restart Claude Code if the change doesn't take effect immediately.

### Enable auto-update (recommended)

Third-party marketplaces have auto-update **off by default**, so the two commands above are needed every time unless you turn it on. To have Claude Code refresh this marketplace and upgrade the plugin automatically at startup:

1. Run `/plugin` to open the plugin manager.
2. Go to the **Marketplaces** tab and select `econsolider-skills`.
3. Choose **Enable auto-update**.

After that, each time you start Claude Code it pulls the latest version on its own; when an update is applied you'll be prompted to run `/reload-plugins`. You only need to do this once.

## Uninstall

To remove the plugin, run in Claude Code:

```text
/plugin uninstall dynare-copilot@econsolider-skills
```

This removes the plugin while keeping the marketplace registered, so you can reinstall or update later without re-adding it.

> If you installed manually (the Advanced method below), there is no plugin to uninstall — just delete the copied directory: `rm -rf ~/.claude/skills/dynare-mod` (or the project-local `.claude/skills/dynare-mod/`).

## Quick Start

After installation, **describe the task directly in Chinese or English** inside Claude Code. The plugin will be enabled automatically:

- "Turn this set of FOCs into Dynare code: `c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]` ..."
- "Replicate Smets-Wouters 2007 with quarterly calibration and run IRFs."
- "Add a zero lower bound on the nominal interest rate to my New Keynesian model using OccBin."
- "My mod reports `Blanchard-Kahn conditions are not satisfied`; help me check the timing."
- "Plot journal-quality IRFs for these variables, comparing baseline vs high-stickiness scenarios, and export them as a PDF."

You can also invoke it manually with `/dynare-mod:dynare-mod`.

The skill bundles two reference libraries under `references/` — 149 MMB replication models for economic structure and 89 Pfeifer examples for Dynare syntax — plus your own growing model archive. When asked to build a model it searches these local libraries first, and only falls back to web search for paper-specific details neither covers. See [How It Works](#how-it-works) for the lookup logic, and [Repository Structure](#repository-structure) for what each library contains.

## Supported Tasks

| What you say                                                                                   | What it does                           | Dynare command                                                                                           |
| ---------------------------------------------------------------------------------------------- | -------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| IRFs, moments, variance decomposition, "simulate this DSGE/RBC/NK"                             | Stochastic simulation                  | `stoch_simul`                                                                                          |
| Transition paths, permanent shocks, deterministic, perfect foresight                           | Perfect foresight                      | `perfect_foresight_*`                                                                                  |
| Bayesian, priors, MCMC, maximum likelihood                                                     | Estimation                             | `estimation`                                                                                           |
| GMM, SMM, simulated moments, IRF matching                                                      | Method-of-moments estimation           | `method_of_moments`                                                                                    |
| Historical decomposition, "which shock is driving this"                                        | Shock decomposition                    | `shock_decomposition`                                                                                  |
| Extrapolation, conditional forecasts, fan charts                                               | Forecasting                            | `forecast` / `conditional_forecast`                                                                  |
| Identifiability, sensitivity / GSA                                                             | Identification and sensitivity         | `identification` / `sensitivity`                                                                     |
| Markov switching, structural BVAR                                                              | MS-SBVAR                               | `markov_switching` / `sbvar`                                                                         |
| HANK, Krusell-Smith, heterogeneous households                                                  | Heterogeneity                          | `heterogeneity_*`                                                                                      |
| Ramsey, discretion, welfare, simple rules                                                      | Optimal policy                         | `ramsey_model` / `osr`                                                                               |
| ZLB / effective lower bound, collateral / borrowing constraints                                | Occasionally binding constraints       | `occbin_*` / `lmmcp`                                                                                 |
| Multi-country, multi-sector, switching variants                                                | Macro processor                        | `@#define / @#if / @#for`                                                                              |
| Replicate paper X, "I want a model with feature Y", unsure whether an implementation exists    | Dual local library lookup (runs first) | grep `catalog.csv` (structure) + `catalog-code.csv` (syntax) → `model-archive-catalog.csv` → web |
| Journal-quality IRF / time-series figures, export PDF paper figures, multi-scenario / multi-shock comparison | Publication-quality plotting | IRF→`plot_irfs_pub.m`; simulated series / transition paths→`plot_series_pub.m`                    |
| It does not run, BK conditions fail, steady state cannot be solved                             | Debugging                              | Diagnostic commands                                                                                      |

## How It Works

It does not write purely from memory. It follows a fixed workflow:

1. **Confirm first, then write**: before coding, it asks you to approve **modeling choices that change equation structure**, such as which agents are included, whether labor supply is homogeneous or heterogeneous, whether capital is included, and the market structure. It then produces a structured derivation file covering the optimization problems, FOCs, steady-state solution, and timing. It only writes code after you confirm. These two pauses are meant to catch mistakes before they happen, rather than reworking a large block of code afterward.
2. **Incremental construction**: variable declarations, equations, steady state, shocks, and experiments are written stage by stage. Each stage must work before moving to the next one.
3. **Nonlinear first**: by default, it writes the original nonlinear equation system and lets Dynare handle expansion, instead of manually deriving a linearized system, which is a common source of hidden mistakes.
4. **Run-debug loop**: when connected to MATLAB MCP, it automatically runs Dynare, reads errors, applies minimal fixes, and reruns. It consults a bundled **error log** (`known-issues.md`) of known traps first, and writes any newly solved error back — so the same trap is never debugged from scratch twice.
5. **Dual local library lookup**: before writing a model, it searches two separate local libraries:

   - **Model reference library** (`catalog.csv`, 149 MMB/rep-mmb models): answers "how should this economic mechanism be structured?" — FOC patterns, timing conventions, calibration.
   - **Programming logic library** (`catalog-code.csv`, 89 Johannes Pfeifer examples: 41 DSGE_mod + 48 *Advanced Dynare* course): answers "how do I write this Dynare block?" — command syntax, `steadystate.m` interface, `discretionary_policy`, `lmmcp`, welfare blocks, news shocks, higher-order methods.

   After both local libraries, it checks your **personal model archive** (`model-archive-catalog.csv`) of models built in past sessions, then falls back to web search only for paper-specific details (precise calibration targets, derivation steps) not covered by the libraries. DSGE_mod is fully bundled locally — no web fetch needed. The model archive grows automatically at the end of every modeling task — the final `.mod` and derivation file are archived to `references/model-archive/`. Linearized reference models are used only for equation content, timing, and calibration, never copied verbatim.
6. **Efficient iteration on slow models**: for models expensive to solve (heterogeneity / HANK, estimation, higher-order), it separates the one-time solve from cheap figure-tweaking — caching results so re-plotting, re-normalizing, and multi-model comparison (e.g. HANK vs RANK) never re-solve the model. Known analytical benchmarks are printed and checked before a figure is trusted, catching silent normalization / scaling errors.

<details>
<summary>Expand: eight hard rules R1–R8, checked line by line</summary>

| #  | Rule                                                                                                                                                                           |
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| R1 | Comments must be in Chinese (or the language the user writes in); everything outside comments, including `long_name`, `[name=]`, and identifiers, must be English / ASCII. |
| R2 | Timing = decision period / end-of-period stock: state variables carry lags in the current period, and the law of motion has the end-of-period stock on the left-hand side.     |
| R3 | `varexo` contains only innovations; persistent AR processes are endogenous variables.                                                                                        |
| R4 | Number of equations = number of endogenous variables, except `ramsey_model` / `discretionary_policy`, which has one fewer equation.                                        |
| R5 | Do not use the names `i`/`inv`/`e`/`E`, Dynare commands, or MATLAB function names; write Greek letters as `alppha`/`betta`/`gam`.                                |
| R6 | In stochastic settings, do not use `max`/`min`/`abs`/`sign`/comparison operators; use OccBin for occasionally binding constraints.                                     |
| R7 | Every statement ends with `;`, every block ends with `end;`, one statement per line, and parameters are assigned before use.                                               |
| R8 | Nonlinear first; use `model(linear);` only for `discretionary_policy` or when the paper provides only a linear system.                                                     |

</details>

## Output Structure

When a modeling task finishes, the working directory holds a self-contained, one-click-rerunnable set of deliverables:

```text
<model>_derivation.md   # Derivation: optimization problems → FOCs → steady-state solution → timing (delivered for your approval before any code)
<model>.mod             # The model itself: variable/parameter declarations, equations, steady state, shocks, experiment commands
<model>_steadystate.m   # External steady-state file (only when the steady state needs a numerical solve; an analytical steady state goes in the .mod's steady_state_model block, so this file is absent)
run_<model>.m           # Run script: self-contained one-click rerun (addpath + cd + dynare + sanity check + calls the plotting script + caches oo_); change one Dynare-path line for your machine and run it
plot_irfs_pub.m         # Plotting script: publication-quality IRF (impulse response) vector figures
plot_series_pub.m       # Plotting script: time series / simulated paths / perfect-foresight transition paths
fig_*.pdf               # Publication-quality vector figures (drop straight into a paper)
<model>_oo.mat          # Cached solve results (generated by the run script; a regenerable intermediate)
```

Not every file appears every time — the output depends on the task:

- The **derivation file** is produced only for non-standard mechanisms (TANK / HANK, financial frictions, open economy, optimal policy, OccBin) or when equations need a consistency check; textbook-standard models (plain RBC, three-equation NK) skip it.
- The **external steady-state file** appears only when the steady state has no closed form and must be solved numerically; an analytical steady state goes straight into the `.mod`.
- **Plotting scripts and figures** are chosen by output type: IRFs call `plot_irfs_pub`, simulated series / transition paths call `plot_series_pub`; figureless tasks (pure steady-state checks, identification) skip them.
- The **run script** is produced by default, wiring the pieces into a one-click rerun and **calling the plotting script automatically** (no more running the plots by hand); if your project already has a top-level `main`, the solve and plotting are wired into that `main` rather than a new file.

On cleanup it removes only Dynare's auto-generated artifacts (`+<model>/`, `Output/`, `*_results.mat`, `.log`, ...); the deliverables above and any data you uploaded are always kept.

## Repository Structure

```text
.claude-plugin/marketplace.json     # Plugin marketplace directory
plugins/dynare-mod/                  # Plugin
  └── .claude-plugin/plugin.json     # Plugin manifest
  └── skills/dynare-mod/             # Bundled skill
      ├── SKILL.md                   # Main file: hard rules + task routing + main workflow
      └── references/                # Detail files loaded on demand + model catalogs + plotting & run scripts
          ├── catalog.csv            # Index of 149 MMB replication models (model structure reference)
          ├── catalog-code.csv       # Index of 89 Pfeifer examples: 41 DSGE_mod + 48 Advanced Dynare course (programming logic reference)
          ├── model-archive-catalog.csv # Index of your accumulated models (grows as you work)
          ├── known-issues.md       # Real-world bug log (symptom → cause → fix), grows via encode-back
          ├── matlab-workflow.md    # MATLAB-side workflow: decouple solve/plot, cache oo_, multi-model comparison
          ├── examples/              # 149 MMB rep-mmb replication .mod files (named by ModelID)
          ├── examples-code/         # 89 Pfeifer .mod files in 22 subfolders: 41 DSGE_mod + 48 Advanced Dynare course (Dynare_Course/, by chapter)
          └── model-archive/         # Your archived .mod files and derivation docs, built up over time
paper-candidates/                    # Candidate papers shortlisted for future inclusion (not part of the skill)
```

<details>
<summary>Expand: responsibilities of files under references/</summary>

| File                          | Contents                                                                                                                                                                                                                                                                                                                                 |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workflow-detail.md`        | Expanded main workflow, run-debug loop, and final cleanup                                                                                                                                                                                                                                                                                |
| `derivation-style.md`       | Eight-section derivation-file structure and formula conventions                                                                                                                                                                                                                                                                          |
| `modeling-blocks.md`        | Library of agent-specific modeling logic: optimization problems, FOCs, and structural variants for households, firms, government / central bank, and market clearing blocks                                                                                                                                                              |
| `steady-state.md`           | Analytical / numerical steady state, reverse calibration, homotopy                                                                                                                                                                                                                                                                       |
| `debugging.md`              | Error → cause → fix, final checklist                                                                                                                                                                                                                                                                                                   |
| `known-issues.md`           | Real-world bug log: symptom → cause → fix for specific traps hit in practice; grows over time (the run-debug loop consults it first and writes new fixes back)                                                                                                                                                                         |
| `templates.md`              | Standard skeletons for RBC / NK / perfect foresight models                                                                                                                                                                                                                                                                               |
| `stochastic-simulation.md`  | `stoch_simul`                                                                                                                                                                                                                                                                                                                          |
| `higher-order.md`           | Higher-order perturbation: risk premia / asset pricing, uncertainty (volatility) shocks, precautionary saving, 2nd/3rd-order welfare, Epstein-Zin, GIRF, stochastic / ergodic steady state, pruning                                                                                                                                       |
| `perfect-foresight.md`      | Deterministic / perfect foresight                                                                                                                                                                                                                                                                                                        |
| `estimation.md`             | Bayesian / maximum likelihood                                                                                                                                                                                                                                                                                                            |
| `moments-method.md`         | GMM / SMM / IRF matching                                                                                                                                                                                                                                                                                                                 |
| `shock-decomposition.md`    | Shock / historical decomposition                                                                                                                                                                                                                                                                                                         |
| `forecasting.md`            | Forecasting / conditional forecasting                                                                                                                                                                                                                                                                                                    |
| `identification.md`         | Identification and sensitivity                                                                                                                                                                                                                                                                                                           |
| `ms-sbvar.md`               | Regime switching / SBVAR                                                                                                                                                                                                                                                                                                                 |
| `heterogeneity.md`          | HANK / heterogeneous agents                                                                                                                                                                                                                                                                                                              |
| `optimal-policy.md`         | Ramsey / OSR / discretion                                                                                                                                                                                                                                                                                                                |
| `occbin.md`                 | ZLB / occasionally binding constraints                                                                                                                                                                                                                                                                                                   |
| `macro-processor.md`        | `@#` macro processor                                                                                                                                                                                                                                                                                                                   |
| `run-script.md`             | How to write the run script `run_<model>.m`: self-contained one-click rerun, output chosen by experiment type, automatic plotting-script calls, and wiring into a project's existing `main` |
| `publication-plots.md`      | Publication-quality plotting, with companion scripts `plot_irfs_pub.m` (IRFs) and `plot_series_pub.m` (time series / simulation / transition paths)                                                                                                                                                                                                                                                              |
| `matlab-workflow.md`        | MATLAB-side workflow for slow models: decouple the expensive solve from cheap plotting, cache `oo_`, project scaffolding (run / analyze scripts), multi-model comparison, analytical-benchmark sanity check                                                                                                                            |
| `catalog.csv`               | Index of the 149-model MMB reference library:`ModelID`, paper, authors, journal, model type, economy, category (14 buckets), and key features. Used to answer "how should this economic mechanism be structured?"                                                                                                                      |
| `catalog-code.csv`          | Index of the 89-example Pfeifer programming library (41 DSGE_mod + 48 *Advanced Dynare* course):`CodeID`, folder, paper, authors, model type, `DynareFeatures` (grep target for commands/blocks), category (11 buckets). Used to answer "how do I write this Dynare block/command?"                                                  |
| `catalog-lookup.md`         | How to search both catalogs by feature, the category indexes, model archive lookup, and caveats on using reference `.mod` files (linearized vs nonlinear, reference not verbatim copy)                                                                                                                                                 |
| `model-archive-catalog.csv` | Index of models you've built across sessions; same columns as `catalog.csv` plus a `Task` and `DateAdded` field. Grows automatically at the end of each modeling task.                                                                                                                                                             |
| `model-archive.md`          | Spec for the personal model archive: directory structure, how to search it, the archiving flow, and fresh-install initialization.                                                                                                                                                                                                        |
| `examples/`                 | The 149 MMB rep-mmb replication `.mod` files (named by `ModelID`). Answers "what's the economic structure?"                                                                                                                                                                                                                          |
| `examples-code/`            | 89 Pfeifer `.mod` files (and key `.m` helpers) in 22 subfolders: 41 from DSGE_mod + 48 from his *Advanced Dynare* course (under `Dynare_Course/`, organized by chapter). Answers "how is this Dynare feature implemented?" Covers: RBC basics, NK linearized/nonlinear, TANK, estimation (ML/Bayesian/IRF-matching), method of moments, optimal policy, higher-order methods, perfect foresight, OccBin, open economy, welfare, news shocks, forward guidance, identification, forecasting. |
| `model-archive/`            | Archive of `.mod` files and derivation docs from your past sessions. Consulted automatically on future modeling tasks, ahead of web search.                                                                                                                                                                                            |

</details>

## Advanced

<details>
<summary>Manual skill installation without the marketplace</summary>

Copy the skill directory into your personal skills directory; the plugin marketplace is not required:

```bash
cp -r plugins/dynare-mod/skills/dynare-mod ~/.claude/skills/
```

After creating `~/.claude/skills/` for the first time, restart Claude Code. To use it for a single project only, place it under that project's `.claude/skills/dynare-mod/`.

</details>

<details>
<summary>Local validation and updates</summary>

```bash
claude plugin validate .                      # Validate marketplace.json
claude plugin validate ./plugins/dynare-mod   # Validate plugin.json and skill metadata
```

To publish an update, push a commit. Users can then run `/plugin marketplace update` to pull the latest version. Remember to increment `version` in `plugin.json` for every release.

</details>

<details>
<summary>Runtime path configuration</summary>

The Dynare / MATLAB paths used for automatic execution are configured in `references/workflow-detail.md`. The default example is `C:\dynare\7.1`; change it according to your actual installation.

</details>

## Join the Project

This is a fast-evolving project. We warmly welcome contributions to development and usage feedback.

## Acknowledgements

- [Dynare](https://www.dynare.org/) and its [official manual](https://www.dynare.org/manual/).
- Johannes Pfeifer's [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod) and his *Advanced Dynare* course — together the source of the 89-example programming logic library bundled under `references/examples-code/` (41 from DSGE_mod + 48 from the course, under `Dynare_Course/`). The main reference for standard Dynare style: file headers, `long_name` / LaTeX names, `[name=]` labels, and `steadystate.m` reverse calibration patterns.
- The [Macroeconomic Model Data Base (MMB)](https://www.macromodelbase.com/rep-mmb) and its replication archive (`IMFS-MMB/mmb-rep`), headed by Volker Wieland — the source of the 149-model reference library bundled under `references/examples/` and indexed by `references/catalog.csv`.

## License

[MIT](./LICENSE) © 2026 EconSolider

MIT only covers content owned by this repository. Materials from Dynare, DSGE_mod, and the MMB / mmb-rep archive are subject to their respective licenses and terms.
