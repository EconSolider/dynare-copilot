# Examples

本目录是用法示范，**不属于 skill 本体**（安装 skill 时不需要）。

## rbc_gov —— 含政府支出的基础 RBC

按 skill 流程端到端产出的样例：

- `rbc_gov_derivation.md` —— 阶段1 推导文件（八节结构：最优化问题 → FOC → 市场出清 → 外生过程 → 稳态求解 → 时序 → 变量对照表）。
- `rbc_gov.mod` —— 据推导逐条翻译的 Dynare 文件，TFP + 政府支出两冲击，稳态解析求解并反解 `psi`（命中 N=1/3）与 `gss`（命中 G/Y=0.2）。

运行：`dynare rbc_gov`（需 Dynare 7.1 + MATLAB/Octave）。
