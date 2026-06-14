# Connecting MATLAB / Stata to Claude Code (MCP Setup Guide, Windows)

> **This guide is written for absolute beginners.** It walks you from zero: install Claude Code on the command line, then "plug in" MATLAB and Stata so the AI can run your code, fix errors, and read results for you directly.
>
> Languages: **English** ｜ [中文](./mcp-setup-guide_zh-CN.md) ｜ [日本語](./mcp-setup-guide_ja.md)

---

## 1. First, the problem this guide solves

Claude Code is Anthropic's **command-line AI coding assistant** — you give it instructions in plain language in your terminal, and it writes code, fixes bugs, and runs programs for you.

But out of the box, it **cannot** operate the MATLAB or Stata installed on your machine. To make that possible, you give it a kind of "adapter plug" called **MCP**. By the end of this guide you'll have a "super workbench": directing the AI in natural language to drive MATLAB and Stata, right from your terminal.

### A common confusion: I already have the VSCode extension — why do I still need MCP?

Many people ask: "I clearly have the MATLAB extension installed in VSCode — why does Claude Code take a detour?"

Here's an analogy:

- **The VSCode extension is for *you, the human*** — syntax highlighting, autocomplete, a Run button. It serves the person sitting at the screen; it does **not** hand the "ability to run MATLAB" to the AI.
- **MCP is the interface for the *AI*.** Claude Code, the AI assistant, only recognizes two kinds of tools: (1) its own built-in tools (reading/writing files, running shell commands); (2) **MCP servers that you have configured yourself**.

So the only way to let the AI actually use MATLAB / Stata is to give it an **MCP (Model Context Protocol) server** — think of it as a standardized "plug" between the AI and your software. What follows is how to wire that plug in.

---

## 2. Checklist before you start

Before you begin, make sure these are in place (skip anything you won't use):

| What you need | What it's for | How to get it |
|--------------|---------------|---------------|
| **Git for Windows** | Claude Code runs commands through it internally — **required** | Download from https://git-scm.com, install with defaults, and make sure "Add Git to PATH" is checked |
| **A paid Claude plan** | Using Claude Code requires a subscription or API credit | Any of Pro / Max / Team / Enterprise, or API credit on the Anthropic Console |
| **MATLAB (2020b or newer)** | Running MATLAB (only needed if you use MATLAB) | Just have it installed, but add it to your system PATH (see Section 4) |
| **Stata (valid license)** | Running Stata (only needed if you use Stata) | Just have it installed |
| **uv (Python package manager)** | Stata MCP depends on it | See the install steps in Section 5 |

> 💡 **MATLAB and Stata are two independent modules.** Configure only the one you actually use; you can skip the entire section for the other.

---

## 3. Step 1: Install Claude Code from the command line

Anthropic now recommends the **native installer** — it needs no Node.js and auto-updates in the background, which is the most hassle-free path.

### 3.1 Open the *right* terminal

Open **Windows PowerShell**. One pitfall here: **do not** open the x86 version, Git Bash, or the old CMD.

How: type "PowerShell" in the taskbar search box and open the plain one literally named "Windows PowerShell".

### 3.2 Run the install command

Paste this single line and press Enter:

```powershell
irm https://claude.ai/install.ps1 | iex
```

> **What does this line do?** `irm` (Invoke-RestMethod) downloads the install script, and `iex` (Invoke-Expression) runs it. The script automatically downloads the program and sets up your PATH — no administrator rights required.

After installation, the program itself lives here:

```
%USERPROFILE%\.local\bin\claude.exe
```

### 3.3 The critical step: close the terminal and reopen it

PATH changes only take effect in a **newly opened** terminal. So after installing, **close the current PowerShell window entirely, open a fresh one**, and then continue.

This step is the easiest to skip — and skipping it causes the next step to fail with "claude is not a command".

### 3.4 Verify the install

In the new terminal, type:

```powershell
claude --version
```

Seeing a version number means it installed successfully.

> ⚠️ If you get `claude : The term 'claude' is not recognized as a cmdlet...`, your PATH isn't set up yet. Fix it manually:
> Press `Win+R` → type `sysdm.cpl` and Enter → "Advanced" tab → "Environment Variables" → under the top "User variables" find `Path` and double-click it → "New" and enter `%USERPROFILE%\.local\bin` → confirm through all dialogs → **close and reopen the terminal**, then try again.

### 3.5 First login

Enter any project folder and run:

```powershell
claude
```

On first launch it automatically opens your browser to log in and authorize your Anthropic account. **You only log in once** — you won't need to again afterward.

---

## 4. Step 2: Configure MATLAB MCP

We use the **official** `matlab-mcp-core-server` published by MathWorks. Once installed, Claude Code gains 5 MATLAB tools: check code, run code, run a file, run a test file, and detect locally installed toolboxes.

### 4.1 First confirm MATLAB is on your system PATH

This is the most common pitfall. Test it in PowerShell:

```powershell
matlab -h
```

If the command isn't found, add MATLAB's `bin` directory to PATH. For example, if your MATLAB is on the D drive, the path usually looks like this (change the version number to match yours):

```
D:\Program Files\MATLAB\R2024b\bin
```

Add to PATH the same way as in 3.4 above, then **reopen the terminal** and run `matlab -h` again to confirm it works.

### 4.2 Download the Windows binary

Go to the official releases page and download `matlab-mcp-core-server-win64.exe`:

> https://github.com/matlab/matlab-mcp-core-server/releases

Put it somewhere **fixed that you won't move later**. We recommend **not** putting it inside MATLAB's install folder (it could get overwritten when you upgrade MATLAB). For example:

```
D:\tools\matlab-mcp-core-server-win64.exe
```

### 4.3 Register it with Claude Code

Use `--scope user` so it works across **all your projects** (configure once, use everywhere):

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe"
```

> **A few key points about this command**
> - The `--` (two hyphens) in the middle matters: it separates "Claude Code's own options" from "the arguments passed to the server". Don't omit it.
> - Wrap the path in double quotes to avoid errors from spaces in the path (such as `Program Files`).
> - A single backslash `\` is fine on the command line; you only need double backslashes `\\` (escaped) when writing the path into a JSON config file.

If you want to give it a default working directory:

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe" --initial-working-folder=D:\projects\my-project
```

### 4.4 A small tip

The new version uses "lazy loading": it only starts the MATLAB desktop the **first time you actually run MATLAB code**, so it won't pop up the moment you open a terminal. Use the latest version.

---

## 5. Step 3: Configure Stata MCP

We use the community-maintained **MCP-for-Stata** (package name `stata-mcp`), which lists Claude Code as a recommended client and is built for empirical research.

### 5.1 First install uv

Stata MCP depends on `uv` (a Python package manager). If you don't have it yet, install it first:

```powershell
pip install uv
```

> Requires Python 3.11 or newer. If you don't even have Python, install one from https://www.python.org first, or use uv's built-in Python management.

### 5.2 Check that the environment is ready

First confirm stata-mcp can find the Stata on your machine:

```powershell
uvx stata-mcp --usable
```

If it reports that Stata can't be found (`STATA_CLI not found`), it doesn't know where Stata is installed — refer to the "StataFinder" section of the project docs, or tell it the path via an environment variable when you add it.

### 5.3 Register it with Claude Code

**Option A: Add directly (recommended for beginners)**, available globally:

```powershell
claude mcp add stata-mcp --scope user -- uvx stata-mcp
```

**Option B: Configure per research project**, run inside a specific project directory:

```powershell
claude mcp add stata-mcp --scope project -- uvx stata-mcp
```

This creates a `.mcp.json` in that project's root, and the config applies only to that project. It suits "one environment per project, no cross-interference" and makes it easy to commit into git to share with your team.

**Option C: Official plugin** (installs both the MCP server and the Stata language server LSP, for more accurate autocomplete):

```powershell
claude plugin marketplace add sepinetam/stata-mcp
claude plugin install stata-toolbox -s user
```

> Stata-MCP supports Windows, macOS, and Linux, as well as the MP / SE / BE editions of Stata, and auto-detects your installation. Running Stata commands requires a valid Stata license.

---

## 6. Verify everything is ready

List all configured MCP servers:

```powershell
claude mcp list
```

You should see `matlab` and `stata-mcp` (depending on which ones you configured).

After entering a Claude Code session, type this command to check connection status:

```
/mcp
```

Next to each server it shows the number of tools it provides and its connection status. Seeing "connected" means you're all set.

---

## 7. About "scope": do I have to configure it every time?

**No.** `claude mcp add` is a one-time setup — run it once and it sticks long-term. Whether it "stops working when you switch projects" depends on the scope you choose:

| Scope | How to add | Where it applies | Stored in |
|-------|-----------|------------------|-----------|
| `local` (default) | omit `--scope` | only the current project | `~/.claude.json` |
| `user` | add `--scope user` | **all** projects on this machine | `~/.claude.json` |
| `project` | add `--scope project` | the current project, committable to git | the project root's `.mcp.json` |

**Advice for beginners**: if you work solo and use MATLAB/Stata across multiple projects, just use `--scope user` everywhere — configure once, use anywhere, least hassle.

---

## 8. FAQ

**Q: After installing, typing `claude` says "not a command"?**
A: 90% of the time the PATH didn't update. First close and reopen the terminal; if that still fails, manually add `%USERPROFILE%\.local\bin` to your user PATH (see 3.4).

**Q: Claude Code still runs MATLAB through the raw command line, not MCP?**
A: First confirm the server is actually connected with `claude mcp list` and `/mcp`. If you originally configured it with `local` scope, it will "disappear" when you switch project directories — re-add it with `--scope user`.

**Q: MATLAB / Stata can't be found?**
A: For MATLAB, make sure its `bin` is on the system PATH (`matlab -h` works). For Stata, make sure `uvx stata-mcp --usable` passes.

**Q: Want to delete a server and reconfigure it?**

```powershell
claude mcp remove matlab
claude mcp remove stata-mcp
```

After removing, just `add` it again with the new arguments.

---

## 9. What you can do once it's set up

In a Claude Code session, you can give instructions in plain language, for example:

- "Run `analysis.do` for me and walk me through the regression results."
- "This MATLAB code throws an error — find it and fix it."
- "Reproduce the DID estimate from this paper using `firm_panel.dta` in my dataset."
- "Detect which MATLAB toolboxes I have installed locally."

Claude Code uses MCP tools to **actually run** MATLAB / Stata, get the real output, and then analyze it for you — instead of guessing code and making up results.

> 💡 If you do **DSGE / macro modeling**, this repo's `dynare-mod` skill works best paired with the MATLAB MCP: the MCP runs Dynare, while the skill turns your economic intuition into a working `.mod` file. See the [README](../README.md) for installation.

---

## 10. References

- Claude Code MCP official docs: https://code.claude.com/docs/en/mcp
- MATLAB MCP Core Server: https://github.com/matlab/matlab-mcp-core-server
- Stata-MCP docs: https://docs.statamcp.com
- Stata-MCP project: https://github.com/SepineTam/stata-mcp

> ⚠️ **Security note**: MCP lets the AI read and write your files and run system commands directly. Before connecting any server, make sure you trust its source, and keep a human-confirmation step for sensitive operations.
