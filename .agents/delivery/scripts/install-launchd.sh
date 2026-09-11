#!/usr/bin/env bash
# Install a macOS launchd agent that runs orchestrate.sh on an interval.
# Placeholder label: com.startup-harness.orchestrate — customize before production use.
set -euo pipefail
ROOT="${PRODUCT_ROOT:-${AIFFER_ROOT:-$PWD}}"
LABEL="${LAUNCHD_LABEL:-com.startup-harness.orchestrate}"
INTERVAL="${LAUNCHD_INTERVAL:-900}"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
SCRIPT="$ROOT/.agents/delivery/scripts/orchestrate.sh"
if [[ ! -x "$SCRIPT" && ! -f "$SCRIPT" ]]; then
  echo "Missing $SCRIPT — run setup.sh first to copy scripts into the product repo."
  exit 1
fi
mkdir -p "$HOME/Library/LaunchAgents" "$ROOT/.agents/delivery"
cat >"$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$SCRIPT</string>
  </array>
  <key>StartInterval</key><integer>$INTERVAL</integer>
  <key>RunAtLoad</key><true/>
  <key>StandardOutPath</key><string>$ROOT/.agents/delivery/orchestrate.stdout.log</string>
  <key>StandardErrorPath</key><string>$ROOT/.agents/delivery/orchestrate.stderr.log</string>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PRODUCT_ROOT</key><string>$ROOT</string>
    <key>PATH</key><string>/opt/homebrew/bin:/usr/bin:/bin</string>
  </dict>
</dict>
</plist>
PLISTEOF
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
echo "Installed $PLIST (every ${INTERVAL}s)"
bash "$SCRIPT" || true
