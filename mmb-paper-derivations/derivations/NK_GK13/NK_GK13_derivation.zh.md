# NK_GK13 -- 推导（最优化问题 + 均衡条件）

> 运行验证：未执行。本文件是基于 MinerU Markdown 的第一版来源支撑推导，状态标记为 `needs_review`。

来源信息：`NK_GK13`，Gertler and Karadi (2013)，"Qe 1 vs. 2 vs. 3. . . : A framework for analyzing large-scale asset purchases as a monetary policy tool"，International Journal of Central Banking 9(1), pp. 5-53。DOI：`raw/mmb_mineru/model_index.csv` 未列出。主 Markdown：`raw/mmb_mineru/runs/nk_gk13__qe_1_vs_2_vs_3_a_framework_for_analyzing_large_scale_asset_purchases_as__77fee003/full.md`。已检查原始 PDF 路径存在：`raw/mmb_papers/A framework for analyzing large-scale asset purchases as a monetary policy tool.pdf`。

## 1. Model Overview

- **模型**：带有私人金融套利约束和中央银行大规模资产购买（LSAPs）的新凯恩斯模型。
- **主体**：含工人与银行家的代表性家庭；金融中介；中央银行；中间品生产商；资本品生产商；Calvo 零售商；财政/货币当局。
- **核心机制**：银行家用短期负债融资私人资本债权和长期政府债券。道德风险约束限制银行资产负债表规模。只有当私人套利受约束时，LSAPs 才影响价格和实际活动。
- **资产**：私人资本支持债权、长期政府 consol 债券、短期无风险债务/存款。
- **模型形式**：论文给出非线性均衡条件。MMB 实现交叉检查文件是在对数稳态附近的一阶线性化 `model`，不是论文侧数学来源。
- **来源状态**：`needs_review`，因为 `model_index.csv` 记录了来源标题/模型标题不一致且有两个 MinerU run ID。本条目只使用该行的 `primary_full_md_path`。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费 $C_t$、劳动 $L_t$ 和短期债务/存款 $D_{ht}$：

$$
\max_{\{C_t,L_t,D_{ht}\}} E_t\sum_{i=0}^{\infty}\beta^i
\left[
\log(C_{t+i}-hC_{t+i-1})
-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}
\right].
$$

期间预算约束为

$$
C_t = W_tL_t+\Pi_t-X+T_t+R_tD_{h,t-1}-D_{ht}.
$$

### 2.2 银行

银行家/中介选择私人债权 $s_t$、长期政府债券 $b_t$ 和存款 $d_t$，并满足资产负债表、净值演化和激励约束：

$$
Q_ts_t+q_tb_t=n_t+d_t,
$$

$$
n_t=R_{kt}Q_{t-1}s_{t-1}+R_{bt}q_{t-1}b_{t-1}-R_td_{t-1},
$$

$$
\max_{\{s_t,b_t,d_t\}} V_t
=E_t\sum_{i=1}^{\infty}(1-\sigma)\sigma^{i-1}\Lambda_{t,t+i}n_{t+i},
$$

$$
V_t\geq \theta Q_ts_t+\Delta\theta q_tb_t.
$$

当 $0\leq\Delta<1$ 时，政府债券对应的激励约束较弱。

### 2.3 中央银行

中央银行选择私人证券购买 $S_{gt}$ 和长期债券购买 $B_{gt}$，并以短期负债融资：

$$
Q_tS_{gt}+q_tB_{gt}=D_{gt}.
$$

论文假定中央银行中介私人证券和政府债券分别有资源成本 $\tau_s$ 与 $\tau_b$。中央银行购买不受银行道德风险约束限制。

### 2.4 家庭直接持有证券

在一般化设定中，家庭可以直接持有私人债权 $S_{ht}$ 和政府债券 $B_{ht}$，但围绕无成本持有量 $\bar S_h$ 和 $\bar B_h$ 有二次交易成本：

$$
\begin{aligned}
C_t+D_{ht} &+ Q_t\left[S_{ht}+\frac{1}{2}\kappa(S_{ht}-\bar S_h)^2\right]
+q_t\left[B_{ht}+\frac{1}{2}\kappa(B_{ht}-\bar B_h)^2\right] \\
&=W_tL_t+\Pi_t+T_t+R_tD_{h,t-1}+R_{kt}S_{h,t-1}+R_{bt}B_{h,t-1}.
\end{aligned}
$$

### 2.5 资本品生产商

资本品生产商在流量投资调整成本下选择投资：

$$
\max_{\{I_\tau\}} E_t\sum_{\tau=t}^{\infty}\Lambda_{t,\tau}
\left\{
Q_\tau I_\tau-\left[1+f\left(\frac{I_\tau}{I_{\tau-1}}\right)\right]I_\tau
\right\}.
$$

## 3. First-Order Conditions

- **(F1) 家庭劳动供给**：
$$
u_{C_t}W_t=\chi L_t^\varphi.
$$

- **(F2) 家庭 Euler 方程**：
$$
E_t\Lambda_{t,t+1}R_{t+1}=1,
\qquad
\Lambda_{t,t+1}\equiv\beta\frac{u_{C_{t+1}}}{u_{C_t}}.
$$

- **(F3) 私人资本债权回报**：
$$
R_{k,t+1}=\frac{Z_{t+1}+(1-\delta)Q_{t+1}}{Q_t}\xi_{t+1}.
$$

- **(F4) 长期政府债券回报**：
$$
R_{b,t+1}=\frac{1/P_t+q_{t+1}}{q_t}.
$$

- **(F5) 银行私人债权超额回报条件**：
$$
E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1})
=\frac{\lambda_t}{1+\lambda_t}\theta.
$$

- **(F6) 银行长期政府债券超额回报条件**：
$$
E_t\widetilde{\Lambda}_{t,t+1}(R_{b,t+1}-R_{t+1})
=\Delta\frac{\lambda_t}{1+\lambda_t}\theta.
$$

- **(F7) 扩展随机贴现因子**：
$$
\widetilde{\Lambda}_{t,t+1}=\Lambda_{t,t+1}\Omega_{t+1}.
$$

- **(F8) 总银行组合约束**：
$$
Q_tS_{pt}+\Delta q_tB_{pt}\leq \phi_tN_t.
$$

- **(F9) 最大调整杠杆率**：
$$
\phi_t=
\frac{E_t\widetilde{\Lambda}_{t,t+1}R_{t+1}}
{\theta-E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1})}.
$$

- **(F10) 银行净值边际价值**：
$$
\Omega_{t+1}=1-\sigma+\sigma\frac{\partial V_{t+1}}{\partial n_{t+1}}.
$$

- **(F11) 净值边际价值递归**：
$$
\frac{\partial V_t}{\partial n_t}
=E_t\widetilde{\Lambda}_{t,t+1}
\left[
(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}
\right].
$$

- **(F12) 总银行净值积累**：
$$
N_t=\sigma\left[
(R_{kt}-R_t)\frac{Q_{t-1}S_{p,t-1}}{N_{t-1}}
+(R_{bt}-R_t)\frac{q_{t-1}B_{p,t-1}}{N_{t-1}}
+R_t
\right]N_{t-1}+X.
$$

- **(F13) 中央银行资产负债表**：
$$
Q_tS_{gt}+q_tB_{gt}=D_{gt}.
$$

- **(F14) 私人证券总供给恒等式**：
$$
S_t=S_{pt}+S_{gt}.
$$

- **(F15) 长期政府债券总供给恒等式**：
$$
B_t=B_{pt}+B_{gt}.
$$

- **(F16) 银行资产负债表受约束时的私人证券总价值**：
$$
Q_tS_t\leq \phi_tN_t+Q_tS_{gt}+\Delta(q_tB_{gt}-q_tB_t).
$$

- **(F17) 跨资产超额回报关系**：
$$
E_t\widetilde{\Lambda}_{t,t+1}(R_{b,t+1}-R_{t+1})
=\Delta E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1}).
$$

- **(F18) 家庭直接持有私人证券需求**：
$$
S_{ht}=\bar S_h+
\frac{E_t\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})}{\kappa}.
$$

- **(F19) 家庭直接持有长期债券需求**：
$$
B_{ht}=\bar B_h+
\frac{E_t\Lambda_{t,t+1}(R_{b,t+1}-R_{t+1})}{\kappa}.
$$

- **(F20) 含家庭持有的私人证券市场出清**：
$$
S_t=S_{pt}+S_{ht}+S_{gt}.
$$

- **(F21) 含家庭持有的政府债券市场出清**：
$$
B_t=B_{pt}+B_{ht}+B_{gt}.
$$

- **(F22) 含家庭持有时的银行组合约束**：
$$
Q_t(S_t-S_{ht})\leq
\phi_tN_t+Q_tS_{gt}+\Delta q_t\left[B_{gt}-(B_t-B_{ht})\right].
$$

- **(F23) 中间品生产函数**：
$$
Y_t=A_tK_t^\alpha L_t^{1-\alpha}.
$$

- **(F24) 劳动需求 / 实际工资**：
$$
W_t=P_{mt}(1-\alpha)\frac{Y_t}{L_t}.
$$

- **(F25) 单位资本毛利润流**：
$$
Z_t=P_{mt}\alpha\frac{Y_t}{K_t}.
$$

- **(F26) 含资本质量冲击的资本积累**：
$$
K_{t+1}=\xi_{t+1}\left[I_t+(1-\delta)K_t\right].
$$

- **(F27) 资本品定价条件**：
$$
Q_t=1+f\left(\frac{I_t}{I_{t-1}}\right)
+\frac{I_t}{I_{t-1}}f'\left(\frac{I_t}{I_{t-1}}\right)
-E_t\Lambda_{t,t+1}\left(\frac{I_{t+1}}{I_t}\right)^2
f'\left(\frac{I_{t+1}}{I_t}\right).
$$

- **(F28) 最终品 CES 加总**：
$$
Y_t=\left[\int_0^1Y_{ft}^{\frac{\varepsilon-1}{\varepsilon}}df\right]^{\frac{\varepsilon}{\varepsilon-1}}.
$$

- **(F29) Calvo 重定价条件**：
$$
\sum_{i=0}^{\infty}\gamma^i\Lambda_{t,t+i}
\left[
\frac{P_t^*}{P_{t+i}}-\mu P_{m,t+i}
\right]Y_{f,t+i}=0,
\qquad
\mu=\frac{1}{1-1/\varepsilon}.
$$

- **(F30) 价格指数演化**：
$$
P_t=\left[(1-\gamma)(P_t^*)^{1-\varepsilon}
+\gamma(P_{t-1})^{1-\varepsilon}\right]^{\frac{1}{1-\varepsilon}}.
$$

- **(F31) 政府预算约束**：
$$
\begin{aligned}
G+(R_{bt}-1)\bar B
&=T_t+(R_{kt}-R_t-\tau_s)Q_{t-1}S_{g,t-1}\\
&\quad +(R_{bt}-R_t-\tau_b)q_{t-1}B_{g,t-1}.
\end{aligned}
$$

- **(F32) Taylor 规则**：
$$
i_t=i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^*)+\epsilon_t.
$$

- **(F33) Fisher 关系**：
$$
1+i_t=R_{t+1}\frac{P_{t+1}}{P_t}.
$$

- **(F34) 私人证券 LSAP 规则**：
$$
S_{gt}=\varphi_{st}S_t.
$$

- **(F35) 政府债券 LSAP 规则**：
$$
B_{gt}=\varphi_{bt}B_t.
$$

`needs_review`：MinerU Markdown 在债券购买方程附近把两个 LSAP 比例都打印成 `\varphi_{st}`。这里根据上下文和实现交叉检查，将私人证券写作 `\varphi_{st}`，债券写作 `\varphi_{bt}`。

## 4. Market Clearing & Identities

- **(F36) 资源约束**：
$$
Y_t=C_t+\left[1+f\left(\frac{I_t}{I_{t-1}}\right)\right]I_t+G+\Phi_t.
$$

- **(F37) 中央银行中介资源成本**：
$$
\Phi_t=\tau_sQ_{t-1}S_{g,t-1}+\tau_bq_{t-1}B_{g,t-1}.
$$

`needs_review`：OCR 来源在资源成本表达式中给出 `\tau_g`，但政府预算和正文使用债券中介成本。本文为一致性写作 $\tau_b$，并记录该差异。

- **(F38) 由已安装资本和新资本构成的私人证券供给**：
$$
S_t=I_t+(1-\delta)K_t.
$$

- **(F39) 固定政府债券供给**：
$$
B_t=\bar B.
$$

- **(F40) 劳动市场出清条件**：
$$
(1-\alpha)\frac{Y_t}{L_t}E_tu_{C_t}
=\frac{1}{P_{mt}}\chi L_t^\varphi.
$$

- **(F41) 短期债务市场出清**：
$$
D_{ht}+D_{gt}=D_t,
$$
在商品、劳动和长期证券市场出清后，精确分解由 Walras 定律决定，是冗余条件。

## 5. Exogenous Processes

- **(F42) 生产率冲击**：
$$
\log A_t=\rho_a\log A_{t-1}+\varepsilon^a_t.
$$

- **(F43) 资本质量冲击**：
$$
\log \xi_t=\rho_\xi\log \xi_{t-1}+\varepsilon^\xi_t.
$$

- **(F44) 政府消费冲击**：
$$
\log G_t=(1-\rho_g)\log \bar G+\rho_g\log G_{t-1}+\varepsilon^g_t.
$$

- **(F45) 私人证券购买过程**：
$$
\varphi_{st}=\rho_{s1}\varphi_{s,t-1}+\rho_{s2}\varphi_{s,t-2}+\varepsilon^s_t.
$$

- **(F46) 政府债券购买过程**：
$$
\varphi_{bt}=\rho_{b1}\varphi_{b,t-1}+\rho_{b2}\varphi_{b,t-2}+\varepsilon^b_t.
$$

- **(F47) 货币政策冲击**：
$$
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\varepsilon^i_t.
$$

实现交叉检查还包含外生银行净值冲击和 ZLB 指示变量冲击；这些是实现层便利变量，未作为主 Markdown 中单独陈述的结构性论文方程。

## 6. Steady-State Solution

论文校准季度稳态，并在其周围研究线性化动态。因此第一版稳态以来源支撑的求解顺序记录，而不是完整数值 `steady_state_model`。

1. 设定稳态外生状态：$\bar A=1$，$\bar \xi=1$，购买比例 $\bar\varphi_s=\bar\varphi_b=0$，所有创新为零。
2. 由家庭储蓄条件设定稳态实际无风险利率：$\bar R=1/\beta$。
3. 根据货币制度设定稳态通胀；在 MMB 交叉检查中，通胀是零对数偏离，名义总利率与 $\bar R$ 一致。
4. 从论文 Table 2 校准 $\alpha,\delta,\varepsilon,G/Y,h,\varphi,\eta_i,\gamma,\kappa_\pi,\kappa_y$。
5. 选择金融参数 $\sigma,\theta,\Delta,X,\bar K^h,\bar B^h,\kappa,\bar B$ 以匹配政府债券超额回报、私人证券超额回报和银行杠杆目标。
6. 用 (F23)-(F27) 求解 $\bar K,\bar L,\bar Y,\bar I,\bar Q,\bar Z$，其中 $\bar Q=1$ 且稳态调整成本为零。
7. 用 (F5)-(F12) 和组合约束求解银行净值、杠杆、超额回报，以及私人债权和政府债券持有。
8. 用 (F36)-(F40) 求解消费、政府支出、劳动、工资和 markup。
9. 用 (F28)-(F30) 施加零通胀 Calvo 稳态和目标稳态加成 $\mu$。

`needs_review`：论文报告了校准目标和 Table 2 参数值，但精确的 MMB 稳态构造只作为实现交叉检查，未做运行验证。

## 7. Timing & Form Conventions

- 论文推导是非线性的；MMB `NK_GK13_rep.mod` 是在对数稳态附近的线性化实现。
- 论文生产函数中的 $K_t$ 是第 $t$ 期用于生产的资本；(F26) 表明第 $t+1$ 期资本由第 $t$ 期投资和未折旧资本产生，并受资本质量冲击缩放。
- 银行净值 $N_t$ 是期末存量。(F12) 依赖上一期资产头寸产生的回报和上一期净值。
- 银行组合份额和中央银行购买份额是期末资产头寸。
- 长期政府债券建模为 perpetuity/consol。论文随后把其转化为十年等价收益率作为报告变量。
- 短期实际回报 $R_t$ 在家庭预算中从 $t-1$ 支付到 $t$；Euler 条件用 $R_{t+1}$ 表示。
- 中央银行资产负债表与财政转移合并处理。LSAPs 由短期政府负债或等价的付息准备金融资。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $C_t$ / `C` | 家庭消费 | (F1), (F36) |
| 内生 | $L_t$ / `L` | 劳动供给 | (F1), (F24), (F40) |
| 内生 | $D_{ht}$ / `D_h` | 家庭短期存款/债务 | household budget, (F41) |
| 内生 | $W_t$ / `W` | 实际工资 | (F1), (F24) |
| 内生 | $\Lambda_{t,t+1}$ / `Lambda` | 家庭随机贴现因子 | (F2), (F7) |
| 内生 | $R_t$ / `R` | 短期实际无风险回报 | (F2), (F33) |
| 内生 | $R_{kt}$ / `Rk` | 私人资本债权回报 | (F3), (F5) |
| 内生 | $R_{bt}$ / `Rb` | 长期政府债券回报 | (F4), (F6) |
| 内生 | $Q_t$ / `Q` | 资本/私人证券市场价值 | (F3), (F13), (F27) |
| 内生 | $q_t$ / `q`, `qn` | 长期政府债券价格 | (F4), (F13) |
| 内生 | $s_t,S_{pt}$ / `Kb` | 银行私人证券持有 | (F8), (F14), (F20) |
| 内生 | $b_t,B_{pt}$ / `Bb` | 银行长期政府债券持有 | (F8), (F15), (F21) |
| 内生 | $n_t,N_t$ / `N` | 银行家/银行部门净值 | (F12) |
| 内生 | $d_t$ / `Dep` | 银行存款 | bank balance sheet, (F41) |
| 内生 | $\lambda_t$ / `lambda` | 激励约束乘子 | (F5), (F6) |
| 内生 | $\Omega_t$ / `Omega` | 银行净值影子价值 | (F7), (F10) |
| 内生 | $\phi_t$ / `phi` | 最大调整杠杆率 | (F8), (F9) |
| 内生 | $S_{gt}$ / `psi` | 中央银行私人证券购买 | (F13), (F34) |
| 内生 | $B_{gt}$ / `Gamma` | 中央银行债券购买 | (F13), (F35) |
| 内生 | $S_{ht}$ / `Kh` | 家庭直接持有私人证券 | (F18), (F20) |
| 内生 | $B_{ht}$ / `Bh` | 家庭直接持有债券 | (F19), (F21) |
| 内生 | $Y_t,Y_{mt}$ / `Y`, `Ym` | 最终产出和中间品产出 | (F23), (F28), (F36) |
| 内生 | $K_t$ / `K` | 资本存量 | (F23), (F26) |
| 内生 | $I_t$ / `I` | 投资 | (F26), (F27), (F36) |
| 内生 | $Z_t$ / `Z` | 单位资本利润流 | (F25) |
| 内生 | $P_{mt}$ / `Pm` | 中间品相对价格 / markup 倒数 | (F24), (F25), (F29) |
| 内生 | $P_t^*$ / `inflstar` | Calvo 重定价/通胀对象 | (F29), (F30) |
| 内生 | $\pi_t,i_t$ / `infl`, `ir` | 通胀和名义利率 | (F32), (F33) |
| 外生 | $A_t$ / `a` | TFP | (F42) |
| 外生 | $\xi_t$ / `ksi` | 资本质量扰动 | (F43) |
| 外生 | $\varepsilon^a_t$ / `e_a` | TFP 创新 | (F42) |
| 外生 | $\varepsilon^\xi_t$ / `e_ksi` | 资本质量创新 | (F43) |
| 外生 | $\varepsilon^g_t$ / `e_g` | 政府支出创新 | (F44) |
| 外生 | $\varepsilon^s_t$ / `e_psi` | 私人证券购买创新 | (F45) |
| 外生 | $\varepsilon^b_t$ / `e_Gamma` | 政府债券购买创新 | (F46) |
| 外生 | $\varepsilon^i_t$ / `e_ir` | 货币政策创新 | (F47) |
| 参数 | $\beta$ / `betta` | 贴现因子 | (F2) |
| 参数 | $h$ / `hh` | 习惯参数 | household utility |
| 参数 | $\chi$ / `chi` | 劳动负效用权重 | (F1), (F40) |
| 参数 | $\varphi$ / `varphi` | Frisch 弹性倒数 | (F1), (F40) |
| 参数 | $\sigma$ / `theta` in paper survival notation | 银行家存活概率 | (F10), (F12) |
| 参数 | $\theta$ / `lambda` or calibrated diversion parameter | 可转移私人资产比例 | bank incentive constraint |
| 参数 | $\Delta$ / `Delta` | 政府债券较低转移/扣押权重 | (F6), (F8), (F17) |
| 参数 | $\alpha$ / `alfa` | 资本份额 | (F23)-(F25) |
| 参数 | $\delta$ / `delta` | 折旧率 | (F3), (F26) |
| 参数 | $\eta_i$ / `eta_i` | 投资对资本价格弹性的倒数 | adjustment cost |
| 参数 | $\gamma$ / `gam` | Calvo 不调价概率 | (F29), (F30) |
| 参数 | $\varepsilon$ / `epsilon` | 零售品替代弹性 | (F28)-(F30) |
| 参数 | $\kappa$ / `kappa_s`, `kappa_b` | 家庭组合调整成本 | (F18), (F19) |
| 参数 | $\kappa_\pi,\kappa_y$ / `kappa_pi`, `kappa_y` | Taylor 规则系数 | (F32) |
| 参数 | $\tau_s,\tau_b$ / `tau` | 中央银行中介成本 | (F31), (F37) |
| 参数 | $\rho_a,\rho_\xi,\rho_g$ | 冲击持续性 | (F42)-(F44) |
