#!/bin/bash
# =============================================================================
# TaxHacker i18n/zh Sync Script
# 
# Syncs the Chinese localization branch with upstream changes from vas3k/TaxHacker
# while preserving all Chinese translations.
#
# Usage:
#   ./scripts/sync-i18n.sh          # Interactive mode
#   ./scripts/sync-i18n.sh --rebase  # Use rebase instead of merge
#   ./scripts/sync-i18n.sh --dry-run # Show what would be synced
# =============================================================================

set -e

UPSTREAM_REMOTE="upstream"
UPSTREAM_REPO="https://github.com/vas3k/TaxHacker.git"
BRANCH_NAME="i18n/zh"
CURRENT_BRANCH=$(git branch --show-current)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
DRY_RUN=false
USE_REBASE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --rebase)
            USE_REBASE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--rebase] [--dry-run]"
            echo "  --rebase    Use rebase instead of merge (default: merge)"
            echo "  --dry-run   Show what would be synced without making changes"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check current branch
if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
    log_warn "Current branch is '$CURRENT_BRANCH', switching to '$BRANCH_NAME'..."
    git checkout "$BRANCH_NAME"
fi

# Step 1: Add upstream remote if not exists
log_info "Checking upstream remote..."
if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
    log_info "Adding upstream remote: $UPSTREAM_REPO"
    git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_REPO"
else
    log_info "Upstream remote already exists"
fi

# Step 2: Fetch upstream
log_info "Fetching upstream changes..."
git fetch "$UPSTREAM_REMOTE"

# Step 3: Check if there are updates
UPSTREAM_COMMIT=$(git rev-parse "$UPSTREAM_REMOTE/main")
CURRENT_COMMIT=$(git rev-parse HEAD)
MERGE_BASE=$(git merge-base HEAD "$UPSTREAM_REMOTE/main")

if [ "$UPSTREAM_COMMIT" == "$CURRENT_COMMIT" ]; then
    log_success "Already up to date with upstream!"
    exit 0
fi

if [ "$UPSTREAM_COMMIT" == "$MERGE_BASE" ]; then
    log_success "No upstream changes (already includes upstream)"
    exit 0
fi

log_info "Upstream has new changes: $(git rev-list --count HEAD..$UPSTREAM_REMOTE/main) commits"

if [ "$DRY_RUN" == true ]; then
    log_info "=== DRY RUN MODE ==="
    log_info "Would merge/rebase with upstream. Run without --dry-run to apply."
    echo ""
    echo "Commits to apply:"
    git log --oneline HEAD..$UPSTREAM_REMOTE/main
    echo ""
    echo "Files likely to conflict:"
    git diff --name-only HEAD $UPSTREAM_REMOTE/main | head -20
    exit 0
fi

# Step 4: Backup Chinese translation files
log_info "Backing up Chinese translation files..."
BACKUP_DIR=$(mktemp -d)
cp messages/zh.json "$BACKUP_DIR/zh.json"
cp messages/en.json "$BACKUP_DIR/en.json"
cp i18n/request.ts "$BACKUP_DIR/request.ts" 2>/dev/null || true
cp routing.ts "$BACKUP_DIR/routing.ts" 2>/dev/null || true
cp next.config.ts "$BACKUP_DIR/next.config.ts" 2>/dev/null || true
log_info "Backup saved to: $BACKUP_DIR"

# Step 5: Merge or rebase with upstream
if [ "$USE_REBASE" == true ]; then
    log_info "Rebasing onto upstream/main..."
    if git rebase "$UPSTREAM_REMOTE/main"; then
        log_success "Rebase completed successfully"
    else
        log_error "Rebase failed with conflicts!"
        log_warn "Resolve conflicts manually, then run: git rebase --continue"
        log_warn "After resolving, restore Chinese files from: $BACKUP_DIR"
        exit 1
    fi
else
    log_info "Merging upstream/main..."
    if git merge "$UPSTREAM_REMOTE/main" --no-edit; then
        log_success "Merge completed successfully"
    else
        log_error "Merge failed with conflicts!"
        log_warn "Resolve conflicts manually, then run: git add . && git commit"
        log_warn "After resolving, restore Chinese files from: $BACKUP_DIR"
        exit 1
    fi
fi

# Step 6: Restore Chinese translation files (force overwrite)
log_info "Restoring Chinese translation files..."
cp "$BACKUP_DIR/zh.json" messages/zh.json
cp "$BACKUP_DIR/en.json" messages/en.json

# Restore i18n config files if they were modified upstream
if [ -f "$BACKUP_DIR/request.ts" ]; then
    # Merge our i18n config with upstream - we need to keep our locale configuration
    log_info "Restoring i18n configuration..."
    cp "$BACKUP_DIR/request.ts" i18n/request.ts
    cp "$BACKUP_DIR/routing.ts" routing.ts
    cp "$BACKUP_DIR/next.config.ts" next.config.ts
fi

# Clean up backup
rm -rf "$BACKUP_DIR"

# Step 7: Verify build
log_info "Verifying build..."
if npm run build &>/dev/null; then
    log_success "Build verified successfully!"
else
    log_warn "Build failed after sync. You may need to manually resolve some issues."
    log_warn "Check for translation keys that may have changed in the upstream code."
fi

# Step 8: Commit restored files if there are changes
if ! git diff --quiet messages/zh.json messages/en.json i18n/request.ts routing.ts next.config.ts 2>/dev/null; then
    log_info "Committing restored Chinese files..."
    git add messages/zh.json messages/en.json i18n/request.ts routing.ts next.config.ts
    git commit -m "chore(i18n): restore Chinese translations after upstream sync

This commit restores the Chinese localization files after syncing
with upstream changes from vas3k/TaxHacker."
fi

echo ""
log_success "=== Sync Complete ==="
echo ""
echo "Branch: $BRANCH_NAME"
echo "Upstream: $UPSTREAM_REMOTE/main"
echo ""
echo "To push the changes:"
echo "  git push"
echo ""
echo "To see what changed:"
echo "  git log --oneline -10"
echo "  git diff HEAD~1"
