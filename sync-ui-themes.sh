#!/usr/bin/env bash
# ==============================================================================
# Universal UI Themes Sync & Distribution Script (sync-ui-themes.sh)
# Author: Yuvanesh KS (@North-Abyss)
# Repository: https://github.com/North-Abyss/ui-themes
#
# Use this script in any other project to install or stay updated with
# the latest Universal UI Themes CSS bundles (22 production presets & tokens).
#
# Usage:
#   ./sync-ui-themes.sh [options]
#   curl -fsSL https://raw.githubusercontent.com/North-Abyss/ui-themes/main/sync-ui-themes.sh | bash
#
# Options:
#   --dest <dir>      Destination directory for CSS bundles (default: src/themes or vendor/themes)
#   --minified-only   Only download universal-themes.min.css
#   --check           Check for updates against upstream without downloading
#   -h, --help        Show this help dialog
# ==============================================================================

set -euo pipefail

# ANSI Output Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

UPSTREAM_RAW="https://raw.githubusercontent.com/North-Abyss/ui-themes/main"
LOCAL_FALLBACK="/mnt/sda5/Projects/UI-Template"
TARGET_DIR=""
MINIFIED_ONLY=false
CHECK_ONLY=false

show_help() {
    echo -e "${BOLD}Universal UI Themes Sync Client (sync-ui-themes.sh)${NC}"
    echo ""
    echo "Usage: ./sync-ui-themes.sh [options]"
    echo ""
    echo "Options:"
    echo "  --dest <dir>       Target directory (default: detects ./src/themes, ./assets/css, or ./vendor)"
    echo "  --minified-only    Download only the minified CSS bundle"
    echo "  --check            Check upstream version/SHA without writing files"
    echo "  -h, --help         Show this help dialog"
    echo ""
    echo "Upstream: ${CYAN}https://github.com/North-Abyss/ui-themes${NC}"
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --dest) TARGET_DIR="$2"; shift 2 ;;
        --minified-only) MINIFIED_ONLY=true; shift ;;
        --check) CHECK_ONLY=true; shift ;;
        -h|--help) show_help ;;
        *) echo -e "${RED}Unknown argument: $1${NC}"; exit 1 ;;
    esac
done

echo -e "${BOLD}${CYAN}🎨 Universal UI Themes Client Updater${NC}"
echo -e "${BLUE}================================================================${NC}"

# Auto-detect destination directory if not specified
if [[ -z "$TARGET_DIR" ]]; then
    if [[ -d "src/themes" ]]; then
        TARGET_DIR="src/themes"
    elif [[ -d "src/assets/css" ]]; then
        TARGET_DIR="src/assets/css"
    elif [[ -d "assets/css" ]]; then
        TARGET_DIR="assets/css"
    elif [[ -d "public/css" ]]; then
        TARGET_DIR="public/css"
    elif [[ -d "vendor" ]]; then
        TARGET_DIR="vendor/ui-themes"
    else
        TARGET_DIR="src/themes"
    fi
fi

mkdir -p "$TARGET_DIR"

CSS_UNMIN="universal-themes.css"
CSS_MIN="universal-themes.min.css"

fetch_file() {
    local filename="$1"
    local dest_path="$TARGET_DIR/$filename"

    # 1. Try local repository if available
    if [[ -d "$LOCAL_FALLBACK/dist" && -f "$LOCAL_FALLBACK/dist/$filename" ]]; then
        cp "$LOCAL_FALLBACK/dist/$filename" "$dest_path"
        echo -e "  ${GREEN}✓ Synced from local master template:${NC} $dest_path ($(wc -c < "$dest_path") bytes)"
        return 0
    fi

    # 2. Try remote upstream via curl
    local url="${UPSTREAM_RAW}/dist/${filename}"
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL "$url" -o "$dest_path"; then
            echo -e "  ${GREEN}✓ Downloaded upstream bundle:${NC} $dest_path ($(wc -c < "$dest_path") bytes)"
            return 0
        fi
    fi

    echo -e "  ${RED}✗ Failed to sync $filename from upstream or local fallback.${NC}"
    return 1
}

if [[ "$CHECK_ONLY" == true ]]; then
    echo -e "${BLUE}Checking upstream repository North-Abyss/ui-themes...${NC}"
    if curl -fsIL "${UPSTREAM_RAW}/dist/${CSS_MIN}" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Upstream release bundles are online and reachable!${NC}"
    else
        echo -e "${YELLOW}Warning: Could not connect to GitHub raw endpoint.${NC}"
    fi
    exit 0
fi

echo -e "Target destination: ${BOLD}${TARGET_DIR}${NC}\n"

if [[ "$MINIFIED_ONLY" != true ]]; then
    fetch_file "$CSS_UNMIN"
fi
fetch_file "$CSS_MIN"

echo -e "\n${BOLD}${GREEN}✨ Universal UI Themes successfully synced!${NC}"
echo -e "${BLUE}----------------------------------------------------------------${NC}"
echo -e "To activate any of the 22 themes in your project HTML:"
echo -e "  1. Include stylesheet: ${YELLOW}<link rel=\"stylesheet\" href=\"${TARGET_DIR}/${CSS_MIN}\">${NC}"
echo -e "  2. Set active theme:   ${YELLOW}<html data-theme=\"tokyo-night\">${NC} (or material3, catppuccin-mocha, etc.)"
echo -e "${BLUE}================================================================${NC}\n"
