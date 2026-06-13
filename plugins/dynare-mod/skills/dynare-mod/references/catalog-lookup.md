# 本地模型库检索（catalog.csv + examples/）

建模/复制类任务**落笔前**，先在这里找 1–3 篇特征相近的现成实现作参照——比凭记忆或 web 检索
更快、论文忠实、时序与校准现成。在 §3 第1.3步执行。

## 这是什么

- `references/catalog.csv`：149 篇可复制宏观模型的索引，来自 Macroeconomic Model Database（MMB）
  的 **rep-mmb 复制档**（macromodelbase.com/rep-mmb；上游仓库 IMFS-MMB/mmb-rep）。
- `references/examples/<ModelID>.mod`：每篇论文对应、可直接跑的 Dynare 复制 mod，**文件名 = catalog
  里的 ModelID**（如 `references/examples/EA_GNSS10_rep.mod`）。
- 这些 `_rep` 文件是**复现原论文**版，已剥去 MMB 的公共政策接口（`interest`/`inflation`/`outputgap`
  那套可切换规则块），因此是干净、论文忠实的参照。若个别文件仍带公共块，剥掉只看原始方程。

> 注：`references/examples/` 里同时有一个教学用最小范例（`rbc_baseline.mod` +
> `rbc_baseline_derivation.md`，供写推导时模仿格式），它与按 ModelID 命名的 149 个库文件并存、不冲突。

## catalog.csv 的列

`ModelID, Paper, Authors, Year, Journal, ModelType, Economy, Category, KeyFeatures`

- **ModelID** = `examples/` 里的文件名（去掉 `.mod`）。
- **ModelType** = 模型族 + **是否线性化**（关键，见下「照搬警示」）。
- **Category** = 14 个主题桶（粗筛索引，见下）。
- **KeyFeatures** = 自由文本机制标签（`financial accelerator` / `search-and-matching` /
  `two-country` / `housing` / `Bayesian estimation` …），是 grep 的主要落点。

## 14 类索引（先按桶粗筛，再 grep 机制）

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

## 检索步骤

1. **提炼特征**：模型类型 + 核心机制 + 经济体（第1步已做）。
2. **grep**（149 行，优先 grep 省上下文；必要时整文件读一遍再人工挑）：
   - 按机制：`grep -i "financial accelerator\|BGG" references/catalog.csv`
   - 按经济体：`grep -i "Euro Area" references/catalog.csv`
   - 组合：先按 Category 缩到一两个桶，再在桶内按 KeyFeatures 筛。
3. **报候选**：选 3–5 个最相近的，向用户报一句"找到这几篇相近：`<ID>`（论文 / 机制）"。
4. **读参照**：读 1–3 个最相近的 `references/examples/<ModelID>.mod`，抽取——变量/方程写法、
   **时序约定**、参数校准、冲击设定、稳态处理。读命中的文件、抽相关块即可，**别把整份 mod 无脑灌进上下文**。

## 照搬警示（最重要，别和 R8 打架）

- **形式逐模型不同**：ModelType 含 `(linearized)` → 该 mod 是（对数）线性化写的；不含 → 多为非线性结构式。
- **线性化参照**：只取方程**内容 / 机制 / 时序 / 校准 / 冲击**；**不要照抄它的线性化形式**——按 R8
  自己写原始非线性方程，让 Dynare 展开。
- **非线性参照**（如 `US_IN10_rep`）：可更直接跟随其结构，但仍要适配用户的具体设定（主体集合、市场
  结构、政策规则可能不同）。
- **参照 ≠ 成品**：参照 mod 用来**交叉验证推导、对齐时序与命名风格、确认机制的标准写法**；它**不替代
  §3 第4步阶段1 的八节推导**——仍要先写推导、再翻成 `.mod`。把参照当作"别人怎么写这个机制"的样本，
  不是直接交付的答案。

## 与主流程的衔接

- 命中后，**§3 第3步 web 检索降为兜底**：仅 catalog 无相近模型、或需补论文精确校准来源/某条推导细节时才上网。
- 检索到的相似模型可直接喂给**闸门1（第1.5步）**的提问：用"这几篇相近模型在 X 上是这么处理的，
  你要 A 还是 B"，让建模选择更具体、更省一轮往返。

## 用户记忆库（memory-catalog.csv）

`references/memory-catalog.csv` 是历次任务积累的第二层索引，优先级低于 `catalog.csv`。
检索方式、字段格式、存档流程、全新安装时的初始化行为，详见 `references/memory.md`。
