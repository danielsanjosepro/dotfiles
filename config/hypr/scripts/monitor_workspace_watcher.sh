#!/usr/bin/env bash
# Apply external-monitor workspace assignments at startup, then re-apply on
# every monitor add/remove event from the Hyprland socket.

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ASSIGN="${SCRIPT_DIR}/assign_external_workspaces.sh"

"$ASSIGN" || true

SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

exec /usr/bin/python3 - "$SOCKET" "$ASSIGN" <<'PY'
import os
import socket
import subprocess
import sys

sock_path, assign = sys.argv[1], sys.argv[2]

s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(sock_path)

buf = b""
while True:
    chunk = s.recv(4096)
    if not chunk:
        break
    buf += chunk
    while b"\n" in buf:
        line, buf = buf.split(b"\n", 1)
        event = line.decode(errors="replace").split(">>", 1)[0]
        if event in ("monitoradded", "monitorremoved", "monitoraddedv2", "monitorremovedv2"):
            subprocess.run([assign], check=False)
PY
