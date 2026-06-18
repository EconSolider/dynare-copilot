# NK_NS14 -- 推导（最优化问题 + 均衡条件）

> 状态：`needs_review`。本一稿档案条目来自 Nakamura and Steinsson (2014) 的 MinerU Markdown。论文正文给出两地区货币联盟框架，并把可变资本细节放在在线附录 F/G。MMB 实现交叉检查为 `model(linear)`，没有运行 Dynare。

来源：Emi Nakamura and Jon Steinsson (2014), "Fiscal stimulus in a monetary union: Evidence from US regions," *American Economic Review* 104(3), 753-792. DOI: `10.1257/aer.104.3.753`。

## 1. Model Overview

- **模型**：`NK_NS14`，用于解释地区政府支出乘数的两地区开放经济新凯恩斯货币联盟模型。
- **地区**：本地区规模为 $`n`$，外国/其余地区规模为 $`1-n`$；本地区承受主要政府支出冲击。
- **主体和模块**：完全市场家庭、CES 最终消费聚合、Calvo 定价的垄断竞争企业、联邦财政当局、共同货币当局，以及 MMB 实现中的可变资本和投资调整成本。
- **冲击**：本地区政府支出、外国政府支出和共同货币政策冲击。
- **形式**：`model(linear)`，变量为相对确定性稳态的百分比/对数偏离。论文中的带帽变量对应 MMB 的小写线性变量。运行验证：未执行。

## 2. Optimization Problems

### 2.1 家庭

劳动类型为 $`x`$ 的本地区家庭最大化：

```math
E_0\sum_{t=0}^{\infty}\beta^t u(C_t,L_t(x)).
```

消费聚合为：

```math
C_t=\left[\phi_H^{1/\eta}C_{Ht}^{(\eta-1)/\eta}
+\phi_F^{1/\eta}C_{Ft}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
```

本地和外国产品组合为差异化品种的 CES 聚合：

```math
C_{Ht}=\left[\int_0^1 c_{ht}(z)^{(\theta-1)/\theta}dz\right]^{\theta/(\theta-1)},
\qquad
C_{Ft}=\left[\int_0^1 c_{ft}(z)^{(\theta-1)/\theta}dz\right]^{\theta/(\theta-1)}.
```

家庭预算约束为：

```math
P_tC_t+E_t[M_{t,t+1}B_{t+1}(x)]
\leq B_t(x)+(1-\tau_t)W_t(x)L_t(x)+\int_0^1\Xi_{ht}(z)dz-T_t.
```

论文考虑可分偏好和 GHH 偏好：

```math
u(C_t,L_t)=\frac{C_t^{1-\sigma^{-1}}}{1-\sigma^{-1}}
-\chi\frac{L_t^{1+\nu^{-1}}}{1+\nu^{-1}},
```

```math
u(C_t,L_t)=
\frac{\left(C_t-\chi L_t^{1+\nu^{-1}}/(1+\nu^{-1})\right)^{1-\sigma^{-1}}}
{1-\sigma^{-1}}.
```

MMB 实现使用由论文 GHH/可变资本设定校准得到的简化线性方程。

### 2.2 政府

政府对差异化产品的需求采用与私人需求相同的 CES 形式：

```math
g_{ht}(z)=G_{Ht}\left(\frac{p_{ht}(z)}{P_{Ht}}\right)^{-\theta},
\qquad
g_{ft}(z)=G_{Ft}\left(\frac{p_{ft}(z)}{P_{Ft}}\right)^{-\theta}.
```

本地区和外国政府支出服从 AR(1) 过程。共同中央银行用扩展 Taylor 规则设定同一个全经济名义利率。

### 2.3 企业

在正文基准模型中，本地区企业 $`z`$ 用劳动生产差异化产出：

```math
y_{ht}(z)=f(L_t(z)).
```

企业最大化：

```math
E_t\sum_{j=0}^{\infty}M_{t,t+j}
\left[p_{ht+j}(z)y_{ht+j}(z)-W_{t+j}(x)L_{t+j}(z)\right],
```

并满足需求：

```math
y_{ht}(z)=\left(nC_{Ht}+(1-n)C_{Ht}^{\ast}+nG_{Ht}\right)
\left(\frac{p_{ht}(z)}{P_{Ht}}\right)^{-\theta}.
```

对于 MMB 的可变资本版本，论文说明在线附录加入资本积累和投资；实现交叉检查确认存在本地区和外国资本、投资以及最优投资方程。

## 3. First-Order Conditions

下面列出 MMB 线性均衡系统；凡论文中可见的方程优先以论文为来源，`.mod` 只用于交叉检查覆盖范围、时序和变量名。变量均为相对稳态的偏离。

- **(F1) 本地区消费 Euler 方程**：

```math
c_t=c_{t+1}-\sigma_c(r_t-\pi_{t+1})
+\frac{\sigma_c}{\sigma_l}l_t-\frac{\sigma_c}{\sigma_l}l_{t+1}.
```

- **(F2) 完全市场 Backus-Smith 条件**：

```math
c_t-c_t^{\ast}=\sigma_c q_t+\frac{\sigma_c}{\sigma_l}(l_t-l_t^{\ast}).
```

- **(F3) 本地区 Phillips 曲线**：

```math
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\kappa\zeta s_{H,t}.
```

- **(F4) 外国 Phillips 曲线**：

```math
\pi_{F,t}=\beta E_t\pi_{F,t+1}+\kappa\zeta s_{F,t}.
```

- **(F5) 本地区 CPI 通胀聚合**：

```math
\pi_t=\phi_H\pi_{H,t}+\phi_F\pi_{F,t}.
```

- **(F6) 外国 CPI 通胀聚合**：

```math
\pi_t^{\ast}=\phi_H^{\ast}\pi_{H,t}+\phi_F^{\ast}\pi_{F,t}.
```

- **(F7) 含预定资本的本地区生产函数**：

```math
y_t=a\,l_t+(1-a)k_{t-1}.
```

- **(F8) 含预定资本的外国生产函数**：

```math
y_t^{\ast}=a\,l_t^{\ast}+(1-a)k_{t-1}^{\ast}.
```

- **(F9) 本地区实际工资/劳动供给关系**：

```math
w_t=\nu^{-1}l_t.
```

- **(F10) 外国实际工资/劳动供给关系**：

```math
w_t^{\ast}=\nu^{-1}l_t^{\ast}.
```

- **(F11) 本地区实际边际成本**：

```math
s_{H,t}+p_{H,t}=\bar\omega y_t-(\bar\omega-\nu^{-1})k_{t-1}.
```

- **(F12) 外国实际边际成本**：

```math
s_{F,t}-\frac{\phi_H}{\phi_F}\phi_F^{\ast}p_{H,t}
=\bar\omega y_t^{\ast}-(\bar\omega-\nu^{-1})k_{t-1}^{\ast}+q_t.
```

- **(F13) 本地区资本积累**：

```math
k_t=(1-\delta)k_{t-1}+\delta i_t.
```

- **(F14) 外国资本积累**：

```math
k_t^{\ast}=(1-\delta)k_{t-1}^{\ast}+\delta i_t^{\ast}.
```

- **(F15) 本地区最优投资条件**（`needs_review`：来自实现交叉检查，因为 MinerU 正文 Markdown 中没有在线附录公式）：

```math
\sigma_c^{-1}c_t-\sigma_c^{-1}E_tc_{t+1}
-\sigma_l^{-1}l_t+\sigma_l^{-1}E_tl_{t+1}
-(1+\beta)\varepsilon_\phi k_t
-(1-\beta(1-\delta))\rho_k k_t
+\beta\varepsilon_\phi E_tk_{t+1}
+(1-\beta(1-\delta))\rho_yE_ty_{t+1}
=-\varepsilon_\phi k_{t-1}.
```

- **(F16) 外国最优投资条件**（`needs_review`：同 F15 的来源限制）：

```math
\sigma_c^{-1}c_t^{\ast}-\sigma_c^{-1}E_tc_{t+1}^{\ast}
-\sigma_l^{-1}l_t^{\ast}+\sigma_l^{-1}E_tl_{t+1}^{\ast}
-(1+\beta)\varepsilon_\phi k_t^{\ast}
-(1-\beta(1-\delta))\rho_k k_t^{\ast}
+\beta\varepsilon_\phi E_tk_{t+1}^{\ast}
+(1-\beta(1-\delta))\rho_yE_ty_{t+1}^{\ast}
=-\varepsilon_\phi k_{t-1}^{\ast}.
```

## 4. Market Clearing & Identities

- **(F17) 本地区资源约束**：

```math
\begin{aligned}
y_t={}&\phi_H\bar C c_t+\frac{1-n}{n}\phi_H^{\ast}\bar C c_t^{\ast}
+\bar I\phi_H i_t+\frac{1-n}{n}\phi_H^{\ast}\bar I i_t^{\ast} \\
&-\eta(\bar C+\bar I)\left(\phi_H+\frac{1-n}{n}\phi_H^{\ast}\right)p_{H,t}
+\eta(\bar C+\bar I)\frac{1-n}{n}\phi_H^{\ast}q_t+g_t.
\end{aligned}
```

- **(F18) 外国资源约束**：

```math
\begin{aligned}
y_t^{\ast}={}&\phi_F^{\ast}\bar C c_t^{\ast}+\frac{n}{1-n}\phi_F\bar C c_t
+\bar I\phi_F^{\ast} i_t^{\ast}+\frac{n}{1-n}\bar I\phi_F i_t \\
&+\eta(\bar C+\bar I)\left(\phi_F^{\ast}+\frac{n}{1-n}\phi_F\right)
\frac{\phi_H}{\phi_F}p_{H,t}
+\eta(\bar C+\bar I)\phi_F^{\ast}q_t+g_t^{\ast}.
\end{aligned}
```

- **(F19) 本地区相对价格运动方程**：

```math
p_{H,t}-p_{H,t-1}=\pi_{H,t}-\pi_t.
```

- **(F20) 实际汇率恒等式**：

```math
\phi_H^{\ast}p_{H,t}-\frac{\phi_H}{\phi_F}\phi_F^{\ast}p_{H,t}=q_t.
```

- **(F21) 本地区名义产出恒等式**：

```math
ny_t=y_t+p_t.
```

- **(F22) 外国名义产出恒等式**：

```math
ny_t^{\ast}=y_t^{\ast}+p_t^{\ast}.
```

- **(F23) 本地区生产者价格指数**：

```math
p_t=\pi_{H,t}+p_{t-1}.
```

- **(F24) 外国生产者价格指数**：

```math
p_t^{\ast}=\pi_{F,t}+p_{t-1}^{\ast}.
```

## 5. Exogenous Processes

- **(F25) 共同货币政策规则**：

```math
r_t=\rho_i r_{t-1}+(1-\rho_i)
\left[\phi_\pi(n\pi_t+(1-n)\pi_t^{\ast})+\phi_y(ny_t+(1-n)y_t^{\ast})
+\phi_g(ng_t+(1-n)g_t^{\ast})\right]+\varepsilon^r_t.
```

- **(F26) 政府支出过程**：

```math
g_t=\rho_G g_{t-1}+\varepsilon^g_t,\qquad
g_t^{\ast}=\rho_G g_{t-1}^{\ast}+\varepsilon^{g\ast}_t.
```

## 6. Steady-State Solution

因为 MMB 模型是 `model(linear)`，所有内生变量都是相对确定性稳态的偏离，在 Dynare model 块中的稳态为零：

```math
\bar c=\bar c^{\ast}=\bar r=\bar\pi=\bar\pi^{\ast}=\bar y=\bar y^{\ast}=\bar g=\bar g^{\ast}=0.
```

用于构造线性系数的非零水平在 model 块外校准：

```math
\beta=0.99,\quad \nu=1,\quad a=0.67,\quad \eta=2,\quad \theta=7,\quad
\delta=0.012,\quad n=0.1,\quad \phi_H=0.69,\quad \rho_G=0.933.
```

关键稳态比率为：

```math
\bar K/\bar L=\left[(1-a)\frac{\beta}{1-\beta(1-\delta)}
\frac{\theta-1}{\theta}\right]^{1/a},
```

```math
\bar I=\delta(\bar K/\bar L)^a,\qquad
\bar G=0.2,\qquad \bar C=1-\bar G-\bar I.
```

实现交叉检查从这些校准原语计算简化系数 $`\sigma_c`$、$`\sigma_l`$、$`\kappa`$、$`\bar\omega`$、$`\rho_y`$、$`\rho_k`$ 和 $`\zeta`$。这些系数公式在升级状态前需要对照在线附录复核。

## 7. Timing & Form Conventions

- 本条目为线性形式：F1-F26 中所有变量都是相对确定性稳态的对数/百分比偏离。
- 资本在生产和边际成本方程中是预定变量：$`k_{t-1}`$ 和 $`k_{t-1}^{\ast}`$ 出现在 F7、F8、F11 和 F12。
- 资本积累方程用上一期资本和当期投资定义期末资本 $`k_t`$ 和 $`k_t^{\ast}`$。
- 通胀和价格指数同时使用生产者价格和 CPI 聚合；$`p_{H,t}`$ 是构造实际汇率的本地区相对价格。
- 完全市场推出 Backus-Smith 条件。论文的不完全市场扩展不是 MMB 基准方程组。
- 未执行运行验证、Blanchard-Kahn 检查或 IRF 复现。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / MMB 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $`c`$, $`c^{\ast}`$ / `c`, `cf` | 本地区和外国消费 | F1, F2, F17, F18 |
| 内生 | $`r`$ / `r` | 共同名义利率偏离 | F1, F25 |
| 内生 | $`\pi`$, $`\pi^{\ast}`$ / `pi`, `pif` | 本地区和外国 CPI 通胀 | F5, F6, F25 |
| 内生 | $`\pi_H`$, $`\pi_F`$ / `piH`, `piF` | 本地产出和外国产出价格通胀 | F3, F4, F23, F24 |
| 内生 | $`l`$, $`l^{\ast}`$ / `l`, `lf` | 本地区和外国劳动 | F1, F2, F7, F8, F9, F10 |
| 内生 | $`p_H`$, $`q`$ / `pH`, `q` | 本地区相对价格和实际汇率 | F19, F20 |
| 内生 | $`p`$, $`p^{\ast}`$ / `p`, `pf` | 生产者价格指数 | F21, F22, F23, F24 |
| 内生 | $`s_H`$, $`s_F`$ / `sH`, `sF` | 本地区和外国实际边际成本 | F3, F4, F11, F12 |
| 内生 | $`y`$, $`y^{\ast}`$ / `y`, `yf` | 本地区和外国产出 | F7, F8, F17, F18, F25 |
| 内生 | $`g`$, $`g^{\ast}`$ / `g`, `gf` | 本地区和外国政府支出 | F17, F18, F25, F26 |
| 内生 | $`w`$, $`w^{\ast}`$ / `w`, `wf` | 本地区和外国实际工资 | F9, F10 |
| 内生 | $`i`$, $`i^{\ast}`$ / `i`, `if` | 本地区和外国投资 | F13, F14, F15, F16 |
| 内生 | $`k`$, $`k^{\ast}`$ / `k`, `kf` | 本地区和外国资本 | F7, F8, F11-F16 |
| 内生 | $`ny`$, $`ny^{\ast}`$ / `ny`, `nyf` | 本地区和外国名义产出 | F21, F22 |
| 外生 | $`\varepsilon^g`$, $`\varepsilon^{g\ast}`$ / `eg`, `egf` | 政府支出创新 | F26 |
| 外生 | $`\varepsilon^r`$ / `er` | 货币政策创新 | F25 |
| 参数 | `sigma_c`, `sigma_l`, `beta`, `kappa`, `zeta` | 简化效用和 Phillips 曲线系数 | F1-F4 |
| 参数 | `phiH`, `phiF`, `phiHstar`, `phiFstar`, `eta`, `nn` | 本地偏好、贸易弹性和地区规模 | F5, F6, F17, F18, F20 |
| 参数 | `Cbar`, `Ibar`, `delta`, `eps_phi`, `rho_y`, `rho_k` | 稳态比率、折旧率、投资调整成本 | F13-F18 |
| 参数 | `rhoii`, `phiPi`, `phiY`, `phiG`, `rhoG` | 政策和财政冲击持续性 | F25, F26 |
| 参数 | `aa`, `nu`, `omegaBar` | 生产/劳动和边际成本系数 | F7-F12 |
