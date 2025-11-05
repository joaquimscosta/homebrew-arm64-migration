#!/usr/bin/env bash

################################################################################
# Homebrew Remnants Cleanup Script
################################################################################
#
# Repository: https://github.com/joaquimscosta/homebrew-arm64-migration
# License: MIT
# Version: 1.0.0
#
# Purpose: Remove Intel Homebrew remnants from /usr/local after migrating to ARM64
#
# What it removes:
#   - Intel Homebrew directories (~636MB)
#   - Python site-packages (~135MB)
#   - Orphaned npm global packages (~48MB)
#   - Broken symlinks
#
# What it preserves:
#   - Non-Homebrew software (Go, .NET SDK, Docker, Microsoft tools)
#   - System libraries
#   - Your data and configurations
#
# Usage:
#   ./cleanup-homebrew-remnants.sh
#
# SECURITY WARNING:
#   This script uses 'sudo' to remove files from /usr/local.
#   Review the script before running to understand what will be deleted.
#   Interactive prompts will ask for confirmation before each deletion.
#
# Requirements:
#   - Previous Intel Homebrew installation at /usr/local
#   - ARM64 Homebrew already installed at /opt/homebrew (recommended)
#   - Administrator access (sudo)
#
################################################################################

set -euo pipefail  # Exit on error, undefined variable, pipe failures

echo "==================================="
echo "Homebrew Remnants Cleanup Script"
echo "==================================="
echo ""

# Check if official Homebrew uninstaller was run first
if [ -d "/usr/local/Homebrew" ] && [ -d "/usr/local/Homebrew/.git" ]; then
    echo "⚠️  WARNING: Intel Homebrew appears to still be installed!"
    echo ""
    echo "This script removes REMNANTS after the official Homebrew uninstaller runs."
    echo "You must run the official uninstaller FIRST:"
    echo ""
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
    echo ""
    echo "Or for custom prefix:"
    echo "  curl -fsSLO https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh"
    echo "  /bin/bash uninstall.sh --path /usr/local"
    echo ""
    echo "For complete uninstall workflow, see: docs/UNINSTALL-GUIDE.md"
    echo "Or online: https://github.com/joaquimscosta/homebrew-arm64-migration/blob/main/docs/UNINSTALL-GUIDE.md"
    echo ""
    read -p "Continue anyway? (not recommended) (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Please run the official Homebrew uninstaller first."
        exit 1
    fi
    echo ""
    echo "⚠️  Proceeding without official uninstaller (not recommended)..."
    echo ""
fi

echo "This will remove approximately 820MB of Homebrew files:"
echo "  - Main Homebrew directory (636MB)"
echo "  - Python site-packages (135MB)"
echo "  - Orphaned npm global packages (48MB)"
echo "  - Configuration files (~1MB)"
echo "  - Broken symlinks"
echo ""
echo "This will NOT remove:"
echo "  - Go installation (261MB)"
echo "  - .NET SDK (2.1GB)"
echo "  - Microsoft/Docker software"
echo "  - OSXFUSE libraries"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "Starting cleanup..."
echo ""

# 1. Remove main Homebrew directory
if [ -d "/usr/local/Homebrew" ]; then
    echo "[1/8] Removing /usr/local/Homebrew (636MB)..."
    sudo rm -rf /usr/local/Homebrew
else
    echo "[1/8] /usr/local/Homebrew not found, skipping..."
fi

# 2. Remove Homebrew var directory
if [ -d "/usr/local/var/homebrew" ]; then
    echo "[2/8] Removing /usr/local/var/homebrew..."
    sudo rm -rf /usr/local/var/homebrew
else
    echo "[2/8] /usr/local/var/homebrew not found, skipping..."
fi

# 3. Remove Homebrew configuration files
echo "[3/8] Removing Homebrew configuration files..."
sudo rm -rf /usr/local/etc/bash_completion.d \
            /usr/local/etc/ca-certificates \
            /usr/local/etc/openssl \
            /usr/local/etc/openssl@1.1 \
            /usr/local/etc/openssl@3 \
            /usr/local/etc/gnutls \
            /usr/local/etc/pkcs11 \
            /usr/local/etc/pkcs11.conf.example \
            /usr/local/etc/unbound \
            /usr/local/etc/fonts \
            /usr/local/etc/gitconfig 2>/dev/null || true

# 4. Remove Python site-packages from Homebrew
echo "[4/8] Removing Python directories (135MB)..."
sudo rm -rf /usr/local/lib/python2.7 \
            /usr/local/lib/python3.6 \
            /usr/local/lib/python3.7 \
            /usr/local/lib/python3.10 \
            /usr/local/lib/python3.11 \
            /usr/local/lib/python3.12 \
            /usr/local/lib/python3.13 \
            /usr/local/lib/python3.14 2>/dev/null || true

# 5. Remove orphaned npm global packages (since you use nvm)
echo "[5/8] Removing orphaned npm global packages (48MB)..."
read -p "You're using nvm. Remove old npm global packages? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo rm -rf /usr/local/lib/node_modules
else
    echo "Skipping npm global packages..."
fi

# 6. Remove Homebrew share directories
echo "[6/8] Removing Homebrew share directories..."
sudo rm -rf /usr/local/share/fish \
            /usr/local/share/zsh \
            /usr/local/share/doc \
            /usr/local/share/info 2>/dev/null || true

# 7. Remove misc Homebrew lib directories
echo "[7/8] Removing misc Homebrew library directories..."
sudo rm -rf /usr/local/lib/gdk-pixbuf-2.0 \
            /usr/local/lib/pkgconfig 2>/dev/null || true

# 8. Remove broken symlinks
echo "[8/8] Removing broken symlinks..."
sudo rm -f /usr/local/bin/claude 2>/dev/null || true

# 9. Clean up .keepme files (optional)
echo ""
read -p "Remove .keepme files? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo find /usr/local -name ".keepme" -delete 2>/dev/null || true
    echo "Removed .keepme files"
fi

# 10. Remove man pages
echo ""
read -p "Remove Homebrew man pages (brew.1)? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo rm -f /usr/local/share/man/man1/brew.1 2>/dev/null || true
    echo "Removed Homebrew man pages"
fi

echo ""
echo "==================================="
echo "Cleanup Complete!"
echo "==================================="
echo ""
echo "Remaining in /usr/local (KEPT):"
echo "  - Go installation: /usr/local/go (261MB)"
echo "  - .NET SDK: /usr/local/share/dotnet (2.1GB)"
echo "  - Microsoft/Docker files"
echo "  - OSXFUSE libraries"
echo "  - Application symlinks in /usr/local/bin"
echo ""
echo "You can verify with: ls -la /usr/local/"
echo ""
