#!/usr/bin/env bash
# Launch Vim with an isolated ddg.vim test environment.
# Does NOT read ~/.vimrc or any plugins from ~/.vim.
#
# Usage:
#   ./test/run.sh              open empty buffer
#   ./test/run.sh some_file    open a file for <Leader>dg / :DDGWord testing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
VIMRC="$SCRIPT_DIR/minimal_vimrc"

if ! command -v vim &>/dev/null; then
  printf 'error: vim not found in PATH\n' >&2
  exit 1
fi

exec vim -u "$VIMRC" -N "$@"
