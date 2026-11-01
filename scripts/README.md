# Scripts Reference Manual — {{PROJECT_NAME}}

> **Upstream Master:** [North-Abyss/PT](https://github.com/North-Abyss/PT)  
> **Related Documentation:** [agent-rules.md](agent-rules.md) | [src/ARCHITECTURE.md](src/ARCHITECTURE.md)

---

## Directory Organization

```text
scripts/
├── dev/                        # Local development & audit utilities
│   ├── verify_template.py      # Universal zero-dep Python directory governance auditor
│   ├── verify_template.mjs     # Node.js directory governance & skill validator
│   ├── verify_code_rules.py    # What & Why docblock + theme token auditor
│   ├── verify_env.py           # Environment variable parity validator (.env vs template)
│   ├── hook_safety_gate.py     # Antigravity PreToolUse destructive & remote command gate
│   ├── verify_web.sh           # Headless browser verification script
│   └── setup_mcp.sh            # Universal MCP server configuration helper
├── deployment/                 # Build, packaging & release automation
│   ├── deploy_gh_pages.sh      # Static site publishing to GitHub Pages
│   └── deploy_server.sh        # Zero-downtime lean VPS / bare server deployment
└── README.md                   # This documentation manual
```

---

## Development Scripts (`scripts/dev/`)

### 1. `verify_template.mjs`
- **Purpose:** Verifies project template integrity, canonical file presence, directory governance, and skill frontmatters.
- **Runtime:** Node.js (v18+, zero external npm dependencies).
- **Usage:**
  ```bash
  node scripts/dev/verify_template.mjs
  # Or via application runner:
  ./run.sh --audit
  ```
- **Checks:**
  - Presence of required architecture directories (`src/frontend`, `src/backend`, `src/database`, `src/integrations`, `src/shared`, `src/themes`, `scripts/dev`, `tests/unit`, `.agents/skills`, `workspace/audit`, etc.).
  - Presence of canonical governance files (`AGENTS.md`, `run.sh`, `git-sync.sh`, `agent-memory.md`, `log.md`, `.agents/hooks.json`).
  - Validation of all 10 on-demand skills in `.agents/skills/` (valid `SKILL.md` with `name:` and `description:`).
  - Absence of prohibited duplicate root directories (`apps/`, `packages/`, stray `pb_data/`).

### 2. `verify_code_rules.py`
- **Purpose:** Scans source code for compliance with the "What & Why" documentation standard, module provider headers, and design token rules.
- **Runtime:** Python 3.8+ (stdlib only, zero pip dependencies).
- **Usage:**
  ```bash
  # Soft audit (warns but exits 0):
  python3 scripts/dev/verify_code_rules.py --src src/

  # Strict mode (exits 1 on any violation, ideal for CI):
  python3 scripts/dev/verify_code_rules.py --src src/ --strict
  ```
- **Checks:**
  - Exported functions/methods/classes without docblocks.
  - Docblocks missing rationale (`@remarks` for TS/JS, `[WHY]` for Python/Dart).
  - Raw inline hex colors (`#[0-9a-fA-F]{3,8}`) outside theme token directories.
  - Hardcoded magic numbers in business logic files.

### 3. `verify_env.py`
- **Purpose:** Verifies that all required keys declared in `config/environments/.env.example` are present in `.env`, and detects undocumented keys.
- **Runtime:** Python 3.8+ (zero dependencies).
- **Usage:**
  ```bash
  python3 scripts/dev/verify_env.py
  # Or via application runner:
  ./run.sh --audit
  ```

### 4. `hook_safety_gate.py`
- **Purpose:** Antigravity `PreToolUse` lifecycle hook intercepting destructive shell commands (`git reset --hard`, `git clean`, `rm -rf`, force-push) and unauthorized remote network executions (`ssh`, `scp`, `rsync.*@`, live deploy scripts).
- **Runtime:** Python 3.8+ (zero dependencies).
- **Usage:**
  ```bash
  echo '{"toolCall":{"name":"run_command","args":{"CommandLine":"git reset --hard"}}}' | python3 scripts/dev/hook_safety_gate.py
  ```

### 5. `verify_web.sh`
- **Purpose:** Headless browser validation using Chromium / Playwright.
- **Usage:**
  ```bash
  ./scripts/dev/verify_web.sh http://localhost:8080/src/themes/showcase.html
  ```

### 5. `setup_mcp.sh`
- **Purpose:** Configures MCP server endpoints and local development tooling.
- **Usage:**
  ```bash
  ./scripts/dev/setup_mcp.sh
  ```

---

## Deployment Scripts (`scripts/deployment/`)

### 1. `deploy_gh_pages.sh`
- **Purpose:** Compiles static web assets and publishes them cleanly to the `gh-pages` branch using temporary worktrees.
- **Runtime:** Bash + Git.
- **Usage:**
  ```bash
  ./scripts/deployment/deploy_gh_pages.sh
  ./scripts/deployment/deploy_gh_pages.sh --dry-run
  # Or via application runner:
  ./run.sh --deploy pages
  ```

### 2. `deploy_server.sh`
- **Purpose:** Deploys pre-compiled distributions to remote Linux servers using atomic symlink swaps (`releases/<timestamp>` and `current -> releases/<timestamp>`), shared `.env` linking, and systemd reloading with zero build overhead on the server.
- **Runtime:** Bash + SSH + rsync.
- **Usage:**
  ```bash
  ./scripts/deployment/deploy_server.sh --host 192.168.1.10 --user deploy --service myapp
  ./scripts/deployment/deploy_server.sh --dry-run
  # Or via application runner:
  ./run.sh --deploy server
  ```


---

## Universal Script Conventions
All scripts in this directory must adhere to the following standards:
1. **Header Comment:** Clear purpose description and usage syntax at the top of the file.
2. **Idempotence:** Safe to run repeatedly without unintended side effects.
3. **CLI Help:** Must support `-h` and `--help` flags displaying usage documentation.
4. **Permissions:** Must have executable permissions (`chmod +x`).
5. **Documentation:** Must be registered in this `scripts/README.md` and referenced in `log.md`.
