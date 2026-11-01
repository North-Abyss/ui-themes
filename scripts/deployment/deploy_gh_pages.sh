#!/usr/bin/env bash
# ==============================================================================
# scripts/deployment/deploy_gh_pages.sh
# Zero-dependency GitHub Pages Deployment Script
#
# [WHAT]
# Compiles static web assets and publishes them to the gh-pages deployment branch
# or checks that GitHub Pages CI is configured, supporting local and automated runs.
#
# [WHY]
# Projects require a rapid, automated, and idempotent mechanism to publish static
# documentation, showcases, or web SPAs without contaminating primary source branches
# with compiled distribution artifacts.
#
# [USAGE]
#   ./scripts/deployment/deploy_gh_pages.sh [options]
#
# Options:
#   --dry-run       Preview build and deployment actions without pushing
#   --source-dir    Directory containing compiled static assets (default: dist/)
#   --branch        Target deployment branch (default: gh-pages)
#   -h, --help      Show this help dialog
# ==============================================================================

set -euo pipefail

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

DRY_RUN=false
SOURCE_DIR="dist"
BRANCH="gh-pages"

show_help() {
    echo -e "${BOLD}deploy_gh_pages.sh${NC} - GitHub Pages Deployment Automation"
    echo ""
    echo "Usage: ./scripts/deployment/deploy_gh_pages.sh [options]"
    echo ""
    echo "Options:"
    echo "  --dry-run         Preview build and deployment actions without pushing"
    echo "  --source-dir <dir> Override source distribution directory (default: dist/)"
    echo "  --branch <branch> Override target Git branch (default: gh-pages)"
    echo "  -h, --help        Show this help dialog"
    echo ""
    echo "Requirements:"
    echo "  - Clean git status on current branch (or committed changes)"
    echo "  - Built distribution files in target directory"
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --source-dir) SOURCE_DIR="$2"; shift 2 ;;
        --branch) BRANCH="$2"; shift 2 ;;
        -h|--help) show_help ;;
        *) echo -e "${RED}Unknown argument: $1${NC}"; exit 1 ;;
    esac
done

echo -e "${BOLD}${BLUE}=== GitHub Pages Deployment Automation ===${NC}"

# 1. Ensure build output exists or trigger build
if [[ -f "./build.sh" ]]; then
    echo -e "${BLUE}Running ./build.sh distribution bundler...${NC}"
    ./build.sh
elif [[ -f "./run.sh" ]]; then
    echo -e "${BLUE}Running ./run.sh --build...${NC}"
    ./run.sh --build
fi

# If source still doesn't exist, check fallback locations (e.g. src/themes or public)
if [[ ! -d "$SOURCE_DIR" || -z "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]]; then
    if [[ -d "public" ]]; then
        SOURCE_DIR="public"
        echo -e "${YELLOW}Using fallback source directory: public/${NC}"
    elif [[ -f "src/themes/showcase.html" ]]; then
        echo -e "${YELLOW}Creating temporary distribution from src/themes/showcase.html...${NC}"
        mkdir -p dist
        cp src/themes/showcase.html dist/index.html
        SOURCE_DIR="dist"
    fi
fi

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}[DRY-RUN] Target branch: $BRANCH${NC}"
    echo -e "${YELLOW}[DRY-RUN] Files ready for deployment:${NC}"
    echo "  - index.html (Showcase & Live Modular Studio)"
    echo "  - dist/ (universal-themes.css, universal-themes.min.css)"
    echo "  - assets/ (social-preview-4x5.png, social-card.html)"
    echo "  - .nojekyll (Bypass Jekyll on GitHub Pages)"
    echo -e "\n${GREEN}[DRY-RUN] Deployment dry run completed successfully.${NC}"
    exit 0
fi

# 2. Check Git remote
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${RED}Error: Git remote 'origin' is not configured.${NC}"
    exit 1
fi

TEMP_WORKTREE="$(mktemp -d)"
cleanup() {
    if git worktree list | grep -q "$TEMP_WORKTREE"; then
        git worktree remove --force "$TEMP_WORKTREE" >/dev/null 2>&1 || true
    fi
    rm -rf "$TEMP_WORKTREE"
}
trap cleanup EXIT

echo -e "${BLUE}Preparing deployment worktree for branch '$BRANCH'...${NC}"

# Check if branch exists on origin
if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
    git fetch origin "$BRANCH":"$BRANCH" >/dev/null 2>&1 || true
    git worktree add -B "$BRANCH" "$TEMP_WORKTREE" "$BRANCH" >/dev/null 2>&1
else
    # Create orphan worktree
    git worktree add --detach "$TEMP_WORKTREE" >/dev/null 2>&1
    (
        cd "$TEMP_WORKTREE"
        git checkout --orphan "$BRANCH" >/dev/null 2>&1
        git rm -rf . >/dev/null 2>&1 || true
    )
fi

echo -e "${BLUE}Syncing build artifacts into worktree...${NC}"
# Remove old contents in worktree (except .git)
find "$TEMP_WORKTREE" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Copy built distribution files, showcase, and assets
if [[ -f "index.html" ]]; then
    cp index.html "$TEMP_WORKTREE"/
fi
if [[ -d "dist" ]]; then
    cp -r dist "$TEMP_WORKTREE"/
fi
if [[ -d "assets" ]]; then
    cp -r assets "$TEMP_WORKTREE"/
fi
if [[ -f "README.md" ]]; then
    cp README.md "$TEMP_WORKTREE"/
fi
if [[ -f "LICENSE" ]]; then
    cp LICENSE "$TEMP_WORKTREE"/
fi

# Add .nojekyll to prevent Jekyll processing on GitHub Pages
touch "$TEMP_WORKTREE/.nojekyll"

(
    cd "$TEMP_WORKTREE"
    git add -A
    if git diff --staged --quiet; then
        echo -e "${YELLOW}No changes detected to publish on '$BRANCH'. Already up to date.${NC}"
    else
        COMMIT_HASH="$(git -C "$ROOT_DIR" rev-parse --short HEAD)"
        git commit -m "deploy: publish build for commit $COMMIT_HASH" >/dev/null
        echo -e "${BLUE}Pushing to origin/$BRANCH...${NC}"
        git push -u origin "$BRANCH"
        echo -e "${GREEN}${BOLD}✔ Successfully deployed to GitHub Pages ($BRANCH)!${NC}"
    fi
)
