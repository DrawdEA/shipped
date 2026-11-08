#!/usr/bin/env bash
# Shipped installer: links the skill into Claude Code and (optionally) scaffolds a private data repo.
# Usage: ./install.sh [data-repo-path]      (default data repo: ~/shipped-log)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DATA="${1:-$HOME/shipped-log}"
DATA="${DATA/#\~/$HOME}"

mkdir -p "$SKILLS_DIR"
if [ -e "$SKILLS_DIR/shipped" ] && [ ! -L "$SKILLS_DIR/shipped" ]; then
  echo "✗ $SKILLS_DIR/shipped exists and is not a symlink; move it aside first." >&2
  exit 1
fi
ln -sfn "$REPO/skills/shipped" "$SKILLS_DIR/shipped"
echo "✓ skill linked: $SKILLS_DIR/shipped -> $REPO/skills/shipped"

mkdir -p "$HOME/.config/shipped"
echo "$DATA" > "$HOME/.config/shipped/home"
echo "✓ data repo path: $DATA (saved to ~/.config/shipped/home)"

mkdir -p "$DATA"/{raw,candidates,log,projects,out}
touch "$DATA"/{raw,candidates,log,projects,out}/.gitkeep
[ -f "$DATA/.gitignore" ] || printf 'out/*.pdf\n.DS_Store\n' > "$DATA/.gitignore"
[ -f "$DATA/config.yaml" ] || cp "$REPO/config.example.yaml" "$DATA/config.yaml"
[ -f "$DATA/state.json" ] || echo '{}' > "$DATA/state.json"
if [ ! -d "$DATA/.git" ]; then git -C "$DATA" init -q -b main; fi
echo "✓ data repo scaffolded"

cat <<EOF

Next: open Claude Code and run
  /shipped setup
It fills config.yaml from your connectors, checks each source, and schedules the daily + weekly tasks.
Keep $DATA private. It will contain names and links from your workplace.
EOF
