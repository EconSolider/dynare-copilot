# EAES_RA09 - 推导

> Dynare 复现工作的第一版私有归档条目。状态：`needs_review`。

来源信息：`EAES_RA09`，Pau Rabanal (2009), "Inflation differentials between Spain and the EMU: A DSGE perspective", Journal of Money, Credit and Banking 41(6), 1141-1166, DOI `10.1111/j.1538-4616.2009.00250.x`。主来源：`raw/mmb_mineru/runs/eaes_ra09__inflation_differentials_between_spain_and_the_emu_a_dsge_perspective__9d18a448/full.md`。原始 PDF 存在于 `raw/mmb_papers/Inflation differentials between Spain and the EMU- A DSGE perspective.pdf`；未读取 PDF 正文。MinerU run id: `9d18a448-9e8f-4f5d-afd4-ccab95a34c76`。附录规范化文件：未找到。

## 1. Model Overview

- **模型**：货币联盟中的两国、两部门新凯恩斯 DSGE 模型。Home 为西班牙；foreign 为 EMU 其他地区。
- **目标**：用部门生产率冲击、需求/政府支出冲击、部门价格黏性和共同 ECB Taylor 规则解释西班牙与 EMU 的通胀差异。
- **主体与模块**：本国和外国代表性家庭；可贸易与不可贸易部门中的垄断竞争中间品厂商；政府支出需求过程；共同货币当局。
- **商品**：本国不可贸易品 $`N`$、本国可贸易品 $`H`$、外国不可贸易品 $`N^{\ast}`$、外国可贸易品 $`F`$。可贸易品按国家差异化，并且在货币区内不能价格歧视。
- **模型形式**：论文给出非线性偏好、CES 加总、生产、Calvo 定价、趋势和规范化。Rep-MMB 实现为 `model(linear)`，使用相对于趋势的平稳百分比偏离。Markdown 来源没有完整附录均衡系统，因此本推导记录有来源支持的非线性骨架，并结合线性实现做交叉核对。
- **运行验证**：未执行。

## 2. Optimization Problems

### 2.1 本国家庭

本国家庭选择消费、劳动和资产持有。偏好含有相对于本国总消费的外部习惯：

```math
\max_{\{C_t^j,L_t^j,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\log(C_t^j-b C_{t-1})-\frac{(L_t^j)^{1+\varpi}}{1+\varpi}
\right].
```

劳动负效用汇总可贸易和不可贸易部门工时：

```math
L_t=L_t^T+L_t^N.
```

以欧元计价的预算约束为：

```math
\frac{B_t}{P_t R_t}\leq \frac{B_{t-1}}{P_t}+W_t L_t-C_t+\zeta_t.
```

外国家庭求解带星号变量和外国参数的对应问题。

### 2.2 消费加总器

本国消费指数结合可贸易品和不可贸易品：

```math
C_t=\left[
\gamma^{1/\varepsilon}(C_t^T)^{(\varepsilon-1)/\varepsilon}
+(1-\gamma)^{1/\varepsilon}(\xi_t^{N,C})^{1/\varepsilon}(C_t^N)^{(\varepsilon-1)/\varepsilon}
\right]^{\varepsilon/(\varepsilon-1)}.
```

可贸易消费结合本国产品和外国产品：

```math
C_t^T=\left[
\lambda^{1/\nu}(C_t^H)^{(\nu-1)/\nu}
+(1-\lambda)^{1/\nu}(\xi_t^{F,C})^{1/\nu}(C_t^F)^{(\nu-1)/\nu}
\right]^{\nu/(\nu-1)}.
```

品种加总器为 CES：

```math
C_t^H=\left[\left(\frac{1}{s}\right)^{1/\sigma}\int_0^s c_t(h)^{(\sigma-1)/\sigma}dh\right]^{\sigma/(\sigma-1)},\quad
C_t^F=\left[\left(\frac{1}{1-s}\right)^{1/\sigma}\int_s^1 c_t(f)^{(\sigma-1)/\sigma}df\right]^{\sigma/(\sigma-1)}.
```

```math
C_t^N=\left[\left(\frac{1}{s}\right)^{1/\sigma}\int_0^s c_t^N(n)^{(\sigma-1)/\sigma}dn\right]^{\sigma/(\sigma-1)}.
```

外国加总器以带星号变量和参数对称定义。

### 2.3 中间品厂商

本国不可贸易品厂商 $`n`$ 仅用劳动生产：

```math
y_t^N(n)=X_t Z_t^N L_t^N(n).
```

本国可贸易品厂商 $`h`$ 的生产函数为：

```math
y_t^H(h)=X_t Z_t^T L_t^T(h).
```

不可贸易品厂商在 Calvo 不重新定价概率 $`\theta_N`$ 和指数化份额 $`\varphi_N`$ 下选择最优重设价格：

```math
\max_{\hat p_t^N(n)} E_t\sum_{k=0}^{\infty}\theta_N^k\Lambda_{t,t+k}
\left[
\frac{\hat p_t^N(n)\left(P_{t+k-1}^N/P_{t-1}^N\right)^{\varphi_N}(\Pi^N)^{k(1-\varphi_N)}}{P_{t+k}}
-MC_{t+k}^N
\right]y_{t+k}^{N,d}(n).
```

约束为：

```math
y_{t+k}^{N,d}(n)=\frac{1-\gamma}{s}
\left[
\frac{\hat p_t^N(n)}{P_{t+k}^N}
\left(\frac{P_{t+k-1}^N}{P_{t-1}^N}\right)^{\varphi_N}
(\Pi^N)^{k(1-\varphi_N)}
\right]^{-\sigma}Y_{t+k}^N.
```

本国可贸易部门和外国部门的定价问题是类似的，但使用部门特定的 $`\theta`$、$`\varphi`$、生产率和需求变量。来源说明完整定价方程在可索取附录中；所以下方详细 Phillips 曲线表达式保留 `needs_review`。

## 3. First-Order Conditions

**家庭与完全市场**

- **(F1) 本国 Euler 方程**：

```math
\mu_t=E_t\mu_{t+1}+r_t-E_t\pi_{t+1}.
```

在线性 Rep-MMB 实现中写为 `mu=mu(+1)+(r-pi(+1));`。

- **(F2) 含习惯的本国边际效用**：

```math
-\mu_t\left(1-\frac{b}{(1+x)(1+\alpha^T)}\right)
=c_t-\frac{b}{(1+x)(1+\alpha^T)}c_{t-1}.
```

- **(F3) 含习惯的外国边际效用**：

```math
-\mu_t^{\ast}\left(1-\frac{b^{\ast}}{(1+x)(1+\alpha^{T\ast})}\right)
=c_t^{\ast}-\frac{b^{\ast}}{(1+x)(1+\alpha^{T\ast})}c_{t-1}^{\ast}.
```

- **(F4) 完全市场风险分担**：

```math
rer_t=\mu_t^{\ast}-\mu_t.
```

非线性来源条件为 $`RER_t=P_t^{\ast}/P_t=\mu_t^{\ast}/\mu_t`$。

- **(F5) 本国劳动供给**：

```math
\bar w\,l_t=w_t+\mu_t.
```

- **(F6) 外国劳动供给**：

```math
\bar w^{\ast}\,l_t^{\ast}=w_t^{\ast}+\mu_t^{\ast}.
```

**期内消费需求**

- **(F7) 本国对本国可贸易品的需求**：

```math
c_{H,t}=-\nu t_{H,t}-(\varepsilon-\nu)t_{T,t}+c_t.
```

- **(F8) 本国对进口可贸易品的需求**：

```math
c_{F,t}=-\nu t_{F,t}-(\varepsilon-\nu)t_{T,t}+c_t.
```

- **(F9) 本国对不可贸易品的需求**：

```math
c_{N,t}=-\varepsilon t_{N,t}+c_t.
```

- **(F10) 外国对本国可贸易品的需求**：

```math
c_{H,t}^{\ast}=-\nu t_{H,t}^{\ast}-(\varepsilon-\nu)t_{T,t}^{\ast}+c_t^{\ast}.
```

- **(F11) 外国对外国可贸易品的需求**：

```math
c_{F,t}^{\ast}=-\nu t_{F,t}^{\ast}-(\varepsilon-\nu)t_{T,t}^{\ast}+c_t^{\ast}.
```

- **(F12) 外国对不可贸易品的需求**：

```math
c_{N,t}^{\ast}=-\varepsilon t_{N,t}^{\ast}+c_t^{\ast}.
```

**生产与定价**

- **(F13) 本国劳动加总**：

```math
l_t=(1-\gamma)l_{N,t}+\gamma l_{T,t}.
```

- **(F14) 外国劳动加总**：

```math
l_t^{\ast}=(1-\gamma^{\ast})l_{N,t}^{\ast}+\gamma^{\ast}l_{T,t}^{\ast}.
```

- **(F15) 本国不可贸易品生产**：

```math
y_{N,t}=z_{N,t}+l_{N,t}.
```

- **(F16) 本国可贸易品生产**：

```math
y_{H,t}=z_{T,t}+l_{T,t}.
```

- **(F17) 外国不可贸易品生产**：

```math
y_{N,t}^{\ast}=z_{N,t}^{\ast}+l_{N,t}^{\ast}.
```

- **(F18) 外国可贸易品生产**：

```math
y_{F,t}^{\ast}=z_{T,t}^{\ast}+l_{T,t}^{\ast}.
```

- **(F19) 本国不可贸易品 Phillips 曲线**（`needs_review` 附录表达式，实现交叉核对）：

```math
\pi_{N,t}-\varphi_N\pi_{N,t-1}
=\kappa_N(w_t-t_{N,t}-z_{N,t})
+\beta\frac{1+\alpha_N}{1+\alpha_T}\left(\pi_{N,t+1}-\varphi_N\pi_{N,t}\right),
```

其中 $`\kappa_N=(1-\theta_N)(1-\beta\theta_N(1+\alpha_N)/(1+\alpha_T))/\theta_N`$。

- **(F20) 本国可贸易品 Phillips 曲线**（`needs_review` 附录表达式，实现交叉核对）：

```math
\pi_{H,t}-\varphi_H\pi_{H,t-1}
=\kappa_H(w_t-t_{H,t}-z_{T,t})
+\beta(\pi_{H,t+1}-\varphi_H\pi_{H,t}),
```

其中 $`\kappa_H=(1-\theta_H)(1-\beta\theta_H)/\theta_H`$。

- **(F21) 外国不可贸易品 Phillips 曲线**（`needs_review` 附录表达式，实现交叉核对）：

```math
\pi_{N,t}^{\ast}-\varphi_N^{\ast}\pi_{N,t-1}^{\ast}
=\kappa_N^{\ast}(w_t^{\ast}-t_{N,t}^{\ast}-z_{N,t}^{\ast})
+\beta\frac{1+\alpha_N^{\ast}}{1+\alpha_T^{\ast}}\left(\pi_{N,t+1}^{\ast}-\varphi_N^{\ast}\pi_{N,t}^{\ast}\right).
```

- **(F22) 外国可贸易品 Phillips 曲线**（`needs_review` 附录表达式，实现交叉核对）：

```math
\pi_{F,t}-\varphi_F^{\ast}\pi_{F,t-1}
=\kappa_F^{\ast}(w_t^{\ast}-t_{F,t}^{\ast}-z_{T,t}^{\ast})
+\beta(\pi_{F,t+1}-\varphi_F^{\ast}\pi_{F,t}).
```

## 4. Market Clearing & Identities

- **(F23) 本国 CPI 通胀**：

```math
\pi_t=\gamma\lambda\pi_{H,t}+\gamma(1-\lambda)\pi_{F,t}+(1-\gamma)\pi_{N,t}.
```

- **(F24) 外国 CPI 通胀**：

```math
\pi_t^{\ast}=\gamma^{\ast}(1-\lambda^{\ast})\pi_{H,t}+\gamma^{\ast}\lambda^{\ast}\pi_{F,t}+(1-\gamma^{\ast})\pi_{N,t}^{\ast}.
```

- **(F25) EMU CPI 通胀**：

```math
\pi_t^{EMU}=s\pi_t+(1-s)\pi_t^{\ast}.
```

- **(F26) 本国 GDP 增长恒等式**：

```math
dy_t=y_t-y_{t-1}.
```

- **(F27) 外国 GDP 增长恒等式**：

```math
dy_t^{\ast}=y_t^{\ast}-y_{t-1}^{\ast}.
```

- **(F28) 本国不可贸易相对价格**：

```math
t_{N,t}=-\frac{\gamma}{1-\gamma}t_{T,t}.
```

- **(F29) 本国可贸易价格指数**：

```math
t_{T,t}=\lambda t_{H,t}+(1-\lambda)t_{F,t}.
```

- **(F30) 本国可贸易相对价格**：

```math
t_{H,t}=t_{H,t-1}+\pi_{H,t}-\pi_t,\quad
t_{F,t}=t_{F,t-1}+\pi_{F,t}-\pi_t.
```

- **(F31) 外国不可贸易相对价格**：

```math
t_{N,t}^{\ast}=t_{N,t-1}^{\ast}+\pi_{N,t}^{\ast}-\pi_t^{\ast}.
```

- **(F32) 外国可贸易相对价格**：

```math
t_{T,t}^{\ast}=(1-\lambda^{\ast})t_{H,t}^{\ast}+\lambda^{\ast}t_{F,t}^{\ast},\quad
t_{H,t}^{\ast}=t_{H,t-1}^{\ast}+\pi_{H,t}-\pi_t^{\ast},\quad
t_{F,t}^{\ast}=t_{F,t-1}^{\ast}+\pi_{F,t}-\pi_t^{\ast}.
```

- **(F33) 实际汇率相对价格恒等式**：

```math
rer_t=-(1-\gamma)(t_{N,t}-t_{T,t})+(1-\gamma^{\ast})(t_{N,t}^{\ast}-t_{T,t}^{\ast})+(1-\lambda-\lambda^{\ast})(t_{H,t}-t_{F,t}).
```

- **(F34) 本国不可贸易品市场出清**：

```math
y_{N,t}=(1-\eta)c_{N,t}+\eta g_{N,t}.
```

- **(F35) 本国可贸易品市场出清**：

```math
y_{H,t}=(1-\eta)\left[\lambda c_{H,t}+(1-\lambda)c_{H,t}^{\ast}\right]+\eta g_{T,t}.
```

- **(F36) 外国不可贸易品市场出清**：

```math
y_{N,t}^{\ast}=(1-\eta^{\ast})c_{N,t}^{\ast}+\eta^{\ast}g_{N,t}^{\ast}.
```

- **(F37) 外国可贸易品市场出清**：

```math
y_{F,t}^{\ast}=(1-\eta^{\ast})\left[(1-\lambda^{\ast})c_{F,t}+\lambda^{\ast}c_{F,t}^{\ast}\right]+\eta^{\ast}g_{T,t}^{\ast}.
```

- **(F38) 本国实际 GDP 加总**：

```math
y_t=\gamma(t_{H,t}+y_{H,t})+(1-\gamma)(t_{N,t}+y_{N,t}).
```

- **(F39) 外国实际 GDP 加总**：

```math
y_t^{\ast}=\gamma^{\ast}(t_{F,t}^{\ast}+y_{F,t}^{\ast})+(1-\gamma^{\ast})(t_{N,t}^{\ast}+y_{N,t}^{\ast}).
```

- **(F40) 共同货币政策规则**：

```math
r_t=\rho_r r_{t-1}+(1-\rho_r)\gamma_{\pi}\pi_t^{EMU}+\varepsilon_t^m.
```

非线性来源规则为 $`R_t=\bar R^{1-\rho_r}R_{t-1}^{\rho_r}(\Pi_t^{EMU}/\Pi)^{(1-\rho_r)\gamma_\pi}\exp(\varepsilon_t^m)`$。

## 5. Exogenous Processes

- **(F41) 本国可贸易生产率**：

```math
z_{T,t}=\rho_{ZT}z_{T,t-1}+\varepsilon_t^{ZT}+\varepsilon_t^Z.
```

- **(F42) 本国不可贸易生产率**：

```math
z_{N,t}=\rho_{ZN}z_{N,t-1}+\varepsilon_t^{ZN}.
```

- **(F43) 外国可贸易生产率**：

```math
z_{T,t}^{\ast}=\rho_{ZT}^{\ast}z_{T,t-1}^{\ast}+\varepsilon_t^{ZT\ast}+\varepsilon_t^Z.
```

- **(F44) 外国不可贸易生产率**：

```math
z_{N,t}^{\ast}=\rho_{ZN}^{\ast}z_{N,t-1}^{\ast}+\varepsilon_t^{ZN\ast}.
```

- **(F45) 本国可贸易需求/政府支出**：

```math
g_{T,t}=\rho_{GT}g_{T,t-1}+\varepsilon_t^{GT}.
```

- **(F46) 本国不可贸易需求/政府支出**：

```math
g_{N,t}=\rho_{GN}g_{N,t-1}+\varepsilon_t^{GN}.
```

- **(F47) 外国可贸易需求/政府支出**：

```math
g_{T,t}^{\ast}=\rho_{GT}^{\ast}g_{T,t-1}^{\ast}+\varepsilon_t^{GT\ast}.
```

- **(F48) 外国不可贸易需求/政府支出**：

```math
g_{N,t}^{\ast}=\rho_{GN}^{\ast}g_{N,t-1}^{\ast}+\varepsilon_t^{GN\ast}.
```

论文层面的非线性趋势过程为 $`X_t=(1+x)^tX_0`$、$`Z_t^i=(1+\alpha^i)^t\tilde Z_t^i`$ 和 $`G_t^i=[(1+\alpha^i)(1+x)]^t\tilde G_t^i`$。线性实现为了匹配 Rep-MMB IRF 将估计趋势参数设为零；这是实现约定，不是论文侧限制。

## 6. Steady-State Solution

由于实际部门变量含确定性趋势，论文使用平稳化后的规范化系统。在规范化变量中，论文意味着：

1. 将稳态创新设为零：$`\varepsilon^m=\varepsilon^{Z}=\varepsilon^{ZT}=\varepsilon^{ZN}=\varepsilon^{ZT\ast}=\varepsilon^{ZN\ast}=\varepsilon^{GT}=\varepsilon^{GN}=\varepsilon^{GT\ast}=\varepsilon^{GN\ast}=0`$。
2. 将规范化生产率与需求状态设在均值：$`\tilde Z^i=1`$ 且 $`\tilde G^i`$ 为常数。
3. 部门 $`i`$ 中数量变量的部门平衡增长率为 $`(1+x)(1+\alpha^i)`$。
4. 模型一致的可观测变量常数为 $`\Delta p=\pi-\alpha^T`$、$`\Delta p^N=\pi-\alpha^N`$、$`\Delta p^{\ast}=\pi-\alpha^{T\ast}`$、$`\Delta p^{N\ast}=\pi-\alpha^{N\ast}`$、$`\Delta y=x+\alpha^T`$、$`\Delta y^N=x+\alpha^N`$、$`\Delta y^{\ast}=x+\alpha^{T\ast}`$、$`\Delta y^{N\ast}=x+\alpha^{N\ast}`$ 以及 $`r=x+\pi-\log\beta`$。
5. 在 Rep-MMB `model(linear)` 文件中，所有内生变量都是相对于趋势的偏离；因此执行 `steady;` 后，实现中的确定性稳态为所有内生变量等于零。

`needs_review`：Markdown 论文来源无法完整恢复重设价格和规范化部门相对价格的非线性稳态代数，因为论文把完整定价方程放在可索取附录中。

## 7. Timing & Form Conventions

- 形式：Rep-MMB 实现为 `model(linear)`。论文的概念模型是非线性的，随后为贝叶斯估计进行规范化和线性化。
- 时序：实现变量为平稳偏离。滞后项出现在习惯、通胀指数化、相对价格累积、GDP 增长、利率平滑和 AR(1) 冲击状态中。
- 共同货币：只有一个名义利率和一个以 EMU HICP 通胀为目标的 ECB 政策规则。
- 完全市场：风险分担条件把实际汇率与相对边际效用相连。
- 可贸易品定价：本国和外国可贸易品价格在货币区内共同适用，因此相对价格恒等式在本国和外国 CPI 模块中都使用 $`\pi_H`$ 和 $`\pi_F`$。
- 存量变量：没有物质资本；生产只使用劳动。
- 附录缺口：论文说明完整定价方程可向作者索取。标为 `needs_review` 的方程在推广前应与该附录做来源级核对。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $`dy_t,dy_t^{\ast}`$ | 本国和外国 GDP 增长 | (F26), (F27) |
| 内生 | $`\mu_t,\mu_t^{\ast}`$ | 边际效用状态 | (F1)-(F4) |
| 内生 | $`r_t`$ | 线性实现中的共同名义政策利率 | (F1), (F40) |
| 内生 | $`\pi_t,\pi_t^{\ast},\pi_t^{EMU}`$ | 本国、外国和 EMU CPI 通胀 | (F23)-(F25) |
| 内生 | $`c_t,c_t^{\ast}`$ | 总消费 | (F2), (F3), (F7)-(F12) |
| 内生 | $`rer_t`$ | 实际汇率 | (F4), (F33) |
| 内生 | $`t_N,t_H,t_F,t_T,t_N^{\ast},t_H^{\ast},t_F^{\ast},t_T^{\ast}`$ | 相对价格 | (F28)-(F33) |
| 内生 | $`c_H,c_F,c_N,c_H^{\ast},c_F^{\ast},c_N^{\ast}`$ | 按来源/部门划分的消费 | (F7)-(F12), (F34)-(F37) |
| 内生 | $`l,l^{\ast},w,w^{\ast}`$ | 总劳动和工资 | (F5), (F6), (F13), (F14) |
| 内生 | $`l_N,l_T,l_N^{\ast},l_T^{\ast}`$ | 部门劳动 | (F13)-(F18) |
| 内生 | $`y_N,y_H,y_N^{\ast},y_F^{\ast}`$ | 部门产出 | (F15)-(F18), (F34)-(F37) |
| 内生 | $`z_N,z_T,z_N^{\ast},z_T^{\ast}`$ | 生产率状态 | (F41)-(F44) |
| 内生 | $`\pi_N,\pi_H,\pi_N^{\ast},\pi_F`$ | 部门通胀 | (F19)-(F25), (F30)-(F32) |
| 内生 | $`g_N,g_T,g_N^{\ast},g_T^{\ast}`$ | 部门需求/政府支出状态 | (F45)-(F48) |
| 内生 | $`y,y^{\ast}`$ | 实际 GDP 加总 | (F38), (F39) |

### 外生冲击

| 符号 | 含义 |
|---|---|
| $`\varepsilon_t^m`$ | 货币政策创新 |
| $`\varepsilon_t^Z`$ | 共同可贸易技术创新 |
| $`\varepsilon_t^{ZT},\varepsilon_t^{ZN}`$ | 本国可贸易和不可贸易技术创新 |
| $`\varepsilon_t^{ZT\ast},\varepsilon_t^{ZN\ast}`$ | 外国可贸易和不可贸易技术创新 |
| $`\varepsilon_t^{GT},\varepsilon_t^{GN}`$ | 本国可贸易和不可贸易需求/政府支出创新 |
| $`\varepsilon_t^{GT\ast},\varepsilon_t^{GN\ast}`$ | 外国可贸易和不可贸易需求/政府支出创新 |

### 参数

| 符号 | 含义 |
|---|---|
| $`\beta`$ | 折现因子 |
| $`b,b^{\ast}`$ | 习惯持续性 |
| $`x`$ | EMU 总实际增长趋势 |
| $`\alpha_T,\alpha_N,\alpha_T^{\ast},\alpha_N^{\ast}`$ | 部门/国家生产率趋势 |
| $`\varepsilon`$ | 可贸易品与不可贸易品之间的替代弹性 |
| $`\nu`$ | 本国与外国可贸易品之间的替代弹性 |
| $`\sigma`$ | 品种间替代弹性 |
| $`\gamma,\gamma^{\ast}`$ | 本国和外国消费篮子中的可贸易品权重 |
| $`\lambda,\lambda^{\ast}`$ | 可贸易品篮子中的本国/外国偏好权重 |
| $`s`$ | 本国在 EMU 中的权重 |
| $`\bar w,\bar w^{\ast}`$ | 线性实现中的劳动负效用尺度 |
| $`\varpi`$ | 论文符号中的劳动供给弹性倒数 |
| $`\theta_N,\theta_H,\theta_N^{\ast},\theta_F^{\ast}`$ | Calvo 不重新定价概率 |
| $`\varphi_N,\varphi_H,\varphi_N^{\ast},\varphi_F^{\ast}`$ | 通胀指数化份额 |
| $`\eta,\eta^{\ast}`$ | 政府支出份额 |
| $`\rho_r,\gamma_\pi`$ | 货币政策平滑和通胀反应 |
| $`\rho_{ZT},\rho_{ZN},\rho_{ZT}^{\ast},\rho_{ZN}^{\ast}`$ | 技术冲击持续性 |
| $`\rho_{GT},\rho_{GN},\rho_{GT}^{\ast},\rho_{GN}^{\ast}`$ | 需求/政府支出冲击持续性 |
