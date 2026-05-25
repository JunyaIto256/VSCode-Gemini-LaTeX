// ============================================================
//  VSCode + Gemini & LaTeX 環境構築ガイド
// ============================================================

#set document(
  title: "VSCode + Gemini & LaTeX 環境構築ガイド",
  author: "",
)

#set page(
  paper: "a4",
  margin: (top: 25mm, bottom: 25mm, left: 25mm, right: 25mm),
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 {
      align(right, text(size: 9pt, fill: gray)[VSCode + Gemini \& LaTeX 環境構築ガイド])
    }
  },
)

#set text(
  lang: "ja",
  font: ("Hiragino Mincho ProN", "Yu Mincho", "MS Mincho", "Arial Unicode MS", "Times"),
  size: 11pt,
)

#set heading(numbering: "1.1.")
#set par(leading: 0.9em, justify: true)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.5em)
  block[
    #set text(size: 15pt)
    #it
  ]
  v(0.3em)
}

#show heading.where(level: 2): it => {
  v(0.3em)
  block[
    #set text(size: 13pt)
    #it
  ]
  v(0.1em)
}

#show heading.where(level: 3): it => {
  v(0.2em)
  block[
    #set text(size: 11pt)
    #it
  ]
}

// --- カラーボックス定義 ---
#let tip-box(body) = block(
  fill: rgb("#e8f5e9"),
  inset: (x: 12pt, y: 9pt),
  radius: 4pt,
  width: 100%,
  stroke: (left: (thickness: 4pt, paint: rgb("#4caf50"))),
)[
  #text(weight: "bold", fill: rgb("#2e7d32"))[ヒント] #h(0.5em) #body
]

#let caution-box(body) = block(
  fill: rgb("#fff8e1"),
  inset: (x: 12pt, y: 9pt),
  radius: 4pt,
  width: 100%,
  stroke: (left: (thickness: 4pt, paint: rgb("#ff8f00"))),
)[
  #text(weight: "bold", fill: rgb("#e65100"))[注意] #h(0.5em) #body
]

#let note-box(body) = block(
  fill: rgb("#e3f2fd"),
  inset: (x: 12pt, y: 9pt),
  radius: 4pt,
  width: 100%,
  stroke: (left: (thickness: 4pt, paint: rgb("#1976d2"))),
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[メモ] #h(0.5em) #body
]

#let check-box(body) = block(
  fill: rgb("#fce4ec"),
  inset: (x: 12pt, y: 9pt),
  radius: 4pt,
  width: 100%,
  stroke: (left: (thickness: 4pt, paint: rgb("#c2185b"))),
)[
  #text(weight: "bold", fill: rgb("#880e4f"))[確認] #h(0.5em) #body
]

// --- キーボードショートカット表示 ---
#let kbd(key) = box(
  fill: rgb("#f5f5f5"),
  inset: (x: 5pt, y: 2pt),
  radius: 3pt,
  stroke: (paint: rgb("#bdbdbd"), thickness: 1pt),
)[#text(font: ("Consolas", "Courier New"), size: 9.5pt)[#key]]

// ============================================================
//  タイトルページ
// ============================================================
#align(center + horizon)[
  #v(2cm)

  #block(
    fill: rgb("#1a237e"),
    inset: (x: 30pt, y: 20pt),
    radius: 8pt,
    width: 85%,
  )[
    #text(size: 22pt, weight: "bold", fill: white)[
      VSCode + Gemini \& LaTeX
    ]
    #linebreak()
    #text(size: 14pt, fill: rgb("#b0bec5"))[
      環境構築ガイド
    ]
  ]

  #v(1.5cm)

  #text(size: 12pt)[
    AI を活用した学習・研究環境の構築
  ]

  #v(2cm)

  #block(
    stroke: rgb("#e0e0e0"),
    inset: 16pt,
    radius: 6pt,
    width: 80%,
  )[
    #set text(size: 11pt)
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      [*目標 1*], [VSCode 上で Gemini を Agent として使えるようになる],
      [], [],
      [*目標 2*], [VSCode 上で LaTeX をコンパイルして PDF を出力できるようになる],
      [], [],
      [*実践例*], [電磁気学のマクスウェル方程式を PDF で出力する],
    )
  ]

  #v(3cm)

  #text(size: 10pt, fill: gray)[2026 年度版]
]

#pagebreak()

// ============================================================
//  目次
// ============================================================
#outline(
  title: [目次],
  depth: 3,
  indent: 1.5em,
)

// ============================================================
//  1. はじめに
// ============================================================
= はじめに

本資料は，VSCode（Visual Studio Code）を中心とした学習・研究環境を構築するためのステップバイステップガイドです．

*達成目標：*

+ *メイン目標*: VSCode 上で Google の AI「Gemini」を Agent として使えるようになる
+ *追加目標*: VSCode 上で LaTeX をコンパイルし，美しい PDF を出力できるようになる
+ *実践例*: 電磁気学のマクスウェル方程式を LaTeX で記述し，PDF として出力する

各ステップを順に実施すれば必ず環境が整います．エラーが出ても落ち着いて対処しましょう．

#note-box[本資料は主に *Windows* を対象としています．macOS・Linux の場合は，各節の該当箇所を読み替えてください．]

== 全体の流れ

#table(
  columns: (auto, auto, 1fr),
  align: (center, left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*手順*], [*内容*], [*所要時間の目安*],
  [1], [VSCode のインストール], [10 分],
  [2], [Gemini Code Assist の設定], [15 分],
  [3], [TeX Live のインストール], [30〜120 分（ダウンロードに依存）],
  [4], [LaTeX Workshop の設定], [15 分],
  [5], [マクスウェル方程式の出力確認], [10 分],
)

// ============================================================
//  2. VSCode のインストール
// ============================================================
= VSCode のインストール

Visual Studio Code（VSCode）は Microsoft が開発した無料のエディタです．
軽量でありながら拡張機能により LaTeX 編集・AI アシスタントなど多様な用途に使えます．

== ダウンロードとインストール

=== Windows

+ ブラウザで以下の URL にアクセスする：
  #block(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt)[`https://code.visualstudio.com/`]
+ 青い「Download for Windows」ボタンをクリックし，インストーラー（`.exe`）をダウンロードする
+ ダウンロードしたファイルをダブルクリックして実行する
+ インストールのオプション画面では，以下を*必ずチェックする*：
  - 「PATH への追加（再起動後に使用可能）」
  - 「エクスプローラーのファイルコンテキストメニューに \[Codeで開く\] アクションを追加する」
+ 「インストール」ボタンを押して完了を待つ

#caution-box[「PATH への追加」を忘れると，ターミナルから `code` コマンドで VSCode を起動できません．インストール後にターミナルで `code --version` を実行して確認してください．]

=== macOS

+ `https://code.visualstudio.com/` からダウンロードする
  - M1/M2/M3 Mac（Apple Silicon）は「Apple Silicon」版を選ぶ
  - Intel Mac は「Intel chip」版を選ぶ
+ ダウンロードした `.zip` を展開し，`Visual Studio Code.app` を「アプリケーション」フォルダに移動する
+ VSCode を起動し，コマンドパレット（#kbd("Shift+Cmd+P")）を開く
+ 「Shell Command: Install 'code' command in PATH」と入力して実行する

=== Linux (Ubuntu/Debian)

```bash
# Microsoft のリポジトリを追加して VSCode をインストール
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 \
  packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
  https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update && sudo apt install code
```

== 初期設定

=== 日本語 UI のインストール

+ 拡張機能パネル（#kbd("Ctrl+Shift+X")）を開く
+ 検索欄に「Japanese Language Pack」と入力する
+ Microsoft 製「Japanese Language Pack for Visual Studio Code」をインストールする
+ 再起動すると UI が日本語になる

=== おすすめ設定

設定ファイル（#kbd("Ctrl+,")）から以下を変更することを推奨します：

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*設定項目*], [*推奨値*],
  [`Editor: Font Family`], [`'Consolas', 'Courier New', monospace`],
  [`Editor: Font Size`], [`14`],
  [`Editor: Tab Size`], [`2` または `4`],
  [`Editor: Word Wrap`], [`on`（折り返し表示）],
  [`Files: Auto Save`], [`afterDelay`（自動保存）],
)

// ============================================================
//  3. Gemini を Agent として使う
// ============================================================
= Gemini を Agent として使う

Google の AI「Gemini」を VSCode で使うには，*Gemini Code Assist* 拡張機能を導入します．
これは Google が公式に提供する無料のコーディング支援ツールです．

== Gemini Code Assist とは

Gemini Code Assist は，Gemini モデルを搭載した AI プログラミングアシスタントです．
主な機能は以下の通りです：

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*機能*], [*説明*],
  [コード補完], [入力中にリアルタイムでコードを提案．Tab で受け入れ],
  [チャット], [コードについて質問・コード生成を自然言語で依頼],
  [Agent モード], [複数ファイルの読み書き・コマンド実行など自律的にタスクを実行],
  [インライン編集], [選択範囲を指定して部分的な修正を依頼],
)

*無料枠*（個人利用，Google アカウント必要）：
- コード補完: 月 6,000 回
- チャット: 月 240 回

== インストール手順

=== Step 1: 拡張機能のインストール

+ VSCode の拡張機能パネル（#kbd("Ctrl+Shift+X")）を開く
+ 検索欄に「Gemini Code Assist」と入力する
+ *発行元が Google であること*を確認して「インストール」をクリックする

#note-box[似た名前の拡張機能が複数存在します．必ず「*Google*」が発行元のものを選んでください．]

=== Step 2: Google アカウントでサインイン

+ インストール後，VSCode の左サイドバーに Gemini のアイコン（星形）が表示される
+ アイコンをクリックするか，コマンドパレット（#kbd("Ctrl+Shift+P")）から「Gemini: Sign In」を実行する
+ ブラウザが開くので，Google アカウントでログインする
+ アクセス許可を求められたら「許可」をクリックする
+ VSCode に戻るとサインイン完了

#caution-box[大学メールアドレス（`@ms.saitama-u.ac.jp`）でサインインすると，組織のポリシーにより機能が制限される場合があります．個人の Gmail アカウントの使用を推奨します．]

=== Step 3: 動作確認

サインイン後，左サイドバーの Gemini アイコンをクリックしてチャットパネルを開き，
以下のメッセージを送信してみましょう：

```
こんにちは！VSCode 上で Gemini が使えるか確認しています．
```

Gemini から返答が来れば設定完了です．

== Gemini Chat の使い方

=== チャットパネルの操作

チャットパネルはサイドバーの Gemini アイコンから開きます．
または #kbd("Ctrl+Shift+P") → 「Gemini: Open Chat」でも開けます．

```
# 入力例（自然な日本語で OK）

このコードの動作を説明してください

以下のエラーの解決方法を教えてください：
[エラーメッセージを貼り付ける]

Python で CSV ファイルを読み込んで平均値を計算するコードを書いてください
```

=== ファイルの参照

チャット入力欄で `@` を入力すると，プロジェクト内のファイルを参照できます：

```
@maxwell.tex  このファイルにある数式の意味を説明してください
```

== Agent モードの活用

Agent モードでは，Gemini が複数のステップを*自律的に実行*します．
ファイルの読み書き・コマンド実行などもできます．

=== Agent モードの起動

チャットパネル下部の「*Agent Preview*」をonにします．

=== Agent モードの活用例

```
プロジェクト内のすべての .tex ファイルを確認して，
使用しているパッケージの一覧をまとめてください
```

```
maxwell.tex を開いて，数式の番号を付け直してください
```

```
README.md を日本語で作成してください
```

#caution-box[Agent モードはファイルを自動編集します．大切なファイルはあらかじめバックアップを取るか，Git でバージョン管理することを強く推奨します．（Git についてはここでは説明しませんが，知りたい人はAIに聞いてみてください．というか，GitはAIに操作させた方が良いかもしれません．）]

== インライン補完の使い方

コードを書いているとき，Gemini が補完候補を薄いグレーで表示します：

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: none,
  [#kbd("Tab")], [候補を受け入れる],
  [#kbd("Esc")], [候補を無視する],
  [#kbd("Ctrl+Enter")], [複数の候補を表示する],
  [#kbd("Alt+]")], [次の候補を表示する],
)

// ============================================================
//  4. LaTeX 環境の構築
// ============================================================
= LaTeX 環境の構築（追加目標）

LaTeX は論文・技術文書を美しくタイプセットするためのシステムです．
理工系の学術論文では事実上の標準となっています．

== TeX Live のインストール

TeX Live は LaTeX の実行環境（処理系）です．まずこれをインストールします．

=== Windows

==== 公式インストーラーを使う方法（推奨）

+ 以下にアクセスする：
  #block(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt)[`https://www.tug.org/texlive/`]
+ 「download」をクリックし，「install-tl-windows.exe」をダウンロードする
+ ダウンロードしたファイルを*管理者として実行*する
+ インストーラーが起動したら「Install」をクリックして待つ

#caution-box[
  フルインストールには *約 7〜8 GB のディスク容量*と *1〜2 時間*かかります．
  ネットワーク環境の良い場所（学内 Wi-Fi など）で行ってください．
  途中でキャンセルしないでください．
]

インストール後，コマンドプロンプト（Win+R → `cmd`）で確認します：

```
lualatex --version
```

バージョン情報が表示されれば成功です．

==== winget を使う方法

```powershell
winget install --id TeXLive.TeXLive
```

または MiKTeX（必要なパッケージを自動ダウンロードする軽量版）：

```powershell
winget install --id MiKTeX.MiKTeX
```

=== macOS

MacTeX（macOS 向け TeX Live）をインストールします：

+ `https://www.tug.org/mactex/` にアクセスする
+ 「MacTeX Download」をクリックし，`.pkg`（約 4GB）をダウンロードする
+ ダウンロードしたファイルをダブルクリックしてインストールする

または Homebrew を使う場合：

```bash
brew install --cask mactex-no-gui
```

=== Linux (Ubuntu/Debian)

```bash
# フルインストール（推奨，約 5GB）
sudo apt-get install texlive-full

# 日本語のみ必要な場合（最小構成）
sudo apt-get install texlive-lang-japanese \
  texlive-latex-extra texlive-fonts-recommended
```

== LaTeX Workshop 拡張機能のインストール

LaTeX Workshop は VSCode で LaTeX を書くための最も人気のある拡張機能です．

+ 拡張機能パネル（#kbd("Ctrl+Shift+X")）を開く
+ 「LaTeX Workshop」と検索する
+ *James Yu* 氏の「LaTeX Workshop」をインストールする

主な機能：
- 保存時に自動コンパイル
- PDF プレビュー（VSCode 内で表示）
- シンタックスハイライトとコマンド補完
- SyncTeX（PDF とソースの双方向ジャンプ）
- エラーメッセージの可視化

== settings.json の設定

VSCode の設定ファイル `settings.json` を編集して，LaTeX Workshop の動作を設定します．

=== 設定ファイルを開く

+ #kbd("Ctrl+Shift+P") でコマンドパレットを開く
+ `Preferences: Open User Settings (JSON)` と入力して選択する
+ `settings.json` が開く

=== 設定の追加

以下の内容を `settings.json` に追加してください
（既存の `{...}` の内部に追記します）：

```json
{
  // === LaTeX Workshop 設定 ===

  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ],
      "env": {}
    }
  ],

  "latex-workshop.latex.recipes": [
    {
      "name": "latexmk",
      "tools": ["latexmk"]
    }
  ],

  "latex-workshop.view.pdf.viewer": "tab",

  "latex-workshop.latex.autoBuild.run": "onSave",

  "latex-workshop.synctex.afterBuild.enabled": true,

  "latex-workshop.latex.autoClean.run": "onFailed",

  "latex-workshop.latex.clean.fileTypes": [
    "*.aux", "*.bbl", "*.blg", "*.idx", "*.ind",
    "*.lof", "*.lot", "*.out", "*.toc",
    "*.fls", "*.log", "*.fdb_latexmk",
    "*.snm", "*.nav", "*.dvi", "*.synctex.gz"
  ]
}
```

#tip-box[`settings.json` に既に設定がある場合は，既存の `{` と `}` の*内側*に追記してください．JSON では，最後の要素の後ろにカンマを付けてはいけません．]

=== 設定項目の説明

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*設定名*], [*説明*],
  [`latex.tools`], [コンパイルに使うコマンドを定義する],
  [`latex.recipes`], [ビルドレシピ（ツールの組み合わせ）を定義する],
  [`view.pdf.viewer`], [PDF を VSCode のタブ内で表示する],
  [`autoBuild.run`], [ファイル保存時に自動コンパイルする],
  [`synctex.afterBuild.enabled`], [コンパイル後に PDF の対応箇所に移動する],
  [`autoClean.run`], [ビルド失敗時に中間ファイルを削除する],
)

== .latexmkrc の設定

`.latexmkrc` は `latexmk` コマンドの動作を設定するファイルです．
ここで使用する処理系（LuaLaTeX や upLaTeX など）を指定します．

=== ファイルの配置場所

`.latexmkrc` は以下のどちらかに配置します：

- *プロジェクトフォルダ内*: そのフォルダのみに適用
- *ホームディレクトリ*: 全プロジェクトに適用
  - Windows: `C:\Users\ユーザー名\.latexmkrc`
  - macOS/Linux: `~/.latexmkrc`

=== LuaLaTeX を使う場合（推奨）

LuaLaTeX は Unicode を完全サポートし，日本語も扱いやすい現代的な処理系です．
以下の内容で `.latexmkrc` を作成してください：

```perl
#!/usr/bin/env perl

# LuaLaTeX で直接 PDF を生成する（pdf_mode = 4）
$pdf_mode = 4;

# LuaLaTeX のオプション
$lualatex = 'lualatex -synctex=1 -halt-on-error '
           . '-interaction=nonstopmode %O %S';

# 参考文献の処理
$bibtex = 'upbibtex %O %B';

# 索引の処理（日本語対応）
$makeindex = 'mendex %O -o %D %S';

# クリーンアップ対象ファイル
$clean_full_ext = '%R.synctex.gz %R.auxlock';
```

=== upLaTeX を使う場合（日本語 LaTeX の伝統的な処理系）

```perl
#!/usr/bin/env perl

# DVI 経由で PDF を生成する（pdf_mode = 3）
$pdf_mode = 3;

# upLaTeX のオプション
$latex = 'uplatex -synctex=1 -halt-on-error '
       . '-interaction=nonstopmode %O %S';

# DVI → PDF 変換
$dvipdf = 'dvipdfmx %O -o %D %S';

# 参考文献の処理
$bibtex = 'upbibtex %O %B';

# 索引の処理
$makeindex = 'mendex %O -o %D %S';
```

#note-box[本資料では *LuaLaTeX を推奨*します．Unicode をネイティブにサポートし，日本語の設定が簡単です．upLaTeX は既存の日本語文書との互換性が必要な場合に使用してください．]

=== Windows でファイルを作成する方法

VSCode のターミナル（#kbd("Ctrl+@")）を開いて以下を実行すると確実です：

```powershell
# PowerShell: ホームディレクトリに .latexmkrc を作成して開く
New-Item -Path "$HOME\.latexmkrc" -ItemType File -Force
code "$HOME\.latexmkrc"
```

=== 動作確認

以下の内容で `test.tex` を作成して動作確認します：

```latex
\documentclass[lualatex, a4paper, 12pt]{jlreq}

\title{動作確認}
\author{自分の名前}
\date{\today}

\begin{document}
\maketitle

\section{はじめに}
LaTeX の動作確認用ファイルです．

\begin{equation}
  E = mc^2
\end{equation}

\end{document}
```

ファイルを保存（#kbd("Ctrl+S")）すると自動でコンパイルが始まります．
右上の PDF アイコン（または #kbd("Ctrl+Alt+V")）をクリックして PDF を確認します．

#tip-box[コンパイルのログは「出力」パネル（#kbd("Ctrl+Shift+U")）の「LaTeX Workshop」を選択すると確認できます．エラーが出た場合は必ずここを見てください．]

// ============================================================
//  5. 例：マクスウェル方程式
// ============================================================
= 例：マクスウェル方程式

電磁気学の基本方程式であるマクスウェル方程式を LaTeX で記述し，PDF として出力します．

== マクスウェル方程式について

マクスウェル方程式は電磁気学を支配する 4 つの方程式の組です．
電場 $bold(E)$，磁場 $bold(B)$，電荷密度 $rho$，電流密度 $bold(J)$ の関係を記述します．

=== 微分形

$
  nabla dot bold(E) = frac(rho, epsilon_0)
  quad & quad
  nabla dot bold(B) = 0
  \
  nabla times bold(E) = -frac(partial bold(B), partial t)
  quad & quad
  nabla times bold(B) = mu_0 bold(J) + mu_0 epsilon_0 frac(partial bold(E), partial t)
$

=== 文書クラス

文書クラスは `\documentclass[オプション]{クラス名}` で指定し，文書全体の体裁を決める．

#table(
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*クラス名*], [*対応処理系*], [*説明*],
  [`jlreq`], [LuaLaTeX / upLaTeX], [日本語組版規則（JIS X 4051）に準拠したモダンなクラス．*本資料で使用*],
  [`jsarticle`\/ `jsbook`], [upLaTeX / pLaTeX], [日本で広く使われてきた標準クラス．レポート・書籍向け],
  [`article`\/ `book`], [pdfLaTeX / LuaLaTeX], [LaTeX 標準クラス．英文向けだが日本語も使用可],
  [`beamer`], [LuaLaTeX など], [プレゼンテーションスライド作成用クラス],
)

#note-box[`jlreq` はオプションに処理系（`lualatex` など）を指定するだけで日本語が使える．日本語組版の新しい文書には `jlreq` を使うことを推奨する．]

=== 使用する主なパッケージ

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*パッケージ*], [*用途*],
  [`amsmath`], [高度な数式環境（`align` 環境など）],
  [`amssymb`], [数学記号の拡張],
  [`bm`], [太字のベクトル記号 `\bm{E}` など],
  [`physics`], [物理向けコマンド（`\div`，`\curl` など）],
)

== LaTeX ソースコード

以下の内容を `maxwell.tex` として保存してください
（`examples/maxwell.tex` として保存することを推奨します）：

```latex
% マクスウェル方程式 --- LuaLaTeX でコンパイル
\documentclass[lualatex, a4paper, 12pt]{jlreq}

% 数学パッケージ
\usepackage{amsmath}    % 高度な数式環境
\usepackage{amssymb}    % 数学記号
\usepackage{bm}         % 太字ベクトル \bm{...}

% ページ設定（オプション）
\usepackage{geometry}
\geometry{top=25mm, bottom=25mm, left=25mm, right=25mm}

\title{マクスウェル方程式}
\author{電磁気学}
\date{\today}

\begin{document}
\maketitle

\section{概要}

電磁気学はマクスウェル方程式と呼ばれる4つの方程式によって
完全に記述される．
電場 $\bm{E}$，磁場 $\bm{B}$，電荷密度 $\rho$，
電流密度 $\bm{J}$ を用いて表される．

\section{積分形}

\begin{align}
  \oint_S \bm{E} \cdot d\bm{A}
    &= \frac{Q}{\varepsilon_0}
    \tag{ガウスの法則}
    \label{eq:gauss_e}
    \\[8pt]
  \oint_S \bm{B} \cdot d\bm{A}
    &= 0
    \tag{磁気のガウスの法則}
    \label{eq:gauss_b}
    \\[8pt]
  \oint_C \bm{E} \cdot d\bm{l}
    &= -\frac{d}{dt} \int_S \bm{B} \cdot d\bm{A}
    \tag{ファラデーの法則}
    \label{eq:faraday}
    \\[8pt]
  \oint_C \bm{B} \cdot d\bm{l}
    &= \mu_0 \int_S \bm{J} \cdot d\bm{A}
       + \mu_0 \varepsilon_0 \frac{d}{dt}
         \int_S \bm{E} \cdot d\bm{A}
    \tag{アンペール--マクスウェルの法則}
    \label{eq:ampere}
\end{align}

\section{微分形}

ガウスの定理とストークスの定理を用いると，
積分形から微分形が導かれる．

\begin{align}
  \nabla \cdot \bm{E}
    &= \frac{\rho}{\varepsilon_0}
    \tag{ガウスの法則}
    \label{eq:gauss_e_diff}
    \\[8pt]
  \nabla \cdot \bm{B}
    &= 0
    \tag{磁気のガウスの法則}
    \label{eq:gauss_b_diff}
    \\[8pt]
  \nabla \times \bm{E}
    &= -\frac{\partial \bm{B}}{\partial t}
    \tag{ファラデーの法則}
    \label{eq:faraday_diff}
    \\[8pt]
  \nabla \times \bm{B}
    &= \mu_0 \bm{J}
       + \mu_0 \varepsilon_0 \frac{\partial \bm{E}}{\partial t}
    \tag{アンペール--マクスウェルの法則}
    \label{eq:ampere_diff}
\end{align}

\section{物理定数}

\begin{table}[h]
  \centering
  \caption{電磁気学の基本定数}
  \begin{tabular}{cll}
    \hline
    記号 & 名称 & 値 \\
    \hline
    $\varepsilon_0$ & 真空の誘電率 &
      $8.854 \times 10^{-12}\ \mathrm{F/m}$ \\
    $\mu_0$ & 真空の透磁率 &
      $4\pi \times 10^{-7}\ \mathrm{H/m}$ \\
    $c$ & 真空中の光速 &
      $c = 1/\sqrt{\mu_0 \varepsilon_0}
       \approx 3.0 \times 10^8\ \mathrm{m/s}$ \\
    \hline
  \end{tabular}
  \label{tab:constants}
\end{table}

\section{電磁波}

マクスウェル方程式から，電場と磁場が波として伝播すること
（電磁波）が導かれる．電場の波動方程式：

\begin{equation}
  \nabla^2 \bm{E}
  - \mu_0 \varepsilon_0 \frac{\partial^2 \bm{E}}{\partial t^2}
  = \bm{0}
\end{equation}

この波の速度は $c = 1/\sqrt{\mu_0\varepsilon_0}$ であり，
光速と一致する．これがマクスウェルによる
「光は電磁波である」という発見である．

\end{document}
```

== コンパイルと PDF の確認

=== VSCode での手順

+ `maxwell.tex` を VSCode で開く
+ #kbd("Ctrl+S") で保存すると自動コンパイルが始まる
+ 右上の PDF アイコンをクリック（または #kbd("Ctrl+Alt+V")）して PDF を確認する

=== SyncTeX の使い方

PDF と LaTeX ソースを行き来できます：

#table(
  columns: (1fr, auto),
  align: (left, left),
  stroke: none,
  [PDF 上で #kbd("Ctrl+クリック")], [→ 対応するソース行に移動],
  [ソース上で #kbd("Ctrl+Alt+J")], [→ PDF の対応箇所に移動],
)

=== よくあるエラーと対処法

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*エラー内容*], [*対処法*],
  [`package not found`], [`tlmgr install パッケージ名` でパッケージを追加],
  [`Undefined control sequence`], [コマンドのスペルを確認．必要なパッケージが `\usepackage` されているか確認],
  [`Missing \$ inserted`], [数式環境（`$...$` や `equation`）の対応が正しいか確認],
  [`Font not found`], [TeX Live を再インストール，またはフォント名を変更],
  [`File not found`], [ファイルパスを確認．拡張子も含めて正確に指定],
)

#tip-box[Gemini に「以下のエラーを解決してください：[エラーメッセージ]」と貼り付けると，具体的な解決策を提案してくれます！]

// ============================================================
//  6. 練習：Gemini Agent を使って LaTeX を書く
// ============================================================
= 練習：Gemini Agent を使って LaTeX を書く

== 課題

Gemini Agent に以下のプロンプトを与えて，*アインシュタイン方程式*の LaTeX ファイルを生成させよ．
生成されたコードをコンパイルし，後述する「正解の出力」と見比べて確認すること．

=== Gemini へのプロンプト例

```
一般相対性理論のアインシュタイン場の方程式を LaTeX で書いてください．
条件は以下の通りです：

- \documentclass[lualatex, a4paper, 12pt]{jlreq} を使う
- \usepackage{amsmath}, \usepackage{amssymb}, \usepackage{bm} を使う
- 宇宙項（\Lambda）を含む形で書く
- アインシュタインテンソルの定義式も書く
- 各記号（G_{μν}, R_{μν}, R, g_{μν}, T_{μν}, Λ, G, c）の説明を
  表か箇条書きでまとめる
- align 環境を使って数式番号を付ける
```

#tip-box[プロンプトが具体的であるほど，Gemini の出力が正確になります．条件を箇条書きで整理して伝えるのが効果的です．]

== 正解となる出力

以下の数式と記号説明が PDF に表示されれば正解です．

=== アインシュタインテンソルの定義

$ G_(mu nu) = R_(mu nu) - 1/2 R g_(mu nu) $

=== アインシュタイン場の方程式（宇宙項あり）

$ G_(mu nu) + Lambda g_(mu nu) = frac(8 pi G, c^4) T_(mu nu) $

=== 記号の説明

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#f5f5f5") } else { none },
  [*記号*], [*意味*],
  [$G_(mu nu)$], [アインシュタインテンソル（時空の曲率を表す）],
  [$R_(mu nu)$], [リッチテンソル（曲率の縮約）],
  [$R$], [リッチスカラー（スカラー曲率）],
  [$g_(mu nu)$], [計量テンソル（時空の距離構造を定める）],
  [$T_(mu nu)$], [エネルギー運動量テンソル（物質・エネルギーの分布）],
  [$Lambda$], [宇宙項（宇宙定数，真空エネルギーに対応）],
  [$G$], [ニュートンの重力定数　$G approx 6.674 times 10^(-11)$ N m² / kg²],
  [$c$], [真空中の光速　$c approx 3.0 times 10^8$ m/s],
)

=== 確認ポイント

以下をすべて満たしていれば合格です：

+ アインシュタインテンソルの定義式 $G_(mu nu) = R_(mu nu) - 1/2 R g_(mu nu)$ が出力されている
+ 場の方程式 $G_(mu nu) + Lambda g_(mu nu) = 8 pi G \/ c^4 dot T_(mu nu)$ が出力されている
+ 各数式に番号が付いている（`align` 環境を使用）
+ 記号の説明が表または箇条書きで記載されている
+ エラーなしでコンパイルできる

#note-box[Gemini が生成したコードがそのままコンパイルできない場合は，エラーメッセージを Gemini に貼り付けて修正を依頼してみましょう．これも Agent との対話練習になります．]

// ============================================================
//  7. まとめ
// ============================================================
= まとめ

本資料で構築した環境のまとめです：

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*ツール*], [*用途*], [*状態*],
  [VSCode], [エディタ本体・すべての基盤], [完了],
  [日本語パック], [UI を日本語化], [完了],
  [Gemini Code Assist], [AI コーディング支援・Agent], [完了],
  [TeX Live], [LaTeX 処理系（LuaLaTeX 含む）], [完了],
  [LaTeX Workshop], [VSCode で LaTeX を快適に書く拡張機能], [完了],
  [`settings.json`], [LaTeX Workshop の自動コンパイル設定], [完了],
  [`.latexmkrc`], [LuaLaTeX を使うための latexmk 設定], [完了],
  [`maxwell.tex`], [マクスウェル方程式の PDF 出力確認], [完了],
)

== 次のステップ

環境が整ったら，以下にチャレンジしてみましょう：

+ *Gemini × LaTeX*: チャットで「アンペールの法則を LaTeX の `align` 環境で書いて」と依頼してみる
+ *レポートを LaTeX で*: 授業のレポートを LaTeX で書いてみる
+ *参考文献管理*: `biblatex` + `biber` で参考文献リストを自動生成する
+ *図の挿入*: `graphicx` パッケージで画像や PDF を文書に挿入する
+ *Beamer でスライド作成*: LaTeX でプレゼン資料を作る
+ *TikZ*で図の作成をしてみる

== 参考リンク

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: none,
  [*TeX Wiki*], [`https://texwiki.texjp.org/` 日本語の LaTeX 情報が充実],
  [*Overleaf*], [`https://www.overleaf.com/` ブラウザで使えるオンライン LaTeX（環境構築不要）],
  [*TeX Live 公式*], [`https://www.tug.org/texlive/`],
  [*jlreq クラス*], [`https://github.com/abenori/jlreq` 本資料で使用した文書クラス],
)

#note-box[エラーが出て困ったときは，エラーメッセージをそのまま Gemini に貼り付けて聞いてみてください．また，TA にも気軽に相談してください．]

#v(2em)
#align(center)[
  #text(size: 13pt, style: "italic")[Happy TeXing \& Coding!]
]

// ============================================================
//  付録：LaTeX 数学表記リファレンス
// ============================================================
#counter(heading).update(0)
#set heading(numbering: "A.1.")

= LaTeX 数学表記リファレンス

LaTeX で数式を書く際によく使う記法をまとめる．
コンパイルには断りがない限り `amsmath`・`amssymb`・`bm` を `\usepackage` しておく必要がある．

== 数学フォントスタイル

文字の形（書体）を変えるコマンドの一覧．
引数には英字1文字でなく文字列も指定できる（例：`\mathbf{ABC}`）．

#table(
  columns: (auto, auto, auto, 1fr),
  align: (left, center, left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*LaTeX コマンド*], [*出力例*], [*必要パッケージ*], [*主な用途*],
  [`\mathrm{A}`],     [$upright(A)$],          [（なし）],   [単位・演算子名（$upright(sin)$，$upright(d)x$ など）],
  [`\mathit{A}`],     [$A$],                   [（なし）],   [数式のデフォルト書体（通常は不要）],
  [`\mathbf{A}`],     [$bold(upright(A))$],     [（なし）],   [太字立体（行列・ベクトルの一部表記）],
  [`\boldsymbol{A}`], [$bold(A)$],              [`amsmath`],  [太字イタリック（ベクトル・行列の標準表記）],
  [`\bm{A}`],         [$bold(A)$],              [`bm`],       [`\boldsymbol` の改良版．ギリシャ文字にも有効],
  [`\mathcal{A}`],    [$cal(A)$],              [（なし）],   [筆記体（ラグランジアン $cal(L)$，集合族など）],
  [`\mathbb{R}`],     [$bb(R)$],               [`amssymb`],  [黒板太字（実数 $bb(R)$，複素数 $bb(C)$，整数 $bb(Z)$ など）],
  [`\mathsf{A}`],     [$sans(A)$],             [（なし）],   [サンセリフ体（行列表記の一流儀）],
  [`\mathtt{A}`],     [$mono(A)$],             [（なし）],   [等幅（コードや特定の定数）],
  [`\mathfrak{g}`],   [$frak(g)$],             [`amssymb`],  [フラクトゥール体（リー代数 $frak(g)$，$frak(s u)(2)$ など）],
)

#tip-box[物理のベクトルには `\bm{a}` が最も一般的（太字イタリック $bold(a)$）．\
数学の集合 $bb(R)$ や演算子名 $upright(sin)$ など，分野慣習に合わせて使い分ける．]

== アクセント・デコレータ

文字の上下に記号を付けるコマンドの一覧．`{...}` 内には複数文字も入れられる．

=== 1文字用アクセント

#table(
  columns: (auto, auto, 1fr),
  align: (left, center, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*LaTeX コマンド*], [*出力例*], [*主な用途*],
  [`\hat{a}`],    [$hat(a)$],        [推定量，単位ベクトル（$hat(e)$，$hat(x)$）],
  [`\tilde{a}`],  [$tilde(a)$],      [フーリエ変換，等価量（$tilde(f)$）],
  [`\bar{a}`],    [$overline(a)$],   [平均値，複素共役（$overline(z)$）],
  [`\vec{a}`],    [$arrow(a)$],      [ベクトル（手書き流儀；物理では `\bm` が多い）],
  [`\dot{a}`],    [$dot(a)$],        [時間の1階微分（$dot(x) = d x\/d t$）],
  [`\ddot{a}`],   [$diaer(a)$],      [時間の2階微分（$diaer(x) = d^2 x\/d t^2$）],
  [`\acute{a}`],  [$acute(a)$],      [鋭アクセント],
  [`\grave{a}`],  [$grave(a)$],      [重アクセント],
  [`\breve{a}`],  [$breve(a)$],      [ブレーブ],
  [`\check{a}`],  [$caron(a)$],      [キャロン（チェック）],
  [`\mathring{a}`], [$circle(a)$],   [リング（ストロームなど）],
)

=== 複数文字・幅広アクセント

#table(
  columns: (auto, auto, 1fr),
  align: (left, center, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*LaTeX コマンド*], [*出力例*], [*説明*],
  [`\widehat{ABC}`],   [$hat(A B C)$],      [コンテンツ幅に合わせたハット],
  [`\widetilde{ABC}`], [$tilde(A B C)$],    [コンテンツ幅に合わせたチルダ],
  [`\overline{ABC}`],  [$overline(A B C)$], [コンテンツ全体に上線],
  [`\underline{ABC}`], [$underline(A B C)$],[コンテンツ全体に下線],
  [`\overbrace{A+B}^{n}`],  [$overbrace(A + B, n)$],  [上ブレース＋ラベル],
  [`\underbrace{A+B}_{n}`], [$underbrace(A + B, n)$], [下ブレース＋ラベル],
)

== ギリシャ文字

大文字は先頭を大文字にする（例：`\Gamma`）．
直立体が必要な場合は `\mathrm{\Gamma}` とする．

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, center, left, center, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*コマンド*],[*出力*],[*コマンド*],[*出力*],[*コマンド*],[*出力*],
  [`\alpha`],   [$alpha$],   [`\iota`],    [$iota$],    [`\rho`],     [$rho$],
  [`\beta`],    [$beta$],    [`\kappa`],   [$kappa$],   [`\sigma`],   [$sigma$],
  [`\gamma`],   [$gamma$],   [`\lambda`],  [$lambda$],  [`\tau`],     [$tau$],
  [`\delta`],   [$delta$],   [`\mu`],      [$mu$],      [`\upsilon`], [$upsilon$],
  [`\epsilon`], [$epsilon$], [`\nu`],      [$nu$],      [`\phi`],     [$phi$],
  [`\zeta`],    [$zeta$],    [`\xi`],      [$xi$],      [`\chi`],     [$chi$],
  [`\eta`],     [$eta$],     [`\pi`],      [$pi$],      [`\psi`],     [$psi$],
  [`\theta`],   [$theta$],   [`\varpi`],   [$pi.alt$],  [`\omega`],   [$omega$],
)

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, center, left, center, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*コマンド（大文字）*],[*出力*],[*コマンド（大文字）*],[*出力*],[*コマンド（大文字）*],[*出力*],
  [`\Gamma`],   [$Gamma$],   [`\Lambda`],  [$Lambda$],  [`\Phi`],     [$Phi$],
  [`\Delta`],   [$Delta$],   [`\Xi`],      [$Xi$],      [`\Chi`],     [---],
  [`\Theta`],   [$Theta$],   [`\Pi`],      [$Pi$],      [`\Psi`],     [$Psi$],
  [`\Lambda`],  [$Lambda$],  [`\Sigma`],   [$Sigma$],   [`\Omega`],   [$Omega$],
  [`\Upsilon`], [$Upsilon$], [`\Phi`],     [$Phi$],     [],           [],
)

#note-box[`\varepsilon`（$epsilon.alt$），`\varphi`（$phi.alt$），`\vartheta`（$theta.alt$），`\varsigma`（$sigma.alt$）など，バリアント形（`var` 付き）も存在する．物理では $epsilon.alt_0$（真空の誘電率）のように慣習的に使われる場合がある．]

== よく使う数学記号

=== 関係演算子

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, center, left, center, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*コマンド*],[*出力*],[*コマンド*],[*出力*],[*コマンド*],[*出力*],
  [`\leq`],     [$lt.eq$],      [`\geq`],    [$gt.eq$],      [`\neq`],     [$eq.not$],
  [`\ll`],      [$lt.double$],  [`\gg`],     [$gt.double$],  [`\approx`],  [$approx$],
  [`\sim`],     [$tilde.op$],   [`\simeq`],  [$tilde.eq$],   [`\equiv`],   [$equiv$],
  [`\propto`],  [$prop$],       [`\in`],     [$in$],         [`\notin`],   [$in.not$],
  [`\subset`],  [$subset$],     [`\supset`], [$supset$],     [`\subseteq`],[$subset.eq$],
)

=== 矢印

#table(
  columns: (auto, auto, auto, auto),
  align: (left, center, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*コマンド*],[*出力*],[*コマンド*],[*出力*],
  [`\to` / `\rightarrow`],  [$arrow.r$],      [`\leftarrow`],   [$arrow.l$],
  [`\Rightarrow`],          [$arrow.r.double$],[`\Leftarrow`],   [$arrow.l.double$],
  [`\Leftrightarrow`],      [$arrow.l.r.double$],[`\leftrightarrow`],[$arrow.l.r$],
  [`\mapsto`],              [$arrow.r.bar$],  [`\longrightarrow`],[$arrow.r.long$],
  [`\uparrow`],             [$arrow.t$],      [`\downarrow`],   [$arrow.b$],
  [`\nearrow`],             [$arrow.tr$],     [`\searrow`],     [$arrow.br$],
)

=== 二項演算子・その他記号

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, center, left, center, left, center),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*コマンド*],[*出力*],[*コマンド*],[*出力*],[*コマンド*],[*出力*],
  [`\times`],   [$times$],     [`\div`],     [$div$],      [`\pm`],      [$plus.minus$],
  [`\cdot`],    [$dot.c$],     [`\cdots`],   [$dots.c$],   [`\ldots`],   [$dots.h$],
  [`\nabla`],   [$nabla$],     [`\partial`], [$partial$],  [`\infty`],   [$infinity$],
  [`\forall`],  [$forall$],    [`\exists`],  [$exists$],   [`\emptyset`], [$emptyset$],
  [`\sum`],     [$sum$],       [`\prod`],    [$product$],  [`\int`],     [$integral$],
  [`\oint`],    [$integral.cont$], [`\iint`],[$integral.double$],[`\iiint`],[$integral.triple$],
  [`\hbar`],    [$planck.reduce$],  [`\ell`],[$ell$],      [`\Re`],      [$Re$],
  [`\Im`],      [$Im$],        [`\dagger`],  [$dagger$],   [`\star`],    [$star$],
)

== 数式環境の使い分け

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  stroke: (x: none, y: rgb("#e0e0e0")),
  fill: (_, y) => if y == 0 { rgb("#e8eaf6") } else { none },
  [*環境名*], [*用途*], [*必要パッケージ*],
  [`equation`],    [番号付き1行数式（標準）], [（なし）],
  [`equation*`],   [番号なし1行数式], [`amsmath`],
  [`align`],       [複数行，`&` で揃える，各行に番号], [`amsmath`],
  [`align*`],      [番号なし版 `align`], [`amsmath`],
  [`gather`],      [複数行を中央揃え，各行に番号], [`amsmath`],
  [`multline`],    [長い1式を複数行に折り返す], [`amsmath`],
  [`split`],       [`equation` 内で複数行に分割（番号は1つ）], [`amsmath`],
  [`cases`],       [場合分け（左に大括弧）], [`amsmath`],
  [`pmatrix`],     [括弧付き行列（丸括弧）], [`amsmath`],
  [`bmatrix`],     [括弧付き行列（角括弧）], [`amsmath`],
  [`vmatrix`],     [行列式（縦棒）], [`amsmath`],
)
