#!/usr/bin/env bash

# ==============================================================================
# Universal MCP Configurator (scripts/dev/setup_mcp.sh)
# Detects local Node/npx paths and configures global Antigravity MCP servers
# (Playwright, Chrome DevTools, Google Stitch, Memory, Fetch)
# ==============================================================================

set -e

# Output Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_FILE="$PROJECT_ROOT/config/mcp/mcp_config.template.json"

DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        -h|--help)
            echo "Usage: ./scripts/dev/setup_mcp.sh [options]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Preview generated configuration without writing files"
            echo "  -h, --help   Show this help message"
            exit 0
            ;;
    esac
done

echo -e "${BOLD}${BLUE}=== Antigravity Universal MCP Configurator ===${NC}"

# 1. Locate Node and NPX binary
NPX_BIN="$(which npx 2>/dev/null || true)"
if [[ -z "$NPX_BIN" || ! -x "$NPX_BIN" ]]; then
    if [[ -x "$HOME/.nvm/versions/node/v22.18.0/bin/npx" ]]; then
        NPX_BIN="$HOME/.nvm/versions/node/v22.18.0/bin/npx"
    elif [[ -x "$HOME/.local/bin/npx" ]]; then
        NPX_BIN="$HOME/.local/bin/npx"
    elif [[ -x "$HOME/.gemini/antigravity-ide/bin/npx" ]]; then
        NPX_BIN="$HOME/.gemini/antigravity-ide/bin/npx"
    fi
fi

if [[ -z "$NPX_BIN" ]]; then
    echo -e "${RED}Error: Could not locate 'npx' executable.${NC}"
    echo "Please install Node.js / npm on your system."
    exit 1
fi

NODE_DIR="$(dirname "$NPX_BIN")"
echo -e "${GREEN}✓ Located NPX:${NC}  $NPX_BIN"
echo -e "${GREEN}✓ Node Directory:${NC} $NODE_DIR"

if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo -e "${RED}Error: Template file not found at $TEMPLATE_FILE${NC}"
    exit 1
fi

# 2. Render Template
GH_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
GENERATED_JSON=$(python3 - <<EOF
with open("$TEMPLATE_FILE", "r") as f:
    content = f.read()

content = content.replace("{{NPX_PATH}}", "$NPX_BIN")
content = content.replace("{{NODE_DIR}}", "$NODE_DIR")
content = content.replace("{{GITHUB_TOKEN}}", "$GH_TOKEN")
print(content)
EOF
)

if [[ "$DRY_RUN" == true ]]; then
    echo -e "\n${YELLOW}--- Dry Run Output ---${NC}"
    echo "$GENERATED_JSON"
    exit 0
fi

# 3. Write Target Configuration Files
TARGET_1="$HOME/.gemini/config/mcp_config.json"
TARGET_2="$HOME/.gemini/antigravity-ide/mcp_config.json"

mkdir -p "$(dirname "$TARGET_1")" "$(dirname "$TARGET_2")"

echo "$GENERATED_JSON" > "$TARGET_1"
echo "$GENERATED_JSON" > "$TARGET_2"

echo -e "\n${GREEN}✓ Successfully updated:${NC}"
echo -e "  - $TARGET_1"
echo -e "  - $TARGET_2"
echo -e "\n${BLUE}Next Step:${NC} Click ${BOLD}Refresh 🔄${NC} under Antigravity Settings > Customizations to activate servers."
