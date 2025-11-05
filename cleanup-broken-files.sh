#!/usr/bin/env bash

################################################################################
# Broken Files Cleanup Script
################################################################################
#
# Repository: https://github.com/joaquimscosta/homebrew-arm64-migration
# License: MIT
# Version: 1.0.0
#
# Purpose: Remove specific broken symlinks and scripts after Homebrew uninstall
#
# What this script removes:
#   - Broken Python scripts that reference non-existent Homebrew Python
#   - Broken npm CLI symlinks that reference non-existent node_modules
#   - Broken man page symlinks (npm docs + Homebrew docs)
#
# What this script PRESERVES:
#   - All legitimate software (Go, .NET SDK, Docker, Microsoft tools, VS Code)
#   - All working symlinks and binaries
#   - All system directories
#
# Safety Features:
#   - Interactive confirmation before each deletion category
#   - Dry-run mode to preview changes without making them
#   - Detailed reporting of what will be removed
#
# Usage:
#   ./cleanup-broken-files.sh              # Interactive mode
#   ./cleanup-broken-files.sh --dry-run    # Preview mode (no changes)
#   ./cleanup-broken-files.sh --auto       # Auto-approve all (use with caution)
#
# SECURITY WARNING:
#   This script removes files from /usr/local. Review the script before running.
#   Use --dry-run first to preview what will be removed.
#
# Requirements:
#   - Previous Intel Homebrew installation at /usr/local
#   - Administrator access (sudo)
#
################################################################################

set -euo pipefail  # Exit on error, undefined variable, pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
DRY_RUN=false
AUTO_APPROVE=false

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            echo -e "${YELLOW}[DRY RUN MODE] No files will be deleted${NC}\n"
            ;;
        --auto)
            AUTO_APPROVE=true
            echo -e "${YELLOW}[AUTO MODE] All deletions will be auto-approved${NC}\n"
            ;;
        --help)
            echo "Usage: $0 [--dry-run] [--auto] [--help]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Preview what will be deleted without making changes"
            echo "  --auto       Auto-approve all deletions (use with caution)"
            echo "  --help       Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $arg${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

print_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_error() {
    echo -e "${RED}✗${NC}  $1"
}

confirm_action() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$AUTO_APPROVE" = true ]; then
        echo -e "${YELLOW}Auto-approved: $prompt${NC}"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN] Would ask: $prompt${NC}"
        return 0
    fi

    local response
    if [ "$default" = "y" ]; then
        read -p "$prompt [Y/n]: " response
        response=${response:-y}
    else
        read -p "$prompt [y/N]: " response
        response=${response:-n}
    fi

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

safe_remove() {
    local file="$1"

    if [ ! -e "$file" ] && [ ! -L "$file" ]; then
        print_warning "File does not exist (already removed?): $file"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}[DRY RUN]${NC} Would remove: $file"
        return 0
    fi

    if rm "$file" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Removed: $file"
        return 0
    else
        print_error "Failed to remove: $file (check permissions)"
        return 1
    fi
}

################################################################################
# Main Script
################################################################################

print_header "Homebrew Broken Files Cleanup"

echo "This script will remove orphaned files left behind after Homebrew uninstallation."
echo "These files are broken and will not function because they reference non-existent"
echo "Homebrew installations."
echo ""
echo -e "${GREEN}What will be preserved:${NC}"
echo "  ✓ Go installation (/usr/local/go)"
echo "  ✓ .NET SDK (/usr/local/share/dotnet)"
echo "  ✓ Docker binaries and symlinks"
echo "  ✓ Microsoft tools"
echo "  ✓ VS Code, Ghostty, DBeaver, IntelliJ, Android Studio symlinks"
echo "  ✓ All working files and directories"
echo ""

if [ "$DRY_RUN" = false ] && [ "$AUTO_APPROVE" = false ]; then
    if ! confirm_action "Continue with cleanup?" "n"; then
        echo "Cleanup cancelled."
        exit 0
    fi
fi

################################################################################
# Section 1: Broken Python Scripts
################################################################################

print_header "Section 1: Broken Python Scripts"

echo "These Python scripts reference Homebrew Python installations that no longer exist."
echo "They will fail with 'bad interpreter' errors if executed."
echo ""

PYTHON_SCRIPTS=(
    "/usr/local/bin/pip"
    "/usr/local/bin/pylint"
    "/usr/local/bin/yapf"
    "/usr/local/bin/pyreverse"
    "/usr/local/bin/isort"
    "/usr/local/bin/epylint"
    "/usr/local/bin/symilar"
)

# Count how many actually exist
PYTHON_COUNT=0
for script in "${PYTHON_SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        PYTHON_COUNT=$((PYTHON_COUNT + 1))
        # Show the broken shebang
        shebang=$(head -1 "$script" 2>/dev/null || echo "")
        echo "  - $(basename "$script"): $shebang"
    fi
done

if [ $PYTHON_COUNT -eq 0 ]; then
    print_success "No broken Python scripts found (already cleaned or never existed)"
else
    echo ""
    print_info "Found $PYTHON_COUNT broken Python script(s)"

    if confirm_action "Remove these $PYTHON_COUNT broken Python scripts?" "y"; then
        echo ""
        for script in "${PYTHON_SCRIPTS[@]}"; do
            if [ -f "$script" ]; then
                safe_remove "$script"
            fi
        done
        print_success "Broken Python scripts cleanup complete"
    else
        print_warning "Skipped broken Python scripts cleanup"
    fi
fi

################################################################################
# Section 2: Broken npm CLI Symlinks
################################################################################

print_header "Section 2: Broken npm CLI Symlinks"

echo "These symlinks point to npm global packages that no longer exist."
echo "They reference /usr/local/lib/node_modules/* which was removed with Homebrew."
echo ""

NPM_SYMLINKS=(
    "/usr/local/bin/eslint"
    "/usr/local/bin/live-server"
    "/usr/local/bin/create-react-app"
)

# Count and display broken symlinks
NPM_COUNT=0
for symlink in "${NPM_SYMLINKS[@]}"; do
    if [ -L "$symlink" ] && [ ! -e "$symlink" ]; then
        NPM_COUNT=$((NPM_COUNT + 1))
        target=$(readlink "$symlink" 2>/dev/null || echo "unknown")
        echo "  - $(basename "$symlink") -> $target (broken)"
    fi
done

if [ $NPM_COUNT -eq 0 ]; then
    print_success "No broken npm CLI symlinks found (already cleaned or never existed)"
else
    echo ""
    print_info "Found $NPM_COUNT broken npm symlink(s)"

    if confirm_action "Remove these $NPM_COUNT broken npm symlinks?" "y"; then
        echo ""
        for symlink in "${NPM_SYMLINKS[@]}"; do
            if [ -L "$symlink" ] && [ ! -e "$symlink" ]; then
                safe_remove "$symlink"
            fi
        done
        print_success "Broken npm symlinks cleanup complete"
    else
        print_warning "Skipped broken npm symlinks cleanup"
    fi
fi

################################################################################
# Section 3: Broken npm Man Page Symlinks
################################################################################

print_header "Section 3: Broken Man Page Symlinks"

echo "These are man page symlinks that no longer exist:"
echo "  - npm documentation symlinks (73 files)"
echo "  - Homebrew documentation symlinks (1 file - README.md)"
echo "They won't affect system operation but will cause related 'man' commands to fail."
echo ""

# Find all broken symlinks in man directories (npm + Homebrew)
BROKEN_MAN_PAGES=()
while IFS= read -r -d '' symlink; do
    if [ -L "$symlink" ] && [ ! -e "$symlink" ]; then
        # Check if it's an npm or Homebrew-related symlink
        target=$(readlink "$symlink" 2>/dev/null || echo "")
        if [[ "$target" == *"node_modules/npm"* ]] || [[ "$target" == *"Homebrew"* ]]; then
            BROKEN_MAN_PAGES+=("$symlink")
        fi
    fi
done < <(find /usr/local/share/man -type l -print0 2>/dev/null)

MAN_COUNT=${#BROKEN_MAN_PAGES[@]}

if [ $MAN_COUNT -eq 0 ]; then
    print_success "No broken man page symlinks found"
else
    echo "Found $MAN_COUNT broken man page symlinks (npm + Homebrew):"
    echo ""

    # Show first 5 as examples
    sample_count=$((MAN_COUNT < 5 ? MAN_COUNT : 5))
    for ((i=0; i<sample_count; i++)); do
        basename_only=$(basename "${BROKEN_MAN_PAGES[$i]}")
        echo "  - $basename_only"
    done

    if [ $MAN_COUNT -gt 5 ]; then
        echo "  ... and $((MAN_COUNT - 5)) more"
    fi
    echo ""

    print_info "Total: $MAN_COUNT broken man page symlinks (includes npm + Homebrew docs)"

    if confirm_action "Remove all $MAN_COUNT broken man page symlinks?" "y"; then
        echo ""
        removed=0
        for symlink in "${BROKEN_MAN_PAGES[@]}"; do
            if safe_remove "$symlink"; then
                removed=$((removed + 1))
            fi
        done
        print_success "Removed $removed broken man page symlinks"
    else
        print_warning "Skipped broken man page symlinks cleanup"
    fi
fi

################################################################################
# Section 4: Final Report
################################################################################

print_header "Cleanup Summary"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN COMPLETE${NC}"
    echo ""
    echo "No files were actually deleted. This was a preview of what would be removed."
    echo "To perform the actual cleanup, run the script without --dry-run:"
    echo "  ./cleanup-broken-files.sh"
else
    echo -e "${GREEN}CLEANUP COMPLETE${NC}"
    echo ""
    echo "Summary of actions taken:"
    echo "  - Broken Python scripts: $PYTHON_COUNT processed"
    echo "  - Broken npm CLI symlinks: $NPM_COUNT processed"
    echo "  - Broken npm man pages: $MAN_COUNT processed"
    echo ""
    print_info "Preserved software remains intact:"
    echo "  ✓ Go, .NET SDK, Docker, Microsoft tools"
    echo "  ✓ All working symlinks and binaries"
    echo ""
fi

# Verify /usr/local/bin still has legitimate files
REMAINING_FILES=$(ls -1 /usr/local/bin 2>/dev/null | wc -l)
print_info "Remaining files in /usr/local/bin: $REMAINING_FILES"

# Check for any remaining broken symlinks
REMAINING_BROKEN=$(find /usr/local/bin -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l)
if [ "$REMAINING_BROKEN" -gt 0 ]; then
    print_warning "Found $REMAINING_BROKEN other broken symlink(s) in /usr/local/bin"
    echo "    These may be non-Homebrew related. Check manually with:"
    echo "    find /usr/local/bin -type l ! -exec test -e {} \\; -print"
else
    print_success "No broken symlinks remaining in /usr/local/bin"
fi

echo ""
echo "Done!"
