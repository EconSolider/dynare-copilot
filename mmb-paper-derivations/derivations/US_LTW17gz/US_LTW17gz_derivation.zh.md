# US_LTW17gz -- 推导（最优化问题 + 均衡条件）

> 归档状态：`needs_review`。这是从论文侧 Markdown 抽取的第一版双语 MMB 归档条目。未执行运行时验证。

来源：Leeper、Traum 和 Walker (2017)，《Clearing Up the Fiscal Multiplier Morass》，American Economic Review 107(8), 2409-2454，DOI `10.1257/aer.20111196`。主要来源：`raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`。原始 PDF：`raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`。MinerU run id：`f1cc32b3-a1c8-4473-bab4-edca5aaeb37e`。

## 1. Model Overview

- 模型：估计的美国货币-财政 DSGE 模型，包含储蓄者、非储蓄者、长期名义政府债务、财政规则、稳态税收扭曲、价格黏性、工资黏性、习惯形成、投资调整成本、资本利用率，以及进入效用的政府消费。
- MMB 变体：`US_LTW17gz`。实现交叉检查将其描述为财政规则变体，其中 `gammgc=0` 且 `gammz=0.2`：政府消费不响应债务，而转移支付响应债务。
- 主体：最终品厂商、中间品厂商、劳动中介、储蓄型家庭、非储蓄型家庭、货币当局和财政当局。
- 形式：论文模型是非线性的，但用于数据估计时采用对数线性化形式。MMB 实现是线性化模型块，变量表示相对稳态的偏离；本第一版推导在实现能澄清覆盖范围时记录对数线性均衡条件。仅由 `.mod` 得到的条件标记为 `implementation_cross_check`。
- 主要不确定性：论文 Markdown 中若干展示公式存在 OCR 损坏，特别是工资加总/指数化和政府预算恒等式。这些项目标记为 `needs_review`。

## 2. Optimization Problems

### 最终品厂商

最终品厂商选择中间品投入 $Y_t(i)$，在带有时变价格加成 $\eta_t^p$ 的 Dixit-Stiglitz 加总器下生产 $Y_t$：

$$
Y_t \leq \left(\int_0^1 Y_t(i)^{1/(1+\eta_t^p)}\,di\right)^{1+\eta_t^p}.
$$

利润最大化推出中间品需求：

$$
Y_t(i)=Y_t\left(\frac{\bar P_t(i)}{\bar P_t}\right)^{-(1+\eta_t^p)/\eta_t^p}.
$$

### 中间品厂商

中间品厂商 $i$ 使用有效资本和劳动生产：

$$
\bar Y_t(i)=K_t(i)^\alpha \left(A_t L_t(i)\right)^{1-\alpha}-A_t\Omega.
$$

成本最小化给出共同名义边际成本。价格制定者面对 Calvo 重设价格机会：以概率 $1-\omega_p$ 重设价格；否则按滞后通胀和指数化参数 $\chi_p$ 调整。重设价格厂商最大化预期贴现名义利润：

$$
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t^{\ast}(i)Y_{t+s}(i)
-MC_{t+s}Y_{t+s}(i)
\right].
$$

### 劳动中介和工资制定者

竞争性劳动中介加总差异化劳动服务：

$$
L_t \leq \left(\int_0^1 L_t(l)^{1/(1+\eta_t^w)}\,dl\right)^{1+\eta_t^w}.
$$

其对劳动品种 $l$ 的需求为：

$$
L_t(l)=L_t^d\left(\frac{W_t(l)}{W_t}\right)^{-(1+\eta_t^w)/\eta_t^w}.
$$

储蓄型家庭以概率 $1-\omega_w$ 重设工资。未重设工资按滞后通胀和趋势增长指数化。Markdown 中的精确工资指数化表达式为 `needs_review`。

### 储蓄型家庭

储蓄型家庭 $j$ 从复合消费和劳动中获得效用：

$$
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\left(C_t^{\astS}(j)-\theta\tilde C_{t-1}^{\astS}\right)
-\frac{\left(L_t^S(j)\right)^{1+\xi}}{1+\xi}
\right],
$$

其中

$$
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
$$

储蓄者预算约束为：

$$
\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_t I_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k v_t(j)\bar K_{t-1}^S(j)\\
&\quad -\Psi(v_t)\bar K_{t-1}^S(j)+P_t Z_t^S(j)+D_t(j).
\end{aligned}
$$

有效资本和物理资本演化为：

$$
K_t^S(j)=v_t(j)\bar K_{t-1}^S(j),
$$

$$
\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)
+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j).
$$

### 非储蓄型家庭

非储蓄者消费当期可支配收入。其预算约束为：

$$
(1+\tau_t^C)P_t C_t^N(j)
=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_t Z_t^N(j).
$$

## 3. First-Order Conditions

以下条件是有来源支撑的第一版对数线性均衡映射。(F1)-(F18) 的结构来自论文；当精确对数线性系数形式来自 `US_LTW17gz_rep.mod` 时，它只是 `implementation_cross_check`，仍需用论文/附录方程复核，状态为 `needs_review`。

- **(F1) 生产函数**：
$$
\hat y_t=\frac{\bar Y+\Omega}{\bar Y}\alpha\hat k_t+\frac{\bar Y+\Omega}{\bar Y}(1-\alpha)\hat l_t.
$$

- **(F2) 要素价格关系**：
$$
\hat r_t^k-\hat w_t+\hat k_t-\hat l_t=0.
$$

- **(F3) 边际成本**：
$$
\hat{mc}_t-\alpha\hat r_t^k+(\alpha-1)\hat w_t=0.
$$

- **(F4) 新凯恩斯价格 Phillips 曲线**（`needs_review`, implementation_cross_check）：
$$
\lambda_p\hat\pi_t-\frac{\lambda_p\beta}{1+\beta\chi_p}E_t\hat\pi_{t+1}
-\hat{mc}_t-\lambda_p\hat u_t^p
=\frac{\lambda_p\chi_p}{1+\beta\chi_p}\hat\pi_{t-1}.
$$

- **(F5) 储蓄者财富边际效用**：
$$
\hat\lambda_t+\frac{\theta}{e^\gamma-\theta}\hat u_t^a
+\frac{e^\gamma}{e^\gamma-\theta}\hat c_t^{\ast}
-\hat u_t^b+\frac{\tau^C}{1+\tau^C}\hat\tau_t^C
=\frac{\theta}{e^\gamma-\theta}\hat c_{t-1}^{\ast}.
$$

- **(F6) 长期实际利率与长期债券价格关系**（`needs_review`, implementation_cross_check）：
$$
\hat r_t^L+\hat P_t^B-\frac{\beta\rho}{e^\gamma}E_t\hat r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}E_t\hat P_{t+1}^B+E_t\hat\pi_{t+1}=0.
$$

- **(F7) 长期通胀定义**（`needs_review`, implementation_cross_check）：
$$
\hat\pi_t^L+\hat P_t^B+\hat r_t^L=0.
$$

- **(F8) 复合消费**：
$$
\hat c_t^{\ast}-\frac{C^S}{C^S+\alpha_G G}\hat c_t^S
-\frac{\alpha_G G}{C^S+\alpha_G G}\hat g_t=0.
$$

- **(F9) 储蓄者 Euler 方程**：
$$
\hat\lambda_t-\hat R_t+E_t\hat\pi_{t+1}-E_t\hat\lambda_{t+1}
+\rho_a\hat u_t^a=0.
$$

- **(F10) 资本利用率**：
$$
\frac{1-\psi}{\psi}\hat r_t^k-\hat v_t
-\frac{1-\psi}{\psi}\frac{\tau^K}{1-\tau^K}\hat\tau_t^K=0.
$$

- **(F11) 资本 FOC**：
$$
\hat q_t+\hat R_t-E_t\hat\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)E_t\hat q_{t+1}
-\beta e^{-\gamma}R^k(1-\tau^K)E_t\hat r_{t+1}^k
+\tau^K\beta e^{-\gamma}R^k E_t\hat\tau_{t+1}^K=0.
$$

- **(F12) 投资 FOC**：
$$
-\frac{1}{(1+\beta)s e^{2\gamma}}\hat q_t+\hat i_t
-\frac{\beta}{1+\beta}E_t\hat i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}\hat u_t^a-\hat u_t^i
=\frac{1}{1+\beta}\hat i_{t-1}.
$$

- **(F13) 有效资本**：
$$
\hat k_t-\hat v_t+\hat u_t^a=\hat{\bar K}_{t-1}.
$$

- **(F14) 物理资本运动方程**：
$$
\hat{\bar K}_t-\left(1-(1-\delta)e^{-\gamma}\right)(1+\beta)s e^{2\gamma}\hat u_t^i
-\left(1-(1-\delta)e^{-\gamma}\right)\hat i_t
+(1-\delta)e^{-\gamma}\hat u_t^a
=(1-\delta)e^{-\gamma}\hat{\bar K}_{t-1}.
$$

- **(F15) 工资 Phillips 曲线**（`needs_review`, implementation_cross_check）：
$$
\begin{aligned}
(1+\lambda_w)\hat w_t&-\lambda_w\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\hat\pi_t
-\lambda_w\frac{\beta}{1+\beta}E_t\hat\pi_{t+1}\\
&-\xi\hat l_t+\hat\lambda_t
+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}\hat u_t^a
-\frac{\tau^L}{1-\tau^L}\hat\tau_t^L
-\lambda_w\hat u_t^w-\hat u_t^b\\
&=\frac{\lambda_w}{1+\beta}\hat w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\hat\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\hat u_{t-1}^a.
\end{aligned}
$$

- **(F16) 货币政策规则**：
$$
\hat R_t=(1-\rho_r)\phi_\pi\hat\pi_t+(1-\rho_r)\phi_y\hat y_t+\rho_r\hat R_{t-1}+\hat u_t^m.
$$

- **(F17) 非储蓄者预算条件**：
$$
C^N(1+\tau^C)\hat c_t^N+\tau^C C^N\hat\tau_t^C
-W L(1-\tau^L)\hat w_t-WL(1-\tau^L)\hat l_t
+WL\tau^L\hat\tau_t^L-Z\hat z_t=0.
$$

- **(F18) 消费加总**：
$$
C\hat c_t-(1-\mu)C^S\hat c_t^S-\mu C^N\hat c_t^N=0.
$$

## 4. Market Clearing & Identities

- **(F19) 商品市场出清**：
$$
C\hat c_t+I\hat i_t-Y\hat y_t+G\hat g_t+\Psi'(1)K\hat v_t=0.
$$

- **(F20) 长期债券定价 / 到期结构**：
$$
\hat R_t-\frac{\rho P^B}{1+\rho P^B}E_t\hat P_{t+1}^B+\hat P_t^B=0.
$$

- **(F21) 政府预算约束**（`needs_review`，论文 OCR 损坏；implementation_cross_check）：
$$
\begin{aligned}
s^b\hat b_t&-\frac{G}{Y}\hat g_t-\frac{Z}{Y}\hat z_t
+\tau^K r^k\frac{K}{Y}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
+\frac{s^b}{\beta}\hat u_t^a\\
&+\tau^L w\frac{L}{Y}(\hat\tau_t^L+\hat w_t+\hat l_t)
+\tau^C\frac{C}{Y}(\hat c_t+\hat\tau_t^C)
-s^b\rho e^{-\gamma}\hat P_t^B+\frac{s^b}{\beta}\hat\pi_t\\
&=\frac{s^b}{\beta}\hat b_{t-1}-\frac{s^b}{\beta}\hat P_{t-1}^B.
\end{aligned}
$$

- **(F22) 债务产出比定义**：
$$
\hat s_t^b+\hat y_t-\hat b_t=0.
$$

- **(F23) 消费税收入恒等式**：
$$
\hat T_t^C-\hat\tau_t^C-\hat c_t=0.
$$

- **(F24) 资本税收入恒等式**：
$$
\hat T_t^K-\hat\tau_t^K-\hat r_t^k-\hat k_t=0.
$$

- **(F25) 事后债券回报恒等式**（`needs_review`, implementation_cross_check）：
$$
\hat r_t^b-\frac{\rho\beta}{e^\gamma}\hat P_t^B+\hat\pi_t=-\hat P_{t-1}^B.
$$

- **(F26) 初级盈余恒等式**：
$$
\hat S_t-\frac{\tau^K r^k K}{S}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
-\frac{\tau^L w L}{S}(\hat\tau_t^L+\hat w_t+\hat l_t)
-\frac{\tau^C C}{S}(\hat\tau_t^C+\hat c_t)
+\frac{Z}{S}\hat z_t+\frac{G}{S}\hat g_t=0.
$$

- **(F27) 劳动税收入恒等式**：
$$
\hat T_t^L-\hat\tau_t^L-\hat w_t-\hat l_t=0.
$$

- **(F28) Fisher 方程**：
$$
\hat r_t-\hat R_t+E_t\hat\pi_{t+1}=0.
$$

## 5. Exogenous Processes

- **(F29) 政府消费规则，`US_LTW17gz` 变体**：
$$
\hat g_t-\hat u_t^G=\rho_G\hat g_{t-1}-(1-\rho_G)\gamma_G\hat s_{t-1}^b,\qquad \gamma_G=0\ \text{in }US\_LTW17gz.
$$

- **(F30) 资本税规则**：
$$
\hat\tau_t^K=(1-\rho_K)\gamma_K\hat s_{t-1}^b+\rho_K\hat\tau_{t-1}^K.
$$

- **(F31) 劳动税规则**：
$$
\hat\tau_t^L=(1-\rho_L)\gamma_L\hat s_{t-1}^b+\rho_L\hat\tau_{t-1}^L.
$$

- **(F32) 消费税规则**：
$$
\hat\tau_t^C=\rho_C\hat\tau_{t-1}^C.
$$

- **(F33) 转移支付规则，`US_LTW17gz` 变体**：
$$
\hat z_t-\hat u_t^Z=-(1-\rho_Z)\gamma_Z\hat s_{t-1}^b+\rho_Z\hat z_{t-1},\qquad \gamma_Z=0.2\ \text{in }US\_LTW17gz.
$$

- **(F34) 财政与结构冲击过程**：
$$
\hat u_t^s=\rho_{es}\hat u_{t-1}^s+\epsilon_t^s,\qquad s\in\{Z,a,b,m,i,w,p\}.
$$

论文还给出政府消费冲击 $u_t^G=\rho_{eG}u_{t-1}^G+\epsilon_t^G$。已检查的 `US_LTW17gz_rep.mod` 将 `ugc` 声明为内生变量，但把政府消费创新注释掉；该不一致为 `needs_review`。

## 6. Steady-State Solution

论文将稳态财政变量校准到美国数据：$G/Y=0.11$、$B/Y=1.47$、$\tau^L=0.186$、$\tau^K=0.218$、$\tau^C=0.023$。贴现因子为 $\beta=0.99$，折旧率为 $\delta=0.025$，资本份额为 $\alpha=0.33$，稳态通胀为 $\pi=1$，价格和工资加成用 $\eta_p=\eta_w=0.14$ 校准。

在线性化实现中，所有带帽内生变量的稳态为零。用于缩放线性方程的水平稳态按以下顺序求解（`implementation_cross_check`）：

1. 设定 $\pi=1$、$e^\gamma=\exp(\gamma)$、$R=e^\gamma/\beta$，并用平均债务久期隐含的到期参数计算长期债券价格 $P^B=(R-\rho)^{-1}$。
2. 计算税后资本租金回报 $R^k=(e^\gamma/\beta-1+\delta)/(1-\tau^K)$ 和边际成本 $mc=1/(1+\eta_p)$。
3. 由生产、零利润和资本积累限制反推出工资、资本劳动比、每单位劳动固定成本、每单位劳动产出、每单位劳动投资和每单位劳动消费。
4. 用稳态政府预算计算转移支付，然后计算非储蓄者和储蓄者的每单位劳动消费。
5. 计算复合消费 $C^{\ast}=C^S+\alpha_G G$，并由储蓄者劳动条件求解劳动。
6. 用稳态劳动缩放 $C^S,C^N,Y,K,I,Z,B,G$ 和税收收入。

稳态公式在与论文在线附录或复制文档核对前仍为 `needs_review`。

## 7. Timing & Form Conventions

- 带帽变量表示相对稳态的百分比或对数偏离；观测变量是这些变换变量的差分或水平。
- $K_t$ 是生产中使用的有效资本；$\bar K_t$ 是物理资本。第 $t$ 期生产通过利用率 $v_t$ 使用 $\bar K_{t-1}$。
- 政府债务是长期名义债券组合。第 $t$ 期发行的债券以 $P_t^B$ 出售，存续票息以比例 $\rho$ 衰减。
- MMB 实现包含以 `f` 结尾的平行灵活价格经济变量；这是反事实模块，不是另一篇论文模型。
- `US_LTW17gz` 通过设定政府消费对债务响应为零、转移支付对债务响应为 `0.2` 来固定财政规则变体。
- 未执行 Dynare、残差检查、Blanchard-Kahn 检查、估计或 IRF 验证。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `cs`, $C^S$ | 储蓄者消费 | (F5), (F8), (F9), (F18) |
| 内生 | `cn`, $C^N$ | 非储蓄者消费 | (F17), (F18) |
| 内生 | `c`, $C$ | 总消费 | (F18), (F19) |
| 内生 | `cstar`, $C^{\ast}$ | 效用中的消费 | (F8) |
| 内生 | `R`, $R^n$ | 名义政策利率 | (F16), (F28) |
| 内生 | `r`, $r$ | 实际利率 | (F28) |
| 内生 | `i`, $I$ | 投资 | (F12), (F14), (F19) |
| 内生 | `k`, $K$ | 有效资本 | (F1), (F13) |
| 内生 | `kbar`, $\bar K$ | 物理资本 | (F13), (F14) |
| 内生 | `v`, $v$ | 利用率 | (F10), (F13), (F19) |
| 内生 | `l`, $L$ | 劳动 | (F1), (F15), (F17), (F27) |
| 内生 | `y`, $Y$ | 产出 | (F1), (F19), (F22) |
| 内生 | `gc`, $G$ | 政府消费 | (F19), (F29) |
| 内生 | `q`, $q$ | Tobin's Q | (F11), (F12) |
| 内生 | `rk`, $R^k$ | 资本回报 | (F2), (F3), (F10), (F11) |
| 内生 | `w`, $W$ | 实际工资 | (F2), (F3), (F15), (F17) |
| 内生 | `pi`, $\pi$ | 通胀 | (F4), (F16), (F21), (F28) |
| 内生 | `b`, $B$ | 政府债务 | (F21), (F22) |
| 内生 | `sb`, $s^b$ | 债务产出比 | (F22), 财政规则 |
| 内生 | `tauk`, $\tau^K$ | 资本税率 | (F11), (F21), (F30) |
| 内生 | `taul`, $\tau^L$ | 劳动税率 | (F15), (F17), (F31) |
| 内生 | `tauc`, $\tau^C$ | 消费税率 | (F5), (F17), (F32) |
| 内生 | `z`, $Z$ | 转移支付 | (F17), (F21), (F33) |
| 内生 | `mc` | 边际成本 | (F3), (F4) |
| 内生 | `lambda` | 储蓄者财富边际效用 | (F5), (F9), (F15) |
| 内生 | `Pb` | 长期债券价格 | (F6), (F7), (F20), (F21), (F25) |
| 内生 | `piL`, `rL` | 长期通胀/利率变量 | (F6), (F7) |
| 内生 | `S`, `Tk`, `Tl`, `Tc`, `rb` | 财政会计变量 | (F23)-(F27) |
| 内生 | `ugc`, `uz`, `ua`, `ub`, `um`, `ui`, `uw`, `up` | 冲击状态 | (F29), (F33), (F34) |
| 外生 | `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | 转移、技术/增长、偏好、货币、投资、工资加成、价格加成冲击创新 | (F34) |
| 参数 | `bet`, $\beta$ | 贴现因子 | 稳态，FOC |
| 参数 | `alph`, $\alpha$ | 资本份额 | (F1), (F3) |
| 参数 | `delt`, $\delta$ | 折旧率 | (F11), (F14) |
| 参数 | `etap`, `etaw` | 价格和工资加成参数 | (F4), (F15) |
| 参数 | `omegap`, `omegaw` | Calvo 不重设概率 | (F4), (F15) |
| 参数 | `chip`, `chiw` | 价格和工资指数化 | (F4), (F15) |
| 参数 | `thet`, $\theta$ | 习惯 | (F5) |
| 参数 | `alphag`, $\alpha_G$ | 公共/私人消费替代性 | (F8) |
| 参数 | `gammgc`, `gammz` | 政府消费和转移支付的债务响应 | (F29), (F33) |
| 参数 | `gammtk`, `gammtl` | 资本税和劳动税的债务响应 | (F30), (F31) |
| 参数 | `rho*` | 自回归参数 | (F29)-(F34) |
