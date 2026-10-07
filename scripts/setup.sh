#!/usr/bin/env bash
# One-shot setup for macOS/Linux/WSL: checks tools, runs the test suite.
set -euo pipefail
cd "$(dirname "$0")/.."

for cmd in git node; do
  command -v "$cmd" >/dev/null || { echo "$cmd not found; install Node 22 LTS and Git first." >&2; exit 1; }
done

node --check dist/app.js
for test in gameplay frontiers exploration offline; do
  node "tests/$test.mjs"
done

echo
echo "Ready. Play locally with: python3 -m http.server 8080 -d dist  ->  http://127.0.0.1:8080"
