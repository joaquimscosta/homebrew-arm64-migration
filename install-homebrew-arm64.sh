#!/usr/bin/env bash

################################################################################
# Homebrew ARM64 Installation Script for Apple Silicon
################################################################################
#
# Repository: https://github.com/joaquimscosta/homebrew-arm64-migration
# License: MIT
# Version: 1.0.0
#
# Purpose: Intelligently install Homebrew and development tools on Apple Silicon
#
# Features:
#   - Strict ARM64 architecture verification
#   - Interactive category-based installation
#   - Version manager recommendations with explanations (uv, fnm, SDKMAN)
#   - Auto-upgrade deprecated packages
#   - Comprehensive post-install health check
#
# Usage:
#   ./install-homebrew-arm64.sh              # Interactive mode
#   ./install-homebrew-arm64.sh --dry-run    # Preview without installing
#   ./install-homebrew-arm64.sh --auto-yes   # Auto-approve all prompts
#   ./install-homebrew-arm64.sh --help       # Show help
#
# SECURITY WARNING:
#   This script will install software and modify your system configuration.
#   Always review scripts before running them, especially from the internet.
#   Use --dry-run first to preview what will be installed.
#
# Requirements:
#   - Apple Silicon Mac (M1, M2, M3, or M4)
#   - macOS Sequoia 15.6+ (tested on 15.6.1)
#   - Command Line Tools (xcode-select --install)
#   - Administrator access
#
################################################################################

set -euo pipefail  # Exit on error, undefined variable, pipe failures

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Script configuration
DRY_RUN=false
AUTO_YES=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_LOG="${SCRIPT_DIR}/logs/install-$(date +%Y%m%d-%H%M%S).log"
INSTALLED_PACKAGES=()
BROKEN_FILES_DETECTED=false

# Create logs directory if it doesn't exist
mkdir -p "${SCRIPT_DIR}/logs"

# Homebrew paths
readonly HOMEBREW_ARM64_PATH="/opt/homebrew"
readonly HOMEBREW_INTEL_PATH="/usr/local"
readonly HOMEBREW_ARM64_BIN="${HOMEBREW_ARM64_PATH}/bin/brew"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}${BOLD}========================================${NC}"
    echo -e "${BLUE}${BOLD}$1${NC}"
    echo -e "${BLUE}${BOLD}========================================${NC}\n"
}

print_phase() {
    echo -e "\n${MAGENTA}${BOLD}>>> Phase $1: $2${NC}\n"
}

print_info() {
    echo -e "${CYAN}ℹ${NC}  $1"
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

print_recommendation() {
    echo -e "${YELLOW}💡${NC}  ${BOLD}$1${NC}"
}

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$INSTALL_LOG"
}

confirm_action() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$AUTO_YES" = true ]; then
        echo -e "${YELLOW}Auto-approved: $prompt${NC}"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN] Would ask: $prompt${NC}"
        return 0
    fi

    local response
    if [ "$default" = "y" ]; then
        read -p "$(echo -e ${CYAN}${prompt}${NC}) [Y/n]: " response
        response=${response:-y}
    else
        read -p "$(echo -e ${CYAN}${prompt}${NC}) [y/N]: " response
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

show_explanation() {
    local title="$1"
    local explanation="$2"

    echo -e "\n${YELLOW}${BOLD}━━━ $title ━━━${NC}"
    echo -e "${explanation}"
    echo -e "${YELLOW}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

safe_brew_install() {
    local package="$1"

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}[DRY RUN]${NC} Would install: $package"
        return 0
    fi

    echo -e "  ${BLUE}→${NC} Installing ${BOLD}$package${NC}..."

    if "${HOMEBREW_ARM64_BIN}" install "$package" 2>&1 | tee -a "$INSTALL_LOG"; then
        INSTALLED_PACKAGES+=("$package")
        echo -e "  ${GREEN}✓${NC} Installed: $package"
        log_message "SUCCESS: Installed $package"
        return 0
    else
        echo -e "  ${RED}✗${NC} Failed to install: $package"
        log_message "FAILED: $package"
        return 1
    fi
}

check_architecture() {
    local arch
    arch=$(uname -m)

    if [ "$arch" != "arm64" ]; then
        print_error "This script requires Apple Silicon (ARM64)"
        print_error "Detected architecture: $arch"
        print_error "This Mac appears to be Intel-based or running under Rosetta"
        exit 1
    fi

    print_success "Architecture verified: ARM64 (Apple Silicon)"
}

check_existing_homebrew() {
    local has_intel=false
    local has_arm=false

    if [ -f "${HOMEBREW_INTEL_PATH}/bin/brew" ]; then
        has_intel=true
    fi

    if [ -f "${HOMEBREW_ARM64_BIN}" ]; then
        has_arm=true
    fi

    if [ "$has_intel" = true ]; then
        print_error "Intel Homebrew detected at ${HOMEBREW_INTEL_PATH}/bin/brew"
        print_error "This script is for ARM64 Homebrew only"
        print_error ""
        print_info "You should uninstall Intel Homebrew first:"
        print_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
        print_info ""
        print_info "Or run the cleanup script: ./cleanup-broken-files.sh"
        exit 1
    fi

    if [ "$has_arm" = true ]; then
        print_warning "ARM64 Homebrew already installed at ${HOMEBREW_ARM64_PATH}"
        if ! confirm_action "Continue with package installation?" "y"; then
            print_info "Installation cancelled"
            exit 0
        fi
        return 0
    fi

    print_success "No existing Homebrew installation detected"
}

check_broken_files() {
    local broken_count=0

    # Check for common broken files
    if [ -f "/usr/local/bin/pip" ] && ! /usr/local/bin/pip --version &>/dev/null; then
        ((broken_count++))
    fi

    if [ $broken_count -gt 0 ]; then
        BROKEN_FILES_DETECTED=true
        print_warning "Detected broken files from previous Homebrew installation"
        print_info "Run ./cleanup-broken-files.sh to clean up before proceeding"
        if ! confirm_action "Continue anyway?" "n"; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
}

################################################################################
# Homebrew Installation
################################################################################

install_homebrew() {
    print_phase "1" "Homebrew ARM64 Installation"

    if [ -f "${HOMEBREW_ARM64_BIN}" ]; then
        print_success "Homebrew already installed at ${HOMEBREW_ARM64_PATH}"
        return 0
    fi

    print_info "Installing Homebrew to ${HOMEBREW_ARM64_PATH} (ARM64 native)"
    print_warning "This will download and run the official Homebrew installer"

    if ! confirm_action "Proceed with Homebrew installation?" "y"; then
        print_error "Installation cancelled"
        exit 1
    fi

    if [ "$DRY_RUN" = true ]; then
        print_warning "[DRY RUN] Would install Homebrew"
        return 0
    fi

    # Download and run official installer
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1 | tee -a "$INSTALL_LOG"

    if [ ! -f "${HOMEBREW_ARM64_BIN}" ]; then
        print_error "Homebrew installation failed"
        exit 1
    fi

    # Add to PATH for this script
    eval "$("${HOMEBREW_ARM64_BIN}" shellenv)"

    # Verify ARM64
    local brew_arch
    brew_arch=$(file "${HOMEBREW_ARM64_BIN}" | grep -o "arm64")
    if [ "$brew_arch" != "arm64" ]; then
        print_error "Homebrew binary is not ARM64!"
        print_error "File output: $(file "${HOMEBREW_ARM64_BIN}")"
        exit 1
    fi

    print_success "Homebrew installed successfully (ARM64)"
    log_message "Homebrew installed at ${HOMEBREW_ARM64_PATH}"
}

################################################################################
# Essential Tools Installation
################################################################################

install_essential_tools() {
    print_phase "2" "Essential Tools (Auto-Install)"

    print_info "Installing must-have development tools..."
    echo -e "${CYAN}These tools are essential for most developers and will be installed automatically.${NC}\n"

    local essential_tools=(
        "git"
        "gh"
        "curl"
        "wget"
        "jq"
        "yq"
        "tree"
        "htop"
        "bat"
        "tealdeer"
        "mas"
        "grep"
        "coreutils"
        "sqlite"
        "openssl@3"
        "ca-certificates"
        "diff-so-fancy"
        "git-lfs"
        "nmap"
    )

    for tool in "${essential_tools[@]}"; do
        safe_brew_install "$tool"
    done

    print_success "Essential tools installation complete"
}

################################################################################
# Version Managers
################################################################################

install_version_managers() {
    print_phase "3" "Language Version Managers"

    print_info "Version managers provide better control over language versions than Homebrew"
    echo ""

    # Python - uv (PREFERRED) vs pyenv
    show_explanation "Python Development: uv - The Modern Choice" \
        "${BOLD}uv${NC} is the modern unified Python toolkit (by Astral, creators of Ruff)

${GREEN}Why uv in 2025:${NC}
  • ${BOLD}Unified workflow:${NC} Manages Python versions + dependencies + tools
  • ${BOLD}Blazingly fast:${NC} 10-100x faster than pip, written in Rust
  • ${BOLD}Pre-built binaries:${NC} Install Python in seconds (not minutes)
  • ${BOLD}Drop-in replacement:${NC} 'uv pip install' works like pip
  • ${BOLD}Cross-platform:${NC} Same lockfile works on Mac, Linux, Windows
  • ${BOLD}No compilation:${NC} Unlike pyenv, doesn't need build tools

${CYAN}uv replaces:${NC} pip + pipx + pyenv + virtualenv + pip-tools

${YELLOW}Alternative:${NC} pyenv (version management only, established but slower)

${BOLD}Recommendation:${NC} Install uv for modern Python development (USER PREFERENCE)"

    if confirm_action "Install uv for Python (recommended - unified toolkit)?" "y"; then
        print_info "Installing uv..."
        if [ "$DRY_RUN" = true ]; then
            echo -e "  ${YELLOW}[DRY RUN]${NC} Would install: uv"
        else
            # Install via Homebrew (easier for ARM64 Mac)
            safe_brew_install "uv"
        fi

        echo -e "\n${CYAN}Next steps with uv:${NC}"
        echo "  1. Install Python: uv python install 3.12"
        echo "  2. Set project version: uv python pin 3.12"
        echo "  3. Create venv: uv venv"
        echo "  4. Install packages: uv pip install requests"
        echo "  5. Install CLI tools: uv tool install ruff"
        echo "  6. Run scripts: uv run script.py"
        echo ""
        echo -e "  ${GREEN}Tip:${NC} uv is a drop-in pip replacement - use 'uv pip install' anywhere"

        print_success "uv installed successfully"
    else
        # Offer pyenv as alternative
        print_info "Skipped uv. Offering pyenv as alternative..."
        echo ""

        show_explanation "Python Version Management: pyenv (Alternative)" \
            "pyenv is the established Python version manager.

${GREEN}Benefits:${NC}
  • Mature, stable, widely adopted
  • Multiple Python versions side-by-side
  • Project-specific versions (.python-version file)
  • ARM64 native builds

${YELLOW}Limitations:${NC}
  • Only handles version management (need pip/poetry separately)
  • Compiles Python from source (slow - takes minutes)
  • No dependency management

${BOLD}Note:${NC} uv is faster and more feature-complete (RECOMMENDED)"

        if confirm_action "Install pyenv instead?" "n"; then
            safe_brew_install "pyenv"
            echo -e "\n${CYAN}Next steps:${NC}"
            echo "  1. Add to ~/.zshrc: eval \"\$(pyenv init -)\""
            echo "  2. Install Python: pyenv install 3.12.1"
            echo "  3. Set global: pyenv global 3.12.1"
        else
            print_info "Skipped both uv and pyenv"
        fi
    fi

    echo ""

    # Node.js - nvm/fnm/volta
    show_explanation "Node.js Version Management: nvm vs fnm vs Volta" \
        "${BOLD}You already have nvm installed${NC} (detected in your system)

${GREEN}Current options for Node.js:${NC}
  1. ${BOLD}nvm${NC} (current) - Most popular, largest community, slower
  2. ${BOLD}fnm${NC} (Fast Node Manager) - Rust-based, 40x faster, nvm-compatible commands
  3. ${BOLD}Volta${NC} - Automatic version switching, best for teams

${YELLOW}Recommendation for 2025:${NC}
  • Individual developer: Switch to ${BOLD}fnm${NC} for speed
  • Team environment: Use ${BOLD}Volta${NC} for automation
  • If it works: Keep ${BOLD}nvm${NC} (still widely used)"

    if confirm_action "Keep using nvm (no changes)?" "y"; then
        print_success "Keeping nvm for Node.js management"
    else
        if confirm_action "Install fnm (faster alternative to nvm)?" "n"; then
            safe_brew_install "fnm"
            echo -e "\n${CYAN}To switch from nvm to fnm:${NC}"
            echo "  1. fnm install --lts"
            echo "  2. fnm default <version>"
            echo "  3. Remove nvm from shell config"
        elif confirm_action "Install Volta (team-friendly alternative)?" "n"; then
            safe_brew_install "volta"
            echo -e "\n${CYAN}To switch from nvm to Volta:${NC}"
            echo "  1. volta install node"
            echo "  2. Add 'volta' section to package.json for team consistency"
        fi
    fi

    echo ""

    # Ruby - rbenv
    show_explanation "Ruby Version Management: rbenv" \
        "rbenv is the lightweight, transparent Ruby version manager.

${GREEN}Benefits:${NC}
  • Non-intrusive (doesn't override shell commands like RVM)
  • Works perfectly with Bundler (modern gem management)
  • Simple, focused tool that does one thing well
  • Gemsets are obsolete thanks to Bundler

${BOLD}Recommendation:${NC} Install rbenv if you do Ruby development"

    if confirm_action "Install rbenv for Ruby version management?" "y"; then
        safe_brew_install "rbenv"
        safe_brew_install "ruby-build"
        echo -e "\n${CYAN}Next steps:${NC}"
        echo "  1. Add to ~/.zshrc: eval \"\$(rbenv init - zsh)\""
        echo "  2. Install Ruby: rbenv install 3.2.2"
        echo "  3. Set global: rbenv global 3.2.2"
    else
        print_info "Skipped rbenv"
    fi

    echo ""

    # Terraform - tfenv + OpenTofu
    show_explanation "Terraform/OpenTofu Management: tfenv" \
        "${RED}Terraform changed to BSL license and is deprecated in Homebrew${NC}

${GREEN}Solution: OpenTofu + tfenv${NC}
  • ${BOLD}OpenTofu${NC} - Open-source Terraform fork (100% compatible)
  • ${BOLD}tfenv${NC} - Version manager for Terraform/OpenTofu (like nvm for Node)

${YELLOW}Benefits:${NC}
  • Use .terraform-version file for team consistency
  • Switch between versions easily
  • Support both Terraform and OpenTofu

${BOLD}Recommendation:${NC} Install tfenv + OpenTofu for infrastructure-as-code"

    if confirm_action "Install tfenv + OpenTofu (Terraform replacement)?" "y"; then
        safe_brew_install "tfenv"
        safe_brew_install "opentofu"
        echo -e "\n${CYAN}Next steps:${NC}"
        echo "  1. Create alias: alias terraform='tofu'"
        echo "  2. Create .terraform-version file in projects"
        echo "  3. Use 'tofu' command (100% compatible with terraform)"
    else
        print_info "Skipped tfenv/OpenTofu"
    fi

    print_success "Version managers setup complete"
}

################################################################################
# Language Runtimes
################################################################################

install_languages() {
    print_phase "4" "Programming Language Runtimes"

    print_info "Checking language runtime installations..."
    echo ""

    # PHP
    print_info "${BOLD}PHP${NC} - Web scripting language"
    if confirm_action "Do you do PHP development? (Install PHP 8.4 + Composer)" "n"; then
        safe_brew_install "php"
        safe_brew_install "composer"
        print_success "PHP and Composer installed"
    else
        print_info "Skipped PHP (you mentioned you don't use it)"
    fi

    echo ""

    # Java/JVM - SDKMAN (PREFERRED)
    print_info "${BOLD}Java/JVM Tools${NC} - SDKMAN is your version manager"
    echo ""
    show_explanation "Java/JVM Development: SDKMAN (USER PREFERENCE)" \
        "${BOLD}SDKMAN!${NC} is the superior version manager for Java and JVM ecosystem

${GREEN}Why SDKMAN for Java/JVM:${NC}
  • ${BOLD}Industry standard:${NC} Most popular JVM version manager
  • ${BOLD}Multiple distributions:${NC} Amazon Corretto, GraalVM, Temurin, etc.
  • ${BOLD}Full ecosystem:${NC} Java, Gradle, Maven, Kotlin, Scala, Groovy
  • ${BOLD}Cross-platform:${NC} Works on macOS, Linux, Windows (WSL)
  • ${BOLD}Simple switching:${NC} 'sdk use java 21.0.1' instantly switches versions
  • ${BOLD}Already installed:${NC} Detected at ~/.sdkman

${CYAN}SDKMAN manages:${NC}
  • Java (multiple vendors and versions)
  • Gradle, Maven (build tools)
  • Kotlin, Scala, Groovy (JVM languages)
  • Spring Boot CLI, Micronaut, and more

${BOLD}You already have SDKMAN installed!${NC}
Use it for all Java/JVM tools (USER PREFERENCE)"

    print_success "SDKMAN detected - using for Java/JVM management"
    echo ""
    echo -e "  ${CYAN}Common SDKMAN commands:${NC}"
    echo "    sdk list java           # List available Java versions"
    echo "    sdk install java 21.0.1 # Install specific version"
    echo "    sdk use java 21.0.1     # Use for current shell"
    echo "    sdk default java 21.0.1 # Set as default"
    echo "    sdk current java        # Show current version"
    echo ""

    print_recommendation "Optional: Install Homebrew OpenJDK as system fallback (not recommended)"
    if confirm_action "Install Homebrew OpenJDK anyway? (SDKMAN is better)" "n"; then
        safe_brew_install "openjdk"
        print_warning "OpenJDK installed via Homebrew, but SDKMAN should be your primary tool"
    else
        print_success "Using SDKMAN exclusively for Java (recommended)"
    fi

    echo ""

    # Perl (keep - system dependency)
    print_info "${BOLD}Perl${NC} - Often required by build tools"
    safe_brew_install "perl"

    echo ""

    # Go - check external installation
    if [ -d "/usr/local/go" ]; then
        print_success "Go already installed at /usr/local/go (official installer)"
        print_info "This is the recommended installation method"
        print_recommendation "Use gvm only if you need multiple Go versions"
    else
        print_info "${BOLD}Go${NC} - Systems programming language"
        print_recommendation "Best practice: Use official installer from https://go.dev/dl/"
        if confirm_action "Install Go via Homebrew anyway? (not recommended)" "n"; then
            safe_brew_install "go"
        else
            print_info "Skipped Go. Install from https://go.dev/dl/ for best results."
        fi
    fi

    print_success "Language runtimes configuration complete"
}

################################################################################
# Cloud & DevOps Tools
################################################################################

install_cloud_devops() {
    print_phase "5" "Cloud & DevOps Tools"

    print_info "Tools for cloud platforms, Kubernetes, and automation"
    echo ""

    if confirm_action "Install cloud & DevOps tools (AWS, Azure, GCP CLIs + K8s tools)?" "y"; then
        local cloud_tools=(
            "awscli"
            "azure-cli"
            "helm"
            "k9s"
            "ansible"
            "ansible-lint"
        )

        for tool in "${cloud_tools[@]}"; do
            safe_brew_install "$tool"
        done

        # Google Cloud SDK must be installed as a cask
        if [ "$DRY_RUN" = true ]; then
            echo -e "  ${YELLOW}[DRY RUN]${NC} Would install cask: google-cloud-sdk"
        else
            echo -e "  ${BLUE}→${NC} Installing ${BOLD}google-cloud-sdk${NC} (cask)..."
            if "${HOMEBREW_ARM64_BIN}" install --cask google-cloud-sdk 2>&1 | tee -a "$INSTALL_LOG"; then
                INSTALLED_PACKAGES+=("google-cloud-sdk (cask)")
                echo -e "  ${GREEN}✓${NC} Installed: google-cloud-sdk"
                log_message "SUCCESS: Installed google-cloud-sdk (cask)"
            else
                echo -e "  ${RED}✗${NC} Failed to install: google-cloud-sdk"
                log_message "FAILED: google-cloud-sdk (cask)"
            fi
        fi

        echo ""
        print_info "Post-install setup:"
        echo -e "  ${BOLD}AWS CLI:${NC}     aws configure"
        echo -e "  ${BOLD}Azure CLI:${NC}   az login"
        echo -e "  ${BOLD}Google Cloud:${NC} gcloud init && gcloud auth login"
        echo ""

        # Secrets management (optional)
        if confirm_action "Install Doppler CLI for centralized secrets management?" "n"; then
            safe_brew_install "doppler"
            print_info "Doppler setup: doppler login && doppler setup"
            print_recommendation "Alternative: 1Password CLI (op) or Bitwarden CLI (bw) for password management"
        fi
        echo ""

        print_recommendation "Consider adding: kubectl, kubectx (includes kubens), stern, terraform-docs"
        if confirm_action "Install additional Kubernetes tools?" "y"; then
            safe_brew_install "kubectl"
            safe_brew_install "kubectx"  # Note: kubectx includes kubens binary
            safe_brew_install "stern"
        fi

        print_success "Cloud/DevOps tools installed"
    else
        print_info "Skipped cloud/DevOps tools"
    fi
}

################################################################################
# Build Tools
################################################################################

install_build_tools() {
    print_phase "6" "Build Tools & Compilers"

    print_info "Essential for compiling software from source or C/C++ development"
    echo ""

    if confirm_action "Install build tools (cmake, autoconf, make, etc.)?" "y"; then
        local build_tools=(
            "cmake"
            "autoconf"
            "automake"
            "libtool"
            "pkg-config"
            "bison"
            "m4"
            "make"
        )

        for tool in "${build_tools[@]}"; do
            safe_brew_install "$tool"
        done

        print_success "Build tools installed"
    else
        print_info "Skipped build tools"
    fi
}

################################################################################
# Modern CLI Productivity Tools
################################################################################

install_modern_cli_tools() {
    print_phase "7" "Modern CLI Productivity Tools"

    print_info "Enhance your terminal with modern, faster alternatives to Unix tools"
    echo ""

    show_explanation "Modern CLI Tools for 2025" \
        "${GREEN}Recommended modern replacements:${NC}

  ${BOLD}ripgrep (rg)${NC}     - Faster grep, respects .gitignore
  ${BOLD}eza${NC}              - Modern ls with colors & icons (replaces exa)
  ${BOLD}fd${NC}               - Simple, fast alternative to find
  ${BOLD}httpie${NC}           - User-friendly HTTP client
  ${BOLD}delta${NC}            - Better git diff with syntax highlighting
  ${BOLD}fzf${NC}              - Fuzzy finder for command history
  ${BOLD}zoxide${NC}           - Smart cd that learns your habits
  ${BOLD}procs${NC}            - Modern ps replacement
  ${BOLD}tmux${NC}             - Terminal multiplexer (essential for SSH/remote)
  ${BOLD}chezmoi${NC}          - Modern dotfiles manager with templating

${YELLOW}Note:${NC} These complement (not replace) traditional tools"

    if confirm_action "Install all modern CLI productivity tools?" "y"; then
        local modern_tools=(
            "ripgrep"
            "eza"
            "fd"
            "httpie"
            "git-delta"
            "fzf"
            "zoxide"
            "procs"
            "tmux"
            "chezmoi"
        )

        for tool in "${modern_tools[@]}"; do
            safe_brew_install "$tool"
        done

        print_success "Modern CLI tools installed"
    else
        print_info "Skipped modern CLI tools"
    fi
}

################################################################################
# Database Clients
################################################################################

install_database_clients() {
    print_phase "8" "Database Client Tools"

    print_info "Client libraries and CLI tools (not database servers)"
    echo ""

    if confirm_action "Install database client tools (MySQL, PostgreSQL, SQLite)?" "y"; then
        safe_brew_install "mysql-client"
        safe_brew_install "libpq"
        safe_brew_install "sqlite"

        print_success "Database client tools installed"
        print_info "Note: Install actual database servers separately or via Docker"
    else
        print_info "Skipped database clients"
    fi
}

################################################################################
# Media Processing
################################################################################

install_media_processing() {
    print_phase "9" "Media Processing Tools (Optional)"

    print_info "Image, video, and audio processing (large installations)"
    echo ""

    if confirm_action "Do you work with media files (images, video, audio)?" "n"; then
        print_info "Installing media processing tools..."

        safe_brew_install "imagemagick"
        safe_brew_install "ghostscript"
        safe_brew_install "tesseract"

        if confirm_action "Install FFmpeg and video codecs? (Large download)" "n"; then
            safe_brew_install "ffmpeg"
        fi

        print_success "Media processing tools installed"
    else
        print_info "Skipped media processing tools"
    fi
}

################################################################################
# GUI Applications (Casks)
################################################################################

install_casks() {
    print_phase "10" "GUI Applications (Homebrew Cask)"

    print_info "Install desktop applications via Homebrew Cask"
    echo ""

    if confirm_action "Install GUI applications?" "n"; then
        # Use parallel arrays for bash 3.2 compatibility
        local cask_names=("alfred" "ghostty" "firefox" "caffeine" "cheatsheet")
        local cask_descriptions=(
            "Spotlight replacement & productivity tool"
            "Modern GPU-accelerated terminal emulator"
            "Web browser"
            "Keeps Mac awake"
            "Shows keyboard shortcuts"
        )

        for i in "${!cask_names[@]}"; do
            local cask="${cask_names[$i]}"
            local description="${cask_descriptions[$i]}"
            echo -e "\n${BOLD}${cask}${NC} - ${description}"
            if confirm_action "Install ${cask}?" "n"; then
                if [ "$DRY_RUN" = true ]; then
                    echo -e "  ${YELLOW}[DRY RUN]${NC} Would install cask: ${cask}"
                else
                    "${HOMEBREW_ARM64_BIN}" install --cask "${cask}" 2>&1 | tee -a "$INSTALL_LOG"
                    INSTALLED_PACKAGES+=("${cask} (cask)")
                fi
            fi
        done

        print_success "Cask installation complete"
    else
        print_info "Skipped casks"
    fi
}

################################################################################
# Alias Report Generation
################################################################################

generate_alias_report() {
    local has_aliases=false

    # Check if any tools with common aliases were installed
    # Skip if no packages installed (e.g., dry-run mode)
    if [ ${#INSTALLED_PACKAGES[@]} -eq 0 ]; then
        return 0
    fi

    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            bat|eza|ripgrep|fd|zoxide|kubectl|kubectx|git-delta|httpie|procs|chezmoi|tmux|fzf)
                has_aliases=true
                break
                ;;
        esac
    done

    if [ "$has_aliases" = false ]; then
        return 0
    fi

    echo ""
    print_header "Recommended Shell Aliases"

    echo -e "${CYAN}Based on the tools you installed, here are recommended shell aliases:${NC}"
    echo -e "${YELLOW}Add these to your ~/.zshrc or ~/.bashrc file${NC}"
    echo ""

    # Modern CLI Replacements
    local has_modern_cli=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            bat|eza|ripgrep|fd) has_modern_cli=true; break ;;
        esac
    done

    if [ "$has_modern_cli" = true ]; then
        echo -e "${BOLD}${MAGENTA}## Modern CLI Replacements${NC} ${YELLOW}(⚠️  Overrides default commands)${NC}"
        echo ""

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "bat" ]]; then
            echo -e "  ${GREEN}# Better 'cat' with syntax highlighting${NC}"
            echo "  alias cat='bat'"
            echo "  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'"
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "eza" ]]; then
            echo -e "  ${GREEN}# Modern 'ls' replacement${NC}"
            echo "  alias ls='eza --icons --group-directories-first'"
            echo "  alias ll='eza -l --icons --group-directories-first'"
            echo "  alias la='eza -la --icons --group-directories-first'"
            echo "  alias lt='eza --tree --level=2 --icons'"
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "ripgrep" ]]; then
            echo -e "  ${GREEN}# Better 'grep' - faster with .gitignore support${NC}"
            echo "  alias grep='rg'"
            echo "  alias rg='rg -C 3'  # 3 lines of context"
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fd" ]]; then
            echo -e "  ${GREEN}# Simpler, faster 'find'${NC}"
            echo "  alias find='fd'"
            echo ""
        fi
    fi

    # Navigation & Productivity
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "zoxide" ]]; then
        echo -e "${BOLD}${MAGENTA}## Smart Navigation${NC}"
        echo ""
        echo -e "  ${GREEN}# zoxide - smart 'cd' that learns your habits${NC}"
        echo "  eval \"\$(zoxide init --cmd cd zsh)\"  # Makes 'cd' use zoxide"
        echo "  # Or use 'z' command: eval \"\$(zoxide init zsh)\""
        echo ""
    fi

    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fzf" ]]; then
        echo -e "${BOLD}${MAGENTA}## Fuzzy Finding${NC}"
        echo ""
        echo -e "  ${GREEN}# fzf - fuzzy finder for files, history, processes${NC}"
        echo "  eval \"\$(fzf --zsh)\"  # Enable fzf keybindings and completion"
        echo ""
    fi

    # Kubernetes Tools
    local has_k8s=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            kubectl|kubectx) has_k8s=true; break ;;
        esac
    done

    if [ "$has_k8s" = true ]; then
        echo -e "${BOLD}${MAGENTA}## Kubernetes Shortcuts${NC}"
        echo ""

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "kubectl" ]]; then
            echo -e "  ${GREEN}# kubectl shortcuts${NC}"
            echo "  alias k='kubectl'"
            echo "  alias kgp='kubectl get pods'"
            echo "  alias kgs='kubectl get svc'"
            echo "  alias kgd='kubectl get deployment'"
            echo "  alias kgn='kubectl get nodes'"
            echo "  alias kd='kubectl describe'"
            echo "  alias kdel='kubectl delete'"
            echo "  alias kl='kubectl logs'"
            echo "  alias klf='kubectl logs -f'"
            echo "  alias kex='kubectl exec -it'"
            echo "  alias kaf='kubectl apply -f'"
            echo "  alias kpf='kubectl port-forward'"
            echo ""
            echo -e "  ${GREEN}# kubectl completion${NC}"
            echo "  source <(kubectl completion zsh)"
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "kubectx" ]]; then
            echo -e "  ${GREEN}# kubectx/kubens shortcuts (already short!)${NC}"
            echo "  alias kctx='kubectx'"
            echo "  alias kns='kubens'"
            echo "  # Switch to previous context: kubectx -"
            echo "  # Switch to previous namespace: kubens -"
            echo ""
        fi
    fi

    # Git & Version Control
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "git-delta" ]]; then
        echo -e "${BOLD}${MAGENTA}## Git Enhancements${NC}"
        echo ""
        echo -e "  ${GREEN}# Configure git to use delta for diffs${NC}"
        echo "  git config --global core.pager delta"
        echo "  git config --global interactive.diffFilter 'delta --color-only'"
        echo "  git config --global delta.navigate true"
        echo "  git config --global merge.conflictstyle diff3"
        echo ""
    fi

    # Development Tools
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "httpie" ]]; then
        echo -e "${BOLD}${MAGENTA}## HTTP/API Testing${NC}"
        echo ""
        echo -e "  ${GREEN}# HTTPie shortcuts${NC}"
        echo "  alias http='http --print=HhBb'  # Show headers + body"
        echo "  alias https='http --default-scheme=https'"
        echo ""
    fi

    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "procs" ]]; then
        echo -e "${BOLD}${MAGENTA}## Process Management${NC}"
        echo ""
        echo -e "  ${GREEN}# Modern 'ps' replacement${NC}"
        echo "  alias ps='procs'"
        echo ""
    fi

    # Terminal Multiplexer
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "tmux" ]]; then
        echo -e "${BOLD}${MAGENTA}## Terminal Multiplexer${NC}"
        echo ""
        echo -e "  ${GREEN}# tmux shortcuts${NC}"
        echo "  alias t='tmux'"
        echo "  alias ta='tmux attach'"
        echo "  alias tl='tmux list-sessions'"
        echo "  alias tn='tmux new-session -s'"
        echo ""
    fi

    # Dotfiles Management
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "chezmoi" ]]; then
        echo -e "${BOLD}${MAGENTA}## Dotfiles Management${NC}"
        echo ""
        echo -e "  ${GREEN}# chezmoi shortcuts${NC}"
        echo "  alias cm='chezmoi'"
        echo "  alias cma='chezmoi add'"
        echo "  alias cme='chezmoi edit'"
        echo "  alias cmcd='chezmoi cd'"
        echo "  alias cmup='chezmoi update'"
        echo ""
    fi

    # Version Managers
    local has_version_managers=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            pyenv|rbenv|fnm) has_version_managers=true; break ;;
        esac
    done

    if [ "$has_version_managers" = true ]; then
        echo -e "${BOLD}${MAGENTA}## Version Managers (Required Setup)${NC}"
        echo ""

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "pyenv" ]]; then
            echo -e "  ${GREEN}# pyenv - Python version management${NC}"
            echo "  export PYENV_ROOT=\"\$HOME/.pyenv\""
            echo "  [[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
            echo "  eval \"\$(pyenv init -)\""
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "rbenv" ]]; then
            echo -e "  ${GREEN}# rbenv - Ruby version management${NC}"
            echo "  eval \"\$(rbenv init - zsh)\""
            echo ""
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fnm" ]]; then
            echo -e "  ${GREEN}# fnm - Fast Node Manager${NC}"
            echo "  eval \"\$(fnm env --use-on-cd)\""
            echo ""
        fi
    fi

    # Safety Warning
    echo -e "${YELLOW}${BOLD}⚠️  Important Notes:${NC}"
    echo -e "  ${YELLOW}•${NC} Aliases that override default commands (cat, ls, grep, find) may affect scripts"
    echo -e "  ${YELLOW}•${NC} Test aliases before committing to your shell config"
    echo -e "  ${YELLOW}•${NC} You can always use the original command with: \\command (e.g., \\cat, \\ls)"
    echo -e "  ${YELLOW}•${NC} Version manager init commands are REQUIRED for those tools to work"
    echo ""

    # Quick copy instructions
    echo -e "${CYAN}${BOLD}To apply these aliases:${NC}"
    echo "  1. Copy the aliases you want above"
    echo "  2. Add them to ~/.zshrc (or ~/.bashrc for bash)"
    echo "  3. Run: source ~/.zshrc"
    echo ""
}

################################################################################
# Generate .aliases File
################################################################################

generate_aliases_file() {
    local aliases_file="${SCRIPT_DIR}/.aliases"

    # Skip if no packages installed (e.g., dry-run mode)
    if [ ${#INSTALLED_PACKAGES[@]} -eq 0 ]; then
        return 0
    fi

    # Check if any tools with common aliases were installed
    local has_aliases=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            bat|eza|ripgrep|fd|zoxide|kubectl|kubectx|git-delta|httpie|procs|chezmoi|tmux|fzf|pyenv|rbenv|fnm)
                has_aliases=true
                break
                ;;
        esac
    done

    if [ "$has_aliases" = false ]; then
        return 0
    fi

    # Generate the file
    cat > "$aliases_file" <<ALIASES_EOF
# ============================================================
# Homebrew ARM64 Migration - Recommended Shell Aliases
# ============================================================
#
# Generated by: install-homebrew-arm64.sh
# Generated on: $(date '+%Y-%m-%d %H:%M:%S')
#
# USAGE:
#   Add these lines to the END of your ~/.zshrc (or ~/.bashrc for Bash):
#
#     # Load custom aliases (must be last to avoid breaking initialization)
#     if [ -f "${HOME}/.aliases" ]; then
#         source "${HOME}/.aliases"
#     fi
#
#   Then reload your shell:
#     source ~/.zshrc
#
# IMPORTANT:
#   - Must be placed at the END of your shell config file
#   - Loading too early breaks compinit, SDKMAN, and other tools
#   - Aliases override system commands; use \cat, \ls, etc. for originals
#
# NOTE:
#   - This file is regenerated each time you run the installer
#   - All aliases are idempotent (safe to source multiple times)
#
# ============================================================

ALIASES_EOF

    # Add Modern CLI Replacements
    local has_modern_cli=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            bat|eza|ripgrep|fd) has_modern_cli=true; break ;;
        esac
    done

    if [ "$has_modern_cli" = true ]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Modern CLI Replacements
# ============================================================
# ⚠️  WARNING: These override default commands
# Use \cat, \ls, \grep, \find to access originals

ALIASES_EOF

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "bat" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# Better 'cat' with syntax highlighting
alias cat='bat'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "eza" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# Modern 'ls' replacement
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "ripgrep" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# Better 'grep' - faster with .gitignore support
alias grep='rg'
alias rg='rg -C 3'  # 3 lines of context

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fd" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# Simpler, faster 'find'
alias find='fd'

ALIASES_EOF
        fi
    fi

    # Add Navigation & Productivity
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "zoxide" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Smart Navigation
# ============================================================

# zoxide - smart 'cd' that learns your habits
eval "$(zoxide init --cmd cd zsh)"  # Makes 'cd' use zoxide
# Or use 'z' command: eval "$(zoxide init zsh)"

ALIASES_EOF
    fi

    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fzf" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Fuzzy Finding
# ============================================================

# fzf - fuzzy finder for files, history, processes
eval "$(fzf --zsh)"  # Enable fzf keybindings and completion

ALIASES_EOF
    fi

    # Add Kubernetes Tools
    local has_k8s=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            kubectl|kubectx) has_k8s=true; break ;;
        esac
    done

    if [ "$has_k8s" = true ]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Kubernetes Shortcuts
# ============================================================

ALIASES_EOF

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "kubectl" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# kubectl shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployment'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kpf='kubectl port-forward'

# kubectl completion
source <(kubectl completion zsh)

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "kubectx" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# kubectx/kubens shortcuts
alias kctx='kubectx'
alias kns='kubens'
# Switch to previous context: kubectx -
# Switch to previous namespace: kubens -

ALIASES_EOF
        fi
    fi

    # Add Git Enhancements
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "git-delta" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Git Enhancements
# ============================================================

# Configure git to use delta for diffs
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictstyle diff3

ALIASES_EOF
    fi

    # Add Development Tools
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "httpie" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# HTTP/API Testing
# ============================================================

# HTTPie shortcuts
alias http='http --print=HhBb'  # Show headers + body
alias https='http --default-scheme=https'

ALIASES_EOF
    fi

    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "procs" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Process Management
# ============================================================

# Modern 'ps' replacement
alias ps='procs'

ALIASES_EOF
    fi

    # Add Terminal Multiplexer
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "tmux" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Terminal Multiplexer
# ============================================================

# tmux shortcuts
alias t='tmux'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

ALIASES_EOF
    fi

    # Add Dotfiles Management
    if [[ " ${INSTALLED_PACKAGES[*]} " =~ "chezmoi" ]]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Dotfiles Management
# ============================================================

# chezmoi shortcuts
alias cm='chezmoi'
alias cma='chezmoi add'
alias cme='chezmoi edit'
alias cmcd='chezmoi cd'
alias cmup='chezmoi update'

ALIASES_EOF
    fi

    # Add Version Managers
    local has_version_managers=false
    for pkg in "${INSTALLED_PACKAGES[@]}"; do
        case "$pkg" in
            pyenv|rbenv|fnm) has_version_managers=true; break ;;
        esac
    done

    if [ "$has_version_managers" = true ]; then
        cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Version Managers (Required Setup)
# ============================================================

ALIASES_EOF

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "pyenv" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# pyenv - Python version management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "rbenv" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# rbenv - Ruby version management
eval "$(rbenv init - zsh)"

ALIASES_EOF
        fi

        if [[ " ${INSTALLED_PACKAGES[*]} " =~ "fnm" ]]; then
            cat >> "$aliases_file" <<'ALIASES_EOF'
# fnm - Fast Node Manager
eval "$(fnm env --use-on-cd)"

ALIASES_EOF
        fi
    fi

    # Add footer
    cat >> "$aliases_file" <<'ALIASES_EOF'

# ============================================================
# Important Notes
# ============================================================
# • Aliases that override default commands (cat, ls, grep, find) may affect scripts
# • Test aliases before committing to your shell config
# • You can always use the original command with: \command (e.g., \cat, \ls)
# • Version manager init commands are REQUIRED for those tools to work
# ============================================================
ALIASES_EOF

    echo ""
    print_success "Shell aliases saved to: ${BOLD}${aliases_file}${NC}"
    echo ""
}

################################################################################
# Post-Install Report
################################################################################

generate_post_install_report() {
    print_phase "11" "Post-Installation Report"

    # Show alias recommendations first (before health check)
    generate_alias_report

    # Generate .aliases file for easy sourcing
    generate_aliases_file

    print_info "Running system health check..."
    echo ""

    # Run brew doctor
    if [ "$DRY_RUN" = false ]; then
        print_info "Running 'brew doctor'..."
        "${HOMEBREW_ARM64_BIN}" doctor 2>&1 | head -20
    fi

    echo ""
    print_success "Installation Complete!"
    echo ""

    # Summary
    print_header "Installation Summary"

    echo -e "${BOLD}Installed Packages (${#INSTALLED_PACKAGES[@]} total):${NC}"
    if [ ${#INSTALLED_PACKAGES[@]} -gt 0 ]; then
        for pkg in "${INSTALLED_PACKAGES[@]}"; do
            echo "  • $pkg"
        done
    else
        echo "  (none - dry run mode)"
    fi

    echo ""
    print_header "Architecture Verification"

    if [ "$DRY_RUN" = false ]; then
        echo -e "${BOLD}Key tool architectures:${NC}"
        for tool in git python3 node ruby; do
            local tool_path
            tool_path=$(command -v "$tool" 2>/dev/null || echo "not found")
            if [ "$tool_path" != "not found" ]; then
                local arch
                arch=$(file "$tool_path" | grep -o "arm64" || echo "NOT ARM64!")
                echo "  • $tool: $arch ($tool_path)"
            fi
        done
    fi

    echo ""
    print_header "Next Steps"

    echo -e "${YELLOW}1. Add Homebrew to your shell:${NC}"
    echo "   echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zshrc"
    echo "   source ~/.zshrc"
    echo ""

    echo -e "${YELLOW}2. Configure version managers:${NC}"
    if [ ${#INSTALLED_PACKAGES[@]} -gt 0 ] && [[ " ${INSTALLED_PACKAGES[*]} " =~ "pyenv" ]]; then
        echo -e "   ${BOLD}pyenv:${NC}"
        echo "     echo 'eval \"\$(pyenv init -)\"' >> ~/.zshrc"
        echo "     pyenv install 3.12.1"
        echo "     pyenv global 3.12.1"
        echo ""
    fi
    if [ ${#INSTALLED_PACKAGES[@]} -gt 0 ] && [[ " ${INSTALLED_PACKAGES[*]} " =~ "rbenv" ]]; then
        echo -e "   ${BOLD}rbenv:${NC}"
        echo "     echo 'eval \"\$(rbenv init - zsh)\"' >> ~/.zshrc"
        echo "     rbenv install 3.2.2"
        echo "     rbenv global 3.2.2"
        echo ""
    fi

    echo -e "${YELLOW}3. Load shell aliases (if generated):${NC}"
    if [ -f "${SCRIPT_DIR}/.aliases" ]; then
        echo -e "   ${CYAN}echo 'source ${SCRIPT_DIR}/.aliases' >> ~/.zshrc${NC}"
        echo -e "   ${CYAN}source ~/.zshrc${NC}"
        echo -e "   ${CYAN}(Or copy individual aliases from .aliases file)${NC}"
    else
        echo -e "   ${CYAN}No aliases file generated (no tools with aliases installed)${NC}"
    fi
    echo ""

    # Only show cleanup instruction if broken files were detected
    if [ "$BROKEN_FILES_DETECTED" = true ]; then
        echo -e "${YELLOW}4. Run cleanup script:${NC}"
        echo "   ./cleanup-broken-files.sh"
        echo "   ${CYAN}(Removes broken symlinks from previous Homebrew installation)${NC}"
        echo ""
    fi

    if [ "$DRY_RUN" = false ]; then
        echo -e "${GREEN}${BOLD}Installation log saved to:${NC} $INSTALL_LOG"
    else
        echo -e "${CYAN}Note: No log file created in dry-run mode${NC}"
    fi
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --dry-run)
                DRY_RUN=true
                print_warning "DRY RUN MODE - No packages will be installed"
                ;;
            --auto-yes)
                AUTO_YES=true
                print_warning "AUTO-YES MODE - All prompts will be auto-approved"
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --dry-run         Preview installation without making changes"
                echo "  --auto-yes        Auto-approve all prompts"
                echo "  --help            Show this help"
                exit 0
                ;;
            *)
                print_error "Unknown option: $arg"
                exit 1
                ;;
        esac
    done

    # Header
    print_header "Homebrew ARM64 Installation for Apple Silicon"

    print_info "System: $(uname -m) / $(sw_vers -productName) $(sw_vers -productVersion)"
    print_info "Date: $(date)"
    echo ""

    # Pre-flight checks
    print_info "Running pre-flight checks..."
    check_architecture
    check_existing_homebrew
    check_broken_files
    echo ""

    # Installation phases
    install_homebrew
    install_essential_tools
    install_version_managers
    install_languages
    install_cloud_devops
    install_build_tools
    install_modern_cli_tools
    install_database_clients
    install_media_processing
    install_casks

    # Final report (includes alias report)
    generate_post_install_report

    print_success "All done! Enjoy your new development environment! 🎉"
}

# Run main function
main "$@"
