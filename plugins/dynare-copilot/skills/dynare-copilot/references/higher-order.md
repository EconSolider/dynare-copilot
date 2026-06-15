# 高阶摄动（order=2/3，风险、资产定价、不确定性冲击）

> **何时读**：任务涉及**风险/不确定性本身的效应**——风险溢价/资产定价、预防性储蓄、不确定性（波动率）
> 冲击、福利的二阶项、Epstein-Zin 递归偏好、随机/遍历稳态、GIRF。命令仍是 `stoch_simul`/`method_of_moments`，
> 但 `order=2` 或 `3`。**本文件回答**：何时必须上高阶、各阶多算了什么、pruning/GIRF/随机稳态怎么用、
> 资产定价与 Epstein-Zin 的写法、政策函数怎么画。
> **分工**：`stoch_simul` 的选项细节与 `oo_.dr` 高阶张量存储见 stochastic-simulation.md；本文讲**为什么用高阶、
> 高阶特有的对象与陷阱**。

一阶摄动满足**确定性等价**：风险（冲击方差）完全不进决策规则，IRF 对称、风险溢价恒为 0、不确定性冲击无效。
凡是研究"风险/方差本身如何影响均值与决策"的问题，一阶都给不出答案，必须上二阶及以上。

## 1. 各阶多算了什么（决定该选几阶）

| 现象 / 需求 | 最低阶 | 为什么 |
| ----------- | ------ | ------ |
| 标准 IRF、矩、估计 | 1 | 确定性等价够用、最快最稳 |
| 风险溢价、预防性储蓄、风险对**均值**的修正（`ghs2`）、二阶福利 | 2 | 引入常数风险修正项与平方项，均值偏离确定性稳态 |
| **时变**风险溢价、随机波动率/不确定性冲击的传播、三阶福利 | 3 | 风险修正随状态变化（风险×状态交互），波动率冲击才有非平凡动态 |

经验法则：能用一阶回答的就别上高阶（慢、易爆、需 pruning）；一旦问题里"方差/不确定性"是主角，才上。

## 2. 必备选项：order 与 pruning

```dynare
stoch_simul(order=2, pruning, irf=0) y c rp_ann;   // 高阶通常 irf=0，改看矩/GIRF
```

- `order=2|3`：泰勒展开阶。
- **`pruning`：二阶起强烈建议开**。高阶模拟会因高次项产生爆炸性伪路径，pruning（Kim et al. 2008 /
  Andreasen et al. 2018）按阶剥离这些项，保证模拟平稳。开 pruning 后理论矩按剪枝状态空间算（更准）；
  不开则二阶矩只是基于线性项的近似（详见 stochastic-simulation.md）。
- 高阶**不支持** `conditional_variance_decomposition`（order<3 且无 pruning 才行）、部分解析矩。
- 高阶 + 非对称/有偏创新：见 DSGE_mod `Andreasen_2012`、`Born_Pfeifer_2014`。

## 3. 高阶特有对象

### 随机稳态 / 遍历均值（stochastic steady state, EMAS）
二阶起，模型的"中心"不再是确定性稳态：
- **随机稳态（risky steady state）**：无当期冲击、但 agent 知道未来有风险时停留的点。
- **遍历均值（ergodic mean / EMAS）**：长期模拟的均值。
两者都偏离确定性稳态，偏移量正是风险修正（`oo_.dr.ghs2`）。报告均值/IRF 时要说清是相对哪个基准。
GIRF（见下）默认相对 EMAS。

### 广义脉冲响应 GIRF
高阶下 IRF 依赖初始状态与冲击符号/大小（非线性），标准 `irf=` 给的是相对确定性稳态的一条特定路径，
往往不是想要的。要"从遍历均值出发、对冲击的平均响应"，用 **GIRF**：在 EMAS 处加冲击模拟、对随机化的
未来路径取均值、再减无冲击基线。DSGE_mod `Basu_Bundick_2017` 给了在 EMAS/遍历均值处算 GIRF 的标准写法
（尤其不确定性冲击：一阶下波动率冲击完全无效，必须三阶 + GIRF）。

## 4. 资产定价：为什么一阶杀死风险溢价

风险溢价 = 风险资产与无风险利率的期望收益差，本质上来自收益与随机贴现因子（SDF）的**协方差**——
这是个二阶矩。一阶摄动确定性等价 ⇒ 该协方差被抹平 ⇒ 溢价恒为 0。所以**任何风险溢价/股权溢价问题至少 order=2**
（要时变溢价则 order=3）。课程的 Jermann (1998) 例子把这点演示得最直白：同一资产定价模型分别跑
order=1/2/3，看溢价怎么从 0 长出来。常配合习惯形成（habit）+ 资本调整成本放大溢价。

## 5. Epstein-Zin 递归偏好

把跨期替代弹性与风险厌恶解耦（标准 CRRA 把两者绑死），是高阶资产定价/长期风险模型的常用偏好。
写法：用**辅助变量**递归定义效用与确定性等价算子（`U`、`E_t[U(+1)^(1-gamma)]^(1/(1-gamma))` 等），
模型块里逐条写出，再 `order=2|3` + pruning。参照 DSGE_mod `Caldara_et_al_2012`（Epstein-Zin + 随机波动率，
含递归偏好与预期收益的辅助变量写法）。

## 6. 画政策函数 / 验证非线性

高阶的价值在于决策规则的**曲率**，直接画出来最直观。课程提供 `plot_policy_fun.m`：给定状态网格，调用
`oo_.dr` 张量重构并绘制某控制变量对某状态的政策函数，对比一阶（直线）与二/三阶（弯曲）。
DSGE_mod `Caldara_et_al_2012` 亦含 `plot_policy_fun.m`。课程另有 `AES_example.m`：在一个玩具期望方程
`y_t = E_t[exp(rho*x + eps)]` 上，把**真解**与**标准（同时）摄动**、**序贯摄动**两种近似并排画出，直观看
摄动如何处理风险/Jensen 项（`exp` 的 `1/2*Var` 修正）——理解高阶为何能捕捉风险、不同摄动方案精度差异的最小例子。

## 7. 课程示例（Pfeifer Dynare Course，本地可跑，**首选参照**）

> 路径 `references/examples-code/Dynare_Course/Chapter_08_Higher_order/`。
> `grep -i "order = 2\|order=2\|higher\|risk premium\|asset pricing" references/catalog-code.csv`。

| 文件 | 教什么 |
| ---- | ------ |
| `Jermann1998.mod` | **同模型 order=1 vs 2 vs 3 并排对比**：风险溢价、无风险利率、SDF、年化收益怎么随阶变化；含习惯形成 + 资本调整成本 |
| `Jermann_1998.mod` | DSGE_mod 复制版：`stoch_simul(order=2) rp_ann` 直接取股权溢价 |
| `plot_policy_fun.m` | 政策函数绘图辅助（重构 `oo_.dr` 张量、画曲率） |
| `AES_example.m` | 玩具期望方程上对比真解 vs 同时/序贯摄动近似，展示摄动如何处理风险项 |

先读 `Jermann1998.mod` 的多阶对比块——它把"一阶为何不够"用一个能跑的例子讲清楚，比任何文字都有效。

## 8. 相关 DSGE_mod（catalog-code.csv，编程逻辑库）

- `SGU_2004`：二阶近似经典入门（policy function、pruning、一阶 vs 二阶福利）。
- `Basu_Bundick_2017`：不确定性冲击、EMAS 处的 GIRF、外部 steadystate.m、三阶。
- `Caldara_et_al_2012`：Epstein-Zin 递归偏好 + 随机波动率、`plot_policy_fun.m`。
- `Born_Pfeifer_2018_welfare`、`RBC_baseline_welfare`：二阶福利/消费等价。

## 9. 常见坑

- 忘开 `pruning` → 二/三阶模拟出现爆炸路径或 NaN。
- 在高阶随机情形里用 `max/min/abs/比较算子`（R6）→ 拐点导数错误，结果静默失真；偶尔约束改用 OccBin/完全预见。
- 把高阶 IRF/均值当成"相对确定性稳态"解读 → 实际多相对 EMAS/随机稳态，报告时务必说清基准。
- 估计时盲目上 order=2 GMM/SMM → 慢且未必识别得更好；先确认问题真的需要风险项（见 moments-method.md）。
