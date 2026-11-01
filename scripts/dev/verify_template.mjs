#!/usr/bin/env node

/**
 * ==============================================================================
 * verify_template.mjs
 * Zero-dependency Node.js Directory Governance & Template Integrity Auditor
 *
 * [PURPOSE]
 * Validates that the repository adheres to the Universal PT architecture:
 * checks required directory scaffolding, canonical governance files,
 * on-demand skills with YAML frontmatter, and prohibited anti-patterns.
 *
 * [USAGE]
 *   node scripts/dev/verify_template.mjs
 *   ./run.sh --audit
 * ==============================================================================
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const DEFAULT_ROOT = path.resolve(__dirname, '../../');

// ANSI Colors
const GREEN = '\x1b[32m';
const RED = '\x1b[31m';
const YELLOW = '\x1b[33m';
const BLUE = '\x1b[34m';
const BOLD = '\x1b[1m';
const RESET = '\x1b[0m';

export const REQUIRED_DIRECTORIES = [
  'src/frontend',
  'src/backend',
  'src/database',
  'src/integrations',
  'src/shared',
  'src/themes',
  'scripts/dev',
  'scripts/deployment',
  'packaging/desktop',
  'config/ci',
  'config/docker',
  '.githooks',
  'tests/unit',
  'tests/e2e',
  '.agents/skills',
  'config/mcp',
  'specs',
  'workspace/audit',
];

export const REQUIRED_FILES = [
  'AGENTS.md',
  'run.sh',
  'git-sync.sh',
  'update-template.sh',
  'agent-memory.md',
  'log.md',
  'agent-rules.md',
  'src/ARCHITECTURE.md',
  '.agents/hooks.json',
  '.cursorignore',
  '.agentignore',
  '.githooks/pre-commit',
  'scripts/deployment/deploy_gh_pages.sh',
  'scripts/deployment/deploy_server.sh',
  'scripts/dev/verify_env.py',
  'packaging/desktop/README.md',
  'docs/APP_SPEC.md.template',
];

export const CANONICAL_SKILLS = [
  'spec-planner',
  'tdd-implementer',
  'circuit-breaker',
  'code-review',
  'browser-testing',
  'template-sync',
  'mcp-tooling',
  'doc-governance',
  'db-migrator',
  'security-auditor',
];

export const PROHIBITED_DIRECTORIES = [
  'apps',
  'packages',
  'pb_data',
];

/**
 * Audits a repository root against the universal PT template specification.
 *
 * @param {string} rootDir - Absolute path to the repository root.
 * @returns {{ passed: boolean, errors: string[], warnings: string[], stats: object }}
 */
export function runAudit(rootDir = DEFAULT_ROOT) {
  const errors = [];
  const warnings = [];
  let checkedDirs = 0;
  let checkedFiles = 0;
  let checkedSkills = 0;

  // 1. Check required directories
  for (const relDir of REQUIRED_DIRECTORIES) {
    const fullPath = path.join(rootDir, relDir);
    if (!fs.existsSync(fullPath)) {
      errors.push(`Missing required directory: ${relDir}`);
    } else {
      checkedDirs++;
    }
  }

  // 2. Check canonical files
  for (const relFile of REQUIRED_FILES) {
    const fullPath = path.join(rootDir, relFile);
    if (!fs.existsSync(fullPath)) {
      errors.push(`Missing canonical file: ${relFile}`);
    } else {
      checkedFiles++;
    }
  }

  // 3. Check skills and frontmatters
  const skillsBaseDir = path.join(rootDir, '.agents/skills');
  for (const skillName of CANONICAL_SKILLS) {
    const skillFile = path.join(skillsBaseDir, skillName, 'SKILL.md');
    if (!fs.existsSync(skillFile)) {
      errors.push(`Missing canonical skill: .agents/skills/${skillName}/SKILL.md`);
      continue;
    }

    try {
      const content = fs.readFileSync(skillFile, 'utf8');
      const hasName = /name:\s*[a-zA-Z0-9_-]+/.test(content);
      const hasDesc = /description:\s*.+/.test(content);

      if (!hasName || !hasDesc) {
        warnings.push(`Skill .agents/skills/${skillName}/SKILL.md missing valid YAML frontmatter (name/description)`);
      } else {
        checkedSkills++;
      }
    } catch (err) {
      errors.push(`Could not read skill file: ${skillName} (${err.message})`);
    }
  }

  // 4. Check prohibited directory anti-patterns
  for (const prohibDir of PROHIBITED_DIRECTORIES) {
    const fullPath = path.join(rootDir, prohibDir);
    if (fs.existsSync(fullPath)) {
      errors.push(`Prohibited directory detected at root: ${prohibDir}/ (Violates single-source PT governance)`);
    }
  }

  const passed = errors.length === 0;
  return {
    passed,
    errors,
    warnings,
    stats: {
      directoriesChecked: checkedDirs,
      filesChecked: checkedFiles,
      skillsChecked: checkedSkills,
    },
  };
}

// CLI Execution Handler
if (process.argv[1] && path.resolve(process.argv[1]) === path.resolve(__filename)) {
  const args = process.argv.slice(2);
  if (args.includes('-h') || args.includes('--help')) {
    console.log(`${BOLD}verify_template.mjs${RESET} - PT Directory Governance & Skill Auditor`);
    console.log(`\nUsage: node scripts/dev/verify_template.mjs [options]`);
    console.log(`\nOptions:`);
    console.log(`  --root <path>   Override root directory to scan`);
    console.log(`  -h, --help      Show this help dialog\n`);
    process.exit(0);
  }

  let rootArg = DEFAULT_ROOT;
  const rootIdx = args.indexOf('--root');
  if (rootIdx !== -1 && args[rootIdx + 1]) {
    rootArg = path.resolve(args[rootIdx + 1]);
  }

  console.log(`${BOLD}${BLUE}=== Running PT Template Governance Audit ===${RESET}`);
  console.log(`Auditing target: ${rootArg}\n`);

  const result = runAudit(rootArg);

  console.log(`${GREEN}✔ Directories verified:${RESET} ${result.stats.directoriesChecked}/${REQUIRED_DIRECTORIES.length}`);
  console.log(`${GREEN}✔ Canonical files verified:${RESET} ${result.stats.filesChecked}/${REQUIRED_FILES.length}`);
  console.log(`${GREEN}✔ On-demand skills verified:${RESET} ${result.stats.skillsChecked}/${CANONICAL_SKILLS.length}`);

  if (result.warnings.length > 0) {
    console.log(`\n${YELLOW}${BOLD}Warnings (${result.warnings.length}):${RESET}`);
    for (const w of result.warnings) {
      console.log(`  ${YELLOW}⚠️  ${w}${RESET}`);
    }
  }

  if (!result.passed) {
    console.log(`\n${RED}${BOLD}Audit Failures (${result.errors.length}):${RESET}`);
    for (const err of result.errors) {
      console.log(`  ${RED}✖ ${err}${RESET}`);
    }
    console.log(`\n${RED}Template governance audit failed.${RESET}`);
    process.exit(1);
  } else {
    console.log(`\n${GREEN}${BOLD}✔ All directory governance & template checks passed successfully!${RESET}`);
    process.exit(0);
  }
}
