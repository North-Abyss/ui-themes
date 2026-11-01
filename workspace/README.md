# 🗂️ Local Workspace & Scratchpad Policy

> **Git Tracking Status:** `IGNORED BY VERSION CONTROL` (Except this README and directory scaffold markers)  
> **Master Reference:** [docs/guides/directory_governance_guide.md](../docs/guides/directory_governance_guide.md)

Welcome to the **Local Developer & AI Agent Scratchpad**.

This folder exists to give human engineers and AI coding assistants a designated, sandbox area to experiment, clone reference repositories, run throwaway scripts, and save scratch notes without polluting the Git-tracked project codebase.

---

## 🚫 The Golden Rule: Zero Scratch File Pollution

As mandated by **[AGENTS.md](../AGENTS.md)** (Section 1: Negative Space Constraints):
> **🔴 NEVER DO:** No Scratch File Pollution — Never place throwaway scripts, benchmarks, scraped data, or logs outside `workspace/`.

Any file, script, log, or artifact placed inside `workspace/` is automatically ignored by Git and will **never** be committed or pushed to upstream remotes.

---

## 📁 Subdirectory Governance

```text
workspace/
├── archive/        # Deprecated code snippets, old migration drafts, discarded prototypes
├── audit/          # Visual audits, Playwright/Chrome screenshots, diagnostic traces
├── docs/           # Local scratch notes, uncommitted API specs, offline PDFs/HTML docs
├── repos/          # Cloned reference Git repositories, open-source libraries to inspect
└── tmp/            # Disposable test scripts, debug logs, ad-hoc JSON outputs, scratch benchmarks
```

### 1. `workspace/audit/` — Visual Audits & Headless Screenshots
- **Put Here:**
  - Headless Chromium and Playwright screenshots (`.png`, `.webp`).
  - Chrome DevTools performance traces, DOM heap snapshots, and network waterfall HAR files.
  - Temporary visual audit reports (`audit_report_<date>.md`).
- **Never Put Here:**
  - Production static assets or icons (place in `src/frontend/` or `src/themes/`).
- **Cleanup:**
  - Purged automatically via `./run.sh --clean` when audits are complete.

### 2. `workspace/tmp/` — Disposable Scratch & Test Runners
- **Put Here:**
  - One-off Python, Node, or Bash scripts used to test an isolated function or API call.
  - Temporary JSON or CSV dumps during data extraction.
  - Test output files, debug stack traces, and local benchmark runs.
  - Scraper test outputs or sandbox downloads.
- **Never Put Here:**
  - Production code meant to be run by the application.
  - Permanent configuration files or secrets needed by other team members.

### 2. `workspace/repos/` — Cloned Reference Repositories
- **Put Here:**
  - External GitHub repositories, open-source competitor tools, or upstream libraries cloned specifically to inspect their source code or study implementation patterns.
  - Reference example apps cloned from frameworks (e.g. Next.js examples, Flutter gallery).
- **Why Here?**
  - Git does not support nested repositories without complex submodules. Placing third-party repos inside `workspace/repos/` prevents accidental `.git` nesting and submodule corruption in the main repository.

### 3. `workspace/docs/` — Local Notes & Offline Documentation
- **Put Here:**
  - Personal developer scratchpads and rough notes.
  - Downloaded PDF manuals, offline HTML documentation, vendor whitepapers.
  - Raw meeting transcripts, local architecture ideation dumps.
- **Never Put Here:**
  - Official team documentation, Architecture Decision Records (ADRs), or onboarding runbooks (place these in `docs/architecture/` or `docs/guides/`).

### 4. `workspace/archive/` — Historical Stash & Dead Code
- **Put Here:**
  - Deprecated code snippets or modules that were refactored away but might contain useful historical logic.
  - Discarded exploratory prototypes.
  - Old migration drafts or database schema snapshots.
- **Never Put Here:**
  - Active feature branches (use Git branches instead).

---

## 🔒 Security & Privacy Notice
While `workspace/` is git-ignored, remember:
1. Do **not** leave unencrypted production database credentials or private master keys here.
2. Standard local security hygiene applies: this directory is stored on your local disk.
3. Clean out `workspace/tmp/` periodically to reclaim disk space.
