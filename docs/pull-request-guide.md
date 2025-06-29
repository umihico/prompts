# プルリクエストの作成・マージガイド

## プルリクエストの作成

### 必須事項
**プルリクエストは必ずDraft（下書き）で作成してください。**

### 理由
- 誤ってマージされることを防ぐ
- レビュー準備が整うまでマージを制限
- 作業中の状態を明確に示す

### 作成手順
1. 新しいブランチを作成
2. 変更をコミット
3. プッシュ
4. **Draftプルリクエストを作成**
5. レビュー準備が整ったら「Ready for review」に変更

## プルリクエストのマージ

### 推奨方法
**マージコミット**を使用してください。

### 理由
- プルリクエストの履歴が明確に残る
- ブランチの境界が分かりやすい
- ロールバックが容易

### 設定
GitHubのリポジトリ設定で「Allow merge commits」を有効化し、「Allow squash merging」を無効化してください。

## ワークフローまとめ

1. **ブランチ作成** → 作業開始
2. **Draftプルリクエスト作成** → レビュー準備
3. **Ready for review** → レビュー開始
4. **マージコミットでマージ** → 完了 
