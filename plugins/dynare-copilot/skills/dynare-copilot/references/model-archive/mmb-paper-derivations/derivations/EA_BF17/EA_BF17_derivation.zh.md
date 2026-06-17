# EA_BF17 - 欧元区的货币与货币政策：危机期间的实证分析

> `EA_BF17` 的第一轮私有归档推导。状态：`needs_review`。
> 来源：Jonathan Benchimol and Andre Fourcans (2017), "Money And Monetary Policy In The Eurozone: An Empirical Analysis During Crises", Macroeconomic Dynamics 21(03), 677-707. DOI: `10.1017/s1365100515000644`。
> 主要 Markdown：`raw/mmb_mineru/runs/ea_bf17__money_and_monetary_policy_in_the_eurozone_an_empirical_analysis_during_c__c4e7b84e/full.md`。
> 原始 PDF 路径存在并已记录作溯源，但未打开 PDF 正文。

## 1. 模型概述

- **模型**：欧元区小型新凯恩斯 DSGE 模型，用于在危机窗口中比较可分基准模型与货币进入非可分效用的模型。
- **论文侧来源匹配**：Markdown 开头报告了预期标题以及作者 Jonathan Benchimol 和 Andre Fourcans。作者姓名存在 OCR 重音符号瑕疵，但没有来源标题不匹配。
- **主体**：代表性家庭、采用 Calvo 定价的垄断竞争企业，以及根据平滑 Taylor 型名义利率规则行动的中央银行。
- **货币模块**：Model 2 包含消费与实际货币余额之间的非可分性，并包含带货币项的货币政策规则。Model 1 将货币相关参数和冲击置零。
- **估计/实现形式**：围绕零值或趋势稳态的对数线性 `model(linear)`。文章说明详细模型在 Online Appendix 中，但 MinerU Markdown 不含该附录；因此下方约化方程组为 `needs_review`，并且只用 MMB 实现作交叉检查。
- **运行时验证**：未执行。没有运行 Dynare，也没有把本推导提升到可运行 skill archive。

## 2. 优化问题

### 家庭

来源描述了两类家庭偏好。Model 1 的效用中不包含货币。Model 2 使用消费与实际货币余额之间的非可分偏好，其中 `b` 是货币相对权重，`\nu` 是替代弹性倒数，`\sigma` 是风险厌恶/跨期替代参数。

与论文一致的 Model 2 家庭问题可紧凑写为：

$$
\max_{\{C_t,M_t,B_t,N_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C_t,M_t/P_t,N_t;\varepsilon_t^p,\varepsilon_t^m)
$$

约束为包含消费、实际货币余额、一期间名义债券、劳动收入、利润和转移的名义预算约束：

$$
P_t C_t + M_t + Q_t B_t
\le B_{t-1}+M_{t-1}+W_tN_t+\Pi_t^{div}-T_t.
$$

Markdown 中没有 Online Appendix 的精确效用聚合器，故为 `needs_review`。MMB 实现交叉检查显示，约化 IS 曲线和货币需求关系中，预期产出增长、名义利率缺口和货币冲击会影响实际货币余额。

### 企业

最终产出由垄断竞争企业使用劳动和技术生产。参数表将 `\alpha` 定义为劳动份额，将 `\theta` 定义为价格不变的 Calvo 概率。来源描述了标准新凯恩斯粘性价格模块及其弹性价格对应项。

论文侧 Markdown 不包含完整企业优化问题或 Calvo 重设价格 FOC，因此 Phillips 曲线斜率公式为 `needs_review`。

### 中央银行

货币当局遵循平滑 Taylor 型规则，包含利率平滑 `\lambda_i`、通胀系数 `\lambda_\pi`、产出缺口系数 `\lambda_x`，以及在 Model 2 中的货币缺口系数 `\lambda_{mp}`。

## 3. 一阶条件（FOC）

归档系统采用非可分 Model 2 的约化形式。方程以对数偏离或去趋势观测单位书写。系数别名是 Online Appendix 中结构参数的函数；由于 Markdown 不含 Online Appendix 方程，这些系数为 `needs_review`。

**(F1) 弹性价格产出**

$$
y_t^f =
\frac{1+\eta}{D}a_t
+ \frac{(1-\alpha)(\nu-\sigma)(1-a_1)}{D}mp_t^f
- \frac{(1-\alpha)\log\left(\frac{\varepsilon}{\varepsilon-1}\right)}{D}
+ \frac{(1-\alpha)(\nu-\sigma)(1-a_1)}{(1-\nu)D}e_t^m,
$$

其中

$$
D=\bigl(\nu-(\nu-\sigma)a_1\bigr)(1-\alpha)+\eta+\alpha.
$$

该公式依据 Markdown 中关于货币冲击系数的讨论以及 MMB 实现中的约化弹性价格模块；系数仍需来源级复核。

**(F2) 弹性价格实际货币余额**

$$
mp_t^f =
-\frac{a_2\bigl(\nu-(\nu-\sigma)a_1\bigr)}{\nu}E_t[y_{t+1}^f]
+ \left(1+\frac{a_2\bigl(\nu-(\nu-\sigma)a_1\bigr)}{\nu}\right)y_t^f
+ \frac{1}{\nu}e_t^m.
$$

**(F3) 新凯恩斯 Phillips 曲线**

$$
\pi_t=\beta E_t[\pi_{t+1}]
+ \kappa_y(y_t-y_t^f)
+ \kappa_m(mp_t-mp_t^f).
$$

实现交叉检查把斜率展开为 `\alpha`、`\theta`、`\beta`、`\nu`、`\sigma`、`a_1`、`\eta` 和加成冲击 `e_t^p` 的函数；这些分母项需对照 Online Appendix 复核，状态为 `needs_review`。

**(F4) 动态 IS 曲线**

$$
y_t=E_t[y_{t+1}]
-\frac{1}{\nu-a_1(\nu-\sigma)}(r_t-\bar r-E_t[\pi_{t+1}])
+\frac{(\sigma-\nu)(1-a_1)}{\nu-a_1(\nu-\sigma)}E_t[mp_{t+1}-mp_t]
-\frac{(1-a_1)(\nu-\sigma)}{(1-\nu)(\nu-a_1(\nu-\sigma))}E_t[e_{t+1}^m-e_t^m].
$$

**(F5) 实际货币需求**

$$
mp_t=y_t-\frac{a_2}{\nu}(r_t-\bar r)+\frac{1}{\nu}e_t^m.
$$

**(F6) 平滑 Taylor 规则**

$$
r_t-\bar r=(1-\lambda_i)\left[\lambda_\pi(\pi_t-\bar\pi)+\lambda_x(y_t-y_t^f)+\lambda_{mp}(mp_t-mp_t^f)\right]
+\lambda_i(r_{t-1}-\bar r)+e_t^i.
$$

来源文字说明 Model 2 在政策规则中包含货币。实现交叉检查中货币项被注释掉，因此精确 MMB 规则变体为 `needs_review`。

## 4. 市场出清与总量恒等式

**(F7) 产出缺口恒等式**

$$
ygap_t=y_t-y_t^f.
$$

文章 Markdown 未单独报告总资源约束；约化对数线性系统把商品市场出清嵌入 IS 方程和弹性产出方程。这是第一轮限制，仍为 `needs_review`。

## 5. 外生过程

来源识别了加成、技术、货币政策和货币冲击。MMB 交叉检查使用 AR(1) 状态变量 `ep`、`ei`、`em` 和 `at`，创新为 `up`、`ui`、`um` 和 `ua`。

**(F8) 技术冲击**

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

**(F9) 加成冲击**

$$
e_t^p=\rho_p e_{t-1}^p+\varepsilon_t^p.
$$

**(F10) 货币政策冲击**

$$
e_t^i=\rho_i e_{t-1}^i+\varepsilon_t^i.
$$

**(F11) 货币冲击**

$$
e_t^m=\rho_m e_{t-1}^m+\varepsilon_t^m.
$$

## 6. 稳态求解

由于实现模型是对数线性的，扣除确定性均值或趋势后的稳态偏离为零：

$$
\bar y=\bar y^f=\overline{mp}=\overline{mp^f}=\bar\pi-\pi^*=\bar r-r^*=\overline{ygap}=0.
$$

实现交叉检查单独设置平稳常数：

$$
\bar\pi=pb,\qquad \bar y=yb,\qquad \overline{mp}=mpb,\qquad \bar r=rb.
$$

观察到的 MMB 有效校准为：

$$
pb=0.92,\qquad yb=0,\qquad mpb=0,\qquad rb=0.
$$

实现中观察到的结构系数定义为：

$$
a_1=\frac{1}{1+\left(\frac{b}{1-b}\right)^{1-\nu}\left(\frac{1}{1-\exp(-1/\beta)}\right)^{(1-\nu)/\nu}},
\qquad
a_2=\frac{1}{\exp(1/\beta)-1}.
$$

上述指数定义在提升到 `needs_review` 以上状态前应对照论文/Online Appendix 检查。

## 7. 时序与形式约定

- **形式**：对数线性 `model(linear)` 约化系统。
- **预期**：`E_t[y_{t+1}]`、`E_t[\pi_{t+1}]` 和 `E_t[mp_{t+1}]` 对应实现交叉检查中的 Dynare lead。
- **存量**：约化模型没有物质资本存量。实际货币余额由货币需求方程和货币冲击过程决定，而不是由单独积累方程决定。
- **政策时序**：Taylor 规则通过 `r_{t-1}` 包含滞后名义利率平滑。
- **冲击**：结构冲击状态为持久 AR(1) 变量；在实现交叉检查中，创新以百分比尺度进入。
- **来源限制**：由于 Markdown 缺少 Online Appendix 方程，系数层面的时序和符号约定仍为 `needs_review`。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生变量 | `y`, $y_t$ | 产出缺口/去趋势产出 | (F4) |
| 内生变量 | `pi`, $\pi_t$ | 通胀 | (F3) |
| 内生变量 | `r`, $r_t$ | 偏离形式的短期名义利率 | (F6) |
| 内生变量 | `mp`, $mp_t$ | 实际货币余额 | (F5) |
| 内生变量 | `yf`, $y_t^f$ | 弹性价格产出 | (F1) |
| 内生变量 | `mpf`, $mp_t^f$ | 弹性价格实际货币余额 | (F2) |
| 内生变量 | `ygap`, $ygap_t$ | 相对弹性价格产出的产出缺口 | (F7) |
| 内生冲击状态 | `at`, $a_t$ | 技术状态 | (F8) |
| 内生冲击状态 | `ep`, $e_t^p$ | 加成/偏好状态 | (F9) |
| 内生冲击状态 | `ei`, $e_t^i$ | 货币政策冲击状态 | (F10) |
| 内生冲击状态 | `em`, $e_t^m$ | 货币冲击状态 | (F11) |
| 外生创新 | `ua`, $\varepsilon_t^a$ | 技术创新 | -- |
| 外生创新 | `up`, $\varepsilon_t^p$ | 加成/偏好创新 | -- |
| 外生创新 | `ui`, $\varepsilon_t^i$ | 货币政策创新 | -- |
| 外生创新 | `um`, $\varepsilon_t^m$ | 货币创新 | -- |
| 参数 | `alpha`, $\alpha$ | 生产中的劳动份额 | -- |
| 参数 | `beta`, $\beta$ | 贴现因子 | -- |
| 参数 | `teta`, $\theta$ | Calvo 不重设价格概率 | -- |
| 参数 | `vega`, $\nu$ | 消费与实际货币余额之间替代弹性的倒数 | -- |
| 参数 | `sigma`, $\sigma$ | 风险厌恶/跨期替代弹性倒数 | -- |
| 参数 | `b` | 实际货币余额在效用中的相对权重 | -- |
| 参数 | `neta`, $\eta$ | Frisch 弹性倒数 | -- |
| 参数 | `epsilon`, $\varepsilon$ | 产品间替代弹性 | -- |
| 参数 | `li1`, $\lambda_i$ | 利率平滑 | -- |
| 参数 | `li2`, $\lambda_\pi$ | 通胀反应 | -- |
| 参数 | `li3`, $\lambda_x$ | 产出缺口反应 | -- |
| 参数 | `li4`, $\lambda_{mp}$ | 货币缺口反应 | -- |
| 参数 | `rhoa`, `rhop`, `rhoi`, `rhom` | 冲击持久性参数 | -- |
| 参数 | `pb`, `yb`, `mpb`, `rb` | 线性模型常数/平稳值 | -- |
