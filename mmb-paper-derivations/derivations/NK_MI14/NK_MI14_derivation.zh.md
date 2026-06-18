# NK_MI14 -- 推导（最优化问题 + 一阶条件）

> 本私有归档推导概括有来源支撑的模型结构，供后续审阅和可能的 Dynare 工作使用。未执行运行时验证。
> 来源：Pascal Michaillat (2014), "A Theory of Countercyclical Government Multiplier," American Economic Journal: Macroeconomics, 6(1): 190-217, DOI `10.1257/mac.6.1.190`。

## 1. Model Overview

- **模型**：带公共就业的新凯恩斯搜索匹配模型，对应 MMB 模型 `NK_MI14`。
- **核心机制**：政府和私人企业从同一求职者池招聘。公共招聘提高劳动力市场紧张度并挤出私人招聘，但在高失业时期挤出较弱。
- **主体与模块**：大家庭、最终品厂商、垄断竞争中间品厂商、政府和货币当局。
- **政策实验**：技术冲击叠加公共就业招聘冲击。论文研究扩张和衰退中的公共就业乘数。
- **形式**：带 Rotemberg 价格调整成本的非线性动态模型。论文模拟非线性完全预见近似，而不是对数线性近似。MMB 实现使用带 `min`/`max` 保护项的非线性 Dynare `model` 块。
- **来源记录**：主 Markdown `raw/mmb_mineru/runs/nk_mi14__a_theory_of_countercyclical_government_multiplier__afea0443/full.md`；原始 PDF `raw/mmb_papers/A Theory of Countercyclical Government Multiplier.pdf`；MinerU run IDs `afea0443-0728-45fc-b048-6add939d19ec` 和 `ee399d61-9d94-4794-ba44-4a43691caddf`。

## 2. Optimization Problems

### 2.1 家庭

大家庭汇集劳动收入，消费最终品和公共品，并选择消费与一期名义债券：

\[
\max_{\{c_t,b_t\}} E_0 \sum_{t=0}^{\infty}\beta^t\left[\ln(c_t)+\chi\ln(z_t)\right]
\]

约束为

\[
p_t c_t+b_t=p_t n_t(1-\tau_t)w_t+R_{t-1}b_{t-1}+p_tT_t .
\]

家庭不选择工时；就业由搜索匹配流量决定。

### 2.2 最终品厂商

代表性最终品厂商合成差异化中间品：

\[
y_t=\left[\int_0^1 y_t(i)^{(\epsilon-1)/\epsilon}\,di\right]^{\epsilon/(\epsilon-1)}
\]

并选择 \(\{y_t(i)\}_{i\in[0,1]}\) 以最大化

\[
p_t\left[\int_0^1 y_t(i)^{(\epsilon-1)/\epsilon}\,di\right]^{\epsilon/(\epsilon-1)}
-\int_0^1 p_t(i)y_t(i)\,di .
\]

### 2.3 中间品厂商

中间品厂商 \(i\) 选择就业和名义价格：

\[
\max_{\{l_t(i),p_t(i)\}} E_0\sum_{t=0}^{\infty}\frac{\beta^t}{c_t}
\left\{
\frac{p_t(i)}{p_t}y_t(i)-w_tl_t(i)
-\frac{\phi}{2}\left(\frac{p_t(i)}{p_{t-1}(i)}-1\right)^2c_t
-\frac{r a_t}{q(\theta_t)}\left[l_t(i)-(1-s)l_{t-1}(i)\right]
\right\}
\]

约束为最终品需求和生产技术：

\[
y_t(i)=y_t\left(\frac{p_t(i)}{p_t}\right)^{-\epsilon},\qquad
y_t(i)=a_t l_t(i)^\alpha .
\]

招聘成本与技术成比例，并与职位填补率 \(q(\theta_t)\) 负相关。

### 2.4 政府与货币当局

政府雇用 \(g_t\) 名工人，支付工资和招聘成本，并通过劳动税和债务融资。其预算约束在第 4 节作为均衡条件记录。货币政策通过带利率平滑的 Taylor 规则设定名义总利率。

## 3. First-Order Conditions

**(F1) 家庭 Euler 方程**：

\[
1=\beta E_t\left[\frac{R_t}{1+\pi_{t+1}}\frac{c_t}{c_{t+1}}\right].
\]

**(F2) 每种中间品的最终需求**：

\[
y_t(i)=y_t\left(\frac{p_t(i)}{p_t}\right)^{-\epsilon}.
\]

**(F3) 最终品价格指数**：

\[
p_t=\left[\int_0^1 p_t(i)^{1-\epsilon}\,di\right]^{1/(1-\epsilon)}.
\]

**(F4) 中间品生产技术**：

\[
y_t(i)=a_t l_t(i)^\alpha .
\]

**(F5) 中间品厂商劳动需求 / 招聘成本 FOC**：

\[
\Lambda_t(i)\alpha l_t(i)^{\alpha-1}
=\frac{w_t}{a_t}+\frac{r}{q(\theta_t)}
-\beta(1-s)E_t\left[\frac{c_t}{c_{t+1}}\frac{a_{t+1}}{a_t}\frac{r}{q(\theta_{t+1})}\right].
\]

**(F6) 中间品厂商定价 FOC**：

\[
\frac{p_t(i)}{p_t}
=\frac{\epsilon}{\epsilon-1}\Lambda_t(i)
+\frac{\phi}{\epsilon-1}\frac{c_t}{y_t}
\left(\frac{p_t(i)}{p_t}\right)^\epsilon
\left[
\beta E_t\left[\left(\frac{p_{t+1}(i)}{p_t(i)}-1\right)\frac{p_{t+1}(i)}{p_t(i)}\right]
-\left(\frac{p_t(i)}{p_{t-1}(i)}-1\right)\frac{p_t(i)}{p_{t-1}(i)}
\right].
\]

**(F7) 对称均衡劳动需求**：

\[
\Lambda_t\alpha l_t^{\alpha-1}
=\frac{w_t}{a_t}+\frac{r}{q(\theta_t)}
-\beta(1-s)E_t\left[\frac{c_t}{c_{t+1}}\frac{a_{t+1}}{a_t}\frac{r}{q(\theta_{t+1})}\right].
\]

**(F8) 对称 Rotemberg Phillips 曲线**：

\[
\pi_t(1+\pi_t)=\frac{1}{\phi}\frac{y_t}{c_t}\left[\epsilon\Lambda_t-(\epsilon-1)\right]
+\beta E_t\left[\pi_{t+1}(1+\pi_{t+1})\right].
\]

**needs_review**：MinerU OCR 将厂商定价条件分成两个展示公式。对称 Phillips 曲线清楚，但非对称定价 FOC 在作为实现来源前应与 PDF 核对。

## 4. Market Clearing & Identities

**(F9) 匹配函数**：

\[
h_t=m u_t^\eta \nu_t^{1-\eta}.
\]

**(F10) 劳动力市场紧张度**：

\[
\theta_t=\frac{\nu_t}{u_t}.
\]

**(F11) 找到工作的概率**：

\[
f(\theta_t)=\frac{h_t}{u_t}=m\theta_t^{1-\eta}.
\]

**(F12) 职位填补概率**：

\[
q(\theta_t)=\frac{h_t}{\nu_t}=m\theta_t^{-\eta}.
\]

**(F13) 期初失业 / 求职者**：

\[
u_t=1-(1-s)n_{t-1}.
\]

**(F14) 总就业运动方程**：

\[
n_t=(1-s)n_{t-1}+\left[1-(1-s)n_{t-1}\right]f(\theta_t).
\]

**(F15) 新招聘身份式**：

\[
h_t=n_t-(1-s)n_{t-1}.
\]

**(F16) 总就业身份式**：

\[
n_t=l_t+g_t.
\]

**(F17) 对称生产函数**：

\[
y_t=a_t l_t^\alpha.
\]

**(F18) 通胀定义**：

\[
\pi_t=\frac{p_t}{p_{t-1}}-1.
\]

**(F19) 政府预算约束**：

\[
n_t\tau_t w_t+\frac{b_t}{p_t}
=g_t w_t+\frac{r a_t}{q(\theta_t)}\left[g_t-(1-s)g_{t-1}\right]
+\frac{R_{t-1}}{p_t}b_{t-1}.
\]

**(F20) 资源约束**：

\[
y_t=c_t\left(1+\frac{\phi}{2}\pi_t^2\right)
+\frac{r a_t}{q(\theta_t)}\left[n_t-(1-s)n_{t-1}\right].
\]

**(F21) 公共品生产**：

\[
z_t=\sigma g_t^\alpha.
\]

**(F22) 模拟中使用的 GDP 口径**：

\[
GDP_t=y_t+w_tg_t+\left[g_t-(1-s)g_{t-1}\right]\frac{r a_t}{q(\theta_t)}.
\]

## 5. Exogenous Processes

**(F23) 实际工资规则**：

\[
w_t=\omega a_t^\gamma.
\]

**(F24) 货币政策规则**：

\[
R_t=\frac{1}{\beta}(1+\pi_t)^{\mu_\pi(1-\mu_R)}(\beta R_{t-1})^{\mu_R}.
\]

**(F25) 技术过程**：

\[
\log(a_{t+1})=\rho\log(a_t)+\nu_{t+1}.
\]

**(F26) 主模拟中的公共就业基准**：

\[
g_t=\bar{g}
\]

除非政府干预额外增加公共就业。

**(F27) 一次性公共就业干预路径**：

\[
g_1^{\ast}=\hat{g}_1+\Delta g,\qquad
g_t^{\ast}-(1-s)g_{t-1}^{\ast}=s\bar{g}\quad\text{for }t\ge 2.
\]

MMB 实现交叉检查将该政策表示为外生公共招聘冲击 `hireg` 和内生存量 `gendo`。

## 6. Steady-State Solution

零通胀稳态与第 I 节的比较静态稳态模型同构。

**(F28) 稳态准劳动供给**：

\[
n^s(\theta)=\frac{f(\theta)}{s+(1-s)f(\theta)}.
\]

**(F29) 稳态私人劳动需求**：

\[
l^d(\theta,w)=
\left[
\frac{1}{\alpha}
\left\{
w+\left[1-\beta(1-s)\right]\frac{r}{q(\theta)}
\right\}
\right]^{-1/(1-\alpha)}.
\]

在新凯恩斯稳态中，垄断力量和技术缩放修正同一对象：零通胀意味着 \(\Lambda=(\epsilon-1)/\epsilon\)，因此实际边际劳动成本由加成缩放，并且动态生产模块中 \(w\) 被替换为 \(w/a\)。

**(F30) 稳态总劳动需求**：

\[
n^d(\theta,w,g)=g+l^d(\theta,w).
\]

**(F31) 劳动力市场稳态均衡**：

\[
n^s(\theta)=n^d(\theta,w,g).
\]

**(F32) 稳态总就业**：

\[
n=n^d(\theta,w,g).
\]

**(F33) 公共就业乘数**：

\[
\lambda\equiv\frac{\partial n}{\partial g}
=1-\frac{1}{1+(\epsilon^s/\epsilon^d)}.
\]

**(F34) 乘数公式中的供给弹性**：

\[
\epsilon^s=(1-\eta)u.
\]

**(F35) 乘数公式中的需求弹性**：

\[
\epsilon^d=\frac{\eta}{(1+\zeta)(1-\alpha)}\Omega,\qquad
\Omega=\frac{[1-\beta(1-s)]r/q(\theta)}
{[1-\beta(1-s)]r/q(\theta)+w}.
\]

**从来源和 MMB 交叉检查记录的校准顺序**：

1. 归一化 \(\bar{a}=1\)，并设零稳态通胀 \(\bar{\pi}=0\)。
2. 设定 \(\bar{u}=0.064\)、\(\bar{\theta}\approx0.43\) 和 \(s\approx0.009\)。
3. 求解 \(\bar{n}=(1-\bar{u})/(1-s)\)、\(\bar{g}=0.167\bar{n}\) 和 \(\bar{l}=\bar{n}-\bar{g}\)。
4. 设 \(m=s\bar{n}\bar{\theta}^{\eta-1}/\bar{u}\)。
5. 零通胀意味着 \(\bar{\Lambda}=(\epsilon-1)/\epsilon\)。
6. 从稳态劳动需求条件校准 \(\omega\)，并设 \(r=0.32\omega\)。
7. 设 \(\bar{R}=1/\beta\)、\(\bar{w}=\omega\bar{a}^\gamma\)、\(\bar{y}=\bar{a}\bar{l}^{\alpha}\)，并由资源约束求解 \(\bar{c}\)。

**needs_review**：MMB `.mod` 在若干动态表达式中使用 `delta` 表示论文中的 \(\beta\)。这似乎是实现中的参数命名约定，而不是论文侧证据。

## 7. Timing & Form Conventions

- **频率**：周频。
- **就业时序**：\(n_t\) 是当期匹配后的就业；期初失业为 \(u_t=1-(1-s)n_{t-1}\)。
- **招聘时序**：新招聘为 \(n_t-(1-s)n_{t-1}\)；公共部门招聘相应为 \(g_t-(1-s)g_{t-1}\)。
- **紧张度时序**：\(\theta_t\) 是当期每名求职者对应的职位空缺数，并决定 \(f(\theta_t)\) 和 \(q(\theta_t)\)。
- **价格时序**：Rotemberg 成本使用 \(p_t(i)/p_{t-1}(i)\)，通胀率为 \(\pi_t=p_t/p_{t-1}-1\)。
- **利率时序**：\(R_t\) 是第 \(t\) 期设定、在 \(t\) 到 \(t+1\) 间支付的名义总利率，并进入 Euler 方程。
- **形式**：非线性。不要把本推导视为来源验证过的对数线性系统。
- **运行时验证**：未执行；没有运行 Dynare、残差检查、BK 检查或 IRF 复现。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | ASCII / MMB 线索 | 含义 | 主要方程 |
|---|---|---|---|
| \(a_t\) | `a` | 技术 | (F25) |
| \(c_t\) | `c` | 家庭消费 | (F1), (F20) |
| \(\pi_t\) | `pie` | 通胀率 | (F8), (F18) |
| \(l_t\) | `l` | 私人就业 | (F7), (F16), (F17) |
| \(n_t\) | `n` | 总就业 | (F14), (F16) |
| \(\theta_t\) | `th` | 劳动力市场紧张度 | (F10)-(F12), (F14) |
| \(R_t\) | `R` | 名义总利率 | (F1), (F24) |
| \(g_t\) | `g`, `gendo` | 公共就业 | (F16), (F19), (F26)-(F27) |
| \(y_t\) | `y` | 最终产出 | (F17), (F20) |
| \(u_t\) | `u` | 求职者 / 失业度量 | (F13) |
| \(h_t\) | `h` | 新匹配 / 新招聘 | (F9), (F15) |
| \(w_t\) | `w` | 实际工资 | (F23) |
| \(\Lambda_t\) | `.mod` 中 `mpl` 线索 | 实际边际收入 / 边际成本对象 | (F7), (F8) |
| \(f(\theta_t)\) | `f` | 找到工作的概率 | (F11), (F14) |
| \(b_t\) | MMB `.mod` 未显式列出 | 名义债券 | (F1), (F19) |
| \(\tau_t\) | MMB `.mod` 未显式列出 | 劳动税率 | (F19) |
| \(z_t\) | MMB `.mod` 未显式列出 | 公共品 | (F21) |

### 外生创新

| 符号 | ASCII / MMB 线索 | 含义 |
|---|---|---|
| \(\nu_t\) | `epsa` | 技术创新 |
| \(\Delta g_t\) | `hireg` | 公共招聘干预冲击 |

### 参数

| 符号 | ASCII / MMB 线索 | 含义 |
|---|---|---|
| \(\beta\) | `.mod` 线索中的 `delta` | 折现因子 |
| \(\alpha\) | `alpha` | 劳动的边际收益递减参数 |
| \(\epsilon\) | `epsilon` | 商品间替代弹性 |
| \(s\) | `s` | 工作破坏率 |
| \(\eta\) | `eta` | 匹配函数对失业的弹性 |
| \(m\) | `.mod` 线索中的 `omegah` | 匹配效率 |
| \(r\) | `r` | 招聘成本 |
| \(\gamma\) | `gamma` | 实际工资对技术的弹性 |
| \(\omega\) | `omega` | 实际工资水平 |
| \(\phi\) | `phi` | Rotemberg 价格调整成本 |
| \(\mu_\pi\) | `phipi` | Taylor 规则通胀反应 |
| \(\mu_R\) | `phir` | 利率平滑 |
| \(\rho\) | `rhoa` | 技术持续性 |
| \(\chi\) | 未作为效用对象实现 | 公共品偏好 |
| \(\sigma\) | 未作为生产对象实现 | 公共品生产率尺度 |
| \(\zeta\) | `zeta` | 公共/私人就业比线索 |
| \(\bar{g}\) | `gexo`, `g_ss` | 基准公共就业 |

**覆盖说明**：来源论文将对称均衡表述为十个过程和十个关系，而 MMB 实现加入辅助变量（`u`, `h`, `w`, `mpl`, `f`, `gendo`, `y`）以便透明模拟。本表同时记录论文侧概念和实现交叉检查线索。
