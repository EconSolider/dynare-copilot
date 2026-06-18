# EA_DKR11 - 不同监管制度下的宏观传播

> `EA_DKR11` 的私有模型档案一稿推导。状态：`needs_review`。
> 来源：Matthieu Darracq Pariès、Christoffer Kok Sørensen、Diego Rodriguez-Palenzuela (2011)，"Macroeconomic propagation under different regulatory regimes: Evidence from an estimated DSGE model for the euro area"，International Journal of Central Banking 7(4), 49-113。DOI: `10.2139/ssrn.1682085`。
> 主 Markdown：`raw/mmb_mineru/runs/ea_dkr11__macroeconomic_propagation_under_different_regulatory_regimes_evidence_fr__5f88c84d/full.md`。
> 原始 PDF 路径存在并用于出处记录，但未打开 PDF 正文。

## 1. 模型概述

- **模型**：闭合经济的欧元区 DSGE 模型，包含耐心储蓄户、非耐心借款户、企业家、两个实际部门、名义价格和工资刚性，以及带资本比率摩擦的银行部门。
- **论文来源匹配**：Markdown 第一行给出预期标题，第 3 行给出预期作者。在前 80 行 Markdown 中未发现标题或作者不匹配。
- **实际部门**：非住宅中间品使用资本和劳动；住宅中间品使用资本、劳动和固定土地。零售商差异化商品并按 Calvo 机制定价。
- **信贷摩擦**：借款户和企业家面对带有特质抵押品冲击的 costly-state-verification/default 合约。商业贷款分支盈亏平衡；违约阈值决定还款、抵押品处置和贷款溢价。
- **银行部门**：批发银行分支以存款和银行资本为家庭与企业家信贷融资。二次成本惩罚银行资本比率相对目标值的偏离。零售存款和贷款账簿融资分支在 Calvo 型利率刚性下设定存款和贷款利率。
- **政策实验**：基准制度是 Basel I 型固定风险权重；论文还研究风险敏感的 Basel II 型要求、更高资本要求，以及逆周期宏观审慎规则。
- **模型形式**：用于贝叶斯估计的非线性结构模型。MMB 实现交叉检查是包含水平变量、比率和观测方程的非线性 Dynare 模型，而不是 `model(linear)`。
- **运行验证**：未执行。没有运行 Dynare，也没有将本推导提升到可运行 skill archive。

## 2. 主体的最优化问题

### 耐心储蓄户

耐心家庭最大化关于非住宅消费和住房服务复合品的预期终身效用，并承担分部门劳动负效用：

```math
E_t\sum_{j=0}^{\infty}\beta^j\varepsilon_{t+j}^{\beta}
\left[
\frac{(X_{t+j}^{s})^{1-\sigma_X}}{1-\sigma_X}
-\sum_{m\in\{C,D\}}\frac{\varepsilon_{t+j}^{L}\bar L_m}{1+\sigma_{Lm}}
(N_{m,t+j}^{s})^{1+\sigma_{Lm}}
\right].
```

消费服务聚合器为

```math
X_t^s=\left[(1-\varepsilon_t^D\omega_D)^{1/\eta_D}
(C_t^s-h_SC_{t-1}^s)^{(\eta_D-1)/\eta_D}
+(\varepsilon_t^D\omega_D)^{1/\eta_D}(D_t^s)^{(\eta_D-1)/\eta_D}
\right]^{\eta_D/(\eta_D-1)}.
```

储蓄户预算约束为

```math
C_t^s+Q_{D,t}T_{D,t}\big(D_t^s-(1-\delta)D_{t-1}^s\big)+Dep_t^s
=\frac{1+R_{D,t-1}}{1+\pi_t}Dep_{t-1}^s
+(1-\tau_{w,t})(w_{C,t}^sN_{C,t}^s+w_{D,t}^sN_{D,t}^s)+\Pi_t^s+TT_t^s.
```

### 非耐心借款户

非耐心家庭具有相同的聚合器结构，但贴现因子更低。它们选择非住宅消费、住房、家庭债务、违约阈值和劳动供给，并受预算约束和贷款银行零利润条件约束：

```math
\widetilde C_t+\widetilde Q_{D,t}T_{D,t}\big(\widetilde D_t-(1-\delta)\widetilde D_{t-1}\big)
+H(\bar\varpi_{HH,t})\widetilde A_{HH,t}
=B_{HH,t}+\widetilde TT_t+\widetilde w_{C,t}\widetilde N_{C,t}
+\widetilde w_{D,t}\widetilde N_{D,t}.
```

借款户可执行抵押品为

```math
\widetilde A_{HH,t}=(1-\chi_{HH})\widetilde Q_{D,t}T_{D,t}(1-\delta)\widetilde D_{t-1}.
```

### 企业家

企业家最大化带习惯的非住宅消费效用：

```math
E_t\sum_{j=0}^{\infty}\beta_E^j
\varepsilon_{t+j}^{\beta}
\frac{(C_{t+j}^E-h_EC_{t+j-1}^E)^{1-\sigma_{CE}}}{1-\sigma_{CE}},
```

并受到生产技术约束

```math
Z_t(e)=\varepsilon_t^A(u_t^C(e)K_{t-1}^C(e))^{\alpha_C}
L_t^C(e)^{1-\alpha_C}-\Omega_C,
```

```math
Z_{D,t}(e)=\varepsilon_t^{A_D}(u_t^D(e)K_{t-1}^D(e))^{\alpha_D}
L_t^D(e)^{1-\alpha_D-\alpha_{\mathcal L}}\mathcal L_t(e)^{\alpha_{\mathcal L}}-\Omega_D,
```

以及总预算约束：

```math
\begin{aligned}
C_t^E&+Q_t^C(K_t^C-(1-\delta_K)K_{t-1}^C)
+Q_t^D(K_t^D-(1-\delta_K)K_{t-1}^D)
+H^E(\bar\varpi_{E,t})\widetilde A_{E,t} \\
&=B_{E,t}+MC_tZ_t+MC_{D,t}Z_{D,t}-W_{C,t}^rL_{C,t}-W_{D,t}^rL_{D,t}
-p_{\ell,t}\mathcal L_t-\Phi(u_t^C)K_{t-1}^C-\Phi(u_t^D)K_{t-1}^D+TT_t^E.
\end{aligned}
```

企业家抵押品价值为

```math
\widetilde A_{E,t}=(1-\chi_E)(1-\delta_K)(Q_t^CK_{t-1}^C+Q_t^DK_{t-1}^D).
```

### 零售商、存量生产商与银行

零售商购买同质中间品，并在 Calvo 摩擦下设定差异化价格。资本和住房存量生产商将最终品转化为新资本和住房存量，并面对投资调整成本。批发银行在资产负债表恒等式和银行资本比率二次成本下求解静态利润问题；零售存款和贷款账簿分支在 Calvo 型刚性下选择重设利率。

## 3. 一阶条件

论文未打印一套紧凑的完整 FOC；本一稿档案记录 Markdown 中可见的结构均衡条件，并将压缩或由实现确认的模块标记为 `needs_review`。

**(F1) 储蓄户消费服务边际效用**

```math
UC_t=\varepsilon_t^\beta (X_t^s)^{-\sigma_X}
(1-\varepsilon_t^D\omega_D)^{1/\eta_D}
(X_t^s)^{1/\eta_D}(C_t^s-h_SC_{t-1}^s)^{-1/\eta_D}
-\beta h_S E_t[\cdots] .
```

这里的前瞻习惯项因 OCR 被缩写，需要源级复核。

**(F2) 储蓄户住房 Euler 条件**

```math
Q_{D,t}T_{D,t}UC_t=UC_{D,t}+\beta(1-\delta)E_t[UC_{t+1}Q_{D,t+1}T_{D,t+1}].
```

**(F3) 储蓄户存款 Euler 条件**

```math
UC_t=\beta E_t\left[UC_{t+1}\frac{1+R_{D,t}}{1+\pi_{t+1}}\right].
```

**(F4) 借款户违约阈值**

```math
\bar\varpi_{HH,t}\widetilde A_{HH,t}
=\frac{1+R_{HH,t}^L}{1+\pi_t}B_{HH,t-1}.
```

**(F5) 借款户还款/违约份额**

```math
H(\bar\varpi_{HH,t})=
\left(1-F_t(\bar\varpi_{HH,t})\right)\bar\varpi_{HH,t}
+\int_0^{\bar\varpi_{HH,t}}\varpi\,dF_t(\varpi).
```

**(F6) 家庭信贷银行盈亏平衡条件**

```math
G(\bar\varpi_{HH,t})\widetilde A_{HH,t}
=\frac{1+R_{HH,t-1}}{1+\pi_t}B_{HH,t-1},
```

其中

```math
G(\bar\varpi_{HH,t})=
\left(1-F_t(\bar\varpi_{HH,t})\right)\bar\varpi_{HH,t}
+(1-\mu_{HH})\int_0^{\bar\varpi_{HH,t}}\varpi\,dF_t(\varpi).
```

**(F7) 借款户含外部融资溢价的修正 Euler 条件**

```math
1=\beta_B E_t\left[\frac{UCNR_{t+1}}{UCNR_t}
\frac{1+R_{L,t}}{1+\pi_{t+1}}\Psi_{HH,t+1}\right].
```

这里 $`\Psi_{HH,t}`$ 是违约合约引致的外部融资溢价项；该压缩记号为 `needs_review`。

**(F8) 借款户住房 Euler 条件**

```math
Q_{H,t}^{NR}T_{D,t}
=\frac{UC_{D,t}^{NR}}{UCNR_t}
+\beta_B(1-\delta)E_t\left[\frac{UCNR_{t+1}}{UCNR_t}Q_{H,t+1}^{NR}T_{D,t+1}
\left(1-\chi_{HH}\right)(H_{HH,t+1}+G_{HH,t+1}\Psi_{HH,t+1})Q_{H,t+1}^{NR}T_{D,t+1}\right].
```

**(F9) 企业家违约阈值**

```math
\bar\varpi_{E,t}\widetilde A_{E,t}
=\frac{1+R_{E,t}^L}{1+\pi_t}B_{E,t-1}.
```

**(F10) 企业家还款/违约份额**

```math
H^E(\bar\varpi_{E,t})=
\left(1-F_t^E(\bar\varpi_{E,t})\right)\bar\varpi_{E,t}
+\int_0^{\bar\varpi_{E,t}}\varpi\,dF_t^E(\varpi).
```

**(F11) 企业家信贷银行盈亏平衡条件**

```math
G^E(\bar\varpi_{E,t})\widetilde A_{E,t}
=\frac{1+R_{E,t-1}}{1+\pi_t}B_{E,t-1},
```

其中

```math
G^E(\bar\varpi_{E,t})=
\left(1-F_t^E(\bar\varpi_{E,t})\right)\bar\varpi_{E,t}
+(1-\mu_E)\int_0^{\bar\varpi_{E,t}}\varpi\,dF_t^E(\varpi).
```

**(F12) 企业家含外部融资溢价的消费 Euler 条件**

```math
1=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\frac{1+R_{L,E,t}}{1+\pi_{t+1}}\Psi_{E,t+1}\right].
```

**(F13) 企业家非住宅资本 Euler 条件**

```math
Q_t^C=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\left(Q_{t+1}^C(1-\delta_K)+u_{t+1}^C\Phi'(u_{t+1}^C)-\Phi(u_{t+1}^C)\right)\right]
+\text{collateral-premium term}.
```

抵押品溢价项来自论文的违约合约楔子，标记为 `needs_review`。

**(F14) 企业家住宅资本 Euler 条件**

```math
Q_t^D=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\left(Q_{t+1}^D(1-\delta_K)+u_{t+1}^D\Phi'(u_{t+1}^D)-\Phi(u_{t+1}^D)\right)\right]
+\text{collateral-premium term}.
```

**(F15) 资本利用率条件**

```math
\Phi'(u_t^C)=R_{K,t}^C,\qquad \Phi'(u_t^D)=R_{K,t}^D.
```

**(F16) 非住宅部门边际成本**

```math
MC_t=\left(\frac{R_{K,t}^C}{\alpha_C}\right)^{\alpha_C}
\left(\frac{W_{C,t}}{1-\alpha_C}\right)^{1-\alpha_C}
(\varepsilon_t^A)^{-1}.
```

**(F17) 住宅部门边际成本**

```math
MC_{D,t}T_{D,t}=
\left(\frac{R_{K,t}^D}{\alpha_D}\right)^{\alpha_D}
\left(\frac{W_{D,t}}{1-\alpha_D-\alpha_{\mathcal L}}\right)^{1-\alpha_D-\alpha_{\mathcal L}}
\left(\frac{p_{\ell,t}}{\alpha_{\mathcal L}}\right)^{\alpha_{\mathcal L}}
(\varepsilon_t^{A_D})^{-1}.
```

**(F18) 资本存量生产商 FOC**

```math
Q_t^C\left[1-S_t^C-\frac{I_t^C}{I_{t-1}^C}S_{1,t}^C\right]\varepsilon_t^I
+\beta E_t\left[Q_{t+1}^C\frac{UC_{t+1}}{UC_t}S_{1,t+1}^C
\left(\frac{I_{t+1}^C}{I_t^C}\right)^2\varepsilon_{t+1}^I\right]=1.
```

**(F19) 住房存量生产商 FOC**

```math
Q_{H,t}\left[1-S_{H,t}-\frac{I_{H,t}}{I_{H,t-1}}S_{H1,t}\right]
+\beta E_t\left[Q_{H,t+1}\frac{T_{D,t+1}}{T_{D,t}}\frac{UC_{t+1}}{UC_t}
S_{H1,t+1}\left(\frac{I_{H,t+1}}{I_{H,t}}\right)^2\right]=1.
```

**(F20) Calvo 价格重设：非住宅部门**

```math
\left(\mu(1-subv)\frac{ZP1_t}{ZP2_t}\right)^{1/(1-\mu)}(1-\xi_p)
+1-\xi_p AP_t^{1/(\mu-1)}=0.
```

**(F21) Calvo 价格递归：非住宅分子**

```math
ZP1_t=UC_tMC_tY_t+\beta\xi_p E_t[AP_{t+1}^{\mu/(\mu-1)}ZP1_{t+1}].
```

**(F22) Calvo 价格递归：非住宅分母**

```math
ZP2_t=(1-\tau)UC_tY_t+\beta\xi_p E_t[AP_{t+1}^{1/(\mu-1)}ZP2_{t+1}].
```

**(F23) Calvo 工资重设：部门/类型模块**

```math
W_{j,i,t}^{1/(1-\mu_w)}
=(1-\xi_{w,j,i})\left(\mu_w(1-subw)\frac{ZW1_{j,i,t}}{ZW2_{j,i,t}}\right)^{-1/(\mu_w-1)}
+\xi_{w,j,i}W_{j,i,t-1}^{1/(1-\mu_w)}AW_{j,i,t}^{-1/(1-\mu_w)}.
```

这概括了非住宅和住宅部门中储蓄户/借款户劳动的四个工资设定模块；每个模块在提升状态前都需要公式级复核。

**(F24) 批发银行资产负债表**

```math
B_{HH,t}^{wb}+B_{E,t}^{wb}=Dep_t^{wb}+Bankcap_t.
```

**(F25) Basel I 家庭贷款批发利差**

```math
R_{HH,t}^{wb}-R_t=
-\chi_{wb}\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}-0.11\right)
\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}\right)^2 0.5.
```

**(F26) Basel I 企业家贷款批发利差**

```math
R_{E,t}^{wb}-R_t=
-\chi_{wb}\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}-0.11\right)
\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}\right)^2.
```

**(F27) 银行资本积累**

```math
Bankcap_t=(1-\delta^{wb})Bankcap_{t-1}+\nu^b\Pi_t^b.
```

**(F28) 零售存款利率重设**

```math
\hat R_{D,t}
=\arg\max_{\hat R}
E_t\sum_{k=0}^{\infty}(\beta\xi_D^R)^k
\frac{\Lambda_{t+k}}{\Lambda_t}
\left(R_{t+k}-\hat R\right)Dep_{t+k}(j).
```

**(F29) 零售贷款利率重设**

```math
\hat R_{i,t}
=\arg\max_{\hat R}
E_t\sum_{k=0}^{\infty}(\beta\xi_i^R)^k
\frac{\Lambda_{t+k}}{\Lambda_t}
\left(\hat R-R_{i,t+k}^{wb}\right)B_{i,t+k}(j),
\qquad i\in\{HH,E\}.
```

**(F30) 零售利率离散/指数方程**

```math
R_{i,t}^{1/(1-\mu_i^R)}
=(1-\xi_i^R)\hat R_{i,t}^{1/(1-\mu_i^R)}
+\xi_i^R R_{i,t-1}^{1/(1-\mu_i^R)},\qquad i\in\{D,HH,E\}.
```

## 4. 市场出清与总量恒等式

**(F31) 非住宅资源约束**

```math
Y_t=C_t^E+\omega C_t^B+(1-\omega)C_t^S+I_t+G_t+\Phi(u_t^C)K_{t-1}^C+\Phi(u_t^D)K_{t-1}^D.
```

**(F32) 住宅资源约束**

```math
Z_{D,t}=(1-\omega)I_{H,t}^S+\omega I_{H,t}^B+G_D.
```

**(F33) 总资本、劳动和投资恒等式**

```math
K_t=K_t^C+K_t^D,\qquad L_t=L_{C,t}+L_{D,t},\qquad I_t=I_t^C+I_t^D.
```

**(F34) 银行贷款/存款汇总**

```math
Debt_t^{TOT}=\omega B_{HH,t}+B_{E,t},\qquad Dep_t+Bankcap_t=Debt_t^{TOT}.
```

**(F35) 货币政策规则**

```math
r_t=\rho r_{t-1}+(1-\rho)(r_{\pi}\pi_{t-1}+r_y y_{t-1})
+r_{\Delta\pi}\Delta\pi_t+r_{\Delta y}\Delta y_t+r_{T_D}\Delta t_{D,t}
+\log(\varepsilon_t^R).
```

**(F36) 逆周期资本要求规则**

```math
cap_t=\rho^{bc}cap_{t-1}+r_y^{bc}y_t+r_{\Delta y}^{bc}\Delta y_t
+r_{\Delta h}^{bc}\Delta b_{HH,t}+r_{\Delta e}^{bc}\Delta b_{E,t}
+r_{T_D}^{bc}\Delta t_{D,t}+r_Q^{bc}\Delta q_t.
```

## 5. 外生过程

论文说明主要结构扰动均为 AR(1)，除非另有说明。实现交叉检查确认了以下过程族和冲击名称。

**(F37) 技术冲击**

```math
\log\varepsilon_t^A=\rho_A\log\varepsilon_{t-1}^A+\xi_{A,t},\qquad
\log\varepsilon_t^{A_D}=\rho_{A_D}\log\varepsilon_{t-1}^{A_D}+\xi_{A_D,t}.
```

**(F38) 偏好、住房偏好、政府和劳动冲击**

```math
\log\varepsilon_t^j=\rho_j\log\varepsilon_{t-1}^j+\xi_{j,t},
\qquad j\in\{\beta,D,G,L\}.
```

**(F39) 投资专有和住房投资冲击**

```math
\log\varepsilon_t^I=\rho_I\log\varepsilon_{t-1}^I+\xi_{I,t},\qquad
\log\varepsilon_t^{IH}=\rho_{IH}\log\varepsilon_{t-1}^{IH}+\xi_{IH,t}.
```

**(F40) 零售利率加成冲击**

```math
\log\varepsilon_{i,t}^{R}=\rho_i^R\log\varepsilon_{i,t-1}^{R}+\xi_{i,t}^{R},
\qquad i\in\{D,HH,E\}.
```

**(F41) 借款人风险冲击**

```math
\log\sigma_{i,t}=\rho_{\sigma_i}\log\sigma_{i,t-1}+\xi_{\sigma_i,t},
\qquad i\in\{HH,E\}.
```

**(F42) 银行资本和货币政策冲击**

```math
\log\varepsilon_t^{Bankcap}=\rho_{Bankcap}\log\varepsilon_{t-1}^{Bankcap}+\xi_{Bankcap,t},
\qquad \log\varepsilon_t^R=\xi_{R,t}.
```

## 6. 稳态求解

档案状态为 `needs_review`：论文给出校准目标和描述性的稳态限制，而完整代数很长且部分编码在 MMB 实现中。未运行 Dynare 稳态验证。

1. 设零通胀，并将平稳冲击规范化到均值：$`\bar\pi=0`$, $`\bar\varepsilon^A=\bar\varepsilon^{A_D}=\bar\varepsilon^\beta=\bar\varepsilon^D=\bar\varepsilon^G=\bar\varepsilon^L=1`$。
2. 耐心贴现因子决定实际存款利率。论文校准 patient $`\beta=0.995`$，对应约 2% 年化实际存款利率。
3. 采用 Appendix 2 的资本和住房折旧：住房季度折旧 $`\delta=0.01`$，论文记号下资本年折旧 $`\delta_K=0.1`$。
4. 商品市场加成为 1.3，两个部门劳动市场加成为 1.5。
5. 设置住宅效用份额 $`\omega_D`$ 以匹配住宅投资/GDP 比率；设置 $`\eta_D=1`$，企业家跨期替代弹性 $`\sigma_{CE}=1`$。
6. 决定贷款和存款加成，使贷款-存款利差为 100 个年化基点，家庭和企业家贷款利差分别为 200 和 120 个年化基点。
7. 从修正 Euler 方程和零利润条件求稳态违约阈值 $`\bar\varpi_{HH}`$ 和 $`\bar\varpi_E`$。在监控成本 $`\mu_E=0.2`$ 和 $`\mu_{HH}=0.15`$ 下，选择特质风险方差以再现企业 0.7% 和非耐心家庭 0.3% 的违约频率。
8. 校准借款户份额 $`\omega=0.25`$。选择贷款价值比项 $`(1-\chi_E)=0.6`$ 和 $`(1-\chi_{HH})=0.2`$，使公司贷款约为年度 GDP 的 33%，家庭住房贷款约为年度 GDP 的 25%。
9. 对银行模块，在 Basel I 基准中目标银行资本比率为 11%；留存收益和银行利润闭合银行资本积累。
10. 完整的顺序闭式稳态赋值为 `needs_review`；实现交叉检查包含许多反解的稳态别名，但这些不被视为论文侧数学证据。

## 7. 时序与形式约定

- 资本和住房存量在生产和抵押品项中是预定的：第 `t` 期生产使用 $`K_{t-1}^C`$、$`K_{t-1}^D`$ 和 $`D_{t-1}`$。
- 违约阈值使用上一期发行的债务和当期实现的抵押品价值。
- 借款户和企业家贷款利率是一期利率。零售贷款和存款利率是由 Calvo 型分支设定的粘性复合利率。
- 银行资本是由滞后银行资本和留存银行利润累积形成的状态变量。
- 政策规则写为相对确定性稳态的偏离。政策规则模块中的小写变量表示对数偏离。
- 结构论文和 MMB 实现交叉检查中的模型均为非线性。观测方程将模型水平和利率转换为数据单位。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `C`, `CNR`, $`C^S`$, $`C^B`$ | 储蓄户和借款户非住宅消费 | (F1), (F7), (F31) |
| 内生变量 | `D`, `DNR` | 储蓄户和借款户住房存量 | (F2), (F8), (F32) |
| 内生变量 | `Debt`, `Debt_E` | 家庭和企业家债务 | (F4), (F6), (F9), (F11), (F34) |
| 内生变量 | `OMEG_HH`, `OMEG` | 家庭和企业家违约阈值 | (F4), (F9) |
| 内生变量 | `H_OMEG_HH`, `G_OMEG_HH`, `H_OMEG`, `G_OMEG` | 还款和银行回收份额 | (F5), (F6), (F10), (F11) |
| 内生变量 | `PSI`, `PSI_E` | 外部融资溢价项 | (F7), (F8), (F12)-(F14) |
| 内生变量 | `C_E` | 企业家消费 | (F12), (F31) |
| 内生变量 | `K_C`, `K_D`, `Q`, `Q_D` | 分部门资本和资产价格 | (F13), (F14), (F18), (F33) |
| 内生变量 | `TCU`, `TCU_D`, `R_K` | 资本利用率和租金回报 | (F15) |
| 内生变量 | `Z`, `Z_D`, `Y` | 中间品和最终产出 | (F16), (F17), (F31), (F32) |
| 内生变量 | `MC`, `MC_D` | 分部门边际成本 | (F16), (F17), (F21), (F22) |
| 内生变量 | `Dp`, `Dp_D`, `ZP1`, `ZP2` | Calvo 价格离散/递归 | (F20)-(F22) |
| 内生变量 | `W_C`, `W_D`, `Dw_C`, `Dw_D` | 工资和工资离散 | (F23) |
| 内生变量 | `R`, `R_D`, `R_L`, `R_L_E` | 政策、存款、家庭贷款和企业家贷款利率 | (F3), (F28)-(F30), (F35) |
| 内生变量 | `Bankcap`, `Debt_TOT`, `Depo`, `LEV` | 银行资本、总贷款、存款、杠杆 | (F24), (F27), (F34) |
| 内生变量 | `RB_L`, `RB_L_E`, `SB_L`, `SB_L_E` | 批发贷款利率和利差 | (F25), (F26) |
| 外生变量 | `E_A`, `E_A_D` | 技术创新 | (F37) |
| 外生变量 | `E_B`, `E_G`, `E_L`, `E_H` | 偏好、公共支出、劳动、住房偏好创新 | (F38) |
| 外生变量 | `E_I` | 投资专有创新 | (F39) |
| 外生变量 | `E_R_D`, `E_R_L`, `E_R_L_E` | 零售存款和贷款利率加成创新 | (F40) |
| 外生变量 | `E_SIG_HH`, `E_SIG` | 家庭和企业家风险创新 | (F41) |
| 外生变量 | `E_Bankcap`, `E_R` | 银行资本和货币政策创新 | (F42) |
| 参数 | `betta`, `betta_NR`, `betta_NR_E` | 储蓄户、借款户和企业家贴现因子 | 稳态 |
| 参数 | `omega_NR`, `omega_D` | 借款户份额和住房偏好份额 | (F1), (F31), (F32) |
| 参数 | `alph`, `alph_D`, `alph_LAN` | 生产份额 | (F16), (F17) |
| 参数 | `tau`, `tau_D` | 实现中的资本/住房折旧记号 | (F13), (F14), (F18), (F19) |
| 参数 | `mu_NFC`, `mu_HH`, `chi_NR_E`, `chi_NR` | 监控成本和抵押品豁免 | (F4)-(F11) |
| 参数 | `xi_p`, `xi_p_D`, `xi_w_C`, `xi_w_D` | 价格和工资 Calvo 概率 | (F20)-(F23) |
| 参数 | `xi_R_D`, `xi_R_L`, `xi_R_L_E` | 零售利率 Calvo 概率 | (F28)-(F30) |
| 参数 | `kappa_b`, `nu_b`, `omega_B` | 银行资本成本、目标/留存参数 | (F25)-(F27) |
| 参数 | `rho`, `r_PI`, `r_y`, `r_dpi`, `r_dy`, `r_dtd` | 货币政策规则参数 | (F35) |
| 参数 | `rho_*` | 冲击持续性参数 | (F37)-(F42) |

该表有意保持宽口径，因为 MMB 模型规模较大。与完整 `.mod` 方程数量的公式级核对被推迟；本条目是一稿、基于来源的推导，状态保持为 `needs_review`。
