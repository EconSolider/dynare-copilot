# 模型存档库（model archive）使用规范

> **何时读**：① 第1.3步检索模型库时需要查模型存档库；② 第6步交付收尾时需要执行存档。
> 本文件规定模型存档库的目录结构、检索方式、存档流程与全新安装时的初始化行为。

---

## 目录结构

```
references/
├── model-archive-catalog.csv   ← 存档库索引（格式同 catalog.csv，可同一 grep 命令搜索）
└── model-archive/
    ├── <模型名>.mod             ← 存档的 Dynare 模型文件
    └── <模型名>_derivation.md   ← （可选）配套推导文件
```

全新安装时以上文件/目录均不存在，属正常情况——按下方"全新安装"处理。

---

## 一、检索（第1.3步执行）

在 `catalog.csv`（149 篇 MMB）无相近命中后，检索模型存档库：

```bash
# 先确认文件存在，再 grep
grep -i "TANK\|hand-to-mouth" references/model-archive-catalog.csv
grep -i "financial accelerator" references/model-archive-catalog.csv
```

**全新安装时**：`references/model-archive-catalog.csv` 不存在 → 直接跳过，视为无命中，不报错，不尝试读取。

有命中时，读 `references/model-archive/<ModelID>.mod` 作补充参照（只取内容/时序/校准，勿照搬形式）。

---

## 二、存档（第6步第10条执行）

### 触发条件

- 建模/复制类任务（产出了新 .mod）→ 必须执行本节
- 纯排错 / 对已有 .mod 修改且无新文件产出 → 跳过

### ⏸ 询问门控（必须停下等回答，不得提前写任何文件）

清理工作目录完成后，向用户发出：

> "是否将本次模型归档至模型存档库？归档后可在未来任务中自动检索调用。（是/否）"

用户回答**否**：跳过，不做任何文件操作。  
用户回答**是**：按下方步骤执行。

### 存档步骤

**a. 初始化目录**（全新安装时执行，已存在则跳过）
```bash
mkdir -p references/model-archive
```

**b. 复制模型文件**
```bash
cp <工作目录>/<模型名>.mod references/model-archive/<模型名>.mod
# 若本任务产出了推导 md，一并复制
cp <工作目录>/<模型名>_derivation.md references/model-archive/<模型名>_derivation.md
```

**c. 初始化 CSV 表头**（全新安装、文件不存在时执行）
```
"ModelID","Task","Paper","Year","ModelType","Economy","Category","KeyFeatures","DateAdded"
```

**d. 追加 catalog 行**

格式与 `catalog.csv` 完全兼容（便于跨两个文件同一 grep）：

| 字段 | 说明 |
|------|------|
| `ModelID` | 文件名（不含 `.mod`） |
| `Task` | 本次任务一句话摘要（区分于 Paper 描述） |
| `Paper` | 复现论文全名；自建模型填 `custom` |
| `Year` | 论文年份；自建填建模当年 |
| `ModelType` | 模型族 + 是否线性化，如 `NK nonlinear`、`RBC nonlinear` |
| `Economy` | `Closed economy` / `Open economy` / `Euro Area` 等 |
| `Category` | 14 类桶之一（见 catalog-lookup.md），如 `3. Financial Accelerator / BGG-type Credit Frictions` |
| `KeyFeatures` | 自由文本机制标签，供 grep 命中，如 `financial accelerator, Calvo pricing, @#define switch` |
| `DateAdded` | 存档日期 YYYY-MM-DD |

**e. 完成报告**

向用户报告："已归档至模型存档库：`references/model-archive/<模型名>.mod`"

---

## 三、格式示例

```csv
"ModelID","Task","Paper","Year","ModelType","Economy","Category","KeyFeatures","DateAdded"
"bgg_financial","BGG 1999 financial accelerator vs frictionless NK; @#define macro switch WITH_FA","Bernanke Gertler Gilchrist 1999","1999","NK nonlinear","Closed economy","3. Financial Accelerator / BGG-type Credit Frictions","financial accelerator, CSV optimal contract, external finance premium, entrepreneur net worth, @#ifndef WITH_FA macro switch, Calvo nonlinear pricing, CEE investment adjustment costs","2026-06-13"
```
