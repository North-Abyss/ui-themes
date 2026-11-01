#!/usr/bin/env python3
"""
[WHAT]
Zero-dependency Python Directory Governance & Template Integrity Auditor.

[WHY]
Validates that the repository adheres to the Universal PT architecture:
checks required directory scaffolding, canonical governance files, on-demand skills
with YAML frontmatter, and prohibited anti-patterns. Provides a universal fallback
for developer environments where Node.js is not present.

[USAGE]
  python3 scripts/dev/verify_template.py [options]
  ./run.sh --audit
"""

import os
import re
import sys
from typing import List, Dict, Any, Tuple

DEFAULT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))

GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
BOLD = "\033[1m"
RESET = "\033[0m"

REQUIRED_DIRECTORIES = [
    "src/frontend",
    "src/backend",
    "src/database",
    "src/integrations",
    "src/shared",
    "src/themes",
    "scripts/dev",
    "scripts/deployment",
    "packaging/desktop",
    "config/ci",
    "config/docker",
    ".githooks",
    "tests/unit",
    "tests/e2e",
    ".agents/skills",
    "config/mcp",
    "specs",
    "workspace/audit",
]

REQUIRED_FILES = [
    "AGENTS.md",
    "run.sh",
    "git-sync.sh",
    "update-template.sh",
    "agent-memory.md",
    "log.md",
    "agent-rules.md",
    "src/ARCHITECTURE.md",
    ".agents/hooks.json",
    ".cursorignore",
    ".agentignore",
    ".githooks/pre-commit",
    "scripts/deployment/deploy_gh_pages.sh",
    "scripts/deployment/deploy_server.sh",
    "scripts/dev/verify_env.py",
    "packaging/desktop/README.md",
    "docs/APP_SPEC.md.template",
]

CANONICAL_SKILLS = [
    "spec-planner",
    "tdd-implementer",
    "circuit-breaker",
    "code-review",
    "browser-testing",
    "template-sync",
    "mcp-tooling",
    "doc-governance",
    "db-migrator",
    "security-auditor",
]

PROHIBITED_DIRECTORIES = [
    "apps",
    "packages",
    "pb_data",
]


def run_audit(root_dir: str = DEFAULT_ROOT) -> Dict[str, Any]:
    """
    [WHAT]
    Executes comprehensive directory governance audit against the PT specification.

    [WHY]
    Ensures that structural drift does not accumulate silently across local dev and CI.
    """
    errors: List[str] = []
    warnings: List[str] = []
    checked_dirs = 0
    checked_files = 0
    checked_skills = 0

    # 1. Check required directories
    for rel_dir in REQUIRED_DIRECTORIES:
        full_path = os.path.join(root_dir, rel_dir)
        if not os.path.isdir(full_path):
            errors.append(f"Missing required directory: {rel_dir}")
        else:
            checked_dirs += 1

    # 2. Check canonical files
    for rel_file in REQUIRED_FILES:
        full_path = os.path.join(root_dir, rel_file)
        if not os.path.isfile(full_path):
            errors.append(f"Missing canonical file: {rel_file}")
        else:
            checked_files += 1

    # 3. Check skills and frontmatters
    skills_base = os.path.join(root_dir, ".agents/skills")
    for skill_name in CANONICAL_SKILLS:
        skill_file = os.path.join(skills_base, skill_name, "SKILL.md")
        if not os.path.isfile(skill_file):
            errors.append(f"Missing canonical skill: .agents/skills/{skill_name}/SKILL.md")
            continue

        try:
            with open(skill_file, "r", encoding="utf-8") as f:
                content = f.read()
            has_name = bool(re.search(r"name:\s*[a-zA-Z0-9_-]+", content))
            has_desc = bool(re.search(r"description:\s*.+", content))

            if not has_name or not has_desc:
                warnings.append(f"Skill .agents/skills/{skill_name}/SKILL.md missing valid YAML frontmatter")
            else:
                checked_skills += 1
        except Exception as e:
            errors.append(f"Could not read skill file: {skill_name} ({e})")

    # 4. Check prohibited directories
    for prohib_dir in PROHIBITED_DIRECTORIES:
        full_path = os.path.join(root_dir, prohib_dir)
        if os.path.isdir(full_path):
            errors.append(f"Prohibited directory detected: {prohib_dir}/ (Violates single-source PT governance)")

    passed = len(errors) == 0
    return {
        "passed": passed,
        "errors": errors,
        "warnings": warnings,
        "stats": {
            "directories_checked": checked_dirs,
            "files_checked": checked_files,
            "skills_checked": checked_skills,
        },
    }


def main():
    args = sys.argv[1:]
    if "-h" in args or "--help" in args:
        print(f"{BOLD}verify_template.py{RESET} - PT Directory Governance & Skill Auditor (Python)")
        print("\nUsage: python3 scripts/dev/verify_template.py [options]")
        print("\nOptions:")
        print("  --root <path>   Override root directory to scan")
        print("  -h, --help      Show this help dialog\n")
        sys.exit(0)

    root_arg = DEFAULT_ROOT
    if "--root" in args:
        idx = args.index("--root")
        if idx + 1 < len(args):
            root_arg = os.path.abspath(args[idx + 1])

    print(f"{BOLD}{BLUE}=== Running PT Template Governance Audit (Python) ==={RESET}")
    print(f"Auditing target: {root_arg}\n")

    res = run_audit(root_arg)

    print(f"{GREEN}✔ Directories verified:{RESET} {res['stats']['directories_checked']}/{len(REQUIRED_DIRECTORIES)}")
    print(f"{GREEN}✔ Canonical files verified:{RESET} {res['stats']['files_checked']}/{len(REQUIRED_FILES)}")
    print(f"{GREEN}✔ On-demand skills verified:{RESET} {res['stats']['skills_checked']}/{len(CANONICAL_SKILLS)}")

    if res["warnings"]:
        print(f"\n{YELLOW}{BOLD}Warnings ({len(res['warnings'])}):{RESET}")
        for w in res["warnings"]:
            print(f"  {YELLOW}⚠️  {w}{RESET}")

    if not res["passed"]:
        print(f"\n{RED}{BOLD}Audit Failures ({len(res['errors'])}):{RESET}")
        for err in res["errors"]:
            print(f"  {RED}✖ {err}{RESET}")
        print(f"\n{RED}Template governance audit failed.{RESET}")
        sys.exit(1)
    else:
        print(f"\n{GREEN}{BOLD}✔ All directory governance & template checks passed successfully!{RESET}")
        sys.exit(0)


if __name__ == "__main__":
    main()
