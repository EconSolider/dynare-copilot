# NK_AFL15 - Monetary policy and risk taking 推导

> 面向 Dynare 复核的第一轮归档抽取。状态：`needs_review`。

来源：Angeloni, Ignazio; Faia, Ester; Lo Duca, Marco (2015), "Monetary policy and risk taking," Journal of Economic Dynamics & Control 52, 285-307, DOI `10.1016/j.jedc.2014.12.001`。

## 1. Model Overview

- **模型**：带内生银行融资风险和基本面银行挤兑的新凯恩斯模型。
- **MMB ID**：`NK_AFL15`。
- **主体**：代表性家庭、银行经理/银行资本家/存款人、中间品厂商、资本品生产者、最终品聚合部门、政府和货币当局。
- **机制**：银行用需求存款和银行资本为资本项目融资。存款融资是短期且易受挤兑影响的；银行经理选择存款比例。低政策利率降低存款融资成本，提高杠杆，并提高内生银行挤兑概率。
- **形式**：非线性均衡模型。论文在 IRF 中报告一阶近似，在波动率和长期风险实验中报告二阶近似。MMB 实现交叉检查使用围绕稳态求解的非线性 Dynare `model` 块。
- **运行验证**：本归档条目未执行。

## 2. Optimization Problems

### 2.1 家庭

代表性家庭消费、供给劳动，并以有风险需求存款储蓄。来源给出的效用为

$$
E_0 \sum_{t=0}^{\infty}\beta^t U(C_t,N_t).
$$

预算约束为

$$
P_t C_t + T_t + D_t
\leq W_t N_t + \Theta_t + \Xi_t
+ R_{t-1}(1-\phi_{t-1}g_{t-1})D_{t-1}.
$$

校准中论文使用

$$
U(C_t,N_t)=\frac{C_t^{1-\sigma}-1}{1-\sigma}+\nu\log(1-N_t),
$$

其中劳动负效用的精确 OCR 符号/归一化标为 `needs_review`，因为 Markdown 文本有噪声，但隐含边际效用与实现交叉检查一致。

### 2.2 银行经理

银行经理选择存款比例

$$
d_t=\frac{D_t}{L_t}
$$

以最大化外部融资者的期望收益。总资金满足

$$
L_t=Q_t K_{t+1}=D_t+K_t^B.
$$

项目收益为 $R_t^A+x_t$，其中 $x_t$ 在 $[-h,h]$ 上均匀分布。当项目实现值过低、无法支付承诺存款收益时发生挤兑。来源将期望收益目标写成挤兑和非挤兑区域上的分段积分；下文使用其闭式最优解。

### 2.3 中间品厂商

中间品生产者选择劳动、资本和价格路径以最大化贴现名义利润：

$$
E_0\sum_{t=0}^{\infty}\Lambda_{0,t}
\left[
P_t(i)Y_t(i)-W_tN_t(i)-Z_tK_t(i)
-\frac{\vartheta}{2}\left(\frac{P_t(i)}{P_{t-1}(i)}-\pi\right)^2P_t
\right],
$$

约束为

$$
Y_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\varepsilon}Y_t,
\qquad
Y_t(i)=A_tF(N_t(i),K_t(i)).
$$

### 2.4 资本品生产者

资本品生产者把最终品转化为已安装资本，并选择投资以最大化

$$
Q_t\chi\left(\frac{I_t}{K_t}\right)K_t-P_tI_t,
$$

资本积累为

$$
K_{t+1}=(1-\delta)K_t+\chi\left(\frac{I_t}{K_t}\right)K_t.
$$

定量设定使用投资-资本比率中的二次调整成本。

## 3. First-Order Conditions

- **(F1) 家庭劳动供给**：

$$
\frac{W_t}{P_t}=-\frac{U_{n,t}}{U_{c,t}}.
$$

- **(F2) 家庭需求存款欧拉方程**：

$$
U_{c,t}=\beta E_t\left[
\frac{R_t}{\pi_{t+1}}(1-\phi_t g_t)U_{c,t+1}
\right].
$$

- **(F3) 银行资产负债表恒等式**：

$$
L_t=Q_tK_{t+1}=D_t+K_t^B.
$$

- **(F4) 最优存款比例**：

$$
d_t=z\frac{R_t^A+h}{R_t},
\qquad
z=\frac{1}{2-\lambda+c(1+\lambda)}.
$$

- **(F5) 融资结构隐含的银行资本**：

$$
K_t^B=\left(1-z\frac{R_t^A+h}{R_t}\right)Q_tK_{t+1}.
$$

- **(F6) 银行挤兑概率**：

$$
\phi_t=\frac{1}{2h}\int_{-h}^{R_td_t-R_t^A}dx_t
=\frac{1}{2}\left(1-\frac{R_t^A-R_td_t}{h}\right).
$$

- **(F7) 代入最优存款比例后的简化挤兑概率**：

$$
\phi_t=\frac{1}{2}\left(1-\frac{R_t^A(1-z)-zh}{h}\right).
$$

- **(F8) 非挤兑状态中的银行资本期望收益**：

$$
R_t^{BK}
=\frac{1}{2h}\int_{R_td_t-R_t^A}^{h}
\frac{(R_t^A+x_t)-R_td_t}{2}\,dx_t
=\frac{(R_t^A+h-R_td_t)^2}{8h}.
$$

- **(F9) 银行资本积累**：

$$
K_t^B=\frac{\theta}{\pi_t}
\left[
K_{t-1}^B+\frac{(R_t^A+h-R_td_t)^2}{8h}L_t
\right].
$$

- **(F10) 厂商要素需求**：

$$
\frac{W_t}{P_t}=mc_tA_tF_{n,t},
\qquad
\frac{Z_t}{P_t}=mc_tA_tF_{k,t}.
$$

- **(F11) 带二次价格调整成本的非线性菲利普斯曲线**：

$$
U_{c,t}(\pi_t-1)\pi_t
=\beta E_t\left[
U_{c,t+1}(\pi_{t+1}-1)\pi_{t+1}
\right]
+U_{c,t}A_tF_t(\bullet)\frac{\varepsilon}{\vartheta}
\left(mc_t-\frac{\varepsilon-1}{\varepsilon}\right).
$$

- **(F12) 结合家庭和厂商条件的劳动市场均衡**：

$$
-\frac{U_{n,t}}{U_{c,t}}=mc_tA_tF_{n,t}.
$$

- **(F13) 资本积累**：

$$
K_{t+1}=(1-\delta)K_t+\chi\left(\frac{I_t}{K_t}\right)K_t.
$$

- **(F14) Tobin's Q / 已安装资本价格条件**：

$$
Q_t\chi'\left(\frac{I_t}{K_t}\right)=P_t.
$$

- **(F15) 资本名义收益**：

$$
Y_t^k
=Z_t+Q_t\left[
(1-\delta)-\chi'\left(\frac{I_t}{K_t}\right)\frac{I_t}{K_t}
+\chi\left(\frac{I_t}{K_t}\right)
\right].
$$

- **(F16) 银行融资资本的实际收益**：

$$
\frac{R_{t+1}^A}{\pi_{t+1}}
=\frac{
mc_{t+1}A_{t+1}F_{k,t+1}
+Q_{t+1}\left[
(1-\delta)-\chi'\left(\frac{I_{t+1}}{K_{t+1}}\right)\frac{I_{t+1}}{K_{t+1}}
+\chi\left(\frac{I_{t+1}}{K_{t+1}}\right)
\right]
}{Q_t}.
$$

`needs_review`：OCR 文本在 Eq. (26) 中将一个项打印为 `\phi(\cdot)` 而非 `\chi(\cdot)`；周围资本品生产者记号和实现交叉检查表明它是调整成本技术。

## 4. Market Clearing & Identities

- **(F17) 生产技术**：

$$
Y_t=A_tF(N_t,K_t).
$$

定量设定为：

$$
F(N_t,K_t)=K_t^{\alpha}N_t^{1-\alpha}.
$$

- **(F18) 政府预算**：

$$
T_t=G_t.
$$

- **(F19) 含挤兑成本和价格调整成本的最终品资源约束**：

$$
Y_t-\Omega_t=C_t+I_t+G_t+\frac{\vartheta}{2}(\pi_t-1)^2.
$$

- **(F20) 银行挤兑的期望资源成本**：

$$
\Omega_t
=\frac{1}{2h}\int_{-h}^{R_td_t-R_t^A}
cR_t^AQ_tK_{t+1}\,dx_t.
$$

- **(F21) 货币政策规则**：

$$
\ln\left(\frac{1+R_t}{1+R}\right)
=\phi_{\pi}\ln\left(\frac{\pi_t}{\pi}\right)
+\phi_y\ln\left(\frac{Y_t}{Y}\right)+m_t.
$$

MMB 实现交叉检查使用带可选利率平滑和 Tobin's Q 反应的总名义利率规则；这些特征未在论文显示的 Eq. (27) 中明确给出，因此记为仅来自实现的细节。

## 5. Exogenous Processes

- **(F22) 生产率过程**：

$$
A_t=A_{t-1}^{\rho_a}\exp(\varepsilon_t^a),
\qquad \bar A=1.
$$

- **(F23) 政府支出过程**：

$$
\ln\left(\frac{G_t}{G}\right)
=\rho_g\ln\left(\frac{G_{t-1}}{G}\right)+\varepsilon_t^g,
\qquad \frac{G}{Y}=0.2.
$$

- **(F24) 货币政策冲击过程**：

$$
m_t=\rho_m m_{t-1}+\varepsilon_t^m.
$$

校准文字说明货币政策冲击具有中等持续性，系数为 0.2。实现交叉检查使用 `rsh=0.2*rsh(-1)+ur`。

## 6. Steady-State Solution

来源说明模型围绕由项目异质收益长期分布刻画的随机稳态近似。下面的第一轮确定性稳态映射足以供后续实现复核，但仍为 `needs_review`。

1. 归一化 $\bar A=1$，设 $\bar\pi=\pi$，并令冲击为零。
2. 由家庭欧拉方程：

$$
1=\beta\frac{\bar R}{\bar\pi}(1-\bar\phi\bar g),
$$

其中稳态存款收益是否包含有风险存款损失楔子、或是否被实现吸收到 `rd` 中，标为 `needs_review`。

3. 期望加成给出

$$
\bar{mc}=\frac{\varepsilon-1}{\varepsilon}.
$$

4. 对 Cobb-Douglas 生产函数，计算边际产出：

$$
\bar F_k=\alpha\frac{\bar Y}{\bar K},
\qquad
\bar F_n=(1-\alpha)\frac{\bar Y}{\bar N}.
$$

5. 资本租金定价：

$$
\bar Z/P=\bar{mc}\,\bar A\,\bar F_k,
\qquad
\bar W/P=\bar{mc}\,\bar A\,\bar F_n.
$$

6. 在二次调整成本下，$\bar I/\bar K=\delta$，$\bar Q=1$，收益方程由边际产出加未折旧资本价值确定 $\bar R^A$。
7. 银行融资和风险：

$$
\bar d=z\frac{\bar R^A+h}{\bar R},\qquad
\bar K^B=(1-\bar d)\bar Q\bar K,\qquad
\bar\phi=\frac{1}{2}\left(1-\frac{\bar R^A-\bar R\bar d}{h}\right).
$$

8. 银行资本供给：

$$
\bar K^B=\frac{\theta}{\bar\pi}
\left[
\bar K^B+\frac{(\bar R^A+h-\bar R\bar d)^2}{8h}\bar L
\right],
\qquad
\bar L=\bar Q\bar K.
$$

该式的精确时序标为 `needs_review`，因为论文显示的 Eq. (17) 与 MMB 实现在银行资本和贷款存量上的索引不同。

9. 设 $\bar G=0.2\bar Y$，并用资源约束求家庭消费：

$$
\bar C=\bar Y-\bar I-\bar G-\bar\Omega.
$$

10. 使用劳动供给条件选择 $\nu$ 或匹配校准目标 $\bar N\approx0.3$。

论文校准值包括 $\sigma=1$、$\beta=0.99$、$\alpha=0.3$、$\delta=0.025$、$\varepsilon=6$、$\lambda=0.45$、$\theta=0.97$、$c=0.1$、$\rho_a=0.95$、$\rho_g=0.9$、$\phi_{\pi}=1.5$、$\phi_y=0.5/4$ 和 $h=0.4$。MMB 文件使用 `BETTA=0.995`、`ALFA=1/3` 及其他相近但不完全相同的校准名称；该差异留待复核。

## 7. Timing & Form Conventions

- 论文的银行资产负债表和资本品生产者方程中，时期 $t$ 选择的资本写作 $K_{t+1}$；实现交叉检查中，生产资本写作 `k(-1)`，当前积累写作 `k`。
- 银行资本 $K_t^B$ 是由存活银行资本家的留存收益积累而来的状态变量。
- 需求存款承诺名义合约收益，该承诺在下一期项目收益和挤兑结果实现前确定。
- $t$ 到 $t+1$ 的资本实际收益为 $R_{t+1}^A/\pi_{t+1}$。
- 论文模型为非线性；不要把该推导视为 `model(linear)`。
- `needs_review`：来源 OCR 在若干公式中含有噪声符号，尤其是 Eq. (26)、资源成本积分和 Appendix A 中 $g_t$ 的定义。只有在周围记号足以明确修正时才做了规范化。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $C_t$ / `c` | 家庭消费 | (F2), (F19) |
| 内生 | $N_t$ / `n` | 劳动时间 | (F1), (F12), (F17) |
| 内生 | $D_t$ / `demand_deposits` | 需求存款 | (F3), (F4) |
| 内生 | $d_t$ / `deprat` | 存款比例 | (F4) |
| 内生 | $K_t^B$ / `bk` | 银行资本 | (F5), (F9) |
| 内生 | $L_t$ / `loans` | 银行贷款/资金 | (F3) |
| 内生 | $\phi_t$ / `br` | 银行挤兑概率/风险度 | (F6), (F7) |
| 内生 | $R_t^{BK}$ / `rbk` | 银行资本收益 | (F8) |
| 内生 | $Y_t$ / `y` | 产出 | (F17), (F19) |
| 内生 | $I_t$ / `inv` | 投资 | (F13), (F19) |
| 内生 | $K_t$ / `k` | 实物资本存量 | (F13), (F17) |
| 内生 | $Q_t$ / `q` | Tobin's Q / 资产价格 | (F14), (F16) |
| 内生 | $R_t^A$ / `ra` | 项目/银行资产收益 | (F16) |
| 内生 | $\pi_t$ / `pai` | 总通胀率 | (F11), (F21) |
| 内生 | $mc_t$ / `mc` | 实际边际成本 | (F10), (F11) |
| 内生 | $W_t/P_t$ / `w_real` | 实际工资 | (F1), (F10) |
| 内生 | $Z_t/P_t$ / `z` | 资本实际租金率 | (F10) |
| 内生 | $\Omega_t$ / `crun` | 银行挤兑资源成本 | (F20) |
| 内生 | $G_t$ / `g` | 政府消费 | (F23), (F19) |
| 内生 | $R_t$ / `rn` or `rd` | 政策/存款收益，来源与实现记号不同 | (F2), (F21) |
| 外生 | $\varepsilon_t^a$ / `ua` | 生产率创新 | (F22) |
| 外生 | $\varepsilon_t^g$ / `ug` | 政府支出创新 | (F23) |
| 外生 | $\varepsilon_t^m$ / `ur` | 货币政策创新 | (F24) |
| 参数 | $\beta$ / `BETTA` | 贴现因子 | (F2) |
| 参数 | $\sigma$ / `SIG` | 跨期替代弹性倒数 | 偏好 |
| 参数 | $\nu$ or `PHI` | 劳动效用权重 | (F1) |
| 参数 | $\alpha$ / `ALFA` | 资本份额 | (F17) |
| 参数 | $\delta$ / `DELTA` | 折旧率 | (F13) |
| 参数 | $\varepsilon$ / `EPSI` | 需求弹性 | (F11) |
| 参数 | $\vartheta$ / `OMP` | 价格调整成本 | (F11), (F19) |
| 参数 | $\lambda$ | 关系型贷款回收参数 | (F4) |
| 参数 | $c$ / `CR` | 挤兑清算成本 | (F4), (F20) |
| 参数 | $h$ / `HH` | 项目异质收益冲击半宽度 | (F4), (F6) |
| 参数 | $\theta$ / `THETA` | 银行生存率 | (F9) |
| 参数 | $\rho_a,\rho_g,\rho_m$ | 冲击持续性 | (F22)-(F24) |
| 参数 | $\phi_{\pi},\phi_y$ / `vP`, `vY` | Taylor 规则系数 | (F21) |

方程计数：(F1)-(F24)，共 24 个编号条件。
