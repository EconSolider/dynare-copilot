# NK_GS14 - 推导

> `NK_GS14` 的模型档案草稿。未执行运行时验证。源方程来自 Gambacorta and Signoretti (2014) 的 MinerU Markdown，尤其是附录 A；MMB 复现文件仅作为实现交叉检查使用。

## 1. Model Overview

- **模型**：`NK_GS14`，基于 Leonardo Gambacorta and Federico M. Signoretti (2014), "Should monetary policy lean against the wind? An analysis based on a DSGE model with banking", *Journal of Economic Dynamics and Control*, 43, 146-174, DOI `10.1016/j.jedc.2014.01.016`。
- **来源**：`raw/mmb_mineru/runs/nk_gs14__should_monetary_policy_lean_against_the_wind_an_analysis_based_on_a_dsge__0f9b3acb/full.md`；原始 PDF 路径已检查：`raw/mmb_papers/Should monetary policy lean against the wind? An analysis based on a DSGE model with banking.pdf`。
- **主体**：耐心家庭、非耐心企业家、含批发与零售贷款部门的银行、资本品生产者、零售商和中央银行。
- **核心摩擦**：企业家面对与资本价值挂钩的抵押/借款约束；银行有目标资本资产比率，并随银行杠杆调整贷款利差。
- **冲击与政策实验**：论文研究技术冲击和成本推动冲击，并比较标准泰勒规则与可响应产出、信贷和资本资产价格的扩展泰勒规则。
- **模型形式**：源文附录 A 给出完整非线性均衡系统。论文围绕非随机零通胀稳态进行对数线性化求解；MMB 实现使用带 `exp(...)` 变量的对数水平非线性方程并做一阶 `stoch_simul`，不是 Dynare `model(linear)` 形式。
- **状态**：`needs_review`，因为 MinerU Markdown 中附录 C 的若干公式有 OCR 痕迹，且没有执行 Dynare 运行时验证。

## 2. Optimization Problems

### 耐心家庭

家庭 $`i`$ 选择消费、劳动供给和存款：

```math
\max_{\{c_t^p(i),l_t^p(i),d_t^p(i)\}}
E_0\sum_{t=0}^{\infty}\beta_P^t
\left[\log c_t^p(i)-\frac{(l_t^p(i))^{1+\phi}}{1+\phi}\right].
```

预算约束为：

```math
c_t^P(i)+d_t^P(i)
\leq w_t l_t^P(i)+(1+r_{t-1}^{ib})d_{t-1}^P(i)+J_t^R(i).
```

### 企业家

企业家 $`i`$ 选择消费、劳动需求、贷款和资本：

```math
\max_{\{c_t^E(i),l_t^{P,d}(i),b_t^{EE}(i),k_t^E(i)\}}
E_0\sum_{t=0}^{\infty}\beta_E^t\log c_t^E(i).
```

预算约束为：

```math
c_t^E(i)+(1+r_{t-1}^b)b_{t-1}^{EE}(i)+w_t l_t^{P,d}(i)+q_t^k k_t^E(i)
\leq \frac{y_t^e(i)}{x_t}+b_t^{EE}(i)+q_t^k(1-\delta^k)k_{t-1}^e(i).
```

抵押约束为：

```math
b_t^{EE}(i)\leq
\frac{m^E q_{t+1}^k k_t^e(i)(1-\delta^k)}{1+r_t^b}.
```

企业家生产批发品：

```math
y_t^E(i)=A_t^E(k_{t-1}^E(i))^{\xi}(l_t^{P,d}(i))^{1-\xi}.
```

源文 A.7 在生产函数中印为 $`k_t^E`$，但资本回报方程和 MMB 实现均使用预定资本 $`k_{t-1}^E`$；这里按该时序规范化，并标记为 `needs_review`。

### 银行批发部门

银行 $`j`$ 选择贷款和存款：

```math
\max_{\{b_t(j),d_t(j)\}}
R_t^b b_t(j)-r_t^{ib}d_t(j)
-\frac{\theta}{2}\left(\frac{K_t^b(j)}{b_t(j)}-\nu\right)^2K_t^b(j)
```

约束为：

```math
b_t(j)=d_t(j)+K_t^b(j).
```

### 资本品生产者和零售商

资本品生产者在投资调整成本下把最终品转化为新资本。零售商带来 Rotemberg 型新凯恩斯菲利普斯曲线，其中包含加价冲击 $`mk_t^y`$ 和边际成本 $`mc_t^E=1/x_t`$。

## 3. First-Order Conditions

- **(F1) 家庭消费边际效用**：

```math
\lambda_t^P=\frac{1}{c_t^p}.
```

- **(F2) 家庭欧拉方程**：

```math
\frac{1}{c_t^p}
=E_t\left[\frac{\beta_P(1+r_t^{ib})}{c_{t+1}^p}\right].
```

- **(F3) 家庭劳动供给**：

```math
(l_t^p)^\phi=\frac{w_t}{c_t^p}.
```

- **(F4) 家庭预算约束**：

```math
c_t^p+d_t^p=w_t l_t^p+(1+r_{t-1}^{ib})d_{t-1}^p+J_t^R/\gamma_p.
```

- **(F5) 企业家消费边际效用**：

```math
\lambda_t^E=\frac{1}{c_t^E}.
```

- **(F6) 企业家劳动需求**：

```math
w_t=\frac{(1-\xi)y_t^e}{l_t^{P,d}x_t}.
```

- **(F7) 企业家投资欧拉方程**：

```math
s_t^E\frac{m^E q_{t+1}^k(1-\delta^k)}{1+r_t^b}
\beta_E E_t\left[\lambda_{t+1}^E\left(q_{t+1}^k(1-\delta^k)+r_{t+1}^k\right)\right]
=\lambda_t^E q_t^k.
```

- **(F8) 含抵押乘子的企业家消费欧拉方程**：

```math
\lambda_t^E-s_t^E
=\beta_E E_t\left[\lambda_{t+1}^E(1+r_t^b)\right].
```

- **(F9) 企业家预算约束**：

```math
c_t^E+(1+r_{t-1}^b)b_{t-1}^{EE}+w_t l_t^{P,d}+q_t^k k_t^E
=\frac{y_t^e}{x_t}+b_t^{EE}+q_t^k(1-\delta^k)k_{t-1}^e.
```

- **(F10) 企业家生产函数**：

```math
y_t^e=A_t^E(k_{t-1}^E)^\xi(l_t^{P,d})^{1-\xi}.
```

- **(F11) 借款约束**：

```math
(1+r_t^b)b_t^{EE}=m^E q_{t+1}^k k_t^e(1-\delta^k).
```

- **(F12) 资本回报**：

```math
r_t^k=\xi\frac{A_t^E(k_{t-1}^E)^{\xi-1}(l_t^{P,d})^{1-\xi}}{x_t}.
```

- **(F13) 含调整成本的资本积累**：

```math
K_t=(1-\delta^k)K_{t-1}
+\left[1-\frac{\kappa^i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right]I_t.
```

- **(F14) 资本品生产者关于 $`q_t^k`$ 的 FOC**：

```math
1=q_t^k\left[
1-\frac{\kappa^i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2
-\kappa^i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}}
\right]
+\beta_E E_t\left[
\frac{\lambda_{t+1}^E}{\lambda_t^E}q_{t+1}^k\kappa^i
\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
```

- **(F15) 新凯恩斯菲利普斯曲线**：

```math
1-\frac{mk_t^y}{mk_t^y-1}
+\frac{mk_t^y}{mk_t^y-1}mc_t^E
-\kappa_p(\pi_t-1)\pi_t
+\beta_P E_t\left[
\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_p(\pi_{t+1}-1)\pi_{t+1}
\frac{Y_{t+1}}{Y_t}
\right]=0.
```

- **(F16) 零售边际成本/加价恒等式**：

```math
mc_t^E=\frac{1}{x_t}.
```

- **(F17) 批发银行贷款利率 FOC**：

```math
R_t^b=r_t^{ib}
-\theta\left(\frac{K_t^b}{B_t}-\nu\right)\left(\frac{K_t^b}{B_t}\right)^2.
```

- **(F18) 含加性加价的零售贷款利率**：

```math
r_t^b=R_t^b+\overline{\mu}^b.
```

- **(F19) 贷款利差定义**：

```math
spread_t=r_t^b-r_t^{ib}.
```

- **(F20) 银行总利润**：

```math
J_t^B=r_t^bB_t-r_t^{ib}D_t
-\frac{\theta}{2}\left(\frac{K_t^b}{B_t}-\nu\right)^2K_t^b.
```

- **(F21) 银行资本积累**：

```math
K_t^b=(1-\delta^b)K_{t-1}^b+J_{t-1}^B.
```

## 4. Market Clearing & Identities

- **(F22) 总消费**：

```math
C_t=\gamma_p c_t^p+\gamma_e c_t^e.
```

- **(F23) 劳动市场出清**：

```math
\gamma_e l_t^{P,d}=\gamma_p l_t^p.
```

- **(F24) 总贷款**：

```math
B_t=\gamma_e b_t^{EE}.
```

- **(F25) 总存款**：

```math
D_t=\gamma_p d_t^p.
```

- **(F26) 总资本**：

```math
K_t=\gamma_e k_t^e.
```

- **(F27) 银行总资产负债表/信贷市场均衡**：

```math
B_t=D_t+K_t^b.
```

- **(F28) 总产出**：

```math
Y_t=\gamma_e y_t^e.
```

- **(F29) 资源约束**：

```math
Y_t=C_t+q_t^k\left(K_t-(1-\delta^k)K_{t-1}\right)
+\frac{\delta^b K_{t-1}^b}{\pi_t}.
```

- **(F30) MMB 政策规则交叉检查中使用的辅助产出**：

```math
Y1_t=C_t+I_t.
```

- **(F31) 银行杠杆**：

```math
lev_t=\frac{B_t}{K_t^b}.
```

- **(F32) 实现中使用的实际利率诊断变量**：

```math
rr_t=r_t^b-\pi_t.
```

- **(F33) 一般扩展泰勒规则**：

```math
\tilde r_t^{ib}=\rho^{ib}\tilde r_{t-1}^{ib}
+(1-\rho^{ib})
\left[
\phi_\pi\widehat{\pi}_t+\phi_y\widehat{Y}_t+\phi_B\widehat{B}_t+\phi_q\widehat{q}_t^k
\right].
```

非线性 MMB 实现把该规则写成总利率规则，并使用经稳态归一化的通胀、辅助产出总量 $`Y1_t`$、资产价格和信贷。这一实现细节记录为 `implementation_cross_check`，不是独立的论文侧源方程。

## 5. Exogenous Processes

- **(F34) 技术冲击**：

```math
A_t^E=\rho^A A_{t-1}^E+\varepsilon_t^A.
```

MMB 文件在 `exp(A_e)` 中把正水平过程实现为
$`A_t^E=1-\rho_A+\rho_A A_{t-1}^E+e_t^A`$。论文源表达式是偏离量上的线性化 AR(1)。

- **(F35) 产品加价/成本推动冲击**：

```math
mk_t^y=(1-\rho_{mk})mk^y+\rho_{mk}mk_{t-1}^y+\varepsilon_t^{mk}.
```

该方程根据 MMB 实现以及论文中成本推动冲击通过 $`mk_t^y`$ / $`\widehat{\varepsilon}_t^y`$ 进入菲利普斯曲线的说明重构；标记 `needs_review` 以便后续源级公式复查。

## 6. Steady-State Solution

论文使用非随机零通胀稳态，并围绕该点对数线性化求解。实现交叉检查提供了数值初值，而非封闭形式的 `steady_state_model`；未执行运行时验证。

稳态规范化和求解顺序：

1. 设 $`\bar{\pi}=1`$、$`\bar{A}^E=1`$、$`\bar{mk}^y=mk^y`$，并令创新为零。
2. 家庭欧拉方程给出

```math
1=\beta_P(1+\bar r^{ib}).
```

3. 当银行资本位于目标比率 $`\bar K^b/\bar B=\nu`$ 时，校准银行利差给出 $`\bar r^b=\bar r^{ib}+\overline{\mu}^b`$。
4. 实现交叉检查中资本价格归一化为 $`\bar q^k=1`$。
5. 目标资本比率、银行资产负债表和总贷款/存款定义给出：

```math
\bar K^b=\nu\bar B,\qquad \bar D=(1-\nu)\bar B,\qquad \bar B=\gamma_e\bar b^{EE}.
```

6. 绑定的借款约束给出：

```math
(1+\bar r^b)\bar b^{EE}=m^E\bar k^e(1-\delta^k).
```

7. 在校准值和论文报告的稳态比率下，生产、劳动需求、劳动供给和资源约束共同确定 $`\bar y^e,\bar l^{P,d},\bar l^p,\bar w,\bar c^p,\bar c^e,\bar I,\bar K,\bar Y`$。
8. 银行资本法则要求：

```math
\delta^b\bar K^b=\bar J^B.
```

9. 论文报告的稳态比率包括 $`C/Y=0.90`$、$`I/Y=0.11`$、$`c^E/C=0.05`$、$`B/K=0.33`$、$`K^b/B=0.09`$ 以及年化 2% 的银行贷款利差。这些是校准目标/检查项，不是已验证的解析稳态推导。

待处理问题：未来实现阶段应推导或复现 MMB 文件使用的精确稳态构造，并运行 `resid; steady; check;`。

## 7. Timing & Form Conventions

- 资本在生产和回报中是预定变量：实现使用 $`k_{t-1}^E`$ 进入生产，并在资本积累/资源约束中使用 $`K_{t-1}`$。印刷版附录 A 的生产方程按该时序规范化，上文已标记 `needs_review`。
- 第 $`t-1`$ 期选择的存款和贷款在第 $`t`$ 期支付利率：家庭和企业家预算包含 $`(1+r_{t-1}^{ib})d_{t-1}^p`$ 与 $`(1+r_{t-1}^b)b_{t-1}^{EE}`$。
- 抵押约束使用下一期资本价格 $`q_{t+1}^k`$ 和当期贷款利率 $`r_t^b`$。
- 银行资本服从滞后利润法则：$`K_t^b=(1-\delta^b)K_{t-1}^b+J_{t-1}^B`$。
- 源文中的政策规则是偏离量上的对数线性规则。MMB 实现用 `exp(...)` 把变量映射为对数水平，并进行一阶模拟。
- 基准情形下债务按当期通胀指数化。附录 D 给出名义债务变体；本档案条目把它记录为待处理变体，不纳入基准 `NK_GS14` 方程列表。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| 内生 | $`c^p`$ / `c_p` | 耐心家庭消费 | (F1), (F2), (F4), (F22) |
| 内生 | $`d^p`$ / `d_p` | 耐心家庭存款 | (F4), (F25) |
| 内生 | $`\lambda^P`$ / `lam_p` | 家庭边际效用 | (F1), (F15) |
| 内生 | $`l^p`$ / `l_p` | 家庭劳动供给 | (F3), (F23) |
| 内生 | $`c^E`$ / `c_e` | 企业家消费 | (F5), (F8), (F9), (F22) |
| 内生 | $`k^E`$ / `k_e` | 企业家资本 | (F9), (F10), (F11), (F26) |
| 内生 | $`b^{EE}`$ / `b_ee` | 企业家贷款 | (F9), (F11), (F24) |
| 内生 | $`\lambda^E`$ / `lam_e` | 企业家边际效用 | (F5), (F7), (F14) |
| 内生 | $`s^E`$ / `s_e` | 借款约束乘子 | (F7), (F8) |
| 内生 | $`l^{P,d}`$ / `l_pd` | 企业家劳动需求 | (F6), (F10), (F23) |
| 内生 | $`y^e`$ / `y_e` | 企业家批发产出 | (F10), (F28) |
| 内生 | $`r^k`$ / `r_k` | 资本回报 | (F12) |
| 内生 | $`\pi`$ / `pie` | 总通胀率 | (F15), (F29), (F33) |
| 内生 | $`mc^E`$ / `mc_E` | 边际成本 | (F15), (F16) |
| 内生 | $`J^R`$ / `J_R` | 零售商利润 | (F4) |
| 内生 | $`q^k`$ / `q_k` | 资本价格 | (F7), (F11), (F14), (F29), (F33) |
| 内生 | $`x`$ / `x` | 零售加价 | (F6), (F10), (F12), (F16) |
| 内生 | $`I`$ / `I` | 投资 | (F13), (F14), (F30) |
| 内生 | $`C`$ / `C` | 总消费 | (F22), (F29), (F30) |
| 内生 | $`Y`$ / `Y` | 总产出 | (F28), (F29), (F33) |
| 内生 | $`w`$ / `w_p` | 实际工资 | (F3), (F4), (F6), (F9) |
| 内生 | $`B`$ / `B` | 总贷款/信贷 | (F24), (F27), (F31), (F33) |
| 内生 | $`D`$ / `D` | 总存款 | (F25), (F27) |
| 内生 | $`K`$ / `K` | 总资本 | (F13), (F26), (F29) |
| 内生 | $`r^{ib}`$ / `r_ib` | 政策/存款利率 | (F2), (F17), (F19), (F33) |
| 内生 | $`J^B`$ / `J_B` | 银行利润 | (F20), (F21) |
| 内生 | $`r^b`$ / `r_b` | 零售贷款利率 | (F8), (F9), (F11), (F18), (F19) |
| 内生 | $`spread`$ / `spread` | 贷款-政策利差 | (F19) |
| 内生 | $`K^b`$ / `K_b` | 银行资本 | (F20), (F21), (F27), (F31) |
| 内生 | $`R^b`$ / `R_b` | 批发贷款利率 | (F17), (F18) |
| 内生 | $`lev`$ / `lev` | 银行杠杆 | (F31) |
| 内生 | $`rr`$ / `rr` | 实际利率诊断变量 | (F32) |
| 内生 | $`Y1`$ / `Y1` | MMB 政策规则中的辅助产出总量 | (F30) |
| 内生 | $`mk^y`$ / `mk_y` | 产品加价/成本推动状态 | (F15), (F35) |
| 内生 | $`A^E`$ / `A_e` | 技术状态 | (F10), (F12), (F34) |
| 外生 | `e_A_e` | 技术创新 | (F34) |
| 外生 | `e_mk_y` | 加价/成本推动创新 | (F35) |
| 参数 | $`\beta_P,\beta_E`$ / `beta_p`, `beta_e` | 折现因子 | (F2), (F7), (F8), (F14), (F15) |
| 参数 | $`\phi`$ / `phi` | Frisch 弹性倒数 | (F3) |
| 参数 | $`m^E`$ / `m_e_ss` | 企业家贷款价值比 | (F7), (F11) |
| 参数 | $`\gamma_p,\gamma_e`$ / `gamma_p`, `gamma_e` | 人口/加总权重 | (F4), (F22)-(F28) |
| 参数 | $`\theta,\nu,\overline{\mu}^b,\delta^b`$ / `theta`, `vi`, `mcspread`, `delta_b` | 银行利差、目标资本比率、加价、银行资本成本 | (F17)-(F21) |
| 参数 | $`\xi,\kappa_p,\kappa^i,\delta^k,\pi^{ss},mk^y`$ / `ksi`, `kappa_p`, `kappa_i`, `deltak`, `piss`, `mk_y_ss` | 生产、价格、投资和稳态加价参数 | (F10), (F13)-(F16), (F29), (F35) |
| 参数 | $`\rho^{ib},\phi_\pi,\phi_y,\phi_q,\phi_B`$ / `rho_ib`, `phi_pie`, `phi_y`, `phi_AP`, `phi_B` | 货币政策规则系数 | (F33) |
| 参数 | $`\rho_A,\rho_{mk}`$ / `rho_A_e`, `rho_mk_y` | 冲击持续性 | (F34), (F35) |
