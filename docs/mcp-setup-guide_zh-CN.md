# 给 Claude Code 接上 MATLAB / Stata（MCP 配置入门指南，Windows）

> **这份指南面向零基础读者**：从头教你在命令行装好 Claude Code，再把 MATLAB 和 Stata「接」进去，让 AI 能直接帮你跑代码、查错、读结果。
>
> 语言：[English](./mcp-setup-guide.md) ｜ **中文** ｜ [日本語](./mcp-setup-guide_ja.md)

---

## 一、先搞懂：这份指南在解决什么问题

Claude Code 是 Anthropic 出的**命令行 AI 编程助手**——你在终端里用大白话给它下指令，它帮你写代码、改 bug、跑程序。

但默认情况下，它**不会**操作你电脑上的 MATLAB 或 Stata。要让它能做到，需要给它配一个叫 **MCP** 的「插头」。读完这份指南，你会拥有一个「超级工作台」：在终端里用自然语言指挥 AI 去操作 MATLAB 和 Stata。

### 一个常见困惑：我装了 VSCode 扩展，为什么还要配 MCP？

很多人会问：「我 VSCode 里明明装了 MATLAB 扩展，为什么 Claude Code 还要绕一圈？」

打个比方：

- **VSCode 扩展是给「你这个人」用的**——语法高亮、自动补全、点按钮运行。它服务的是坐在屏幕前的你，并不会把「运行 MATLAB 的能力」交到 AI 手里。
- **MCP 才是给「AI」用的接口**。Claude Code 这个 AI 助手只认两类工具：(1) 它自带的内置工具（读写文件、跑命令行）；(2) **你亲手配置过的 MCP server**。

所以，想让 AI 真正用上 MATLAB / Stata，唯一的办法就是给它配 **MCP（Model Context Protocol，模型上下文协议）server**——它相当于 AI 和软件之间的一根「标准插头」。下面要做的，就是把这根插头插好。

---

## 二、动手前的准备清单

开始之前，先确认下面这些东西都就位（用不到的可以跳过）：

| 需要的东西 | 干什么用的 | 怎么搞定 |
|-----------|-----------|---------|
| **Git for Windows** | Claude Code 内部要靠它跑命令，**必须装** | 打开 https://git-scm.com 下载，一路默认安装，注意勾选「Add Git to PATH」 |
| **付费的 Claude 套餐** | 用 Claude Code 需要订阅或 API 额度 | Pro / Max / Team / Enterprise 任一，或在 Anthropic Console 充 API 额度 |
| **MATLAB（2020b 或更新）** | 跑 MATLAB（只在你用 MATLAB 时才需要） | 装好即可，但要把它加进系统 PATH（见第四节） |
| **Stata（有正版授权）** | 跑 Stata（只在你用 Stata 时才需要） | 装好即可 |
| **uv（Python 包管理器）** | Stata MCP 依赖它 | 见第五节的安装步骤 |

> 💡 **MATLAB 和 Stata 是两个互不相干的模块**，你只配自己实际要用的那个就行，另一个整节跳过即可。

---

## 三、第一步：用命令行装 Claude Code

Anthropic 现在推荐用**原生安装器（native installer）**，不需要装 Node.js，而且能自动后台更新，最省心。

### 3.1 打开「正确的」终端

打开 **Windows PowerShell**。这里有个坑：**不要**开成 x86 版本、Git Bash 或老式的 CMD。

做法：在任务栏搜索框输入「PowerShell」，选那个最普通、名字就叫「Windows PowerShell」的打开。

### 3.2 运行安装命令

把下面这一行复制进去，回车：

```powershell
irm https://claude.ai/install.ps1 | iex
```

> **这行命令在干嘛？** `irm`（Invoke-RestMethod）负责把安装脚本下载下来，`iex`（Invoke-Expression）负责把它运行起来。脚本会自动下载程序、配好 PATH，全程不需要管理员权限。

装完后，程序本体会放在这里：

```
%USERPROFILE%\.local\bin\claude.exe
```

### 3.3 关键一步：把终端关掉再重开

PATH 的改动**只对「新打开」的终端生效**。所以装完后，**一定要把当前这个 PowerShell 窗口整个关掉，再重新开一个**，然后继续下一步。

这一步最容易被忽略，一旦跳过，下一步就会报「claude 不是命令」的错。

### 3.4 验证装好了没

在新终端里输入：

```powershell
claude --version
```

能看到一串版本号，就说明装成功了。

> ⚠️ 如果报错 `claude : 无法将"claude"项识别为 cmdlet...`，说明 PATH 还没配好。手动补一下：
> 按 `Win+R` → 输入 `sysdm.cpl` 回车 → 「高级」标签 → 「环境变量」 → 在上半部分「用户变量」里找到 `Path`、双击 → 「新建」一行，填 `%USERPROFILE%\.local\bin` → 一路确定 → **关掉终端重开**，再试一次。

### 3.5 第一次登录

随便进入一个项目文件夹，运行：

```powershell
claude
```

第一次启动会自动弹出浏览器，让你登录 Anthropic 账号授权。**登录一次就够了**，以后不用再登。

---

## 四、第二步：配置 MATLAB MCP

我们用的是 MathWorks **官方**发布的 `matlab-mcp-core-server`。装好后，Claude Code 会多出 5 个 MATLAB 工具：检查代码、运行代码、运行文件、运行测试文件、检测本地已装的工具箱。

### 4.1 先确认 MATLAB 在系统 PATH 里

这是最容易踩的坑。在 PowerShell 里测一下：

```powershell
matlab -h
```

如果提示找不到命令，就得把 MATLAB 的 `bin` 目录加进 PATH。比如你的 MATLAB 装在 D 盘，路径一般长这样（版本号按你实际装的改）：

```
D:\Program Files\MATLAB\R2024b\bin
```

加 PATH 的方法和上面 3.4 的一样，加完**重开终端**，再跑一次 `matlab -h` 确认通过。

### 4.2 下载 Windows 版程序

去官方 releases 页面，下载 `matlab-mcp-core-server-win64.exe`：

> https://github.com/matlab/matlab-mcp-core-server/releases

下载后放在一个**固定的、以后不会乱动**的位置。建议**不要**放进 MATLAB 的安装文件夹里（升级 MATLAB 时可能被覆盖掉）。可以放在比如：

```
D:\tools\matlab-mcp-core-server-win64.exe
```

### 4.3 把它注册给 Claude Code

用 `--scope user`，让它在你**所有项目**里都能用（一次配好，终身受用）：

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe"
```

> **这条命令的几个要点**
> - 中间那个 `--`（两个连字符）很重要，它把「Claude Code 自己的选项」和「要传给 server 的参数」隔开，不能漏。
> - 路径用双引号包起来，防止路径里有空格（比如 `Program Files`）导致出错。
> - 命令行里用单个反斜杠 `\` 就行；只有把路径写进 JSON 配置文件时，才需要写成双反斜杠 `\\` 转义。

如果你想给它指定一个默认的工作目录，可以这样：

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe" --initial-working-folder=D:\projects\my-project
```

### 4.4 小提示

新版用了「懒加载」：只有在**第一次真正要跑 MATLAB 代码**时，才会把 MATLAB 桌面拉起来，不会一开终端就弹窗。建议用最新版。

---

## 五、第三步：配置 Stata MCP

我们用社区维护的 **MCP-for-Stata**（包名 `stata-mcp`），它把 Claude Code 列为推荐客户端，专为实证研究设计。

### 5.1 先装 uv

Stata MCP 依赖 `uv`（一个 Python 包管理器）。如果你还没装，先装它：

```powershell
pip install uv
```

> 需要 Python 3.11 或更新版本。如果你连 Python 都没有，可以先去 https://www.python.org 装一个，或者直接用 uv 自带的 Python 管理功能。

### 5.2 检查环境就绪没

先确认 stata-mcp 能找到你电脑上的 Stata：

```powershell
uvx stata-mcp --usable
```

如果提示找不到 Stata（`STATA_CLI not found`），说明它不知道 Stata 装在哪——可以参考项目文档的 "StataFinder" 部分，或者在添加时用环境变量手动告诉它路径。

### 5.3 把它注册给 Claude Code

**方式 A：直接添加（新手推荐）**，全局可用：

```powershell
claude mcp add stata-mcp --scope user -- uvx stata-mcp
```

**方式 B：按研究项目单独配置**，在某个项目目录里运行：

```powershell
claude mcp add stata-mcp --scope project -- uvx stata-mcp
```

这会在该项目根目录生成一个 `.mcp.json`，配置只对这个项目生效。适合「一个项目一套环境、互不干扰」的情况，也方便把它签进 git 分享给团队。

**方式 C：官方插件**（一次装好 MCP server + Stata 语言服务器 LSP，代码补全更准）：

```powershell
claude plugin marketplace add sepinetam/stata-mcp
claude plugin install stata-toolbox -s user
```

> Stata-MCP 支持 Windows、macOS、Linux，也支持 Stata 的 MP / SE / BE 各版本，会自动检测你的安装。运行 Stata 命令需要有效的 Stata 授权。

---

## 六、验证一切就绪

列出所有已配置的 MCP server：

```powershell
claude mcp list
```

你应该能看到 `matlab` 和 `stata-mcp`（取决于你配了哪些）。

进入 Claude Code 会话后，输入这个命令查看连接状态：

```
/mcp
```

每个 server 旁边会显示它提供的工具数量和连接状态。看到「已连接」就大功告成了。

---

## 七、关于「作用域（scope）」：到底要不要每次都配？

**不用。** `claude mcp add` 是一次性配置，跑一次就长期生效。会不会「换个项目就失效」，取决于你选的 scope（作用范围）：

| Scope | 怎么加 | 生效范围 | 存在哪 |
|-------|--------|---------|---------|
| `local`（默认） | 不写 `--scope` | 只有当前这一个项目 | `~/.claude.json` |
| `user` | 加 `--scope user` | 你这台机器上**所有**项目 | `~/.claude.json` |
| `project` | 加 `--scope project` | 当前项目，可签进 git 分享 | 项目根目录的 `.mcp.json` |

**给新手的建议**：如果你是一个人用、多个项目都要跑 MATLAB/Stata，那就统一用 `--scope user`，配一次到处能用，最省心。

---

## 八、常见问题（FAQ）

**Q：装完输入 `claude` 报「不是命令」？**
A：90% 是 PATH 没更新。先把终端关掉重开；还不行就手动把 `%USERPROFILE%\.local\bin` 加进用户 PATH（见 3.4）。

**Q：Claude Code 还是用命令行硬跑 MATLAB，没走 MCP？**
A：先用 `claude mcp list` 和 `/mcp` 确认 server 真的连上了。如果你当初是用 `local` scope 配的，换个项目目录就会「看不到」它——建议改成 `--scope user` 重新加一遍。

**Q：MATLAB / Stata 找不到？**
A：MATLAB 要保证它的 `bin` 在系统 PATH 里（`matlab -h` 能跑通）；Stata 要保证 `uvx stata-mcp --usable` 检查通过。

**Q：想删掉某个 server 重新配？**

```powershell
claude mcp remove matlab
claude mcp remove stata-mcp
```

删掉后，再用新参数重新 `add` 一遍即可。

---

## 九、配好之后能干什么

在 Claude Code 会话里，你可以直接用大白话下指令，比如：

- 「帮我跑一下 `analysis.do`，把回归结果给我解读一下。」
- 「这段 MATLAB 代码报错了，帮我查出来并修好。」
- 「复现这篇论文里的 DID 估计，用我数据集里的 `firm_panel.dta`。」
- 「检测一下我本地装了哪些 MATLAB 工具箱。」

Claude Code 会通过 MCP 工具**真的去运行** MATLAB / Stata，拿到真实输出，再帮你分析——而不是凭空猜代码、编结果。

> 💡 如果你做的是 **DSGE / 宏观建模**，本仓库的 `dynare-copilot` skill 配合 MATLAB MCP 使用效果最佳：MCP 负责跑 Dynare，skill 负责把你的经济直觉变成跑得通的 `.mod` 文件。安装方式见 [README](../README_zh-CN.md)。

---

## 十、参考链接

- Claude Code MCP 官方文档：https://code.claude.com/docs/en/mcp
- MATLAB MCP Core Server：https://github.com/matlab/matlab-mcp-core-server
- Stata-MCP 文档：https://docs.statamcp.com
- Stata-MCP 项目：https://github.com/SepineTam/stata-mcp

> ⚠️ **安全提醒**：MCP 让 AI 能直接读写你的文件、运行系统命令。连接任何 server 前请确认你信任它的来源，对敏感操作保留人工确认这一关。
