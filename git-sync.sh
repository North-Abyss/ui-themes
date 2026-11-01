#!/usr/bin/env bash

# ==============================================================================
# Git Commit & Sync Script (Universal v0.4.0)
# Syncs local repository with remote and optionally triggers Cloud CI/CD & Deploys
# Usage: ./git-sync.sh [options]
# Options:
#   --sync                  Non-interactive mode (commit & push only, skip CI prompts)
#   -m, --message "msg"     Commit message (auto-timestamps if left blank)
#   -b, --branch "branch"   Target branch (defaults to current branch)
#   -t, --tag "tag"         Release tag to push (e.g., v1.0.0)
#   --deploy-web            Trigger Web Deploy pipeline
#   -h, --help              Show help message
#   -v, --version           Show script version
# ==============================================================================

set -e

# Output Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

VERSION="v0.4.0"
SYNC_ONLY=false
COMMIT_MSG=""
TARGET_BRANCH=""
RELEASE_TAG=""
DEPLOY_WEB=""
DEPLOY_GH_PAGES=""

# Parse Command-Line Arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --sync)
            SYNC_ONLY=true
            shift
            ;;
        --deploy-gh-pages|--deploy-pages)
            DEPLOY_GH_PAGES="y"
            DEPLOY_WEB=${DEPLOY_WEB:-"n"}
            shift
            ;;
        -m|--message)
            COMMIT_MSG="$2"
            shift 2
            ;;
        -b|--branch)
            TARGET_BRANCH="$2"
            shift 2
            ;;
        -t|--tag)
            RELEASE_TAG="$2"
            shift 2
            ;;
        --deploy-web)
            DEPLOY_WEB="y"
            shift
            ;;
        -v|--version)
            echo -e "git-sync.sh ${VERSION}"
            exit 0
            ;;
        -h|--help|-help|-\?)
            echo -e "${BOLD}Usage:${NC} ./git-sync.sh [options]"
            echo ""
            echo "Options:"
            echo "  --sync                Skip interactive prompts (git commit & push only)"
            echo "  -m, --message <msg>   Commit message (defaults to timestamp if blank)"
            echo "  -b, --branch <branch> Target branch (defaults to current active branch)"
            echo "  -t, --tag <tag>       Create and push a release tag (e.g. v1.0.0)"
            echo "  --deploy-gh-pages     Deploy showcase directly to GitHub Pages (gh-pages)"
            echo "  --deploy-web          Trigger automated web deployment tag"
            echo "  -v, --version         Display script version"
            echo "  -h, --help            Display this help dialog"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown parameter passed: $1${NC}"
            echo -e "Run ${YELLOW}./git-sync.sh --help${NC} for available options."
            exit 1
            ;;
    esac
done

# Ensure we are inside a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}Error: Not inside a Git repository. Run 'git init' first.${NC}"
    exit 1
fi

echo -e "${BLUE}=== Starting Repository Sync (${VERSION}) ===${NC}"

# 1. Branch Resolution
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

if [[ -z "$TARGET_BRANCH" ]]; then
    if [[ "$SYNC_ONLY" == true ]]; then
        TARGET_BRANCH="$current_branch"
    else
        echo -e "${YELLOW}Available local branches:${NC}"
        git branch --format="  %(refname:short)" 2>/dev/null || echo "  $current_branch"
        echo ""
        read -p "Target branch [$current_branch]: " user_branch
        TARGET_BRANCH=${user_branch:-$current_branch}
    fi
fi

if [[ "$current_branch" != "$TARGET_BRANCH" ]]; then
    echo -e "${YELLOW}Switching to branch '$TARGET_BRANCH'...${NC}"
    git checkout "$TARGET_BRANCH" 2>/dev/null || git checkout -b "$TARGET_BRANCH"
fi

# 2. Stage and Commit Changes
echo -e "${BLUE}Staging modified files...${NC}"
git add .

if [[ -n "$(git status --porcelain)" ]]; then
    if [[ -z "$COMMIT_MSG" ]]; then
        if [[ "$SYNC_ONLY" == true ]]; then
            COMMIT_MSG="sync: automated update $(date '+%d-%b-%Y %H:%M')"
        else
            read -p "Enter commit message (leave blank for auto-timestamp): " user_msg
            COMMIT_MSG=${user_msg:-"$(date '+%d-%b-%Y-T-%H:%M')"}
        fi
    fi
    echo -e "${BLUE}Committing changes: ${BOLD}${COMMIT_MSG}${NC}"
    git commit -m "$COMMIT_MSG"
else
    echo -e "${YELLOW}Working tree clean. No new changes to commit.${NC}"
fi

# 3. Pull & Push Remote Verification
has_remote=$(git remote 2>/dev/null || true)

if [[ -n "$has_remote" ]]; then
    echo -e "${BLUE}Fetching and rebasing with origin/$TARGET_BRANCH...${NC}"
    git fetch origin "$TARGET_BRANCH" --tags 2>/dev/null || true
    git pull --rebase origin "$TARGET_BRANCH" 2>/dev/null || true

    echo -e "${BLUE}Pushing to origin/$TARGET_BRANCH...${NC}"
    git push origin "$TARGET_BRANCH"
    echo -e "${GREEN}✓ Successfully synced with origin/$TARGET_BRANCH!${NC}"
else
    echo -e "${YELLOW}Notice: No remote configured. Local commit succeeded.${NC}"
fi

# Exit early if running in non-interactive sync mode
if [[ "$SYNC_ONLY" == true ]]; then
    exit 0
fi

# 4. Optional Release Tagging
echo -e "\n${YELLOW}--- Release Pipeline ---${NC}"
if [[ -z "$RELEASE_TAG" ]]; then
    read -p "Do you want to publish a release tag now? (y/n) [n]: " trigger_release
else
    trigger_release="y"
fi

if [[ "${trigger_release,,}" == "y" ]]; then
    if [[ -z "$RELEASE_TAG" ]]; then
        read -p "Enter version tag (e.g. v1.0.0): " RELEASE_TAG
    fi

    if [[ -n "$RELEASE_TAG" ]]; then
        if git rev-parse -q --verify "refs/tags/$RELEASE_TAG" >/dev/null; then
            echo -e "${RED}Warning: Tag '$RELEASE_TAG' already exists!${NC}"
            read -p "Do you want to overwrite it? (y/n) [n]: " replace_tag
            if [[ "${replace_tag,,}" == "y" ]]; then
                git tag -d "$RELEASE_TAG" 2>/dev/null || true
                if [[ -n "$has_remote" ]]; then
                    git push origin --delete "$RELEASE_TAG" 2>/dev/null || true
                fi
            else
                echo -e "${BLUE}Release tagging skipped.${NC}"
                RELEASE_TAG=""
            fi
        fi

        if [[ -n "$RELEASE_TAG" ]]; then
            git tag "$RELEASE_TAG"
            if [[ -n "$has_remote" ]]; then
                git push origin "$RELEASE_TAG"
                echo -e "${GREEN}✓ Release tag '$RELEASE_TAG' created and pushed!${NC}"
            else
                echo -e "${GREEN}✓ Release tag '$RELEASE_TAG' created locally.${NC}"
            fi
        fi
    fi
fi

# 5. Optional GitHub Pages & Web Deployment Pipeline
echo -e "\n${YELLOW}--- Deployment Pipeline (GitHub Pages) ---${NC}"
if [[ -z "$DEPLOY_GH_PAGES" && "$SYNC_ONLY" == false ]]; then
    read -p "Deploy build showcase to GitHub Pages (gh-pages)? (y/n) [y]: " pages_prompt
    DEPLOY_GH_PAGES=${pages_prompt:-"y"}
fi

if [[ "${DEPLOY_GH_PAGES,,}" =~ ^(y|yes)$ ]]; then
    if [[ -f "./scripts/deployment/deploy_gh_pages.sh" ]]; then
        echo -e "${BLUE}Running GitHub Pages deployment...${NC}"
        chmod +x ./scripts/deployment/deploy_gh_pages.sh
        ./scripts/deployment/deploy_gh_pages.sh
    else
        echo -e "${RED}deploy_gh_pages.sh not found.${NC}"
    fi
fi

if [[ -z "$DEPLOY_WEB" && "$SYNC_ONLY" == false ]]; then
    read -p "Trigger Cloud Web Deployment tag? (y/n) [n]: " deploy_prompt
    DEPLOY_WEB=${deploy_prompt:-"n"}
fi

if [[ "${DEPLOY_WEB,,}" == "y" ]]; then
    web_tag="web-deploy-$(date +%Y%m%d-%H%M%S)"
    git tag "$web_tag"
    if [[ -n "$has_remote" ]]; then
        git push origin "$web_tag"
        echo -e "${GREEN}✓ Web deployment triggered via tag '$web_tag'!${NC}"
    else
        echo -e "${GREEN}✓ Web deployment tag '$web_tag' created locally.${NC}"
    fi
fi

echo -e "\n${GREEN}✓ All operations completed successfully.${NC}"
