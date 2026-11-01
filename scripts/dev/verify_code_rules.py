#!/usr/bin/env python3
"""
==============================================================================
verify_code_rules.py
Zero-dependency Python 3.8+ Code Rules, Docblock & Theme Token Auditor

[PURPOSE]
Audits source files for compliance with the "What & Why" documentation standard,
module provider headers, and design token anti-corruption rules (zero magic hex).

[USAGE]
  python3 scripts/dev/verify_code_rules.py [options]
  ./run.sh --audit

[OPTIONS]
  --src <path>     Directory to scan (default: src/)
  --strict         Exit with code 1 on any violation (default: soft warnings, exit 0)
  -h, --help       Show this help dialog
==============================================================================
"""

import argparse
import os
import re
import sys
from pathlib import Path
from typing import List, NamedTuple, Optional

# ANSI Output Colors
GREEN = "\033[0;32m"
BLUE = "\033[0;34m"
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
BOLD = "\033[1m"
NC = "\033[0m"


class Violation(NamedTuple):
    rule_id: str
    file_path: str
    line_number: int
    message: str
    severity: str = "WARNING"  # WARNING or ERROR


# Regex patterns
HEX_COLOR_PATTERN = re.compile(r"""(?:["']|\s|:)(#[0-9a-fA-F]{3,8})(?:["';,\s]|$)""")

# File extensions to audit for functions/docblocks
AUDIT_EXTENSIONS = {".ts", ".tsx", ".js", ".jsx", ".py", ".dart"}

# Files and directories exempt from hex color checks
THEME_EXEMPT_PATHS = {"themes", "theme", "presets", "tokens", "showcase.html"}


def is_exempt_from_hex_check(file_path: str) -> bool:
    """Checks whether a given file path is permitted to contain raw hex colors."""
    p = Path(file_path)
    parts = set(p.parts)
    if parts.intersection(THEME_EXEMPT_PATHS):
        return True
    if "constants" in parts or "tests" in parts or "spec" in p.name.lower():
        return True
    return False


def audit_file_content(file_path: str, content: str) -> List[Violation]:
    """
    Audits the text content of a single source file.
    
    @remarks
    Analyzes docblock presence, @remarks / [WHY] sections, and hardcoded
    hex values. Pure and stateless to allow rapid in-memory unit testing.
    
    @param file_path - Relative or absolute path of the file
    @param content - Full string contents of the file
    @returns List of Violation objects detected in the file
    """
    violations: List[Violation] = []
    lines = content.splitlines()
    ext = Path(file_path).suffix.lower()

    # 1. Check for hardcoded hex colors
    if not is_exempt_from_hex_check(file_path):
        for idx, line in enumerate(lines, 1):
            # Skip comments
            trimmed = line.strip()
            if trimmed.startswith(("//", "/*", "*", "#")):
                continue
            matches = HEX_COLOR_PATTERN.findall(line)
            for hex_code in matches:
                violations.append(
                    Violation(
                        rule_id="RULE-HEX_COLOR",
                        file_path=file_path,
                        line_number=idx,
                        message=f"Hardcoded hex color '{hex_code}' found. Use global theme tokens from src/themes/.",
                        severity="WARNING",
                    )
                )

    # 2. Check TypeScript / JavaScript / Dart docblocks
    if ext in {".ts", ".tsx", ".js", ".jsx"}:
        violations.extend(_audit_js_ts_docblocks(file_path, lines))
    elif ext == ".py":
        violations.extend(_audit_python_docstrings(file_path, lines, content))
    elif ext == ".dart":
        violations.extend(_audit_dart_docblocks(file_path, lines))

    return violations


def _audit_js_ts_docblocks(file_path: str, lines: List[str]) -> List[Violation]:
    violations: List[Violation] = []
    export_fn_pattern = re.compile(
        r"""^\s*export\s+(?:async\s+)?(?:function\*?|class|const\s+([a-zA-Z0-9_]+)\s*=\s*(?:async\s*)?\([^)]*\)\s*=>)"""
    )

    for idx, line in enumerate(lines):
        line_num = idx + 1
        if export_fn_pattern.search(line):
            # Look backwards for a preceding JSDoc comment /** ... */
            docblock = _extract_preceding_jsdoc(lines, idx - 1)
            if not docblock:
                violations.append(
                    Violation(
                        rule_id="RULE-MISSING_DOCBLOCK",
                        file_path=file_path,
                        line_number=line_num,
                        message="Exported function/class lacks a What & Why docblock (JSDoc).",
                        severity="WARNING",
                    )
                )
            else:
                # Check for @remarks
                if "@remarks" not in docblock and "[why]" not in docblock.lower():
                    violations.append(
                        Violation(
                            rule_id="RULE-MISSING_WHY",
                            file_path=file_path,
                            line_number=line_num,
                            message="Docblock lacks an '@remarks' (or [WHY]) section explaining architectural rationale.",
                            severity="WARNING",
                        )
                    )

    return violations


def _extract_preceding_jsdoc(lines: List[str], end_idx: int) -> Optional[str]:
    """Finds immediately preceding /** ... */ block above a statement."""
    curr = end_idx
    # Walk backwards skipping empty lines or decorators
    while curr >= 0 and (lines[curr].strip() == "" or lines[curr].strip().startswith("@")):
        curr -= 1

    if curr < 0:
        return None

    if lines[curr].strip().endswith("*/"):
        block = []
        while curr >= 0:
            block.insert(0, lines[curr])
            if "/**" in lines[curr]:
                return "\n".join(block)
            curr -= 1
    return None


def _audit_python_docstrings(file_path: str, lines: List[str], full_content: str) -> List[Violation]:
    violations: List[Violation] = []
    # Identify top-level public functions/classes
    func_pattern = re.compile(r"""^def\s+([a-zA-Z0-9_]+)\s*\([^)]*\)\s*(?:->\s*[^:]+)?\s*:""")
    class_pattern = re.compile(r"""^class\s+([a-zA-Z0-9_]+)(?:\([^)]*\))?\s*:""")

    for idx, line in enumerate(lines):
        line_num = idx + 1
        fn_match = func_pattern.match(line)
        cl_match = class_pattern.match(line)

        target_name = None
        if fn_match and not fn_match.group(1).startswith("_"):
            target_name = fn_match.group(1)
        elif cl_match and not cl_match.group(1).startswith("_"):
            target_name = cl_match.group(1)

        if target_name:
            # Check lines following def/class for docstring
            docstring = _extract_following_py_docstring(lines, idx + 1)
            if not docstring:
                violations.append(
                    Violation(
                        rule_id="RULE-MISSING_DOCBLOCK",
                        file_path=file_path,
                        line_number=line_num,
                        message=f"Public function/class '{target_name}' lacks a What & Why docstring.",
                        severity="WARNING",
                    )
                )
            else:
                if "[why]" not in docstring.lower() and "why:" not in docstring.lower():
                    violations.append(
                        Violation(
                            rule_id="RULE-MISSING_WHY",
                            file_path=file_path,
                            line_number=line_num,
                            message=f"Docstring for '{target_name}' lacks a '[WHY]' section explaining rationale.",
                            severity="WARNING",
                        )
                    )

    return violations


def _extract_following_py_docstring(lines: List[str], start_idx: int) -> Optional[str]:
    """Finds the docstring immediately following a python def/class."""
    curr = start_idx
    while curr < len(lines) and lines[curr].strip() == "":
        curr += 1
    if curr >= len(lines):
        return None

    first_line = lines[curr].strip()
    quotes = None
    if first_line.startswith('"""'):
        quotes = '"""'
    elif first_line.startswith("'''"):
        quotes = "'''"

    if not quotes:
        return None

    # Single-line docstring
    if first_line.count(quotes) >= 2 and len(first_line) > len(quotes) * 2:
        return first_line

    # Multi-line docstring
    block = [first_line]
    curr += 1
    while curr < len(lines):
        block.append(lines[curr])
        if quotes in lines[curr]:
            return "\n".join(block)
        curr += 1
    return "\n".join(block)


def _audit_dart_docblocks(file_path: str, lines: List[str]) -> List[Violation]:
    violations: List[Violation] = []
    decl_pattern = re.compile(r"""^\s*(?:void|[A-Z][a-zA-Z0-9<>_]*)\s+([a-zA-Z0-9_]+)\s*\([^)]*\)\s*\{""")

    for idx, line in enumerate(lines):
        line_num = idx + 1
        match = decl_pattern.match(line)
        if match and not match.group(1).startswith("_"):
            # Look backwards for /// comments
            curr = idx - 1
            comments = []
            while curr >= 0 and lines[curr].strip().startswith("///"):
                comments.insert(0, lines[curr])
                curr -= 1

            if not comments:
                violations.append(
                    Violation(
                        rule_id="RULE-MISSING_DOCBLOCK",
                        file_path=file_path,
                        line_number=line_num,
                        message="Public Dart function lacks '///' documentation comments.",
                        severity="WARNING",
                    )
                )
            else:
                combined = "\n".join(comments)
                if "[why]" not in combined.lower() and "why:" not in combined.lower():
                    violations.append(
                        Violation(
                            rule_id="RULE-MISSING_WHY",
                            file_path=file_path,
                            line_number=line_num,
                            message="Dart doc comments lack a '[WHY]' rationale section.",
                            severity="WARNING",
                        )
                    )

    return violations


def audit_directory(src_dir: str) -> List[Violation]:
    """Recursively audits all supported source files in the given directory."""
    all_violations: List[Violation] = []
    root_path = Path(src_dir)

    if not root_path.exists():
        return all_violations

    for root, _, files in os.walk(src_dir):
        for f in sorted(files):
            ext = Path(f).suffix.lower()
            if ext in AUDIT_EXTENSIONS or ext in {".css", ".html"}:
                full_path = os.path.join(root, f)
                try:
                    with open(full_path, "r", encoding="utf-8", errors="replace") as fh:
                        content = fh.read()
                    all_violations.extend(audit_file_content(full_path, content))
                except Exception as err:
                    all_violations.append(
                        Violation(
                            rule_id="RULE-READ-ERROR",
                            file_path=full_path,
                            line_number=1,
                            message=f"Failed to read file: {err}",
                            severity="ERROR",
                        )
                    )

    return all_violations


def main():
    parser = argparse.ArgumentParser(
        description="Verify code structure, What & Why docblocks, and design token rules."
    )
    parser.add_argument(
        "--src",
        default="src/",
        help="Source directory to audit (default: src/)",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Exit with code 1 if any violation is found (default: soft warnings, exit 0)",
    )

    args = parser.parse_args()

    print(f"{BOLD}{BLUE}=== Running PT Code Rules & Documentation Audit ==={NC}")
    print(f"Scanning target directory: {args.src}\n")

    violations = audit_directory(args.src)

    if not violations:
        print(f"{GREEN}{BOLD}✔ 0 violations detected! Code adheres to What & Why standard and theme rules.{NC}")
        sys.exit(0)

    print(f"{YELLOW}Audit findings ({len(violations)} notice(s)):{NC}")
    for v in violations:
        color = RED if v.severity == "ERROR" else YELLOW
        print(f"  {color}[{v.rule_id}]{NC} {v.file_path}:{v.line_number} — {v.message}")

    if args.strict:
        print(f"\n{RED}{BOLD}✖ Audit failed in strict mode ({len(violations)} violation(s)).{NC}")
        sys.exit(1)
    else:
        print(f"\n{GREEN}✔ Audit completed (soft warnings reported; build unblocked).{NC}")
        sys.exit(0)


if __name__ == "__main__":
    main()
