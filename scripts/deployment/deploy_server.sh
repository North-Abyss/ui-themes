#!/usr/bin/env bash
# ==============================================================================
# scripts/deployment/deploy_server.sh
# Zero-downtime Lean Server Deployment Automation (Capistrano-style Atomic Switch)
#
# [WHAT]
# Deploys pre-compiled application distribution bundles to a remote Linux VPS
# or server using atomic symlink switching, systemd service management,
# and shared persistent state segregation without running compilers on the server.
#
# [WHY]
# Production application servers must remain clean and lean. Running compilers,
# build tools, or heavy devDependencies directly on production hosts risks OOM crashes,
# disk exhaustion, and deployment downtime. Offloaded builds combined with atomic
# symlink swaps guarantee instantaneous rollouts with instant rollback capability.
#
# [USAGE]
#   ./scripts/deployment/deploy_server.sh [options]
#
# Options:
#   --host <ip|domain>     Target remote server hostname or IP address
#   --user <username>      SSH user on the remote host (default: deploy)
#   --path <remote_path>   Remote deployment root path (default: /var/www/app)
#   --service <name>       Systemd service name to reload (default: app)
#   --source-dir <dir>     Local compiled distribution directory (default: dist/)
#   --health-url <url>     Health check URL to smoke-test after reload
#   --dry-run              Simulate deployment without modifying remote host
#   -h, --help             Show this help dialog
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

DEPLOY_HOST="${DEPLOY_HOST:-}"
DEPLOY_USER="${DEPLOY_USER:-deploy}"
DEPLOY_PATH="${DEPLOY_PATH:-/var/www/app}"
SERVICE_NAME="${SERVICE_NAME:-app}"
SOURCE_DIR="dist"
HEALTH_URL="${HEALTH_URL:-}"
DRY_RUN=false
KEEP_RELEASES=5

show_help() {
    echo -e "${BOLD}deploy_server.sh${NC} - Lean Server Zero-Downtime Deployment"
    echo ""
    echo "Usage: ./scripts/deployment/deploy_server.sh [options]"
    echo ""
    echo "Options:"
    echo "  --host <ip|domain>     Target remote server hostname or IP address"
    echo "  --user <username>      SSH user on the remote host (default: deploy)"
    echo "  --path <remote_path>   Remote deployment root path (default: /var/www/app)"
    echo "  --service <name>       Systemd service name to reload (default: app)"
    echo "  --source-dir <dir>     Local compiled distribution directory (default: dist/)"
    echo "  --health-url <url>     Health check URL to smoke-test after reload"
    echo "  --dry-run              Simulate deployment without modifying remote host"
    echo "  -h, --help             Show this help dialog"
    echo ""
    echo "Directory Layout on Server:"
    echo "  $DEPLOY_PATH/"
    echo "  ├── current -> releases/<timestamp>/   # Atomic live symlink"
    echo "  ├── releases/                          # Timestamped releases (last $KEEP_RELEASES)"
    echo "  └── shared/                            # Persistent files (.env, storage/)"
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --host) DEPLOY_HOST="$2"; shift 2 ;;
        --user) DEPLOY_USER="$2"; shift 2 ;;
        --path) DEPLOY_PATH="$2"; shift 2 ;;
        --service) SERVICE_NAME="$2"; shift 2 ;;
        --source-dir) SOURCE_DIR="$2"; shift 2 ;;
        --health-url) HEALTH_URL="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        -h|--help) show_help ;;
        *) echo -e "${RED}Unknown argument: $1${NC}"; exit 1 ;;
    esac
done

echo -e "${BOLD}${BLUE}=== Lean Server Deployment Automation ===${NC}"

# 1. Validate local source distribution
if [[ ! -d "$SOURCE_DIR" || -z "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]]; then
    echo -e "${YELLOW}Distribution directory '$SOURCE_DIR' missing or empty. Running build...${NC}"
    if [[ -f "./run.sh" ]]; then
        ./run.sh --build || {
            echo -e "${RED}Build failed. Aborting deployment.${NC}"
            exit 1
        }
    else
        echo -e "${RED}Error: Cannot find build script or distribution directory '$SOURCE_DIR'.${NC}"
        exit 1
    fi
fi

if [[ -z "$DEPLOY_HOST" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN] No remote host specified. Simulating local staging validation...${NC}"
        echo -e "${GREEN}[DRY-RUN] Validated source directory: $SOURCE_DIR${NC}"
        ls -la "$SOURCE_DIR"
        echo -e "${GREEN}[DRY-RUN] Local staging validation passed.${NC}"
        exit 0
    else
        echo -e "${RED}Error: Remote deployment host not specified. Pass --host <ip|domain> or set DEPLOY_HOST.${NC}"
        echo -e "Run with -h or --help for usage details."
        exit 1
    fi
fi

TIMESTAMP="$(date +'%Y%m%d%H%M%S')"
REMOTE_TARGET="$DEPLOY_USER@$DEPLOY_HOST"
RELEASE_DIR="$DEPLOY_PATH/releases/$TIMESTAMP"

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}[DRY-RUN] Target Server:     $REMOTE_TARGET${NC}"
    echo -e "${YELLOW}[DRY-RUN] Remote Path:       $DEPLOY_PATH${NC}"
    echo -e "${YELLOW}[DRY-RUN] New Release:       $RELEASE_DIR${NC}"
    echo -e "${YELLOW}[DRY-RUN] Systemd Service:   $SERVICE_NAME${NC}"
    echo -e "${YELLOW}[DRY-RUN] Keep Releases:     $KEEP_RELEASES${NC}"
    echo -e "\n${GREEN}[DRY-RUN] Server deployment dry run completed successfully.${NC}"
    exit 0
fi

# 2. Check SSH connectivity & ensure remote directory scaffolding
echo -e "${BLUE}Verifying remote server connection and directory structure...${NC}"
ssh -o BatchMode=yes -o ConnectTimeout=10 "$REMOTE_TARGET" "
    mkdir -p '$DEPLOY_PATH/releases' '$DEPLOY_PATH/shared'
    if [ ! -f '$DEPLOY_PATH/shared/.env' ]; then
        echo 'WARNING: $DEPLOY_PATH/shared/.env not found! Ensure environment variables are configured.' >&2
    fi
"

# 3. Synchronize compiled distribution to new release directory
echo -e "${BLUE}Transferring release payload to $RELEASE_DIR...${NC}"
ssh "$REMOTE_TARGET" "mkdir -p '$RELEASE_DIR'"
rsync -avz --delete "$SOURCE_DIR/" "$REMOTE_TARGET:$RELEASE_DIR/"

# 4. Atomic symlink switch & service restart
echo -e "${BLUE}Executing atomic symlink switch and service restart...${NC}"
ssh "$REMOTE_TARGET" "
    # Link shared .env if present
    if [ -f '$DEPLOY_PATH/shared/.env' ]; then
        ln -nfs '$DEPLOY_PATH/shared/.env' '$RELEASE_DIR/.env'
    fi

    # Link shared storage if present
    if [ -d '$DEPLOY_PATH/shared/storage' ]; then
        ln -nfs '$DEPLOY_PATH/shared/storage' '$RELEASE_DIR/storage'
    fi

    # Atomic symlink swap
    ln -nfsT '$RELEASE_DIR' '$DEPLOY_PATH/current'

    # Graceful service restart/reload
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl reload-or-restart '$SERVICE_NAME' || sudo systemctl restart '$SERVICE_NAME'
    fi

    # Retention: Prune older releases, keeping the latest $KEEP_RELEASES
    cd '$DEPLOY_PATH/releases'
    ls -dt */ 2>/dev/null | tail -n +$((KEEP_RELEASES + 1)) | xargs -r rm -rf
"

# 5. Post-deployment smoke check
if [[ -n "$HEALTH_URL" ]]; then
    echo -e "${BLUE}Running post-deployment health check on $HEALTH_URL...${NC}"
    if curl --silent --fail --retry 3 --retry-delay 2 "$HEALTH_URL" >/dev/null; then
        echo -e "${GREEN}✔ Health check passed!${NC}"
    else
        echo -e "${RED}Health check failed on $HEALTH_URL! Inspect server logs via SSH: journalctl -u $SERVICE_NAME -n 50${NC}"
        exit 1
    fi
fi

echo -e "\n${GREEN}${BOLD}✔ Zero-downtime deployment to $DEPLOY_HOST successfully completed!${NC}"
