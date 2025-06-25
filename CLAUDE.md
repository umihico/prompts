「監督者」としての作業を指示されたら以下の指示ファイルを参照してください。

# Additional Instructions

- 「監督者」としての作業を指示された場合 @docs/tmux-collaboration.md
- プルリクエストの作成・マージ方法について @docs/pull-request-guide.md

# タスク完了時の通知

- タスクを完了する際やユーザーにメッセージを返す際は、必ず以下のコマンドを一度だけ実行してください：
  ```bash
  terminal-notifier -title "Cloud Code" -subtitle "$(basename $(pwd))" -message "DONE" -sound Pop
  ```
