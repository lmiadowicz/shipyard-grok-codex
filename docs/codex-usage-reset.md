# Codex usage reset (when usage hits 0%)

When Codex usage shows **0%**, **stop new limen spawns** (fail-closed). Reset in the **Codex desktop app**, then resume.

## Supported path (desktop)

1. Open the **ChatGPT / Codex desktop** app.
2. Go to **Settings → Usage** (wording may vary by version).
3. Reset / refresh coding-agent usage.
4. Confirm usage is no longer 0%.
5. Resume within your **1–2 job** cap.

## Do not

- Do **not** wipe `~/.codex` to “fix” quota.
- Do **not** keep spawning into a zero-quota wall.

## API note

If an official API quota-reset exists for your plan, use vendor docs. **This harness documents the Codex desktop Settings/Usage path as the supported reset** when the API path is unknown.
