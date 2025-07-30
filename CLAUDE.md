「監督者」としての作業を指示されたら以下の指示ファイルを参照してください。

# Additional Instructions

- プルリクエストの作成・マージ方法について @docs/pull-request-guide.md
- 「dependabot対応して」→dependabotが作るプルリクのレビュー自動化について @docs/dependabot-review.md
- コミット作成について @docs/commit.md

# タスク完了時の通知

- タスクを完了する際やユーザーに入力を求めて作業を一時停止する際は、必ず以下のコマンドを一度だけ実行してください。subtitleとmessageで状況を伝達してください。
  ```bash
  terminal-notifier -title "$(date +'%H:%M') $(basename $(pwd))" -subtitle "[REPLACE_SUBTITLE]" -message "[REPLACE_MESSAGE]" -sound Pop && say "[REPLACE_MESSAGE]"
  ```
