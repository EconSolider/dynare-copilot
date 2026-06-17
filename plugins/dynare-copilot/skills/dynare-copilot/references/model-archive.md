# 模型存档库（model archive）使用规范

> **何时读**：① 第1.3步检索模型库时需要查模型存档库；② 第7步（交付收尾时的归档门控）需要执行存档。
> 本文件规定模型存档库的目录结构、检索方式、存档流程与全新安装时的初始化行为。

---

## 目录结构

**每个模型在存档库里有自己的子文件夹**（文件夹名 = ModelID），子文件夹里放该模型**全部运行所需文件**：

```
references/
├── model-archive-catalog.csv        ← 存档库索引（格式同 catalog.csv，可同一 grep 命令搜索）
└── model-archive/
    └── <ModelID>/                    ← 每个模型一个子文件夹（文件夹名 = ModelID）
        ├── <ModelID>.mod            ← Dynare 模型文件（必有）
        ├── <ModelID>_derivation.md  ← 配套推导文件（可选）
        ├── <ModelID>_steadystate.m  ← 外部稳态文件（稳态写在 .m 里时必存，否则模型跑不出稳态）
        └── ...                       ← 其余运行所需 .m / 数据：求解 driver、helper 函数、
                                         params include、IRF-matching 目标函数等
```

**为什么用子文件夹 + 收齐 .m**：扁平存放时（早期做法）一来文件名前缀容易撞、归属不清，二来
**稳态/系数常常算在 .m 文件里**（外部 `steadystate.m` 反解校准、BGG 的 ζ 系数 fzero、IRF-matching 目标
函数等）——只存 `.mod + 推导 md` 会让模型**无法复跑**。一个子文件夹装齐 = 未来任务直接整夹复制即可运行。

全新安装时以上文件/目录均不存在，属正常情况——按下方"全新安装"处理。

## 一、检索（第1.3步执行）

在 `catalog.csv`（149 篇 MMB）无相近命中后，检索模型存档库。**两条路都走**——既搜 catalog 文本，
也扫**文件夹名**（folder = ModelID，机制有时就体现在命名上，且能兜底 catalog 行漏写的情况）：

```bash
# 先确认文件存在，再 grep catalog（机制标签/经济体/类别都在这里）
grep -i "financial accelerator\|BGG\|spread" references/model-archive-catalog.csv
grep -i "TANK\|hand-to-mouth"               references/model-archive-catalog.csv

# 同时扫子文件夹名（ModelID），命中常见模型族缩写
ls references/model-archive/ | grep -i "swff\|bgg\|hank\|rbc\|nk"
```

**全新安装时**：`references/model-archive-catalog.csv` 或 `references/model-archive/` 不存在 → 直接跳过，
视为无命中，不报错，不尝试读取。

有命中时，进对应子文件夹 `references/model-archive/<ModelID>/`，读其中的 `.mod`（必要时连带
`<ModelID>_steadystate.m` 等 .m）作补充参照（只取内容/时序/校准，勿照搬形式）。

---

## 二、存档（SKILL.md §3 第7步 / 交付格式第11条执行）

### 触发条件

- 建模/复制类任务（产出了新 .mod）→ 必须执行本节
- 纯排错 / 对已有 .mod 修改且无新文件产出 → 跳过

### ⏸ 询问门控（必须停下等回答，不得提前写任何文件）

清理工作目录完成后，把这一行作为交付消息的**固定收尾行**发出（即 SKILL.md 第7步）：

> "是否将本次模型归档至模型存档库？归档后可在未来任务中自动检索调用。（是/否）"

**用户此前说过"收尾 / wrap up / 差不多了"不豁免这一问**——把任务收完本就包含问这一句；
它只花一行，却让模型长期可检索复用，漏问则价值永久且无声地丢失。

用户回答**否**：跳过，不做任何文件操作。  
用户回答**是**：按下方步骤执行。

### 存档步骤

**a. 建该模型的子文件夹**（文件夹名 = ModelID；父目录不存在时一并创建）
```bash
mkdir -p references/model-archive/<ModelID>
```

**b. 复制该模型的全部运行所需文件进子文件夹**
```bash
cp <工作目录>/<ModelID>.mod              references/model-archive/<ModelID>/
# 推导 md（本任务产出了就一并复制）
cp <工作目录>/<ModelID>_derivation.md    references/model-archive/<ModelID>/
# 稳态/辅助 .m —— 凡稳态或关键系数算在 .m 里，必须一并存，否则模型跑不出来：
#   外部稳态文件 <ModelID>_steadystate.m、求解 driver（如 run_<ModelID>.m）、
#   helper 函数（BGG ζ 系数、IRF-matching 目标函数…）、params include（*.inc）等
cp <工作目录>/<ModelID>_steadystate.m    references/model-archive/<ModelID>/   # 若存在
cp <工作目录>/run_<ModelID>.m            references/model-archive/<ModelID>/   # 若存在
# 其余该模型专属、复跑必需的 .m / .inc / 小数据，按需一并复制
```
> 判据：**离开这个子文件夹，模型还能不能从头跑出稳态与 IRF？** 不能则缺的文件就得补进来。
> 不复制：Dynare 自动产物（`+<ModelID>/`、`Output/`、`*_results.mat`、自动生成的 `*_dynamic.m/_static.m`）、
> 论文 PDF、通用 skill 资产（`plot_irfs_pub.m`、`plot_series_pub.m` 已在 skill 里，不必随模型存）。

**c. 初始化 CSV 表头**（全新安装、文件不存在时执行）
```
"ModelID","Task","Paper","Year","ModelType","Economy","Category","KeyFeatures","DateAdded"
```

**d. 追加 catalog 行**

格式与 `catalog.csv` 完全兼容（便于跨两个文件同一 grep）：

| 字段 | 说明 |
|------|------|
| `ModelID` | 模型标识 = 子文件夹名 = `.mod` 文件名（不含 `.mod`） |
| `Task` | 本次任务一句话摘要（区分于 Paper 描述） |
| `Paper` | 复现论文全名；自建模型填 `custom` |
| `Year` | 论文年份；自建填建模当年 |
| `ModelType` | 模型族 + 是否线性化，如 `NK nonlinear`、`RBC nonlinear` |
| `Economy` | `Closed economy` / `Open economy` / `Euro Area` 等 |
| `Category` | 14 类桶之一（见 catalog-lookup.md），如 `3. Financial Accelerator / BGG-type Credit Frictions` |
| `KeyFeatures` | 自由文本机制标签，供 grep 命中，如 `financial accelerator, Calvo pricing, @#define switch` |
| `DateAdded` | 存档日期 YYYY-MM-DD |

**e. 完成报告**

向用户报告："已归档至模型存档库：`references/model-archive/<ModelID>/`（含 .mod、推导 md、稳态/辅助 .m）"，
并列出实际复制进去的文件，便于核对是否齐全（复跑所需文件都在）。

---

## 三、格式示例

```csv
"ModelID","Task","Paper","Year","ModelType","Economy","Category","KeyFeatures","DateAdded"
"bgg_financial","BGG 1999 financial accelerator vs frictionless NK; @#define macro switch WITH_FA","Bernanke Gertler Gilchrist 1999","1999","NK nonlinear","Closed economy","3. Financial Accelerator / BGG-type Credit Frictions","financial accelerator, CSV optimal contract, external finance premium, entrepreneur net worth, @#ifndef WITH_FA macro switch, Calvo nonlinear pricing, CEE investment adjustment costs","2026-06-13"
```
