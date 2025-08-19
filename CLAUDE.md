# Additional Instructions

- プルリクエストの作成・マージ方法について @docs/pull-request-guide.md
- 「dependabot対応して」→dependabotが作るプルリクのレビュー自動化について @docs/dependabot-review.md
- コミット作成について @docs/commit.md
- プライベトートレポジトリのGithubを参照するときはghコマンドを積極的に使う。

# タスク完了時の通知

- タスクを完了する際やユーザーに入力を求めて作業を一時停止する際は、必ず以下のコマンドを一度だけ実行してください。subtitleとmessageで状況を伝達してください。
  ```bash
  terminal-notifier -title "$(date +'%H:%M') $(basename $(pwd))" -subtitle "[REPLACE_SUBTITLE]" -message "[REPLACE_MESSAGE]" -sound Pop && say "[REPLACE_MESSAGE]" &
  ```

# ドキュメント自動整理

メインの指示されたタスクとは別に、指示されなくてもドキュメントの整理も並行して常に積極的に行ってください。

- ドキュメントは積極的にディレクトリ構造を整理し、適切な階層で管理する
- 関連する内容は専用のサブディレクトリに分離する
- ファイル間の重複を避け、必要に応じてファイル間で内容を移行・統合する
- フォルダ構成の変更や再編成を常に検討し、より良い構造を維持する
- 会話から得た知見や変更点を常に反映し、最新の状態を保つこと

# ドキュメント自動分割

メインの指示されたタスクとは別に、指示されなくてもドキュメントの分割も並行して常に積極的に行ってください。

プロジェクトのCLAUDE.mdとdocs/配下のファイルが以下の条件を満たした場合、自動分割を実行：
- 100行超過 OR セクション5個以上 OR 1セクション30行超過
- 詳細手順: `@docs/auto-split-documentation.md`
