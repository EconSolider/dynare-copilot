# EA_QR14 - 推导

> MMB 私有模型档案第一遍条目。状态：`needs_review`；公式来自 MinerU Markdown OCR，未对 PDF 正文逐式核验。

来源：`EA_QR14`，Dominic Quint 和 Pau Rabanal（2014），"Monetary and Macroprudential Policy in an Estimated DSGE Model of the Euro Area"，*International Journal of Central Banking* 10(2), 169-236。`model_index.csv` 记录的 DOI：`10.5089/9781484333693.001`。主来源：`raw/mmb_mineru/runs/ea_qr14__monetary_and_macroprudential_policy_in_an_estimated_dsge_model_of_the_eu__78d59631/full.md`。原始 PDF 存在于 `raw/mmb_papers/Monetary and Macroprudential Policy in an Estimated DSGE Model of the Euro Area.pdf`；未读取 PDF 正文。MinerU run id：`78d59631-1509-497c-b15f-d57584562569`。附录规范化文件：未找到。实现交叉检查：`.agents/skills/dynare-copilot/references/examples/EA_QR14_rep.mod`。

## 1. Model Overview

- **模型**：一个估计的两国欧元区 DSGE 模型，包含核心与外围两个地区、两个部门、两类家庭、抵押信贷金融摩擦、共同 ECB 货币政策规则和国家层面的宏观审慎工具。
- **国家**：本国人口权重为 $`n`$；外国权重为 $`1-n`$。论文用星号表示外国变量，Rep-MMB 实现中用 `_s`。
- **部门与商品**：非耐用品可跨国贸易；耐用品不可贸易，并解释为住房。每个国家的非耐用品和耐用品部门均有 Calvo 定价。
- **家庭**：储蓄者占比 $`\lambda`$，借款者占比 $`1-\lambda`$。两者消费非耐用品、积累耐用住房，并向两个部门供给劳动。借款者更不耐心，并以住房抵押借款。
- **金融模块**：国内中介吸收储蓄者存款并向借款者放贷。当个体住房质量冲击使抵押品低于债务时，借款者违约。宏观审慎政策改变银行可贷负债比例，从而影响贷款-存款利差。
- **开放经济模块**：国际中介通过依赖净外国资产的风险溢价连接本国和外国融资市场。
- **模型形式**：附录 2 给出围绕平衡增长稳态的线性化条件。Rep-MMB 文件用指数化平稳变量写非线性 `model` 块，然后做一阶近似。本档案条目记录论文侧的线性化方程，`.mod` 仅用作 `implementation_cross_check`。
- **运行验证**：未执行。

## 2. Optimization Problems

### 储蓄者

储蓄者选择非耐用品消费 $`C_t`$、耐用住房存量 $`D_t`$、住宅投资 $`I_t`$、非耐用品和耐用品部门劳动，以及存款/债券。偏好包含习惯调整后的非耐用品消费、住房服务和总劳动：

```math
E_0\sum_{t=0}^{\infty}\beta^t\left[
\gamma \xi_t^C \log(C_t-\varepsilon C_{t-1}/A_t)
+(1-\gamma)\xi_t^D\log D_t
-\frac{L_t^{1+\varphi}}{1+\varphi}
\right].
```

总劳动是部门劳动的 CES 型汇总：

```math
L_t=\left[\alpha^{-\iota_L}(L_t^C)^{1+\iota_L}+(1-\alpha)^{-\iota_L}(L_t^D)^{1+\iota_L}\right]^{1/(1+\iota_L)}.
```

耐用住房在非线性实现中按折旧和安装成本演化；附录 2 记录趋势规范化后的线性运动方程。

### 借款者

借款者求解类似问题，但 $`\beta^B<\beta`$，且习惯参数为 $`\varepsilon^B`$。其预算约束包含新增信贷 $`\tilde S_t^B`$、正常偿还债务、止赎/违约清偿项、耐用品投资，以及两个部门的劳动收入。借款者面对由金融中介模块决定的抵押贷款利率 $`R_t^L`$、违约阈值和违约率函数。

### 国内金融中介

国内中介吸收储蓄者存款，向借款者发放贷款，并通过零利润/参与约束使融资成本等于正常贷款和止赎清偿的预期收益。宏观审慎楔子 $`\eta_t`$ 移动信贷供给。

### 企业与定价者

非耐用品和耐用品企业用部门劳动和部门技术生产。垄断竞争企业在带滞后通胀指数化的 Calvo 合约下定价，因此每个国家有两个新凯恩斯 Phillips 曲线。

### 货币与宏观审慎当局

ECB 通过带平滑项、欧元区 CPI 通胀和欧元区产出增长的规则设定共同名义政策利率。各国宏观审慎工具对信贷指标作反应；政策实验中该指标为名义信贷增长或信贷/GDP。

## 3. First-Order Conditions

以下方程为本档案条目对来源附录 2 条件的连续重编号。若外国条件没有引入额外结构，则只说明其与带星号变量的本国条件对称。

- **(F1) 储蓄者住房投资 Euler 方程**：

```math
q_t+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}
+\psi(i_t-i_{t-1}+\varepsilon_t^A)
=E_t\varrho_{t+1}+\beta\psi(E_t i_{t+1}-i_t).
```

- **(F2) 储蓄者耐用品需求影子价值**：

```math
[1-\beta(1-\delta)](\xi_t^D-d_t)=\varrho_t-\beta(1-\delta)E_t\varrho_{t+1}.
```

- **(F3) 储蓄者非耐用品 Euler 方程**：

```math
\varepsilon(\Delta c_t+\varepsilon_t^A)
=E_t\Delta c_{t+1}-(1-\varepsilon)(r_t+E_t\Delta\xi_{t+1}^C-E_t\Delta p_{t+1}^C).
```

- **(F4) 储蓄者非耐用品部门劳动供给**：

```math
[(\varphi-\iota_L)\alpha+\iota_L]l_t^C
+(\varphi-\iota_L)(1-\alpha)l_t^D
=\tilde w_t^C+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}.
```

- **(F5) 储蓄者耐用品部门劳动供给**：

```math
[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^D
+(\varphi-\iota_L)\alpha l_t^C
=\tilde w_t^D+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}.
```

- **(F6) 借款者住房投资 Euler 方程**：

```math
q_t+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}
+\psi(i_t^B-i_{t-1}^B+\varepsilon_t^A)
=E_t\varrho_{t+1}^B+\beta^B\psi(E_t i_{t+1}^B-i_t^B).
```

- **(F7) 借款者耐用品需求影子价值**：

```math
[1-\beta^B(1-\delta)](\xi_t^D-d_t^B)=\varrho_t^B-\beta^B(1-\delta)E_t\varrho_{t+1}^B.
```

- **(F8) 含抵押/违约项的借款者 Euler 方程**（`needs_review`，金融导数 OCR 敏感）：

```math
\begin{aligned}
\varepsilon^B(\Delta c_t^B+\varepsilon_t^A)
&=E_t\Delta c_{t+1}^B-(1-\varepsilon^B)(\beta^B R^D E_t r_{t+1}^D
+E_t\Delta\xi_{t+1}^C-E_t\Delta p_{t+1}^C)\\
&\quad -(1-\varepsilon^B)\beta^B R^L[1-F(\bar\omega,\sigma_\omega)]
\left(r_t^L-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_t^a
-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t}\right).
\end{aligned}
```

- **(F9) 违约借款者支付的利率**（`needs_review`）：

```math
r_t^D=d_t^B-\tilde s_{t-1}^B
+\frac{G_\omega\bar\omega}{G}\hat\omega_{t-1}^p
+\frac{G_{\sigma_\omega}\sigma_\omega}{G}\hat\sigma_{\omega,t-1}
+q_t+\Delta p_t^C+\varepsilon_t^A.
```

- **(F10) 借款者非耐用品部门劳动供给**：

```math
[(\varphi-\iota_L)\alpha+\iota_L]l_t^{B,C}
+(\varphi-\iota_L)(1-\alpha)l_t^{B,D}
=\tilde w_t^C+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}.
```

- **(F11) 借款者耐用品部门劳动供给**：

```math
[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^{B,D}
+(\varphi-\iota_L)\alpha l_t^{B,C}
=\tilde w_t^D+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}.
```

- **(F12) 借款者预算约束**（`needs_review`，由来源方程 39 压缩）：

```math
\begin{aligned}
C^B c_t^B+\delta D^B(q_t+i_t^B)
&+R^D\tilde S^B[r_t^D+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A]\\
&+[1-F]R^L\tilde S^B\left[r_{t-1}^L+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_{t-1}^p-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t-1}\right]\\
&=\tilde S^B\tilde s_t^B+\alpha W L^B(\tilde w_t^C+l_t^{B,C})+(1-\alpha)W L^B(\tilde w_t^D+l_t^{B,D}).
\end{aligned}
```

- **(F13) 金融中介参与约束**（`needs_review`，OCR 敏感）：

```math
\begin{aligned}
\frac{1}{\beta}\tilde S^B(r_t+\tilde s_t^B+\eta_t)
&=(1-\mu)D^B G\left[\frac{G_\omega\bar\omega}{G}\hat{\bar\omega}_t^a+\frac{G_{\sigma_\omega}\sigma_\omega}{G}\hat\sigma_{\omega,t}\right]\\
&\quad +(1-\mu)D^B G E_t(q_{t+1}+d_{t+1}^B+\Delta p_{t+1}^C)\\
&\quad +[1-F]R^L\tilde S^B\left[r_t^L+\tilde s_t^B-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_t^a-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t}\right].
\end{aligned}
```

- **(F14) 事前违约阈值**：

```math
\hat{\bar\omega}_t^a+E_t(q_{t+1}+d_{t+1}^B)=r_t^L+\tilde s_t^B-E_t\Delta p_{t+1}^C.
```

- **(F15) 事后违约阈值**：

```math
\hat\omega_{t-1}^p+q_t+d_t^B=r_{t-1}^L+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A.
```

- **(F16) 本国商品的非耐用品需求**：

```math
c_{H,t}=\iota_C(1-\tau)t_t+c_t^{TOT}.
```

- **(F17) 外国商品的非耐用品需求**：

```math
c_{F,t}=-\iota_C\tau t_t+c_t^{TOT}.
```

- **(F18) 总非耐用品消费**：

```math
[\lambda C+(1-\lambda)C^B]c_t^{TOT}=\lambda Cc_t+(1-\lambda)C^B c_t^B.
```

- **(F19) 非耐用品生产**：

```math
y_t^C=z_t^C+l_t^{C,TOT}.
```

- **(F20) 耐用品生产**：

```math
y_t^D=z_t^D+l_t^{D,TOT}.
```

- **(F21) 非耐用品部门劳动汇总**：

```math
[\lambda L^C+(1-\lambda)L^{B,C}]l_t^{C,TOT}
=\lambda L^C l_t^C+(1-\lambda)L^{B,C}l_t^{B,C}.
```

- **(F22) 耐用品部门劳动汇总**：

```math
[\lambda L^D+(1-\lambda)L^{B,D}]l_t^{D,TOT}
=\lambda L^D l_t^D+(1-\lambda)L^{B,D}l_t^{B,D}.
```

- **(F23) CPI 通胀**：

```math
\Delta p_t^C=\tau\Delta p_{H,t}+(1-\tau)\Delta p_{F,t}.
```

- **(F24) 相对房价**：

```math
q_t=q_{t-1}+\Delta p_t^D-\Delta p_t^C.
```

- **(F25) 非耐用品 Phillips 曲线**：

```math
\Delta p_t^H-\varphi_C\Delta p_{t-1}^H
=\beta E_t(\Delta p_{t+1}^H-\varphi_C\Delta p_t^H)
+\kappa^C(\tilde w_t^C+(1-\tau)t_t-z_t^C).
```

- **(F26) 耐用品 Phillips 曲线**：

```math
\Delta p_t^D-\varphi_D\Delta p_{t-1}^D
=\beta E_t(\Delta p_{t+1}^D-\varphi_D\Delta p_t^D)
+\kappa^D(\tilde w_t^D-q_t-z_t^D).
```

## 4. Market Clearing & Identities

- **(F27) 非耐用品市场出清**：

```math
y_t^C=\tau c_{H,t}+\frac{(1-n)(1-\tau^{\ast})}{n}c_{H,t}^{\ast}.
```

- **(F28) 耐用品市场出清**：

```math
y_t^D=\frac{\lambda\delta D\, i_t+(1-\lambda)\delta D^B\, i_t^B}{\lambda\delta D+(1-\lambda)\delta D^B}.
```

- **(F29) 储蓄者住房运动方程**：

```math
d_t=(1-\delta)d_{t-1}+\delta i_{t-1}-\varepsilon_t^A.
```

- **(F30) 借款者住房运动方程**：

```math
d_t^B=(1-\delta)d_{t-1}^B+\delta i_{t-1}^B-\varepsilon_t^A.
```

- **(F31) 总产出**：

```math
y_t=\alpha y_t^C+(1-\alpha)(y_t^D+q_t).
```

- **(F32) 外国模块**：

```math
\mathcal{E}_t^{\ast}=\mathcal{S}\{\text{(F1)--(F31)};\; x_t\mapsto x_t^{\ast},\; \tau\mapsto\tau^{\ast},\; n\mapsto1-n\}.
```

- **(F33) 国际利率联系**：

```math
r_t^{\ast}=r_t+\beta(\kappa_b b_t+\vartheta_t).
```

- **(F34) 净外国资产**：

```math
\lambda b_t=\lambda\frac{1}{\beta}b_{t-1}
+\frac{(1-n)(1-\tau^{\ast})}{n}(c_{H,t}^{\ast}-t_t)
-(1-\tau)c_{F,t}.
```

- **(F35) 贸易条件**：

```math
t_t=t_{t-1}+\Delta p_t^F-\Delta p_t^H.
```

- **(F36) ECB Taylor 规则**（`needs_review`：来源方程在预期应为产出增长系数的位置重复了 $`\gamma_\pi`$）：

```math
r_t=\gamma_R r_{t-1}+(1-\gamma_R)\left[\gamma_\pi\Delta p_t^{EMU}
+\gamma_y(y_t^{EMU}-y_{t-1}^{EMU}+\varepsilon_t^A)\right]+\varepsilon_t^m.
```

- **(F37) 欧元区 CPI 通胀**：

```math
\Delta p_t^{EMU}=n\Delta p_t^C+(1-n)\Delta p_t^{C^{\ast}}.
```

- **(F38) 欧元区产出**：

```math
y_t^{EMU}=ny_t+(1-n)y_t^{\ast}.
```

- **(F39) 本国宏观审慎规则**：

```math
\eta_t=\gamma_\eta\Upsilon_t.
```

- **(F40) 外国宏观审慎规则**：

```math
\eta_t^{\ast}=\gamma_\eta^{\ast}\Upsilon_t^{\ast}.
```

## 5. Exogenous Processes

- **(F41) 本国非耐用品偏好冲击**：

```math
\xi_t^C=\rho_{\xi,H}\xi_{t-1}^C+\varepsilon_t^{\xi,C}.
```

- **(F42) 外国非耐用品偏好冲击**：

```math
\xi_t^{C^{\ast}}=\rho_{\xi,H}\xi_{t-1}^{C^{\ast}}+\varepsilon_t^{\xi,C^{\ast}}.
```

- **(F43) 本国耐用品偏好冲击**：

```math
\xi_t^D=\rho_{\xi,D}\xi_{t-1}^D+\varepsilon_t^{\xi,D}+\varepsilon_t^{\xi,D,COM}.
```

- **(F44) 外国耐用品偏好冲击**：

```math
\xi_t^{D^{\ast}}=\rho_{\xi,D}\xi_{t-1}^{D^{\ast}}+\varepsilon_t^{\xi,D^{\ast}}+\varepsilon_t^{\xi,D,COM}.
```

- **(F45) 本国非耐用品技术冲击**：

```math
z_t^C=\rho_{Z,C}z_{t-1}^C+\varepsilon_t^{Z,C}+\varepsilon_t^{Z,C,COM}.
```

- **(F46) 外国非耐用品技术冲击**：

```math
z_t^{C^{\ast}}=\rho_{Z,C}z_{t-1}^{C^{\ast}}+\varepsilon_t^{Z,C^{\ast}}+\varepsilon_t^{Z,C,COM}.
```

- **(F47) 本国耐用品技术冲击**：

```math
z_t^D=\rho_{Z,D}z_{t-1}^D+\varepsilon_t^{Z,D}.
```

- **(F48) 外国耐用品技术冲击**：

```math
z_t^{D^{\ast}}=\rho_{Z,D}z_{t-1}^{D^{\ast}}+\varepsilon_t^{Z,D^{\ast}}.
```

- **(F49) 本国抵押风险冲击**：

```math
\sigma_{\omega,t}=(1-\rho_{\sigma\omega})\bar\sigma_\omega+\rho_{\sigma\omega}\sigma_{\omega,t-1}+u_{\omega,t}.
```

- **(F50) 外国抵押风险冲击**：

```math
\sigma_{\omega,t}^{\ast}=(1-\rho_{\sigma\omega})\bar\sigma_\omega+\rho_{\sigma\omega}\sigma_{\omega,t-1}^{\ast}+u_{\omega,t}^{\ast}.
```

- **(F51) 国际风险溢价冲击**：

```math
\vartheta_t=\rho_\vartheta\vartheta_{t-1}+\varepsilon_t^\vartheta.
```

- **(F52) 单位根技术与货币政策创新**：

```math
\varepsilon_t^A\;\text{and}\;\varepsilon_t^m\;\text{are i.i.d. innovations.}
```

## 6. Steady-State Solution

论文附录在用共同欧元区技术趋势 $`A_t`$ 规范化变量后，以偏离稳态的形式给出线性化系统。因此线性化稳态令所有小写偏离变量和通胀缺口等于零：

```math
c=d=i=q=l=w=y=b=t=r=\eta=\xi=z=\sigma_\omega-\bar\sigma_\omega=0.
```

对于实现工作，Rep-MMB `.mod` 提供用于初始化指数化模型的非线性平稳校准。重要规范化与目标包括 $`Q=1`$、毛通胀率等于一、$`b=0`$、$`R=RR\_bar`$、$`R^L=RL\_bar`$、稳态违约比例 $`F\_bar`$，以及对称校准的本国/外国住房信贷稳态。这些值记录为 `implementation_cross_check`，不是额外的论文侧推导。

稳态重建为 `needs_review`：来源附录给出线性化条件，而非线性实现编码了一整套稳态常数。本次档案整理未运行 Dynare `steady` 或 `check`。

## 7. Timing & Form Conventions

- **线性化**：附录 2 用小写变量表示稳态对数偏离；带单位根趋势的变量先除以 $`A_t`$。
- **外国变量**：论文用星号记号；Rep-MMB 实现用 `_s`。
- **住房存量**：$`d_t`$ 和 $`d_t^B`$ 是由 (F29) 和 (F30) 中过去投资决定的期初规范化住房存量。实现中的非线性运动方程使用滞后投资和趋势增长。
- **抵押贷款时序**：$`t-1`$ 选择的贷款利率和信贷存量进入 $`t`$ 期偿还和事后违约清偿；事前阈值 $`\hat{\bar\omega}_t^a`$ 依赖预期下一期房屋价值。
- **政策时序**：Taylor 规则用 $`r_{t-1}`$ 平滑共同政策利率，并对当前欧元区通胀和产出增长反应。宏观审慎工具是国家层面的、当期信贷指标函数。
- **公式注意事项**：(F8)、(F9)、(F12)、(F13) 和 (F36) 标记为 `needs_review`，因为 MinerU OCR 或已发表附录文本包含敏感导数记号或可能的系数错误。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量，储蓄者 | $`c,d,i,\varrho,l^C,l^D`$ | 储蓄者消费、住房、投资、住房乘子、部门劳动 | (F1)-(F5), (F29) |
| 内生变量，借款者 | $`c^B,d^B,i^B,\varrho^B,l^{B,C},l^{B,D},\tilde s^B`$ | 借款者消费、住房、投资、信贷和劳动 | (F6)-(F15), (F30) |
| 金融变量 | $`r,r^L,r^D,\hat{\bar\omega}^a,\hat\omega^p,\eta,F,G`$ | 存款利率、贷款/违约利率、违约阈值、宏观审慎楔子和对数正态函数 | (F8)-(F15), (F39)-(F40) |
| 价格和工资 | $`q,\Delta p^C,\Delta p^D,\Delta p^H,\Delta p^F,\tilde w^C,\tilde w^D`$ | 相对房价、CPI/部门通胀、部门实际工资 | (F23)-(F26), (F35), (F37) |
| 数量 | $`c_H,c_F,c^{TOT},y^C,y^D,y,l^{C,TOT},l^{D,TOT}`$ | 需求汇总、生产、市场出清和产出 | (F16)-(F22), (F27)-(F31), (F38) |
| 开放经济 | $`b,t,r^{\ast},y^{\ast},\Delta p^{C^{\ast}}`$ | 净外国资产、贸易条件、外国政策利率和外国总量 | (F32)-(F38) |
| 外生冲击 | $`\xi^C,\xi^{C^{\ast}},\xi^D,\xi^{D^{\ast}},z^C,z^{C^{\ast}},z^D,z^{D^{\ast}},\sigma_\omega,\sigma_\omega^{\ast},\vartheta,\varepsilon^A,\varepsilon^m`$ | 偏好、技术、风险、国际溢价、单位根技术和货币政策冲击 | (F41)-(F52) |
| 参数 | $`\beta,\beta^B,\lambda,n,\delta,\varepsilon,\varepsilon^B,\alpha,\tau,\iota_C,\iota_L,\varphi,\psi,\theta_C,\theta_D,\varphi_C,\varphi_D,\kappa_b,\gamma_R,\gamma_\pi,\gamma_y,\gamma_\eta,\mu,\rho_\cdot`$ | 贴现因子、人口份额、调整与价格参数、政策系数、监督成本和持久性参数 | all equations |
