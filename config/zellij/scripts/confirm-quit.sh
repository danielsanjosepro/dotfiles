#!/usr/bin/env bash

set -euo pipefail

session_name="${ZELLIJ_SESSION_NAME:-current session}"

cleanup() {
  printf '\033[?25h'
}
trap cleanup EXIT

printf '\033[?25l'
printf '\033[2J\033[H'

cat <<EOF
⚠ Close Zellij session?

Session: ${session_name}

[d] Detach
[q] Quit session
[Esc/Enter] Cancel
EOF

while IFS= read -rsn1 key; do
  case "$key" in
    d|D)
      zellij action detach
      exit 0
      ;;
    q|Q)
      if [[ -n "${ZELLIJ_SESSION_NAME:-}" ]]; then
        zellij kill-session "$ZELLIJ_SESSION_NAME"
      fi
      exit 0
      ;;
    ''|$'\e')
      exit 0
      ;;
  esac
done
