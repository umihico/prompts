# tmux連携コマンドガイド

## 1. 自分のペイン番号確認方法

現在のペイン番号を確認するには以下のコマンドを使用します：
通常監督者は1、作業者は0です。

```bash
tmux display-message -p '#P'
```

### オプション説明
- `-p`: メッセージを標準出力に出力
- `#P`: ペイン番号を表示するフォーマット

## 2. 他ペイン内容確認方法

他のペインの画面内容を確認するには `capture-pane` コマンドを使用します：

```bash
# 基本的な使用方法
tmux capture-pane -t <ペイン番号> -p

# 例：ペイン1の内容を確認
tmux capture-pane -t 1 -p

# より詳細なオプション
tmux capture-pane -t <ペイン番号> -p -S <開始行> -E <終了行>

# 現在の画面のみ確認
tmux capture-pane -t 0 -p -S 0

# 最後の30行を確認（監視用）
tmux capture-pane -t 0 -p | tail -n 30
```

## 3. 他ペインへのコマンド送信方法

他のペインにコマンドを送信するには `send-keys` コマンドを使用します：

### 使用例
```bash
# ペイン0にgit statusを実行
tmux send-keys -t 0 'git status' Enter

# ペイン2にテキストのみ入力（実行しない）
tmux send-keys -t 2 'echo "Hello World"'

# 特殊キーの送信
tmux send-keys -t 1 C-c  # Ctrl+Cを送信
tmux send-keys -t 1 C-l  # Ctrl+Lを送信（画面クリア）
```

### 便利な組み合わせ
```bash
# 他ペインの状況確認後、コマンド送信
tmux capture-pane -t 1 -p | tail -5  # 最後の5行を確認
tmux send-keys -t 1 'cd /path/to/dir' Enter  # ディレクトリ移動
```

## 4. コマンド送信後の機動的待機時間

コマンドを送信した直後は作業者が作業を進めるため、**コマンドの性質に応じて機動的に待機時間を調整**します。
各待機時間の後に必ず`capture-pane`で状況確認を行います。

### 🚨 重要: すべてのsend-keysコマンドの後に機動的なsleepとcapture-paneを必須とする

```bash
# 基本的な許可（軽い処理）
tmux send-keys -t 0 Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30

# 自動許可（軽い処理）
tmux send-keys -t 0 Down Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30
```

### 待機時間の機動的調整基準

**監督者はコマンドの性質を分析し、以下の基準で待機時間を決定します**：

#### 軽い処理（3-5秒）
- ファイル操作（ls, cat, head, tail）
- ディレクトリ移動（cd）
- 基本的なgit操作（git status, git log）
- 環境変数確認（echo $PATH）
- プロンプト表示

#### 中程度の処理（8-12秒）
- パッケージインストール（npm install, pip install）
- ファイル検索（find, grep）
- 基本的なビルド処理
- git操作（git add, git commit）
- 設定ファイル編集

#### 重い処理（15-20秒）
- 大規模なパッケージインストール
- データベース操作
- サーバー起動・停止
- テスト実行
- 大規模なファイル処理

#### 特殊処理（25-30秒）
- システムレベルの操作
- 危険なコマンド（sudo使用時）
- 初回セットアップ処理
- 外部API呼び出し

### コマンドの後追いについて

**監督者は作業者のコマンド実行を後追いして監視します**：
- 作業者がコマンドを実行すると、監督者のペインに許可確認が表示される
- 監督者はコマンド内容を確認し、適切な許可判断を行う
- 許可後は機動的な待機時間を設定し、作業者の次の行動を監視する

```bash
# 監督者の基本的な後追いフロー
# 1. 作業者の状況確認
tmux capture-pane -t 0 -p | tail -n 30

# 2. コマンド許可（機動的待機時間）
tmux send-keys -t 0 Down Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30

# 3. 必要に応じて追加確認
sleep 3 && tmux capture-pane -t 0 -p | tail -n 30
```

### 実際の許可フロー例

```bash
# 1. 作業者の状況確認
tmux capture-pane -t 0 -p | tail -n 30

# 2. コマンド内容を確認し判断
# 🎯 安全なコマンドの場合（デフォルト）→ 自動許可を選択
tmux send-keys -t 0 Down Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30  # 自動許可（推奨）

# ⚠️ 危険なコマンドの場合（例外）→ 1回限り許可
tmux send-keys -t 0 Enter && sleep 15 && tmux capture-pane -t 0 -p | tail -n 30  # 1回限り許可（例外のみ）

# 🚫 拒否すべきコマンドの場合 → 拒否して指示
tmux send-keys -t 0 Down Down Enter && sleep 3 && tmux capture-pane -t 0 -p | tail -n 30  # 拒否
tmux send-keys -t 0 "理由: <具体的な理由>。代替案: <安全な方法>" Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30

# 3. 作業継続を監視
sleep 8 && tmux capture-pane -t 0 -p | tail -n 30
```

**重要**: 安全な開発作業コマンドの初回許可時は、必ず自動許可（`Down Enter`）を選択してください。1回限り許可（`Enter`）は使い方によっては危険になりえるコマンドのみに限定します。

### 実際の運用例（自動許可優先）

```bash
# 例1: git addの初回許可 → 自動許可を選択（軽い処理）
tmux capture-pane -t 0 -p | tail -n 30  # 状況確認
tmux send-keys -t 0 Down Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30  # 自動許可選択（推奨）
# → 以降のgit addは自動許可される

# 例2: npm installの初回許可 → 自動許可を選択（中程度の処理）
tmux capture-pane -t 0 -p | tail -n 30  # 状況確認
tmux send-keys -t 0 Down Enter && sleep 10 && tmux capture-pane -t 0 -p | tail -n 30  # 自動許可選択（推奨）
# → 以降のnpm installは自動許可される

# 例3: 危険なコマンド（sudo） → 1回限り許可（重い処理）
tmux capture-pane -t 0 -p | tail -n 30  # 状況確認
tmux send-keys -t 0 Enter && sleep 15 && tmux capture-pane -t 0 -p | tail -n 30  # 1回限り許可（例外）
# → 次回のsudoは再度確認が必要

# 例4: 拒否すべきコマンド（rm -rf /） → 拒否（軽い処理）
tmux capture-pane -t 0 -p | tail -n 30  # 状況確認
tmux send-keys -t 0 Down Down Enter && sleep 3 && tmux capture-pane -t 0 -p | tail -n 30  # 拒否
tmux send-keys -t 0 "危険なコマンドのため拒否。代替案を提案してください" Enter && sleep 5 && tmux capture-pane -t 0 -p | tail -n 30
```

## 5. メタ監督者機能

監督者のペインがハングした場合の自動再起動機能。**入力待ち状態の時のみアクションを実行**します。

```bash
# 1. コマンド内容を確認
tmux capture-pane -t 0 -p | tail -n 30
```

### 入力待ち状態の判定条件

以下のパターンが最終行に含まれる場合、入力待ち状態と判定：
- `%` (シェルプロンプト)
- `$` (シェルプロンプト) 
- `>` (プロンプト)
- `? for shortcuts` (Claude待機状態)
