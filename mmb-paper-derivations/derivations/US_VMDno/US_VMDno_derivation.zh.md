# US_VMDno - 推导（最优化问题 + 一阶条件）

> 本一遍初稿条目基于下列 MinerU Markdown 来源。尚未进行运行时验证。公式质量标记为 `needs_review`，因为已发表文章把 CMR/SW 基础模型的大部分内容放在单独附录中，且 MinerU OCR 中存在可见的数学识别瑕疵。

**来源信息。** 模型 ID：`US_VMDno`。论文：Verona, Fabio; Martins, Manuel M. F.; Drumond, Ines (2013), "(Un)anticipated Monetary Policy in a DSGE Model with a Shadow Banking System - Normal times", *International Journal of Central Banking* 9(3), pp. 78-124。DOI：`10.2139/ssrn.2256278`。主 Markdown 来源：`raw/mmb_mineru/runs/us_vmdno_us_vmdop__un_anticipated_monetary_policy_in_a_dsge_model_with_a_shadow_banking_sys__9ba7c6c3/full.md`。原始 PDF：`raw/mmb_papers/(Un)anticipated monetary policy in a dsge model with a shadow banking system - Normal times.pdf`。MinerU run id：`9ba7c6c3-ab5d-4369-ab19-763c4740a11e`。

## 1. Model Overview

- **模型。** 美国季度 DSGE 模型，在 Christiano-Motto-Rostagno 金融加速器环境上加入影子银行债券融资部门。`US_VMDno` 是正常时期校准：通过把乐观情绪敏感度设为零来关闭乐观情绪层。
- **实验。** 预期与非预期的 "too low for too long" 货币政策路径把政策利率在六个季度内固定在低于稳态 100 个基点的位置，然后回到 Taylor 型规则。
- **主体。** 家庭通过存款/债券储蓄并供给差异化劳动；中间品/最终品厂商生产；资本品生产商把投资转化为已安装资本；企业家出租资本，并通过零售银行贷款或投资银行承销债券融资；政府平衡预算；央行在政策实验之外遵循带平滑的 Taylor 规则。
- **模型形式。** 来源与实现交叉检查显示其为非线性均衡方程，并进行一阶扰动求解，同时含有并行的灵活价格区块。本推导记录正常时期粘性价格主区块，并把完整基础模型附录方程标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 更安全的 LR 企业家

更安全的企业家使用债券融资。在 \(t\) 期末，债券融资的资本购置为

\[
B I_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}.
\]

企业家选择利用率和下一期资本以最大化当期利润：

\[
\Pi_t^{LR,l}
=\left[u_t^{LR,l}r_t^{k,LR}-a(u_t^{LR,l})\right]\bar{K}_t^{LR,l}P_t
+(1-\delta)Q_{\bar{k}',t}\bar{K}_t^{LR,l}
-Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}
-R_t^{coupon}\left(Q_{\bar{k}',t-1}\bar{K}_t^{LR,l}-N_t^{LR,l}\right).
\]

### 2.2 更安全企业家的债券承销需求

企业家在具有垄断竞争的投资银行之间最小化总偿还额：

\[
\min_{\{BI_{t+1}^{LR,l}(z)\}_{z\in[0,1]}}
\int_0^1\left[1+R_{t+1}^{coupon}(z)\right]BI_{t+1}^{LR,l}(z)\,dz
\]

约束为 Dixit-Stiglitz 聚合器：

\[
BI_{t+1}^{LR,l}
=\left\{\int_0^1\left[BI_{t+1}^{LR,l}(z)\right]^{\frac{\varepsilon_{t+1}^{coupon}-1}{\varepsilon_{t+1}^{coupon}}}dz\right\}^{\frac{\varepsilon_{t+1}^{coupon}}{\varepsilon_{t+1}^{coupon}-1}}.
\]

### 2.3 投资银行

承销商选择债券发行的票息利率，并把家庭要求的回报率视为无风险政策利率：

\[
\max_{R_{t+1}^{coupon}(z)}
\left\{\left[1+R_{t+1}^{coupon}(z)\right]BI_{t+1}^{LR,l}(z)
-\left[1+R_{t+1}^{e}\right]BI_{t+1}^{LR,l}(z)\right\}
\]

约束为企业家聚合器隐含的个别需求曲线。

### 2.4 标准 CMR/SW 区块

论文说明模型其余部分遵循 CMR-FA 环境：拥有存款/债券和差异化劳动的家庭，具有粘性价格和工资的中间品厂商，带投资调整成本的资本品生产商，使用 BGG 型零售银行融资的高风险 HR 企业家，以及政府/央行区块。文章指向 Verona, Martins, and Drumond (2012), Appendix A 作为完整方程来源；当前 MinerU 来源不包含该附录。因此，下列依赖实现交叉检查而不是文章正文的区块公式均标记为 `needs_review`。

## 3. First-Order Conditions

**更安全的 LR 企业家和投资银行**

- **(F1) 债券融资资本购置。**

\[
BI_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}.
\]

- **(F2) 利用率条件。**

\[
r_t^{k,LR}=a'\left(u_t^{LR,l}\right).
\]

- **(F3) 资本 Euler 方程。**

\[
Q_{\bar{k}',t}
=\beta E_t\left\{\left[u_{t+1}^{LR,l}r_{t+1}^{k,LR}-a(u_{t+1}^{LR,l})\right]P_{t+1}
+(1-\delta)Q_{\bar{k}',t+1}
-R_{t+1}^{coupon}Q_{\bar{k}',t}\right\}.
\]

- **(F4) 企业家对承销商 \(z\) 的资金需求。**

\[
BI_{t+1}^{LR,l}(z)
=\left(\frac{1+R_{t+1}^{coupon}(z)}{1+R_{t+1}^{coupon}}\right)^{-\varepsilon_{t+1}^{coupon}}BI_{t+1}^{LR,l}.
\]

- **(F5) 平均票息利率指数。**

\[
1+R_{t+1}^{coupon}
=\left\{\int_0^1\left[1+R_{t+1}^{coupon}(z)\right]^{1-\varepsilon_{t+1}^{coupon}}dz\right\}^{\frac{1}{1-\varepsilon_{t+1}^{coupon}}}.
\]

- **(F6) 投资银行加成条件。**

\[
1+R_{t+1}^{coupon}
=\frac{\varepsilon_{t+1}^{coupon}}{\varepsilon_{t+1}^{coupon}-1}\left(1+R_{t+1}^e\right).
\]

- **(F7) 债券融资利差。**

\[
spread_{t+1}\equiv R_{t+1}^{coupon}-R_{t+1}^e
=\frac{1}{\varepsilon_{t+1}^{coupon}-1}\left(1+R_{t+1}^e\right).
\]

- **(F8) 更安全企业家的权益价值。**

\[
V_t^{LR,l}
=\left\{\left[u_t^{LR,l}r_t^{k,LR}-a(u_t^{LR,l})\right]P_t+(1-\delta)Q_{\bar{k}',t}\right\}\bar{K}_t^{LR,l}
-\left(1+R_t^{coupon}\right)\left(Q_{\bar{k}',t-1}\bar{K}_t^{LR,l}-N_t^{LR,l}\right).
\]

- **(F9) 更安全企业家的净值。**

\[
N_{t+1}^{LR,l}=\gamma^{LR}V_t^{LR,l}+W_t^{e,LR,l}.
\]

**正常时期影子银行校准**

- **(F10) 正常时期债券需求弹性。**

\[
\varepsilon_{t+1}^{normal}=\bar{\varepsilon}+\alpha_1\left(Y_t-\bar{Y}\right).
\]

- **(F11) 正常时期票息利率。**

\[
1+R_{t+1}^{coupon,normal}
=\frac{\varepsilon_{t+1}^{normal}}{\varepsilon_{t+1}^{normal}-1}\left(1+R_{t+1}^{e}\right).
\]

- **(F12) 正常时期利差。**

\[
spread_{t+1}^{normal}
=\frac{1}{\varepsilon_{t+1}^{normal}-1}\left(1+R_{t+1}^{e}\right).
\]

**为区分变体而记录的乐观情绪层；在 `US_VMDno` 中不激活**

- **(F13) 乐观情绪过程。**

\[
\chi_t=\rho_\chi\chi_{t-1}+(1-\rho_\chi)\left[\bar{\chi}+\alpha_2\left(N_{t+1}^{LR,l}-N^{LR,l}\right)\right].
\]

对 `US_VMDno`，\(\alpha_2=0\)，所以该层不是额外乐观动态的来源。

- **(F14) 乐观情绪弹性。**

\[
\varepsilon_{t+1}^{optimistic}=\varepsilon_{t+1}^{normal}(1+\chi_t).
\]

- **(F15) 乐观情绪票息利率。**

\[
1+R_{t+1}^{coupon,optimistic}
=\frac{\varepsilon_{t+1}^{normal}(1+\chi_t)}{\varepsilon_{t+1}^{normal}(1+\chi_t)-1}(1+R_{t+1}^{e}).
\]

**政策规则和标准模型外壳**

- **(F16) 固定利率实验之外的 Taylor 型政策规则。**

\[
R_t^e
=\tilde{\rho}R_{t-1}^e
+(1-\tilde{\rho})\left[R^e+\alpha_\pi(E_t\pi_{t+1}-\bar{\pi})+\alpha_y(Y_t-\bar{Y})\right]
+\varepsilon_t^{MP}.
\]

- **(F17) 政策实验路径。**

\[
R_t^e=R^e-0.01 \quad \text{for } t=1,\ldots,6,
\]

通过每期残差非预期冲击或预先宣布的预期冲击序列实现。

- **(F18) 家庭 Euler 方程，实现交叉检查，needs_review。**

\[
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{1+R_t^e}{\pi_{t+1}}\right].
\]

- **(F19) 含习惯的边际效用，实现交叉检查，needs_review。**

\[
\lambda_t=(c_t-bc_{t-1})^{-\sigma_c}-b\beta E_t\left[(c_{t+1}-bc_t)^{-\sigma_c}\right].
\]

- **(F20) 投资调整成本条件，实现交叉检查，needs_review。**

\[
\lambda_t q_t\left[1-\frac{S''}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2-S''\frac{i_t}{i_{t-1}}\left(\frac{i_t}{i_{t-1}}-1\right)\right]
-\lambda_t
+\beta E_t\left[\lambda_{t+1}q_{t+1}S''\left(\frac{i_{t+1}}{i_t}\right)^2\left(\frac{i_{t+1}}{i_t}-1\right)\right]=0.
\]

## 4. Market Clearing & Identities

- **(F21) CES 总资本服务。**

\[
K_t=\left[\eta\left(u_t^{HR,r}\bar{K}_t^{HR,r}\right)^\rho+(1-\eta)\left(u_t^{LR,l}\bar{K}_t^{LR,l}\right)^\rho\right]^{1/\rho}.
\]

- **(F22) 商品市场资源约束，实现交叉检查，needs_review。**

\[
Y_t=G_t+C_t+I_t+a(u_t^{HR})\eta\bar{K}_{t-1}^{HR}+a(u_t^{LR})(1-\eta)\bar{K}_{t-1}^{LR}+monitoring\ costs_t.
\]

- **(F23) 总债券、银行贷款和总融资定义。**

\[
B_t^{LR}=Q_t\bar{K}_t^{LR}-N_t^{LR},\qquad
Loans_t^{HR}=Q_t\bar{K}_t^{HR}-N_t^{HR},\qquad
Finance_t=(1-\eta)B_t^{LR}+\eta Loans_t^{HR}.
\]

- **(F24) 杠杆定义。**

\[
lev_t^{LR}=\frac{Q_t\bar{K}_t^{LR}}{N_t^{LR}},\qquad
lev_t^{HR}=\frac{Q_t\bar{K}_t^{HR}}{N_t^{HR}}.
\]

## 5. Exogenous Processes

- **(F25) 货币政策创新。**

\[
\varepsilon_t^{MP}\sim iid(0,\sigma_{MP}^2).
\]

- **(F26) 乐观情绪持久性过程，在正常时期校准中不激活。**

\[
\chi_t=\rho_\chi\chi_{t-1}\quad\text{when }\alpha_2=0,\ \bar{\chi}=0.
\]

本一遍初稿没有从论文正文中清楚抽取到额外技术或偏好冲击过程。实现交叉检查显示 MMB 复制文件中有一个政策冲击 `e_xpU`。

## 6. Steady-State Solution

文章报告季度校准和稳态目标，但没有给出完整模型的来源侧稳态算法。因此，一遍初稿的稳态质量为 `needs_review`。

1. 设置零通胀/稳态政策对象并关闭乐观情绪：

\[
\chi=0,\qquad \varepsilon^{normal}=\bar{\varepsilon},\qquad \alpha_2=0\quad(\text{for }US\_VMDno).
\]

2. 计算正常时期稳态票息和利差：

\[
1+R^{coupon}=\frac{\bar{\varepsilon}}{\bar{\varepsilon}-1}(1+R^e),\qquad
spread=\frac{1}{\bar{\varepsilon}-1}(1+R^e).
\]

3. 使用论文报告的校准目标：

\[
\beta=0.9875,\quad \eta=0.2772,\quad \bar{\varepsilon}=510,\quad \alpha_1=30000,\quad \gamma^{LR}=0.96,\quad \gamma^{HR}=0.97.
\]

4. 来源表格还报告了 \(C/Y=0.63\)、\(I/Y=0.17\)、\(G/Y=0.2\)、债券-银行融资比 \(1.5152\)、更安全企业家杠杆率 \(1.26\)、高风险企业家杠杆率 \(1.35\) 等目标。把这些目标映射到完整稳态系统需要被延后审查的 Appendix A 方程或 MMB 稳态数据文件，因此此处不声称存在已验证的闭式解。

## 7. Timing & Form Conventions

- 实物资本是为下一期使用而选择的存量；来源将购置写作 \(BI_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}\)。
- 生产中的资本服务使用利用率乘以既有企业家资本。实现交叉检查在生产型方程中使用滞后资本；准确的论文到代码时序应对照 Appendix A 复核。
- 在投资银行问题中，\(t\) 期末发行债券的票息利率以 \(t+1\) 期偿还为索引。
- `US_VMDno` 是正常时期版本：记录 (F13)-(F15) 是为了区分变体，但乐观情绪敏感度设为零。
- 未进行运行时验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Equation anchor |
|---|---|---|---|
| Endogenous | \(BI^{LR}\) / `btotBU`, `btotSU` | 更安全企业家的债券融资 | (F1), (F23) |
| Endogenous | \(Q\) / `qU` | 已安装资本价格 | (F1), (F3) |
| Endogenous | \(\bar{K}^{LR}\) / `kbarBU` | 更安全企业家的实物资本 | (F1), (F21) |
| Endogenous | \(N^{LR}\) / `nBU` | 更安全企业家的净值 | (F8), (F9) |
| Endogenous | \(u^{LR}\) / `uBU` | 更安全企业家的资本利用率 | (F2), (F21) |
| Endogenous | \(R^{coupon}\) / `RcouponXU` | 债券票息利率 | (F5), (F6), (F11) |
| Endogenous | \(R^e\) / `ReXU` | 无风险政策/定期存款利率 | (F6), (F16) |
| Endogenous | \(\varepsilon^{coupon}\) / `eps_couponU` | 债券资金需求弹性 | (F4), (F10) |
| Endogenous | \(spread\) / `SpreadU` | 债券融资利差 | (F7), (F12) |
| Endogenous | \(Y\) / `YU` | 产出 | (F10), (F16), (F21), (F22) |
| Endogenous | \(c,i,\pi,\lambda\) / `cU`, `iU`, `piU`, `lambdanU` | 消费、投资、通胀、家庭边际效用 | (F18)-(F20), needs_review |
| Endogenous | \(lev^{LR},lev^{HR}\) / `levBU`, `levSU` | 杠杆率 | (F24) |
| Exogenous | \(\varepsilon^{MP}\) / `e_xpU` | 货币政策创新 | (F16), (F25) |
| Parameter | \(\beta\) / `betaUU` | 贴现因子 | (F3), (F18), (F20) |
| Parameter | \(\eta\) / `etaSE` | 高风险企业家占比 | (F21), (F23) |
| Parameter | \(\rho\) / `rhoEIS` | 资本服务之间的替代性 | (F21) |
| Parameter | \(\bar{\varepsilon}\) / `eps_couponUU` | 稳态债券需求弹性 | (F10)-(F12) |
| Parameter | \(\alpha_1\) / `alpha4` in implementation | 正常时期弹性对产出缺口的敏感度 | (F10) |
| Parameter | \(\alpha_2\) / `alpha3` in implementation | 乐观情绪敏感度；在 `US_VMDno` 中为零 | (F13) |
| Parameter | \(\rho_\chi\) / `rho_chi` | 乐观情绪持久性 | (F13), (F26) |
| Parameter | \(\gamma^{LR},\gamma^{HR}\) / `gammaBUU`, `gammaSUU` | 企业家存活概率 | (F9) |
| Parameter | \(\tilde{\rho},\alpha_\pi,\alpha_y\) / `rhotilUU`, `aptilUU`, `aytilUU` | 货币政策规则系数 | (F16) |
| Parameter | \(S''\) / `SdouprXUU` | 投资调整成本曲率 | (F20) |
| Status | `needs_review` | 缺失/延后的 Appendix A 和 OCR 敏感公式 | 整个条目 |
