#!/bin/bash
set -euvxo pipefail

cp CLAUDE.md ~/.claude/CLAUDE.md
mkdir -p ~/.claude/docs
cp docs/pull-request-guide.md ~/.claude/docs/pull-request-guide.md
cp docs/dependabot-review.md ~/.claude/docs/dependabot-review.md
cp docs/commit.md ~/.claude/docs/commit.md
