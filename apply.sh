#!/bin/bash
set -euvxo pipefail

# Claude Code設定ファイルのコピー
cp CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/docs
cp docs/pull-request-guide.md ~/.claude/docs/pull-request-guide.md
cp docs/dependabot-review.md ~/.claude/docs/dependabot-review.md
cp docs/commit.md ~/.claude/docs/commit.md
rm -rf ~/.claude/commands
cp -r commands ~/.claude/

# Playwright MCPサーバーの設定
# 一度のみでOK
# echo "Playwright MCPサーバーを設定中..."
# claude mcp add-json -s user playwright '{"name":"playwright","command":"npx","args":["@playwright/mcp@latest"]}' || echo "Playwright MCPサーバーは既に設定済みです"
# Chromeブラウザのインストール（Playwright用）
# echo "Playwright用Chromeブラウザをインストール中..."
# npx playwright install chrome
