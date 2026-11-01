#!/usr/bin/env python3
"""
[WHAT]
Zero-dependency environment variable parity auditor (verify_env.py).

[WHY]
In multi-developer and AI-agent workflows, adding keys to .env without updating
.env.example leads to silent runtime crashes, broken cloud builds, and failed
Docker container boots for other team members and downstream template consumers.
This auditor verifies key parity between local environment configurations and
canonical template definitions.

[USAGE]
  python3 scripts/dev/verify_env.py [options]
  ./run.sh --audit

Options:
  --env <file>          Path to active environment file (default: .env)
  --example <file>      Path to example environment template (default: config/environments/.env.example)
  --strict              Exit with code 1 on missing required keys
  -h, --help            Show this help dialog
"""

import os
import re
import sys
from typing import Dict, List, Set, Tuple

DEFAULT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))

GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
BOLD = "\033[1m"
RESET = "\033[0m"


def parse_env_keys(filepath: str) -> Set[str]:
    """
    [WHAT]
    Extracts all variable key names from an environment file.

    [WHY]
    Ignores comments (#), blank lines, and handles multiline values cleanly.
    """
    keys: Set[str] = set()
    if not os.path.isfile(filepath):
        return keys

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            # Match KEY=value or export KEY=value
            match = re.match(r"^(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=", line)
            if match:
                keys.add(match.group(1))

    return keys


def run_env_audit(
    root_dir: str = DEFAULT_ROOT,
    env_file: str = None,
    example_file: str = None,
    strict: bool = False
) -> Tuple[bool, List[str], List[str]]:
    """
    [WHAT]
    Compares keys defined in the active .env against the template .env.example.

    [WHY]
    Ensures no undocumented secrets leak into dev without an example counterpart,
    and ensures developers know what configuration variables are required.
    """
    if env_file is None:
        env_file = os.path.join(root_dir, ".env")
    if example_file is None:
        example_file = os.path.join(root_dir, "config/environments/.env.example")
        if not os.path.isfile(example_file) and os.path.isfile(os.path.join(root_dir, ".env.example")):
            example_file = os.path.join(root_dir, ".env.example")

    errors: List[str] = []
    warnings: List[str] = []

    if not os.path.isfile(example_file):
        errors.append(f"Example environment template missing: {example_file}")
        return False, errors, warnings

    if not os.path.isfile(env_file):
        warnings.append(f"No active environment file found at {env_file} (Run ./run.sh to initialize from template)")
        return True, errors, warnings

    example_keys = parse_env_keys(example_file)
    actual_keys = parse_env_keys(env_file)

    missing_keys = example_keys - actual_keys
    undeclared_keys = actual_keys - example_keys

    if missing_keys:
        msg = f"Missing required environment key(s) in {os.path.basename(env_file)}: {', '.join(sorted(missing_keys))}"
        if strict:
            errors.append(msg)
        else:
            warnings.append(msg)

    if undeclared_keys:
        warnings.append(f"Undeclared key(s) in {os.path.basename(env_file)} not documented in template: {', '.join(sorted(undeclared_keys))}")

    passed = len(errors) == 0
    return passed, errors, warnings


def main():
    args = sys.argv[1:]
    if "-h" in args or "--help" in args:
        print(f"{BOLD}verify_env.py{RESET} - Environment Variable Parity Auditor")
        print("\nUsage: python3 scripts/dev/verify_env.py [options]")
        print("\nOptions:")
        print("  --env <file>       Override active .env file path")
        print("  --example <file>   Override .env.example file path")
        print("  --strict           Treat missing keys as fatal errors (exit code 1)")
        print("  -h, --help         Show this help dialog\n")
        sys.exit(0)

    env_path = None
    example_path = None
    strict = "--strict" in args

    if "--env" in args:
        idx = args.index("--env")
        if idx + 1 < len(args):
            env_path = os.path.abspath(args[idx + 1])

    if "--example" in args:
        idx = args.index("--example")
        if idx + 1 < len(args):
            example_path = os.path.abspath(args[idx + 1])

    print(f"{BOLD}{BLUE}=== Running Environment Variable Parity Audit ==={RESET}\n")
    passed, errors, warnings = run_env_audit(
        env_file=env_path,
        example_file=example_path,
        strict=strict
    )

    if warnings:
        for w in warnings:
            print(f"  {YELLOW}⚠️  {w}{RESET}")

    if errors:
        for e in errors:
            print(f"  {RED}✖ {e}{RESET}")
        print(f"\n{RED}Environment variable parity audit failed.{RESET}")
        sys.exit(1)

    if not warnings and not errors:
        print(f"{GREEN}✔ Environment keys in .env match template definition perfectly.{RESET}")

    sys.exit(0)


if __name__ == "__main__":
    main()
