#!/usr/bin/env bash
# Test helper: captures the URL argument into $DDG_CAPTURE_FILE.
# Used by vader tests to verify the URL that ddg.vim would open.
#
# Usage (set via g:ddg_open_command in tests):
#   DDG_CAPTURE_FILE=/tmp/some_file test/capture_url.sh 'https://...'

printf '%s\n' "$1" > "${DDG_CAPTURE_FILE:?DDG_CAPTURE_FILE must be set}"
