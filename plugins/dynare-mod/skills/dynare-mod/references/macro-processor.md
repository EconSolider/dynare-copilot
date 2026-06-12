# 宏处理器（Macro processing language）

> **何时读**：任务含多国/多部门/模型变体切换/循环生成方程/模块化拆分/内生化参数。**本文件回答**：宏变量类型与运算符、全部 @# 指令、推导式、四类典型用法。

宏处理器是 Dynare 预处理器中一个**独立**的组件，在解析 `.mod` 之前运行，把带宏的
`.mod` 展开成不带宏的 `.mod` 再交给解析器。**它只做文本替换**（类似 C 预处理器或 PHP），
与模型变量、MATLAB 变量完全无关。可用 `dynare 文件名 savemacro` 查看展开后的结果。

用途：模块化（拆分文件）、循环复制方程块、条件包含代码、写索引求和/求积、内生化参数
（variable flipping）等。

> 语言规则提醒：宏指令和宏表达式本身全是 **ASCII（英文关键字）**，天然符合"注释外必须英文"
> 的要求。中文仍只放在 `//` / `/* */` 注释里。注意：`//` 之后的 `@#` 指令**不被**宏处理器
> 解释；而 `/* */` 块注释里的 `@#` 指令**会**被解释（历史遗留，不要依赖此行为）。

## 两种使用位置

- **在宏指令内部**直接用（如 `@#if`、`@#define` 的表达式）。
- **在 `.mod` 文件体内**用 `@{表达式}` 替换：宏处理器把它替换成表达式的值。
  例如 `var GDP_@{country};` 当 `country="US"` 时展开为 `var GDP_US;`。

指令以 `@#` 开头，通常独占一行；行尾两个反斜杠 `\\` 表示续行。

## 宏变量类型与运算符

宏处理器维护自己的变量表（与模型变量无关），类型有：**boolean、real、string、tuple、
function、array**。

- **Boolean**：比较 `== !=`；逻辑 `&& || !`。
- **Real**：算术 `+ - * / ^`；比较 `< > <= >= == !=`；逻辑 `&& || !`；
  - 区间（步长 1）`1:4` = `[1,2,3,4]`；自定义步长 `6:-2.1:-1` = `[6,3.9,1.8,-0.3]`。
  - 函数：`max min mod exp log(=ln) log10 sin cos tan asin acos atan sqrt cbrt sign
    floor ceil trunc erf erfc gamma lgamma round normpdf normcdf`。
- **String**：双引号 `"name"`；比较；拼接 `+`；取子串 `s[3]`、`s[4:6]`；函数 `length`。
- **Tuple**：圆括号 `(a,b,c)`；比较；函数 `empty length`。
- **Array**：方括号 `[1,[2,3],4]`、`["US","FR"]`；
  - 取元素 `v[2]`；拼接 `+`；并 `|`；交 `&`；差 `-`；笛卡尔积 `*`；自乘 `^N`；
    取子数组 `v[4:6]`；成员测试 `"b" in ["a","b","c"]`（返回 1）；函数 `empty sum length`。

### 推导式（comprehension）——从数组造数组

```
[ i in 1:5 when mod(i,2) == 0 ]        // 过滤 → [2, 4]
[ i^2 for i in 1:5 ]                    // 映射 → [1, 4, 9, 16, 25]
[ i^2 for i in 1:5 when mod(i,2) == 0] // 过滤+映射 → [4, 16]
[ (j, i+1) for (i,j) in (1:2)^2 ]      // → [(1,2),(2,2),(1,3),(2,3)]
```

### 类型检查与转换

- 检查：`isboolean isreal isstring istuple isarray`（如 `isreal("str")` → false）。
- 转换：`(bool) -1.1` → true、`(real) "2.2"` → 2.2、`(array) 4.4` → `[4.4]`、
  `(real) [5.5]` → 5.5；`(real) [6.6,7.7]` → 报错。可在表达式中使用：
  `(string) (3+4)` → `"7"`、`(array) 5 + (array) 6` → `[5,6]`。

## 宏指令详解

### `@#include` / `@#includepath`——文件包含（模块化）

```
@#includepath "/path/to/modfiles"   // 添加搜索路径
@#include "modelcomponent.mod"      // 原地插入该文件内容（等价于复制粘贴）
```

可嵌套包含。文件先在当前目录找，找不到再去 `-I` 与 `@#includepath` 提供的路径找。

### `@#define`——定义宏变量或宏函数

```
@#define flag                     // = true
@#define x = 5                    // real
@#define y = "US"                 // string
@#define v = [1, 2, 4]            // real 数组
@#define w = ["US", "EA"]         // string 数组
@#define z = 3 + v[2]             // = 5
@#define t = ("US" in w)          // = true
@#define f(x) = " " + x + y       // 函数 f：返回 ' ' + x + 'US'
```

宏函数在**调用时**求值（非定义时）。文件体内用 `@{...}` 取值：
`A = @{y[i] + f("D")};`。

### `@#if` / `@#ifdef` / `@#ifndef` / `@#elseif` / `@#else` / `@#endif`——条件包含

只有条件为真的分支被输出。`@#if` 后可跟零个或多个 `@#elseif`，`@#else` 可选。

```
@#define linear_mon_pol = false    // 0 等同 false
...
model;
@#if linear_mon_pol
   i = w*i(-1) + (1-w)*i_ss + w2*(pie - piestar);
@#else
   i = i(-1)^w * i_ss^(1-w) * (pie/piestar)^w2;
@#endif
...
end;
```

- `@#ifdef X`：只要 `X` 被定义过就为真（无论其值）；`@#ifndef X`：尚未定义则为真。
- `@#elseif` 里可用 `defined(X)` 判断是否定义：`@#elseif !defined(X)`。
- **实数当布尔**：表达式结果为实数时，0 视作 false、非 0 视作 true。
- **浮点比较要加容差**：`exp(log(5)) == 5` 会得 false；应写
  `exp(log(5)) > 5-1e-14 && exp(log(5)) < 5+1e-14`。

### `@#for ... @#endfor`——循环复制

可包住变量/参数声明、计算任务，**但不能包住整个 model 声明**（可以在 model 块内部包方程）。

```
model;
@#for country in ["home", "foreign"]
   GDP_@{country} = A * K_@{country}^a * L_@{country}^(1-a);
@#endfor
end;
// 展开为 GDP_home = ...; 与 GDP_foreign = ...;
```

带 `when` 过滤、用 tuple、用笛卡尔积：

```
@#define countries = ["US", "FR", "JA"]
@#define nth_co = "US"
model;
@#for co in countries when co != nth_co
   (1+i_@{co}) = (1+i_@{nth_co}) * E_@{co}(+1) / E_@{co};   // UIP
@#endfor
   E_@{nth_co} = 1;
end;

@#for (i, j) in ["GDP"] * ["home", "foreign"]
   @{i}_@{j} = A * K_@{j}^a * L_@{j}^(1-a);
@#endfor
```

### `@#echo` / `@#error` / `@#echomacrovars`——调试

```
@#echo "some message"          // 标准输出打印（参数须为字符串）
@#error "abort message"        // 打印并中止
@#echomacrovars A C D          // 打印这些宏变量/函数的当前值
@#echomacrovars(save) A        // 存到 options_.macrovars_line_<行号>
```

## 典型用法

### 模块化（`@#include`）

把模型拆成：`modeldesc.mod`（变量声明 + 模型方程 + 冲击声明）、`simul.mod`（包含
modeldesc、校准参数、跑 `stoch_simul`）、`estim.mod`（包含 modeldesc、声明先验、跑
`estimation`）。对 `simul.mod`/`estim.mod` 调用 Dynare，避免重复粘贴整套模型。

### 索引求和/求积（移动平均）

```
@#define window = 2
var x MA_x;
model;
MA_x = @{1/(2*window+1)}*(
@#for i in -window:window
   +x(@{i})
@#endfor
   );
end;
// 展开为 MA_x = 0.2*( +x(-2) +x(-1) +x(0) +x(1) +x(2) );
```

### 多国模型

```
@#define countries = ["US", "EA", "AS", "JP", "RC"]
@#define nth_co = "US"
@#for co in countries
   var Y_@{co} K_@{co} L_@{co} i_@{co} E_@{co};
   parameters a_@{co};
@#endfor
model;
@#for co in countries
   Y_@{co} = K_@{co}^a_@{co} * L_@{co}^(1-a_@{co});
@#if co != nth_co
   (1+i_@{co}) = (1+i_@{nth_co}) * E_@{co}(+1) / E_@{co};   // UIP
@#else
   E_@{co} = 1;
@#endif
@#endfor
end;
```

参考 DSGE_mod 的 `macroprocessor/bkk_1992`（多国 RBC，演示宏处理器）。

### 内生化参数 / variable flipping（校准技巧）

要用稳态内生量（如劳动份额 `lab_rat`）反推份额参数 `alpha`：稳态计算时把 `alpha` 当内生、
把 `lab_rat` 当参数（给经济上合理的值），求解器反解出 `alpha`。用宏开关 `@#if steady`
切换声明，并配合 `change_type`（见 `references/steady-state.md` 与变量声明）：

```
// 在模型声明文件 modeqs.mod 中：
@#if steady
   var alpha;
   parameters lab_rat;
@#else
   parameters alpha;
   var lab_rat;
@#endif
```

然后在"稳态用"主文件里 `@#define steady = 1` 后再 `@#include "modeqs.mod"`，并据此搭建
反解稳态；在"动态用"主文件里 `@#define steady = 0`。

---

# 手册增补（Dynare 7.1 §4.2/4.5 + §3）

## `change_type` 与「变量翻转」（稳态反解参数的正规机制）

```dynare
change_type(var) alpha beta;        // 把参数 alpha,beta 变成内生
change_type(parameters) y w;        // 把内生 y,w 变成参数
```
**全局生效**（在该命令前后都改）。配合宏开关 `@#if steady` 在「稳态用」与「动态用」两份主文件间
切换声明，是用稳态目标（如劳动份额）反解结构参数（如 `alpha`）的标准做法。
另有 `var_remove X;` 删变量（已被用过会报错）。

## 即时声明（on-the-fly，省去顶部声明）

- 方程标签里声明内生：`[endogenous='c']`。
- 方程内用竖线后缀：`c|e`（内生）、`eps|x`（外生）、`alppha|p`（参数）——**只能用于当期变量**，
  不必出现在该符号首次位置。
```dynare
model;
[endogenous='k',name='law of motion of capital']
k(+1) = i|e + (1-delta|p)*k;
y|e = k^alpha|p;
end;
delta = 0.025;  alpha = 0.36;
```

## 按标签增删/替换方程（做变体的利器）

- `model_remove('eq:name', tag=val, [name='x',bar='baz']);`——删带这些标签的方程；对应内生若仍被
  用则转外生，否则删除。
- `model_replace('dummy'); ...新方程... end;`——删旧加新，不改变量类型。
- `model_options(...)`——多个 model 块时给整模型统一选项。
（与命令行 `exclude_eqs`/`include_eqs` 互补，见 debugging.md。）

## 命令行宏定义与包含路径

`-DA=true`、`'-DB="a string"'`、`-DC=[1,2,3]`、`-I<path>`（`@#include` 搜索路径，优先于
`@#includepath`）。`savemacro` 查看展开结果。
