#!/usr/bin/env python3
"""
==============================================================================
hook_safety_gate.py
Antigravity PreToolUse Lifecycle Hook — Destructive Command Interceptor

[PURPOSE]
Acts as an automated safety guard before any tool executes shell commands.
If a command matches high-risk destructive patterns (e.g. git reset --hard,
git clean, rm -rf outside workspace, force push, drop table), it prompts the
developer for interactive confirmation ("ask"). Safe commands execute
automatically ("allow").

[USAGE]
  echo '{"toolCall":{"name":"run_command","args":{"CommandLine":"npm test"}}}' | python3 hook_safety_gate.py
==============================================================================
"""

import json
import re
import sys
from typing import Any, Dict

# High-risk destructive command patterns
DESTRUCTIVE_PATTERNS = [
    (re.compile(r"""\bgit\s+reset\s+--hard\b""", re.IGNORECASE), "git reset --hard will discard uncommitted changes"),
    (re.compile(r"""\bgit\s+clean\s+-[a-zA-Z]*f""", re.IGNORECASE), "git clean will permanently delete untracked files"),
    (re.compile(r"""\bgit\s+branch\s+-[a-zA-Z]*D\b""", re.IGNORECASE), "git branch -D will force-delete an unmerged branch"),
    (re.compile(r"""\bgit\s+push\s+.*(?:--force|-f\b)""", re.IGNORECASE), "git force-push will overwrite remote branch history"),
    (re.compile(r"""\brm\s+-[a-zA-Z]*r[a-zA-Z]*f\s+(?!\s*workspace\/tmp|\s*workspace\/audit)""", re.IGNORECASE), "rm -rf outside workspace/ can cause unrecoverable data loss"),
    (re.compile(r"""\bDROP\s+(?:DATABASE|SCHEMA|TABLE)\b""", re.IGNORECASE), "DROP SQL statement will permanently destroy database entities"),
    (re.compile(r"""\b(?:ssh|scp)\s+""", re.IGNORECASE), "direct remote SSH/SCP command to production or external host requires human confirmation"),
    (re.compile(r"""\brsync\s+.*@""", re.IGNORECASE), "remote rsync to server requires explicit human confirmation"),
    (re.compile(r"""\bdeploy_server\.sh\b(?!\s*--help|\s*-h\b)""", re.IGNORECASE), "executing live server deployment script requires human approval"),
]


def evaluate_hook(payload: Dict[str, Any]) -> Dict[str, Any]:
    """
    Evaluates an Antigravity PreToolUse hook payload.

    @remarks
    Inspects toolCall name and CommandLine arguments. Returns decision 'ask'
    if matching destructive regex, otherwise 'allow'. Stateless and idempotent.

    @param payload - Inbound JSON dictionary from Antigravity lifecycle
    @returns JSON dictionary containing 'decision' and optional 'reason'
    """
    tool_call = payload.get("toolCall", {})
    tool_name = tool_call.get("name", "")
    args = tool_call.get("args", {})

    # Only inspect run_command or shell execution tools
    if tool_name in {"run_command", "bash", "execute_command"}:
        cmd = args.get("CommandLine", "") or args.get("command", "")
        for pattern, warning in DESTRUCTIVE_PATTERNS:
            if pattern.search(cmd):
                return {
                    "decision": "ask",
                    "reason": f"Destructive command detected: {warning}. Command: '{cmd}'.",
                }

    return {"decision": "allow"}


def main():
    if len(sys.argv) > 1 and sys.argv[1] in {"-h", "--help"}:
        print("Antigravity PreToolUse Safety Gate Hook")
        print("\nReads JSON payload from stdin and writes decision to stdout.")
        sys.exit(0)

    try:
        input_data = sys.stdin.read().strip()
        if not input_data:
            print(json.dumps({"decision": "allow"}))
            sys.exit(0)

        payload = json.loads(input_data)
        result = evaluate_hook(payload)
        print(json.dumps(result))
    except Exception as err:
        # Fallback to allow if stdin was malformed so we do not hard crash agent loop
        print(json.dumps({"decision": "allow", "reason": f"Hook fallback: {err}"}))
        sys.exit(0)


if __name__ == "__main__":
    main()
