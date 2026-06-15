# MATLAB / Stata を Claude Code に接続する（MCP セットアップガイド、Windows）

> **このガイドは完全な初心者向けです。** ゼロから順を追って説明します。コマンドラインで Claude Code をインストールし、MATLAB と Stata を「差し込む」ことで、AI があなたのコードを直接実行し、エラーを修正し、結果を読み取れるようにします。
>
> 言語: [English](./mcp-setup-guide.md) ｜ [中文](./mcp-setup-guide_zh-CN.md) ｜ **日本語**

---

## 1. まず、このガイドが解決する問題

Claude Code は Anthropic の**コマンドライン AI コーディングアシスタント**です——ターミナルで普通の言葉で指示すると、コードを書き、バグを直し、プログラムを実行してくれます。

しかし、初期状態では、あなたのマシンにインストールされた MATLAB や Stata を**操作できません**。それを可能にするには、**MCP** という一種の「変換プラグ」を与えます。このガイドを読み終える頃には、「スーパーワークベンチ」が手に入ります——ターミナルから自然言語で AI に MATLAB と Stata を操作させられるのです。

### よくある混乱: VSCode 拡張機能はもう入れた——なぜまだ MCP が必要なのか？

多くの人がこう尋ねます。「VSCode に MATLAB 拡張機能を入れているのに、なぜ Claude Code は遠回りするの？」

たとえ話をしましょう。

- **VSCode 拡張機能は「人間であるあなた」のためのものです** ——シンタックスハイライト、自動補完、実行ボタン。画面の前に座っているあなたのために働くのであって、「MATLAB を実行する能力」を AI に渡すわけではありません。
- **MCP は「AI」のためのインターフェースです。** AI アシスタントである Claude Code が認識するツールは 2 種類だけです: (1) 自身の組み込みツール（ファイルの読み書き、シェルコマンドの実行）、(2) **あなた自身が設定した MCP サーバー**。

したがって、AI に MATLAB / Stata を実際に使わせる唯一の方法は、**MCP（Model Context Protocol、モデルコンテキストプロトコル）サーバー**を与えることです——AI とソフトウェアの間をつなぐ標準化された「プラグ」だと考えてください。以下では、そのプラグの差し込み方を説明します。

---

## 2. 始める前のチェックリスト

始める前に、以下が揃っていることを確認してください（使わないものはスキップして構いません）。

| 必要なもの | 何のため | 入手方法 |
|-----------|---------|---------|
| **Git for Windows** | Claude Code が内部でコマンドを実行するために使う——**必須** | https://git-scm.com からダウンロードし、デフォルトでインストール。「Add Git to PATH」にチェックを入れる |
| **有料の Claude プラン** | Claude Code の利用にはサブスクリプションまたは API クレジットが必要 | Pro / Max / Team / Enterprise のいずれか、または Anthropic Console の API クレジット |
| **MATLAB（2020b 以降）** | MATLAB の実行（MATLAB を使う場合のみ必要） | インストール済みでよいが、システム PATH に追加する（第 4 節参照） |
| **Stata（有効なライセンス）** | Stata の実行（Stata を使う場合のみ必要） | インストール済みでよい |
| **uv（Python パッケージマネージャ）** | Stata MCP が依存する | 第 5 節のインストール手順を参照 |

> 💡 **MATLAB と Stata は互いに独立したモジュールです。** 実際に使う方だけを設定すればよく、もう一方は節ごとスキップできます。

---

## 3. ステップ 1: コマンドラインで Claude Code をインストールする

Anthropic は現在、**ネイティブインストーラ（native installer）**を推奨しています——Node.js が不要で、バックグラウンドで自動更新されるため、最も手間がかかりません。

### 3.1 「正しい」ターミナルを開く

**Windows PowerShell** を開きます。ここに落とし穴があります: x86 版、Git Bash、旧来の CMD を**開かないでください**。

方法: タスクバーの検索ボックスに「PowerShell」と入力し、まさに「Windows PowerShell」という名前の普通のものを開きます。

### 3.2 インストールコマンドを実行する

次の 1 行を貼り付けて Enter を押します。

```powershell
irm https://claude.ai/install.ps1 | iex
```

> **この行は何をしているのか？** `irm`（Invoke-RestMethod）がインストールスクリプトをダウンロードし、`iex`（Invoke-Expression）がそれを実行します。スクリプトが自動でプログラムをダウンロードし PATH を設定します——管理者権限は不要です。

インストール後、プログラム本体はここに置かれます。

```
%USERPROFILE%\.local\bin\claude.exe
```

### 3.3 重要なステップ: ターミナルを閉じて開き直す

PATH の変更は、**新しく開いた**ターミナルでのみ有効になります。そのため、インストール後は**現在の PowerShell ウィンドウを完全に閉じ、新しいものを開いて**から続けてください。

このステップは最も見落とされやすく、スキップすると次のステップで「claude はコマンドではありません」というエラーになります。

### 3.4 インストールを確認する

新しいターミナルで次を入力します。

```powershell
claude --version
```

バージョン番号が表示されれば、インストール成功です。

> ⚠️ `claude : 用語 'claude' は、コマンドレットの名前として認識されません...` というエラーが出たら、PATH がまだ設定されていません。手動で修正します。
> `Win+R` を押す → `sysdm.cpl` と入力して Enter → 「詳細設定」タブ → 「環境変数」 → 上部の「ユーザー環境変数」で `Path` を見つけてダブルクリック → 「新規」で `%USERPROFILE%\.local\bin` を入力 → すべてのダイアログで OK → **ターミナルを閉じて開き直し**、もう一度試す。

### 3.5 初回ログイン

任意のプロジェクトフォルダに入り、次を実行します。

```powershell
claude
```

初回起動時に自動でブラウザが開き、Anthropic アカウントでログインして認可します。**ログインは一度だけ**で、以降は不要です。

---

## 4. ステップ 2: MATLAB MCP を設定する

MathWorks が公開する**公式**の `matlab-mcp-core-server` を使います。インストールすると、Claude Code に 5 つの MATLAB ツールが追加されます: コードのチェック、コードの実行、ファイルの実行、テストファイルの実行、ローカルにインストールされたツールボックスの検出。

### 4.1 まず MATLAB がシステム PATH にあることを確認する

これが最もよくある落とし穴です。PowerShell でテストします。

```powershell
matlab -h
```

コマンドが見つからない場合は、MATLAB の `bin` ディレクトリを PATH に追加します。たとえば MATLAB が D ドライブにある場合、パスは通常このようになります（バージョン番号は実際のものに変えてください）。

```
D:\Program Files\MATLAB\R2024b\bin
```

上記 3.4 と同じ方法で PATH に追加し、**ターミナルを開き直して**から、もう一度 `matlab -h` を実行して通ることを確認します。

### 4.2 Windows 版バイナリをダウンロードする

公式の releases ページで `matlab-mcp-core-server-win64.exe` をダウンロードします。

> https://github.com/matlab/matlab-mcp-core-server/releases

ダウンロード後、**今後動かさない固定の場所**に置きます。MATLAB のインストールフォルダ内に置か**ない**ことを推奨します（MATLAB のアップグレード時に上書きされる恐れがあります）。たとえば:

```
D:\tools\matlab-mcp-core-server-win64.exe
```

### 4.3 Claude Code に登録する

`--scope user` を使い、**すべてのプロジェクト**で使えるようにします（一度設定すればどこでも使えます）。

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe"
```

> **このコマンドの要点**
> - 真ん中の `--`（ハイフン 2 つ）が重要です。これは「Claude Code 自身のオプション」と「サーバーに渡す引数」を区切ります。省略しないでください。
> - パスを二重引用符で囲み、パス内のスペース（`Program Files` など）によるエラーを防ぎます。
> - コマンドラインではバックスラッシュ 1 つ `\` で構いません。二重のバックスラッシュ `\\`（エスケープ）が必要なのは、パスを JSON 設定ファイルに書くときだけです。

デフォルトの作業ディレクトリを指定したい場合は:

```powershell
claude mcp add --transport stdio matlab --scope user -- "D:\tools\matlab-mcp-core-server-win64.exe" --initial-working-folder=D:\projects\my-project
```

### 4.4 ちょっとしたヒント

新しいバージョンは「遅延読み込み」を使います: **実際に MATLAB コードを実行する初回**にのみ MATLAB デスクトップを起動するため、ターミナルを開いた瞬間にポップアップすることはありません。最新版を使ってください。

---

## 5. ステップ 3: Stata MCP を設定する

コミュニティがメンテナンスする **MCP-for-Stata**（パッケージ名 `stata-mcp`）を使います。Claude Code を推奨クライアントとして挙げており、実証研究向けに作られています。

### 5.1 まず uv をインストールする

Stata MCP は `uv`（Python パッケージマネージャ）に依存します。まだ無ければ、先にインストールします。

```powershell
pip install uv
```

> Python 3.11 以降が必要です。Python すら無い場合は、まず https://www.python.org からインストールするか、uv の組み込み Python 管理機能を使ってください。

### 5.2 環境が準備できているか確認する

まず stata-mcp がマシン上の Stata を見つけられるか確認します。

```powershell
uvx stata-mcp --usable
```

Stata が見つからない（`STATA_CLI not found`）と表示される場合、Stata のインストール場所を認識していません——プロジェクトドキュメントの "StataFinder" の節を参照するか、追加時に環境変数でパスを伝えてください。

### 5.3 Claude Code に登録する

**方法 A: 直接追加（初心者推奨）**、グローバルに利用可能:

```powershell
claude mcp add stata-mcp --scope user -- uvx stata-mcp
```

**方法 B: 研究プロジェクトごとに設定**、特定のプロジェクトディレクトリ内で実行:

```powershell
claude mcp add stata-mcp --scope project -- uvx stata-mcp
```

これはそのプロジェクトのルートに `.mcp.json` を作成し、設定はそのプロジェクトにのみ適用されます。「プロジェクトごとに 1 つの環境、相互干渉なし」に適しており、git にコミットしてチームと共有するのも簡単です。

**方法 C: 公式プラグイン**（MCP サーバーと Stata 言語サーバー LSP の両方をインストールし、補完がより正確に）:

```powershell
claude plugin marketplace add sepinetam/stata-mcp
claude plugin install stata-toolbox -s user
```

> Stata-MCP は Windows、macOS、Linux に対応し、Stata の MP / SE / BE 各エディションにも対応、インストールを自動検出します。Stata コマンドの実行には有効な Stata ライセンスが必要です。

---

## 6. すべて準備できたか確認する

設定済みの MCP サーバーを一覧表示します。

```powershell
claude mcp list
```

`matlab` と `stata-mcp`（設定した方）が表示されるはずです。

Claude Code のセッションに入ったら、次のコマンドで接続状態を確認します。

```
/mcp
```

各サーバーの隣に、提供するツール数と接続状態が表示されます。「接続済み」が見えれば完了です。

---

## 7. 「スコープ（scope）」について: 毎回設定が必要？

**いいえ。** `claude mcp add` は一度きりの設定で、一度実行すれば長期間有効です。「プロジェクトを切り替えると効かなくなる」かどうかは、選ぶスコープ次第です。

| スコープ | 追加方法 | 適用範囲 | 保存先 |
|---------|---------|---------|--------|
| `local`（デフォルト） | `--scope` を省略 | 現在のプロジェクトのみ | `~/.claude.json` |
| `user` | `--scope user` を追加 | このマシンの**すべて**のプロジェクト | `~/.claude.json` |
| `project` | `--scope project` を追加 | 現在のプロジェクト、git にコミット可能 | プロジェクトルートの `.mcp.json` |

**初心者へのアドバイス**: 一人で作業し、複数のプロジェクトで MATLAB/Stata を使うなら、どこでも `--scope user` を使いましょう——一度設定すればどこでも使え、最も手間がかかりません。

---

## 8. よくある質問（FAQ）

**Q: インストール後に `claude` と入力すると「コマンドではない」と出る？**
A: 90% は PATH が更新されていません。まずターミナルを閉じて開き直す。それでもダメなら、`%USERPROFILE%\.local\bin` をユーザー PATH に手動で追加します（3.4 参照）。

**Q: Claude Code がまだ MCP ではなく生のコマンドラインで MATLAB を実行する？**
A: まず `claude mcp list` と `/mcp` でサーバーが実際に接続されているか確認します。最初に `local` スコープで設定した場合、プロジェクトディレクトリを切り替えると「見えなく」なります——`--scope user` で追加し直してください。

**Q: MATLAB / Stata が見つからない？**
A: MATLAB は `bin` がシステム PATH にあること（`matlab -h` が通る）を確認します。Stata は `uvx stata-mcp --usable` が通ることを確認します。

**Q: サーバーを削除して再設定したい？**

```powershell
claude mcp remove matlab
claude mcp remove stata-mcp
```

削除後、新しい引数でもう一度 `add` するだけです。

---

## 9. 設定後にできること

Claude Code のセッションで、普通の言葉で指示できます。たとえば:

- 「`analysis.do` を実行して、回帰結果を解説して。」
- 「この MATLAB コードがエラーを出す——見つけて直して。」
- 「この論文の DID 推定を、私のデータセットの `firm_panel.dta` を使って再現して。」
- 「ローカルにインストールされている MATLAB ツールボックスを検出して。」

Claude Code は MCP ツールを使って MATLAB / Stata を**実際に実行**し、本物の出力を取得してから分析します——コードを当て推量したり結果をでっち上げたりはしません。

> 💡 **DSGE / マクロモデリング**を行うなら、このリポジトリの `dynare-copilot` skill は MATLAB MCP と組み合わせると最も効果的です: MCP が Dynare を実行し、skill があなたの経済直感を動作する `.mod` ファイルに変えます。インストール方法は [README](../README_ja.md) を参照してください。

---

## 10. 参考リンク

- Claude Code MCP 公式ドキュメント: https://code.claude.com/docs/en/mcp
- MATLAB MCP Core Server: https://github.com/matlab/matlab-mcp-core-server
- Stata-MCP ドキュメント: https://docs.statamcp.com
- Stata-MCP プロジェクト: https://github.com/SepineTam/stata-mcp

> ⚠️ **セキュリティに関する注意**: MCP は AI にファイルの読み書きやシステムコマンドの実行を直接許可します。どのサーバーに接続する前にも、その出所を信頼できることを確認し、機微な操作には人間による確認のステップを残してください。
