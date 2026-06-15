# SWFF 模型推导与复现说明
**Del Negro, Giannoni & Schorfheide (2015, AEJ:Macro) —《Inflation in the Great Recession and New Keynesian Models》**

> 复现目标:用论文给定参数(SWFF 后验众数,不做估计)重建对数线性化模型,通过 Blanchard-Kahn
> 与稳态检验,产出主要冲击(尤其金融/利差冲击与货币冲击)的 IRF 与发表级图。
> 不复现其 2008Q4 条件预测 / ZLB-前瞻指引的分段线性求解(那需要他们的数据集与 OccBin 式解法)。

---

## 第1节 模型概述

SWFF = **Smets-Wouters (2007) 中等规模 NK 模型** + **两项扩展**:
1. **时变通胀目标** π*_t(随 AR(1) 演化,进入 Taylor 规则);
2. **金融摩擦**(Bernanke-Gertler-Gilchrist / Christiano-Motto-Rostagno 的成本状态核查机制):
   银行向企业家放贷,企业家以自有净值 n 加杠杆购买资本;特异冲击使部分企业家违约;
   银行通过对存款利率加点(利差 spread)来覆盖违约风险。利差随杠杆与企业家风险 σ_ω 变动。

模型一律以**对数线性化偏离稳态**形式给出(论文 §2.1 直接给线性系统)。因此按 skill 规则 R8 例外②,
本复现用 Dynare `model(linear)`。

**权威实现来源**:本复现逐条转写 **FRBNY DSGE.jl 的 `m990`** 均衡条件(`eqcond.jl`)与金融摩擦
稳态(`financial_frictions.jl` + `m990.jl` 的 `steadystate!`)。m990 即 DGS2015 论文模型的官方代码。
论文 §2.1 的方程(3)–(21)与 m990 一一对应;m990 额外含若干 FRBNY 后续添加的冲击(`zp` 长期技术、
`μ_e` 破产成本、`γ` 企业家财富、预期货币冲击),这些在 SWFF 中**方差为 0(不估计)**,故本复现剔除,
只保留论文 Table A-2 中真正有 σ 的 9 个结构冲击。

### 经济体的"双轨"结构
SW 的 Taylor 规则用**产出缺口** = 实际产出 y − 弹性价格产出 y^f。故模型同时求解两套经济:
- **粘性经济**(sticky):含价格/工资黏性 + 金融摩擦 —— 实际经济;
- **弹性经济**(flexible,上标 f):去掉一切名义黏性与金融摩擦 —— 给出 y^f。

---

## 第2节 各主体最优化问题(摘要,FOC 见 SW2007 / BGG 原文)

由于论文与 m990 直接给线性化均衡条件,此处只列主体与其一阶条件来源,不重复推导:

| 主体 | 决策 | 一阶条件 → 线性方程 |
|---|---|---|
| 家庭 | 消费/储蓄、劳动、资本利用、投资 | 欧拉方程(F1)、投资欧拉(F2)、资本利用(F8)、MRS(F13) |
| 工会(黏性工资) | Calvo 工资 + 指数化 | 工资 Phillips 曲线(F14) |
| 中间品厂商(垄断竞争,Calvo 价格 + Kimball 加总) | 定价 | 价格 Phillips 曲线(F11);要素需求(F10、F12) |
| 资本生产者 | 投资→资本转换(投资调整成本) | 资本运动律(F9)、托宾 Q(F2) |
| 企业家 + 银行(BGG-CSV) | 杠杆购资本、违约、利差 | 资本回报定义(F3)、利差方程(F4)、净值演化(F5) |
| 中央银行 | 利率反馈规则(含 π*_t) | 货币政策规则(F15) |

---

## 第3节 线性化均衡条件(模型核心,编号 F1–F16 粘性 + FF1–FF11 弹性)

记号:小写 = 稳态对数偏离;`E_t x_{t+1}` 在 Dynare 中写 `x(+1)`;滞后写 `x(-1)`。
辅助常数:`zg = z_star`(稳态人均增长率对数),`he = h*exp(-zg)`,`bb = betta*exp((1-sigc)*zg)`(即论文 β̄)。

### 3.1 粘性经济(实际经济,16 条)

**F1 消费欧拉方程**(对应论文 eq.3)
```
c = -(1-he)/(sigc*(1+he)) * (R - π(+1) - b)
    + he/(1+he) * (c(-1) - z)
    + 1/(1+he) * (c(+1) + z(+1))
    + (sigc-1)*wl_c/(sigc*(1+he)) * (L - L(+1))
```
(注:m990 中 b 以"原始偏好冲击"进入,系数为 1;见第6节归一化。)

**F2 投资欧拉(托宾 Q)**(eq.4)
```
i = 1/(1+bb) * (i(-1) - z) + bb/(1+bb) * (i(+1) + z(+1))
    + 1/(S2*exp(2*zg)*(1+bb)) * qk + mu
```
其中 `S2 = S''`(投资调整成本二阶导)。

**F3 资本回报定义 R̃^k**(eq.20)
```
Rtil_k - π = r_k_star/(1+r_k_star-delta) * rk + (1-delta)/(1+r_k_star-delta) * qk - qk(-1)
```

**F4 利差方程**(eq.19;FF 核心)
```
Rtil_k(+1) - R = bcoef*b + zeta_spb*(qk + kbar - n) - sigw_t
```
其中 `bcoef = sigc*(1+he)/(1-he)`;`sigw_t` = 金融风险冲击 σ̃_ω。

**F5 企业家净值演化**(eq.21)
```
n = zeta_nRk*(Rtil_k - π) - zeta_nR*(R(-1) - π) + zeta_nqk*(qk(-1)+kbar(-1))
    + zeta_nn*n(-1) - (zeta_nsigw/zeta_spsigw)*sigw_t(-1)
    - (gstar_v_n)*z
```
`gstar_v_n = γ_star*vstar/nstar`(z 项系数,见第6节);γ_star = 企业家存活率 = 0.99(固定)。

**F6 生产函数**(eq.11)`y = Phi*(alppha*k + (1-alppha)*L)`

**F7 资本利用→有效资本**(eq.7)`k = u - z + kbar(-1)`

**F8 资本利用最优**(eq.8)`u = (1-ppsi)/ppsi * rk`

**F9 资本运动律**(eq.5)
```
kbar = (1 - istar/kbarstar)*(kbar(-1) - z) + istar/kbarstar * i
       + istar*S2*exp(2*zg)*(1+bb)/kbarstar * mu
```

**F10 实际边际成本**(eq.9)`mc = w + alppha*L - alppha*k`

**F11 价格 Phillips 曲线**(eq.13)
```
π = kappa * mc + ι_p/(1+ι_p*bb) * π(-1) + bb/(1+ι_p*bb) * π(+1) + λ_f
```
`kappa = (1-zeta_p*bb)*(1-zeta_p) / ( zeta_p*((Phi-1)*eps_p+1)*(1+ι_p*bb) )`(Kimball)。

**F12 要素价格关系**(eq.10)`k = w - rk + L`  ⇔ `rk + k - L - w = 0`

**F13 劳动 MRS**(eq.15)`μ_ω = 1/(1-he)*(c - he*c(-1)) + he/(1-he)*z + ν_l*L`(即 w^h)

**F14 工资 Phillips 曲线**(eq.14)
```
w = (1-zeta_w*bb)*(1-zeta_w)/(zeta_w*((λ_w-1)*eps_w+1)*(1+bb)) * (μ_ω - w)... 
```
(完整系数见 eqcond.jl 第237–247行,逐项转写;含 w(-1)、w(+1)、π、π(-1)、π(+1)、z、z(+1)、λ_w。)

**F15 货币政策规则**(eq.17)
```
R = ρ*R(-1) + (1-ρ)*( ψ1*(π - π_star) + ψ2*(y - y^f) ) + ψ3*((y-y^f) - (y(-1)-y^f(-1))) + rm
```

**F16 资源约束**(eq.12)
```
y = gstar*g + cstar/ystar*c + istar/ystar*i + r_k_star*kstar/ystar*u
```

### 3.2 弹性经济(上标 f,11 条,**无金融摩擦、无黏性**)
FF1 欧拉(同 F1,R→r^f 实际利率,无 π);FF2 投资欧拉(同 F2);
**FF3 资本套利(无 FF)**:`r_k_star/(1+r_k_star-δ)*rk^f(+1) + (1-δ)/(1+r_k_star-δ)*qk^f(+1) - qk^f - r^f + bcoef_b = 0`(eqcond 116–120);
FF4 生产;FF5 资本利用→有效资本;FF6 利用最优;FF7 资本运动律;
FF8 边际成本=0:`w^f = alppha*(k^f - L^f)`;FF9 要素价格;FF10 MRS:`w^f = μ_ω^f`;FF11 资源约束。

### 3.3 外生过程(9 个活跃冲击;eqcond §EXOGENOUS)
```
ztil = ρ_z*ztil(-1) + ε_z                         (eq.1, 趋势平稳技术水平)
z    = (ρ_z-1)/(1-alppha)*ztil(-1) + 1/(1-alppha)*ε_z   (eq.2, 增长率;zp 已置零)
b    = ρ_b*b(-1) + ε_b
mu   = ρ_μ*mu(-1) + ε_μ
g    = ρ_g*g(-1) + ε_g + η_gz*ε_z                  (政府支出,含技术外溢)
λ_f  = ρ_λf*λ_f(-1) - η_λf*λ_f1(-1) + ε_λf ; λ_f1 = ε_λf   (ARMA(1,1))
λ_w  = ρ_λw*λ_w(-1) - η_λw*λ_w1(-1) + ε_λw ; λ_w1 = ε_λw   (ARMA(1,1))
rm   = ρ_rm*rm(-1) + ε_rm                          (货币政策冲击)
sigw = ρ_σw*sigw(-1) + ε_σw                        (金融风险/利差冲击)
π_star = ρ_π*π_star(-1) + ε_π*                     (时变通胀目标)
```

---

## 第4节 市场出清与 Walras 定律
资源约束 F16 即商品市场出清;债券/存款市场出清隐含在企业家-银行融资恒等式(已并入 F4/F5)。
线性系统按 m990 构造,方程数严格 = 变量数,**无冗余方程**(Sims gensys 已是最小表示),
转写为 Dynare 后逐一核对(第8节)。无需额外剔除 Walras 冗余方程。

---

## 第5节 冲击清单(9 个,对应 Table A-2 中有 σ 的项)
ε_z(技术)、ε_b(偏好)、ε_μ(MEI 投资专用)、ε_g(政府)、ε_λf(价格加成)、ε_λw(工资加成)、
ε_rm(货币)、ε_σw(**金融/利差**)、ε_π*(通胀目标)。
**剔除**(SWFF 中 σ=0,不估计):ε_zp、ε_μe、ε_γ、预期货币冲击。

---

## 第6节 稳态与金融摩擦系数求解(照抄 DSGE.jl,可直接编码)

线性模型稳态全 0;需先算"深参数→派生参数"。增长与价格:
```
zg   = log(1+gam) + alppha/(1-alppha)*log(Upsilon)   (Upsilon=1)
rstar= exp(sigc*zg)/betta
r_k_star = spr*rstar*Upsilon - (1-delta)
wstar = (alppha^alppha*(1-alppha)^(1-alppha)*r_k_star^(-alppha)/Phi)^(1/(1-alppha))
Lstar = 1
kstar = alppha/(1-alppha)*wstar*Lstar/r_k_star
kbarstar = kstar*(1+gam)*Upsilon^(1/(1-alppha))
istar = kbarstar*(1-(1-delta)/((1+gam)*Upsilon^(1/(1-alppha))))
ystar = kstar^alppha*Lstar^(1-alppha)/Phi
cstar = (1-gstar)*ystar - istar
wl_c  = wstar*Lstar/(cstar*λ_w)
```
**金融摩擦稳态**(BGG-CSV;`spr` = 稳态毛季度利差 = 1 + SP*/400):
```
z_ω    = norminv(F_star)            (F_star=0.03 固定违约概率)
解 sigw_ss:  zeta_spb_fn(z_ω, sigw_ss, spr) = zeta_spb   (fzero)
ω̄ = exp(sigw_ss*z_ω - sigw_ss^2/2)
G=Φ(z_ω-sigw_ss); Γ=ω̄(1-Φ(z_ω))+Φ(z_ω-sigw_ss); 及各阶导数(见 financial_frictions.m)
μ_e* = μ_fn(...);  nk* = nk_fn(...);  Rho* = 1/nk* - 1
派生:zeta_spsigw, zeta_nRk, zeta_nR, zeta_nqk, zeta_nn, zeta_nsigw
      (公式逐条照抄 m990 steadystate! 第645–661行)
gstar_v_n = γ_star*vstar/nstar
```
> 数值自检:期望 nk*(净值/资本 ≈ 1/杠杆)落在 0.4–0.6、F_star=0.03、利差年化≈1.9%。
> 这些将在 MATLAB 求解脚本 `swff_ff_coeffs.m` 中计算并打印核对。

**深参数(论文 Table A-2,SWFF 列,后验众数)**
α=0.1787, ζp=0.8680, ιp=0.2259, Φ=1.5262, S''=3.0437, h=0.2440, ψ=0.1884, νl=2.6732,
ζw=0.8875, ιw=0.4187, r*=0.1331(→β=1/(1+r*/100)=0.998670), ψ1=1.3737, ψ2=0.01804,
ψ3=0.2398, π*=0.7662(→Π=1.007662), σc=1.3159, ρ(=ρR)=0.6750, γ(增长)=0.4012,
SP*=1.9081, ζsp,b=0.044292;
ρg=0.9793, ρb=0.9440, ρμ=0.6435, ρz=0.9564, ρλf=0.7939, ρλw=0.6609, ρrm=0.0673,
ρσw=0.9899, ρπ*=0.99(固定);
σg=2.9080, σb=0.0384, σμ=0.5033, σz=0.4961, σλf=0.1535, σλw=0.2568, σrm=0.2919,
σσw=0.0575, σπ*=0.0300;
ηgz=0.8737, ηλf=0.7143, ηλw=0.5720。
固定:δ=0.025, gstar=0.18, λw=1.5, εp=εw=10, Upsilon=1, F_star=0.03, γ_star(存活)=0.99。

---

## 第7节 时序约定(R2)
- 资本"期末存量" `kbar` 为状态变量:生产/利用用 `kbar(-1)`(上期末资本本期投入),
  运动律左边是本期末 `kbar`。有效资本 `k = u - z + kbar(-1)`。
- 净值 `n` 为状态:演化律右边含 `n(-1)`、`qk(-1)`、`kbar(-1)`、`R(-1)`、`sigw(-1)`。
- 所有 AR/ARMA 外生过程为内生变量,创新项 `ε_*` 才是 `varexo`(R3)。
- 利差方程含 `Rtil_k(+1)`(期望资本回报);欧拉/Phillips/工资方程含相应 `(+1)` 前瞻项。

---

## 第8节 变量–方程对照表(R4 预核对)

**粘性经济(16 变量 / 16 方程)**

| # | 变量 | 由哪条方程决定 |
|---|---|---|
|1|c|F1 欧拉|
|2|i (invest)|F2 投资欧拉|
|3|qk|F3 资本回报定义|
|4|Rtil_k|(在 F3 定义,F4 给其期望)→ F3|
|5|n|F5 净值演化|
|6|y|F6 生产函数|
|7|k|F7 有效资本|
|8|u|F8 利用最优|
|9|kbar|F9 资本运动律|
|10|mc|F10 边际成本|
|11|π|F11 价格 Phillips|
|12|rk|F12 要素价格关系|
|13|μ_ω (w^h)|F13 MRS|
|14|w|F14 工资 Phillips|
|15|R|F15 Taylor 规则|
|16|(利差闭合)|F4 利差方程|

> 说明:F3 定义 Rtil_k、F4 用 E_t Rtil_k(+1) 闭合利差,共同决定 {qk, Rtil_k}。16 条方程恰好定 16 个粘性变量。

**弹性经济(11 变量 / 11 方程)**:c^f,i^f,qk^f,rk^f,k^f,kbar^f,u^f,w^f,L^f,y^f,r^f —— 对应 FF1–FF11。
此外粘性经济的 L 由 F1 欧拉中的前瞻项与整体系统联立决定(SW 标准:劳动需求 F12/F10 + 工资方程闭合)。

**外生过程(11 变量 / 11 方程)**:ztil,z,b,mu,g,λ_f,λ_f1,λ_w,λ_w1,rm,sigw,π_star
(注:z 由其定义式、ztil 由 AR(1),λ 各含一个 MA 辅助变量)。

> **总计**:16(粘性)+ 11(弹性)+ 12(外生,含 π_star)= 39 内生变量 = 39 方程。
> 建 .mod 时阶段3 跑 Dynare,以 "Found 39 equation(s)" 与变量数一致作为结构验证通过标准。

---

## 第9节 复现计划(增量构建)
1. 写 `swff_ff_coeffs.m`(BGG 函数 + ζ 系数,MATLAB)→ 单独跑,打印 nk*/利差自检。
2. 写 `swff.mod`:声明 → 深参数(字面值)→ 派生参数(由脚本注入)→ `model(linear)` → shocks → `stoch_simul`。
3. 三跑三锁:结构(方程数)→ 稳态/BK(check)→ IRF(无 NaN)。
4. 发表级 IRF 图:金融冲击 σ_ω、货币 rm、技术 z、偏好 b 等对 y、π、R、spread、n 的反应。
