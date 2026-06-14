# 本地模型库检索（两套 catalog + examples）

建模/复制类任务**落笔前**，先在这里找相近的现成实现作参照。两套目录服务于两个不同问题，
分开检索、互不替代，通常组合使用。

---

## 两套目录的分工

| 问题                                                              | 用哪套                          | 查哪个文件                        | 读哪个文件夹                     |
| ----------------------------------------------------------------- | ------------------------------- | --------------------------------- | -------------------------------- |
| **经济学结构怎么设？** FOC、机制设计、校准、时序约定            | **模型参考库**（MMB）            | `references/catalog.csv`          | `references/examples/`           |
| **Dynare 块怎么写？** 命令选项、块格式、特定功能怎么用          | **编程逻辑库**（Pfeifer DSGE_mod）| `references/catalog-code.csv`   | `references/examples-code/`      |

> **重要**：两套都有命中时，先从编程逻辑库取块格式/语法样板，再从模型参考库对齐经济结构——
> 别把两者混淆，也别只查一套就动笔。

---

## 一、模型参考库（catalog.csv + examples/）

### 这是什么

- `references/catalog.csv`：149 篇可复制宏观模型的索引，来自 Macroeconomic Model Database（MMB）
  的 **rep-mmb 复制档**（macromodelbase.com/rep-mmb；上游仓库 IMFS-MMB/mmb-rep）。
- `references/examples/<ModelID>.mod`：每篇论文对应、可直接跑的 Dynare 复制 mod，
  **文件名 = catalog 里的 ModelID**（如 `references/examples/EA_GNSS10_rep.mod`）。
- 这些 `_rep` 文件是**复现原论文**版，已剥去 MMB 的公共政策接口，是干净、论文忠实的参照。

> 注：`references/examples/` 里还有一个教学用最小范例（`rbc_baseline.mod` +
> `rbc_baseline_derivation.md`，供写推导时模仿格式），它与 149 个库文件并存、不冲突。

### catalog.csv 的列

`ModelID, Paper, Authors, Year, Journal, ModelType, Economy, Category, KeyFeatures`

- **ModelID** = `examples/` 里的文件名（去掉 `.mod`）。
- **ModelType** = 模型族 + **是否线性化**（关键，见下「照搬警示」）。
- **Category** = 14 个主题桶（粗筛索引，见下）。
- **KeyFeatures** = 自由文本机制标签（`financial accelerator` / `search-and-matching` /
  `two-country` / `housing` / `Bayesian estimation` …），是 grep 的主要落点。

### 14 类索引（先按桶粗筛，再 grep 机制）

| Category | 篇数 |
|----------|------|
| 1. Baseline NK / Monetary Policy Rules | 14 |
| 2. Estimated DSGE Benchmarks (Smets-Wouters Type) | 17 |
| 3. Financial Accelerator / BGG-type Credit Frictions | 22 |
| 4. Banking Sector / Bank Capital Channel | 18 |
| 5. Labour Market Frictions (Search & Matching) | 10 |
| 6. Open Economy / Multi-Country | 14 |
| 7. Fiscal Policy / Government Spending | 13 |
| 8. Housing / Collateral Constraints | 5 |
| 9. Unconventional Monetary Policy / QE | 6 |
| 10. Energy & Commodities | 4 |
| 11. Money-in-the-Model | 6 |
| 12. Learning & Expectations Formation | 3 |
| 13. Macroprudential Policy | 4 |
| 14. Large Official Policy Models | 13 |

### 检索步骤（模型参考库）

1. **提炼特征**：模型类型 + 核心机制 + 经济体。
2. **grep**（149 行，优先 grep 省上下文）：
   - 按机制：`grep -i "financial accelerator\|BGG" references/catalog.csv`
   - 按经济体：`grep -i "Euro Area" references/catalog.csv`
   - 按类别：先确定 Category 桶，再在桶内按 KeyFeatures 筛。
3. **报候选**：选 3–5 个最相近的，向用户报一句"找到这几篇相近：`<ID>`（论文 / 机制）"。
4. **读参照**：读 1–3 个 `references/examples/<ModelID>.mod`，抽取——变量/方程写法、
   时序约定、参数校准、冲击设定、稳态处理。读命中的文件、抽相关块即可，**别整份 mod 无脑灌进上下文**。

---

## 二、编程逻辑库（catalog-code.csv + examples-code/）

### 这是什么

- `references/catalog-code.csv`：41 个 Dynare 编程逻辑示例的索引，来自
  Johannes Pfeifer 的 **DSGE_mod** 仓库（github.com/JohannesPfeifer/DSGE_mod）。
  目标是展示 Dynare **最佳实践**和特定命令/模块的标准写法，而非复制某篇论文的经济结构。
- `references/examples-code/<Folder>/<CodeID>.mod`：对应的 .mod 文件（及关键 .m 辅助文件），
  **文件夹名 = catalog-code 里的 Folder 列**。

### catalog-code.csv 的列

`CodeID, Folder, Paper, Authors, Year, ModelType, Economy, DynareFeatures, Category`

- **CodeID** = .mod 文件名（去掉 `.mod`）；用作读文件的精确路径。
- **Folder** = `examples-code/` 下的子文件夹名。
- **DynareFeatures** = 该文件最能示范的 Dynare 编程特性（是 grep 的主要落点）。
- **Category** = 11 个功能桶（粗筛用）：

| Category | 代表示例 |
|----------|----------|
| 1. RBC / NK Basics | RBC_baseline, Born_Pfeifer_2018_MP |
| 2. NK Linearized | Gali_2015_chapter_3, Gali_2008_chapter_3 |
| 3. NK Nonlinear | Gali_2015_chapter_3_nonlinear |
| 4. TANK / Heterogeneous | Gali_2010, Gali_2010_calib_target |
| 5. Estimation (ML/Bayesian) | Smets_Wouters_2007_45, Ireland_2004, RBC_baseline_first_diff_bayesian |
| 6. Optimal Policy | Gali_2015_chapter_5_commitment, *_discretion, *_ZLB |
| 7. Higher-Order Methods | Basu_Bundick_2017, SGU_2004, Caldara_et_al_2012 |
| 8. Perfect Foresight | Gali_2015_chapter_5_commitment_ZLB, Solow_* |
| 9. Open Economy | Gali_Monacelli_2005, SGU_2003, Aguiar_Gopinath_2007 |
| 10. Welfare Analysis | RBC_baseline_welfare, Born_Pfeifer_2018_welfare |
| 11. Special Methods | RBC_news_shock_model, NK_linear_forward_guidance, Ascari_Sbordone_2014 |

### 检索步骤（编程逻辑库）

1. **确认要解决的编程问题**：找对应的 Dynare 特性关键词（如 `discretionary_policy`、
   `lmmcp`、`steadystate.m`、`ramsey_model`、`loglinear`、`news shock`、`welfare`…）。
2. **grep DynareFeatures 列**（41 行，速度很快）：
   - 找特定命令：`grep -i "ramsey_model\|discretionary" references/catalog-code.csv`
   - 找块/接口：`grep -i "steadystate.m" references/catalog-code.csv`
   - 找功能：`grep -i "lmmcp\|ZLB\|zero lower bound" references/catalog-code.csv`
   - 找特定模型类：`grep -i "TANK\|hand-to-mouth" references/catalog-code.csv`
3. **读参照**：读 `references/examples-code/<Folder>/<CodeID>.mod`，
   只抽相关块（命令选项写法、块格式、辅助函数接口）即可，不要全灌上下文。
4. **同时需要经济结构参照？**→ 再查模型参考库（catalog.csv）补充机制/时序约定。

---

## 照搬警示

**模型参考库**：
- ModelType 含 `(linearized)` → 该 mod 是线性化版；只取方程**内容/机制/时序/校准**，
  不要照抄线性化形式——按 R8 自己写非线性。
- 参照不替代阶段1 推导。

**编程逻辑库**：
- 很多示例本身是线性化写法（Galí 2008/2015 等）；只抽语法样板，
  经济结构仍以推导为准，按 R8 写非线性版。
- 辅助 .m 文件（steadystate.m、IRF_matching_objective.m 等）可直接改写复用。

---

## 与主流程的衔接

- **§3 第1.3步**：先 grep `catalog.csv`（模型结构），再 grep `catalog-code.csv`（编程逻辑），
  两套均无命中才上 web。
- **第3步 web 检索降级**：两套库均命中时，web 只补论文精确校准来源或某条推导细节。
- **DSGE_mod 已本地化**：不再需要上网找 DSGE_mod（github.com/JohannesPfeifer/DSGE_mod），
  其全部关键 .mod 文件已在 `references/examples-code/` 中，直接读即可。

## 用户模型存档库（model-archive-catalog.csv + model-archive/<ModelID>/）

`references/model-archive-catalog.csv` 是历次任务积累的第三层索引，优先级低于两套主库。
**每个模型在 `references/model-archive/<ModelID>/` 有独立子文件夹**，装齐复跑所需文件
（`.mod`、推导 md、外部 `steadystate.m`、求解 driver、helper、params include 等）。
检索时**两条路都走**：grep `model-archive-catalog.csv` 的机制标签，同时 `ls model-archive/` 扫子文件夹名。
检索方式、字段格式、存档流程详见 `references/model-archive.md`。
