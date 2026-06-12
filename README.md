# dynare-mod

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)
![Dynare](https://img.shields.io/badge/Dynare-7.1-blue)

[中文说明](./README.zh-CN.md)

> A Claude Code plugin that helps you **write, run, and debug Dynare `.mod` models**.
> It covers the full workflow for macroeconomic models such as DSGE, RBC, New Keynesian, and HANK models, from stochastic simulation to Bayesian estimation, optimal policy, occasionally binding constraints, and one-click export of journal-quality IRF figures.

When writing `.mod` files by hand, the biggest risk is **silent failure**: timing, naming, or steady-state algebra mistakes often do not throw errors, but still produce incorrect IRFs or moments. This plugin turns the workflow of "derive the math correctly first, mechanically translate it into code, then validate step by step with Dynare itself" into a fixed process, helping catch mistakes before they propagate.

---

## Requirements

| What you want to do | What you need |
| ------------------- | ------------- |
| Let it **write / edit / inspect** `.mod` files | Only [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) |
| **Run** the generated `.mod` files yourself | Also install [Dynare 7.1](https://www.dynare.org/) + MATLAB or Octave |
| Let it **run automatically and iterate on errors** | Also install a MATLAB MCP server in VSCode |

> You can still use it without MATLAB: it can write models and inspect errors, but it will not run Dynare for you.
>
> Providing the specific paper can greatly reduce response time and token usage.

## Installation (about 1 minute)

First install Claude Code. See the [official installation guide](https://docs.claude.com/en/docs/claude-code/overview); a common method is `npm install -g @anthropic-ai/claude-code`. Then:

1. In a terminal, enter any project directory and run `claude` to start Claude Code.
2. In the Claude Code conversation, paste the following two commands **one line at a time**:

   ```text
   /plugin marketplace add EconSolider/dynare-mod
   /plugin install dynare-mod@econsolider-skills
   ```

   The first line registers this repository as a plugin marketplace, and the second line installs the `dynare-mod` plugin.
3. Done. If typing `/` shows dynare-mod in the menu, the installation succeeded.

> Replace `EconSolider/dynare-mod` with the actual `username/repository` for this repository. `@econsolider-skills` is the fixed marketplace name and does not need to be changed.

## Quick Start

After installation, **describe the task directly in Chinese or English** inside Claude Code. The plugin will be enabled automatically:

- "Turn this set of FOCs into Dynare code: `c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]` ..."
- "Replicate Smets-Wouters 2007 with quarterly calibration and run IRFs."
- "Add a zero lower bound on the nominal interest rate to my New Keynesian model using OccBin."
- "My mod reports `Blanchard-Kahn conditions are not satisfied`; help me check the timing."
- "Plot journal-quality IRFs for these variables, comparing baseline vs high-stickiness scenarios, and export them as a PDF."

You can also invoke it manually with `/dynare-mod:dynare-mod`.

The `examples/` directory contains a complete repository-level example with an RBC model and government spending, including the derivation file and the final `.mod` file for reference. The skill itself also bundles a minimal example, a basic RBC model under `references/examples/`, whose derivation and `.mod` file correspond line by line and are installed together with the skill for format imitation during derivation writing.

## Supported Tasks

| What you say | What it does | Dynare command |
| ------------ | ------------ | -------------- |
| IRFs, moments, variance decomposition, "simulate this DSGE/RBC/NK" | Stochastic simulation | `stoch_simul` |
| Transition paths, permanent shocks, deterministic, perfect foresight | Perfect foresight | `perfect_foresight_*` |
| Bayesian, priors, MCMC, maximum likelihood | Estimation | `estimation` |
| GMM, SMM, simulated moments, IRF matching | Method-of-moments estimation | `method_of_moments` |
| Historical decomposition, "which shock is driving this" | Shock decomposition | `shock_decomposition` |
| Extrapolation, conditional forecasts, fan charts | Forecasting | `forecast` / `conditional_forecast` |
| Identifiability, sensitivity / GSA | Identification and sensitivity | `identification` / `sensitivity` |
| Markov switching, structural BVAR | MS-SBVAR | `markov_switching` / `sbvar` |
| HANK, Krusell-Smith, heterogeneous households | Heterogeneity | `heterogeneity_*` |
| Ramsey, discretion, welfare, simple rules | Optimal policy | `ramsey_model` / `osr` |
| ZLB / effective lower bound, collateral / borrowing constraints | Occasionally binding constraints | `occbin_*` / `lmmcp` |
| Multi-country, multi-sector, switching variants | Macro processor | `@#define / @#if / @#for` |
| Journal-quality IRF figures, export PDF paper figures, multi-scenario / multi-shock comparison | Publication-quality plotting | `plot_irfs_pub.m` |
| It does not run, BK conditions fail, steady state cannot be solved | Debugging | Diagnostic commands |

## How It Works

It does not write purely from memory. It follows a fixed workflow:

1. **Confirm first, then write**: before coding, it asks you to approve **modeling choices that change equation structure**, such as which agents are included, whether labor supply is homogeneous or heterogeneous, whether capital is included, and the market structure. It then produces a structured derivation file covering the optimization problems, FOCs, steady-state solution, and timing. It only writes code after you confirm. These two pauses are meant to catch mistakes before they happen, rather than reworking a large block of code afterward.
2. **Incremental construction**: variable declarations, equations, steady state, shocks, and experiments are written stage by stage. Each stage must work before moving to the next one.
3. **Nonlinear first**: by default, it writes the original nonlinear equation system and lets Dynare handle expansion, instead of manually deriving a linearized system, which is a common source of hidden mistakes.
4. **Run-debug loop**: when connected to MATLAB MCP, it automatically runs Dynare, reads errors, applies minimal fixes, and reruns.
5. **Retrieve first when unfamiliar**: for unfamiliar papers or mechanisms, it first checks the original paper and existing implementations, prioritizing DSGE_mod, before writing.

<details>
<summary>Expand: eight hard rules R1-R8, checked line by line</summary>

| #  | Rule |
| -- | ---- |
| R1 | Comments must be in Chinese; everything outside comments, including `long_name`, `[name=]`, and identifiers, must be English / ASCII. |
| R2 | Timing = decision period / end-of-period stock: state variables carry lags in the current period, and the law of motion has the end-of-period stock on the left-hand side. |
| R3 | `varexo` contains only innovations; persistent AR processes are endogenous variables. |
| R4 | Number of equations = number of endogenous variables, except `ramsey_model` / `discretionary_policy`, which has one fewer equation. |
| R5 | Do not use the names `i`/`inv`/`e`/`E`, Dynare commands, or MATLAB function names; write Greek letters as `alppha`/`betta`/`gam`. |
| R6 | In stochastic settings, do not use `max`/`min`/`abs`/`sign`/comparison operators; use OccBin for occasionally binding constraints. |
| R7 | Every statement ends with `;`, every block ends with `end;`, one statement per line, and parameters are assigned before use. |
| R8 | Nonlinear first; use `model(linear);` only for `discretionary_policy` or when the paper provides only a linear system. |

</details>

## Repository Structure

```text
.claude-plugin/marketplace.json     # Plugin marketplace directory
plugins/dynare-mod/                  # Plugin
  ├── .claude-plugin/plugin.json     # Plugin manifest
  └── skills/dynare-mod/             # Bundled skill
      ├── SKILL.md                   # Main file: hard rules + task routing + main workflow
      └── references/                # 20 detail files loaded on demand + publication-quality plotting script plot_irfs_pub.m
          └── examples/              # Skill-bundled minimal example: basic RBC derivation + matching .mod
examples/                            # Repository-level usage example, RBC with government spending, not part of the skill itself
```

<details>
<summary>Expand: responsibilities of files under references/</summary>

| File | Contents |
| ---- | -------- |
| `workflow-detail.md` | Expanded main workflow, run-debug loop, and final cleanup |
| `derivation-style.md` | Eight-section derivation-file structure and formula conventions |
| `modeling-blocks.md` | Library of agent-specific modeling logic: optimization problems, FOCs, and structural variants for households, firms, government / central bank, and market clearing blocks |
| `steady-state.md` | Analytical / numerical steady state, reverse calibration, homotopy |
| `debugging.md` | Error -> cause -> fix, final checklist |
| `templates.md` | Standard skeletons for RBC / NK / perfect foresight models |
| `stochastic-simulation.md` | `stoch_simul` |
| `perfect-foresight.md` | Deterministic / perfect foresight |
| `estimation.md` | Bayesian / maximum likelihood |
| `moments-method.md` | GMM / SMM / IRF matching |
| `shock-decomposition.md` | Shock / historical decomposition |
| `forecasting.md` | Forecasting / conditional forecasting |
| `identification.md` | Identification and sensitivity |
| `ms-sbvar.md` | Regime switching / SBVAR |
| `heterogeneity.md` | HANK / heterogeneous agents |
| `optimal-policy.md` | Ramsey / OSR / discretion |
| `occbin.md` | ZLB / occasionally binding constraints |
| `macro-processor.md` | `@#` macro processor |
| `publication-plots.md` | Publication-quality IRF plotting, with companion script `plot_irfs_pub.m` |
| `examples/` | Skill-bundled minimal example: basic RBC eight-section derivation + matching `.mod`, with FOC numbers aligned to `[name=]` entries |

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

## Acknowledgements

- [Dynare](https://www.dynare.org/) and its [official manual](https://www.dynare.org/manual/).
- Johannes Pfeifer's [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod), the main reference for standard style, including file headers, `long_name` / LaTeX names, `[name=]` labels, and reverse calibration in `steady_state_model`.

## License

[MIT](./LICENSE) © 2026 EconSolider

MIT only covers content owned by this repository. Materials from Dynare and DSGE_mod are subject to their respective licenses.
