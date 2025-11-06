# Homebrew ARM64 Installation Guide

**For:** Apple M3 Max (Apple Silicon)
**Target:** Fresh ARM64 Homebrew installation with intelligent package selection
**Created:** November 4, 2025

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [What This Script Does](#what-this-script-does)
5. [Installation Phases](#installation-phases)
6. [Package Categories](#package-categories)
7. [Version Manager Recommendations](#version-manager-recommendations)
8. [Usage Examples](#usage-examples)
9. [Troubleshooting](#troubleshooting)
10. [Post-Installation](#post-installation)

---

## Overview

This installation system provides an intelligent, interactive way to set up Homebrew and development tools on Apple Silicon Macs. It:

- **Ensures ARM64-native installations** (no Rosetta 2 emulation)
- **Recommends best practices** for version managers (uv, pyenv, nvm, rbenv, tfenv)
- **Auto-upgrades deprecated packages** (python@2 → python3, terraform → OpenTofu)
- **Provides explanations** for each recommendation
- **Supports dry-run mode** to preview before installing

### Key Features

✅ **Strict Architecture Verification** - Aborts if wrong architecture detected
✅ **Interactive Category Selection** - Install only what you need
✅ **Modern Tool Recommendations** - ripgrep, eza, fd, and other 2025 standards
✅ **Version Manager Best Practices** - Expert guidance on uv vs pyenv for Python, SDKMAN for Java/JVM
✅ **Comprehensive Logging** - Full installation log for troubleshooting
✅ **Post-Install Health Check** - Verify ARM64 binaries and system state

---

## Prerequisites

### System Requirements

- **Apple Silicon Mac** (M1, M2, M3, M4 series)
- **macOS 11.0+** (Big Sur or later)
- **Internet connection** for downloading packages
- **~5GB free disk space** (varies by package selection)

### Before Running

1. **Uninstall existing Homebrew** (if migrating from Intel):

   ⚠️ **IMPORTANT:** You must run the official Homebrew uninstaller **first**, then use cleanup scripts to remove remnants.

   ```bash
   # Step 1: Run official uninstaller
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

   # Step 2: Clean up remnants
   ./cleanup-homebrew-remnants.sh
   ```

   **For complete uninstall workflow, see [UNINSTALL-GUIDE.md](UNINSTALL-GUIDE.md)**

2. **Check architecture**:
   ```bash
   uname -m
   # Should output: arm64
   ```

3. **Ensure Xcode Command Line Tools** (installed automatically by Homebrew installer):
   ```bash
   xcode-select --install
   ```

---

## Quick Start

### Basic Interactive Installation

```bash
# Make executable (first time only)
chmod +x install-homebrew-arm64.sh

# Run interactive installation
./install-homebrew-arm64.sh
```

The script will:
1. Verify ARM64 architecture
2. Check for existing Homebrew
3. Install Homebrew to `/opt/homebrew`
4. Prompt you for each package category
5. Generate post-install report

### Preview Mode (Recommended First Run)

```bash
# See what would be installed without making changes
./install-homebrew-arm64.sh --dry-run
```

---

## What This Script Does

### Pre-Flight Checks

1. **Architecture Verification**
   - Confirms system is ARM64 (Apple Silicon)
   - Aborts if Intel or Rosetta 2 detected

2. **Existing Installation Detection**
   - Checks for Intel Homebrew at `/usr/local/bin/brew`
   - Checks for ARM Homebrew at `/opt/homebrew/bin/brew`
   - Warns if broken files from previous installation detected

3. **Broken Files Warning**
   - Detects orphaned files from old Homebrew
   - Suggests running `cleanup-broken-files.sh`

### Installation Process

The script installs packages in **11 sequential phases** with interactive prompts for each category (except essentials).

### What Gets Installed (Default Selections)

**Always Installed (Essential - 19 packages):**
- Version control: git, gh, git-lfs
- HTTP tools: curl, wget
- Data processing: jq, yq
- System tools: htop, tree, mas, nmap
- Modern CLI: bat (better cat)
- Security: openssl@3, ca-certificates
- Utilities: diff-so-fancy, coreutils, grep, sqlite

**Prompted (Category-Based):**
- Version managers (uv/pyenv for Python, nvm/fnm for Node.js, rbenv, tfenv)
- Language runtimes (PHP, Perl, Go)
  - Note: Java/JVM via SDKMAN (USER PREFERENCE), OpenJDK discouraged
- Cloud/DevOps (AWS CLI, Helm, K9s, Ansible)
- Build tools (cmake, autoconf, make)
- Modern CLI tools (ripgrep, eza, fd, httpie, delta, fzf, zoxide, procs)
- Database clients (MySQL, PostgreSQL, SQLite)
- Media processing (ImageMagick, FFmpeg)
- GUI apps via Cask (Alfred, Ghostty, Firefox, etc.)

---

## Installation Phases

### Phase 1: Homebrew Installation

**What it does:**
- Downloads official Homebrew installer
- Installs to `/opt/homebrew` (ARM64 path)
- Verifies binary is ARM64 native
- Adds to PATH temporarily for script

**Verification:**
```bash
file /opt/homebrew/bin/brew
# Output should include: Mach-O 64-bit executable arm64
```

---

### Phase 2: Essential Tools (Auto-Install)

**Packages installed automatically** (no prompt):

| Package | Purpose |
|---------|---------|
| git | Version control |
| gh | GitHub CLI |
| curl | HTTP client |
| wget | File downloader |
| jq | JSON processor |
| yq | YAML processor |
| tree | Directory visualization |
| htop | Process viewer |
| bat | Modern cat with syntax highlighting |
| mas | Mac App Store CLI |
| grep | Text search (GNU version) |
| coreutils | GNU core utilities |
| sqlite | Embedded database |
| openssl@3 | Security library |
| ca-certificates | SSL certificates |
| diff-so-fancy | Better git diffs |
| git-lfs | Git large file storage |
| nmap | Network scanner |

**Why auto-install?** These tools are universally useful for developers and have minimal downsides.

---

### Phase 3: Version Managers (Interactive)

This is the most important phase for professional development workflows.

#### Python: uv vs pyenv

**Recommendation:** ✅ **INSTALL uv** (2025 Modern Standard - USER PREFERENCE)

**What is uv?**
**uv** is the modern unified Python toolkit by Astral (creators of Ruff). It combines Python version management, dependency resolution, virtual environments, and package management into one blazingly fast tool.

**Why uv over pyenv in 2025?**
- **Unified workflow:** Manages versions + dependencies + tools in one place
- **Blazingly fast:** 10-100x faster than pip (written in Rust)
- **Pre-built binaries:** Install Python in seconds (not minutes)
- **Drop-in replacement:** `uv pip install` works just like `pip install`
- **No compilation:** Unlike pyenv, doesn't need build tools
- **Cross-platform lockfiles:** Same config works on Mac, Linux, Windows
- **Modern:** Cargo-like experience for Python (2025 emerging standard)

**Replaces:** pip + pipx + pyenv + virtualenv + pip-tools

**Alternative:** pyenv (established tool, version management only, requires separate dependency tools)

**Script behavior:**
```
Prompt: Install uv for Python (recommended - unified toolkit)? [Y/n]
  ↓ If YES: uv installed via Homebrew
  ↓ If NO: Fallback prompt: "Install pyenv instead?" [y/N]
```

**Post-install steps with uv (recommended):**
```bash
# uv doesn't need shell init - it's just a binary

# Install Python version
uv python install 3.12

# Set project-specific Python (creates .python-version)
cd your-project/
uv python pin 3.12

# Create virtual environment
uv venv

# Install packages (drop-in pip replacement)
uv pip install requests pandas numpy

# Install CLI tools (replaces pipx)
uv tool install ruff black pytest

# Run Python scripts directly
uv run script.py

# Verify
which python  # Should show .venv/bin/python
```

**Post-install steps with pyenv (alternative):**
```bash
# Add to shell (only if you chose pyenv)
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc

# Install Python
pyenv install 3.12.1
pyenv global 3.12.1

# Verify
python --version  # Should show pyenv version

# Note: Still need pip/pipx/venv separately
```

**Migration from pyenv to uv:**
See UPDATES-FOR-UV-AND-SDKMAN.md for detailed migration guide.

---

#### Node.js: nvm vs fnm vs Volta

**Current Status:** You already have `nvm` installed

**Options presented by script:**

| Option | Speed | Features | Best For |
|--------|-------|----------|----------|
| **nvm** | Slow | Largest community | Established workflows |
| **fnm** | 40x faster | nvm-compatible commands | Individual developers |
| **Volta** | Fast | Auto version switching | Team environments |

**Recommendation for 2025:**
- Keep nvm if it works for you ✅
- Upgrade to **fnm** for speed 🚀
- Use **Volta** for team projects 👥

**Migration (nvm → fnm):**
```bash
# Install fnm
brew install fnm

# Add to shell
echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc

# Install Node
fnm install --lts
fnm default <version>

# Remove nvm from ~/.zshrc
```

---

#### Ruby: rbenv

**Recommendation:** ✅ **INSTALL** (if you do Ruby)

**Why rbenv over RVM?**
- Lightweight and transparent
- Doesn't override shell commands
- Works with Bundler (modern gem management)
- Gemsets are obsolete

**Post-install:**
```bash
# Add to shell
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc

# Install Ruby
rbenv install 3.2.2
rbenv global 3.2.2
```

---

#### Terraform: tfenv + OpenTofu

**Recommendation:** ✅ **INSTALL** (Essential for IaC)

**Why tfenv + OpenTofu?**
- Terraform changed to BSL license (proprietary)
- Deprecated in Homebrew
- **OpenTofu** = Open-source fork (100% compatible)
- **tfenv** = Version manager (like nvm for Node)

**Post-install:**
```bash
# Install OpenTofu version
tfenv install latest
tfenv use latest

# Create alias
echo 'alias terraform="tofu"' >> ~/.zshrc

# Use .terraform-version for team consistency
```

---

### Phase 4: Language Runtimes (Interactive)

**PHP + Composer**
- **Prompt:** "Do you do PHP development?"
- **Default:** NO (you mentioned you don't use PHP)
- **If yes:** Installs PHP 8.4 + Composer

**Java/JVM: SDKMAN vs Homebrew OpenJDK**

**Status:** SDKMAN detected at `~/.sdkman` (USER PREFERENCE)

**Recommendation:** ✅ **USE SDKMAN exclusively** (Industry Standard)

**Why SDKMAN over Homebrew OpenJDK?**
- **Industry standard:** Most popular JVM version manager
- **Multiple distributions:** Amazon Corretto, GraalVM, Temurin, Oracle, etc.
- **Full ecosystem:** Manages Java, Gradle, Maven, Kotlin, Scala, Groovy
- **Version switching:** `sdk use java 21.0.1` instantly switches versions
- **Per-project versions:** `.sdkmanrc` file for team consistency
- **Cross-platform:** Works on macOS, Linux, Windows (WSL)

**Script behavior:**
- **Detection:** Checks for `~/.sdkman` directory
- **Displays:** SDKMAN commands and benefits
- **Prompt:** "Install Homebrew OpenJDK anyway? (SDKMAN is better)" [y/N]
- **Default:** NO (SDKMAN is superior)

**Common SDKMAN commands:**
```bash
# List available Java versions
sdk list java

# Install specific version
sdk install java 21.0.1-tem    # Temurin (Eclipse)
sdk install java 21.0.1-amzn   # Amazon Corretto
sdk install java 21.0.1-graal  # GraalVM

# Use for current shell
sdk use java 21.0.1-tem

# Set as default
sdk default java 21.0.1-tem

# Check current version
sdk current java

# Install other JVM tools
sdk install gradle
sdk install maven
sdk install kotlin
```

**Note:** Homebrew OpenJDK is redundant when using SDKMAN and creates confusion between two Java installations.

**Perl**
- **Auto-installed** (often required by build scripts)

**Go**
- **Detection:** Checks for `/usr/local/go`
- **Recommendation:** Keep official installer, don't use Homebrew
- **Optional:** Install `gvm` for multi-version support

---

### Phase 5: Cloud & DevOps Tools (Interactive)

**Prompt:** "Install cloud & DevOps tools (AWS, Azure, GCP CLIs + K8s tools)?"

**Included packages:**

**Cloud Platform CLIs:**
- `awscli` - AWS command-line interface
- `azure-cli` - Azure CLI (Microsoft Azure)
- `google-cloud-sdk` - Google Cloud SDK (includes gcloud, gsutil, bq)

**Kubernetes & Automation:**
- `helm` - Kubernetes package manager
- `k9s` - Kubernetes TUI (Terminal UI)
- `ansible` - Configuration management
- `ansible-lint` - Ansible linter

**Post-install setup:**
```bash
# AWS
aws configure

# Azure
az login
az account set --subscription <subscription-id>

# Google Cloud
gcloud init
gcloud auth login
gcloud config set project <project-id>
```

**Optional additions:**
- `kubectl` - Kubernetes CLI
- `kubectx` / `kubens` - Context/namespace switching
- `stern` - Multi-pod log tailing
- `terraform-docs` - Terraform documentation generator
- `tflint` - Terraform linter

---

### Phase 6: Build Tools (Interactive)

**Prompt:** "Install build tools for compiling from source?"

**When you need this:**
- Compiling C/C++ projects
- Building software from source
- Working with native extensions

**Packages:**
- `cmake` - Cross-platform build system
- `autoconf` - Build configuration
- `automake` - Build automation
- `libtool` - Library building
- `pkg-config` - Compiler/linker helper
- `bison` - Parser generator
- `m4` - Macro processor
- `make` - GNU make

---

### Phase 7: Modern CLI Productivity Tools (Interactive)

**Prompt:** "Install modern CLI productivity tools?"

This is where traditional Unix tools get modern replacements:

| Traditional | Modern | Why Upgrade |
|-------------|--------|-------------|
| `grep` | **ripgrep (rg)** | 10-100x faster, respects .gitignore, better regex |
| `ls` | **eza** | Colors, icons, Git integration, tree view |
| `find` | **fd** | Simpler syntax, faster, respects .gitignore |
| `curl` | **httpie** | User-friendly, colorized, JSON support |
| (git diff) | **delta** | Syntax highlighting, side-by-side diffs |
| (search) | **fzf** | Fuzzy finder for files, history, commands |
| `cd` | **zoxide** | Smart cd that learns your habits |
| `ps` | **procs** | Better formatting, search, tree view |

**Suggested aliases** (shown at end of installation):
```bash
alias cat='bat'
alias ls='eza'
alias ll='eza -l'
alias grep='rg'
alias find='fd'
alias cd='z'  # zoxide
```

---

### Phase 8: Database Clients (Interactive)

**Prompt:** "Install database client tools?"

**Important:** These are **client tools only**, not database servers.

**Packages:**
- `mysql-client` - MySQL CLI and libraries
- `libpq` - PostgreSQL client library
- `sqlite` - Embedded database (already in essentials)

**For database servers:**
- Use Docker (recommended)
- Or install separately: `brew services start postgresql@16`

---

### Phase 9: Media Processing (Interactive)

**Prompt:** "Do you work with media files?"

**When you need this:**
- Image manipulation
- Video/audio processing
- OCR (text recognition)
- PDF generation

**Packages:**
- `imagemagick` - Image manipulation (300+ formats)
- `ghostscript` - PostScript/PDF interpreter
- `tesseract` - OCR engine

**Optional (large):**
- `ffmpeg` - Video/audio processing
- 40+ codec libraries (aom, x264, x265, etc.)

**Storage impact:** ~500MB-1GB depending on codecs

---

### Phase 10: GUI Applications - Cask (Interactive)

**Prompt:** "Install GUI applications?"

**Individual prompts for each app:**

| App | Description | Priority |
|-----|-------------|----------|
| **alfred** | Spotlight replacement, productivity | High |
| **ghostty** | Modern GPU-accelerated terminal emulator | High |
| **firefox** | Web browser | High |
| **caffeine** | Keeps Mac awake | Medium |
| **cheatsheet** | Shows keyboard shortcuts | Medium |

**Note:** Install only what you'll actually use. All apps can be installed later via:
```bash
brew install --cask <app-name>
```

---

### Phase 11: Post-Install Report

**What it does:**
1. Runs `brew doctor` for health check
2. Lists all installed packages
3. Verifies ARM64 architecture for key tools
4. Shows shell configuration steps
5. Suggests next actions

**Sample output:**
```
Architecture Verification:
  • git: arm64 (/opt/homebrew/bin/git)
  • python3: arm64 ($HOME/.local/share/uv/python/cpython-3.12/bin/python3)
  • node: arm64 ($HOME/.local/share/fnm/node-versions/v20.17.0/bin/node)
  • ruby: arm64 (/opt/homebrew/bin/ruby)
```

---

## Package Categories

### Essential Tools (19 packages)

**Auto-installed without prompting**

```json
[
  "git", "gh", "curl", "wget", "jq", "yq", "tree", "htop", "bat",
  "tealdeer", "mas", "grep", "coreutils", "sqlite", "openssl@3",
  "ca-certificates", "diff-so-fancy", "git-lfs", "nmap"
]
```

### Version Managers (4 systems)

**Recommended over language-specific Homebrew packages**

1. **pyenv** - Python version manager
2. **nvm/fnm/volta** - Node.js version manager
3. **rbenv** - Ruby version manager
4. **tfenv** - Terraform/OpenTofu version manager

### Deprecated / Skip

**These will NOT be installed:**

| Package | Reason | Alternative |
|---------|--------|-------------|
| python@2 | EOL since 2020 | python3 via pyenv |
| python@3.x | Use version manager | pyenv |
| node | Use version manager | nvm/fnm/volta |
| terraform | BSL license, deprecated | OpenTofu + tfenv |
| php | User doesn't use PHP | (skip) |
| composer | PHP dependency manager | (skip with PHP) |

---

## Version Manager Recommendations

### Decision Matrix

| Language | Homebrew | Version Manager | Recommended |
|----------|----------|-----------------|-------------|
| **Python** | ❌ | uv ✅ / pyenv ⚠️ | **uv** (2025 unified toolkit - USER PREFERENCE) |
| **Node.js** | ❌ | nvm/fnm/volta ✅ | fnm (speed) or Volta (teams) |
| **Ruby** | ❌ | rbenv ✅ | rbenv (lightweight) |
| **Go** | ⚠️ | Official + gvm | Official installer |
| **Java/JVM** | ❌ | SDKMAN ✅ | **SDKMAN** (already installed - USER PREFERENCE) |
| **Terraform** | ❌ | tfenv + OpenTofu ✅ | tfenv + OpenTofu |

### Why Version Managers?

**Benefits:**
1. **Multiple versions simultaneously** - Different projects need different versions
2. **Project-specific versions** - `.python-version`, `.node-version` files
3. **Team consistency** - Everyone uses the same version
4. **No sudo** - Installs in user space, no permission issues
5. **Clean uninstalls** - Remove version without affecting others

**Example workflow with uv (recommended - USER PREFERENCE):**
```bash
# Install multiple Python versions
uv python install 3.11
uv python install 3.12

# Set project-specific version
cd my-project/
uv python pin 3.12

# Create virtual environment
uv venv

# Install dependencies
uv pip install -r requirements.txt

# Install CLI tools
uv tool install ruff black

# Run scripts
uv run script.py
```

**Alternative workflow with pyenv:**
```bash
# Install multiple Python versions
pyenv install 3.11.5
pyenv install 3.12.1

# Set global default
pyenv global 3.12.1

# Still need separate tools
pip install -r requirements.txt
pipx install ruff black

# Set project-specific version
cd my-project/
echo "3.11.5" > .python-version
python --version  # Automatically uses 3.11.5 in this directory
```

---

## Usage Examples

### Example 1: Fresh Development Mac

```bash
# Preview first
./install-homebrew-arm64.sh --dry-run

# Run installation
./install-homebrew-arm64.sh

# Answer prompts:
# - Install pyenv? YES
# - Install fnm (faster nvm)? YES
# - Install rbenv? YES (if doing Ruby)
# - Install tfenv + OpenTofu? YES (if doing IaC)
# - Install cloud tools? YES (if using AWS/K8s)
# - Install build tools? YES (if compiling code)
# - Install modern CLI tools? YES (recommended)
# - Install database clients? YES
# - Install media processing? NO (unless needed)
# - Install casks? Select what you use
```

**Time:** ~30-60 minutes depending on selections

---

### Example 2: Minimal Installation (Essential Only)

```bash
./install-homebrew-arm64.sh

# Answer NO to everything except:
# - pyenv (if doing Python)
# - Modern CLI tools (quality of life)
```

**Installs:**
- Homebrew
- 19 essential tools
- pyenv
- 8 modern CLI tools (ripgrep, eza, fd, etc.)

**Time:** ~15 minutes

---

### Example 3: Cloud Developer Setup

```bash
./install-homebrew-arm64.sh

# Answer YES to:
# - pyenv (Python for scripts)
# - Modern CLI tools
# - Cloud/DevOps tools
# - kubectl + K8s tools
# - Database clients
```

**Perfect for:**
- AWS/GCP/Azure development
- Kubernetes administration
- Infrastructure as Code
- DevOps workflows

---

## Troubleshooting

### Issue: "Architecture is not ARM64"

**Cause:** Running on Intel Mac or Rosetta 2

**Solution:**
```bash
# Check architecture
uname -m
# Should output: arm64

# If it shows x86_64, you're running under Rosetta
# Disable Rosetta for Terminal:
# Right-click Terminal.app → Get Info → Uncheck "Open using Rosetta"
```

---

### Issue: "Intel Homebrew detected"

**Cause:** Previous Intel Homebrew installation at `/usr/local/bin/brew`

**Solution:**
```bash
# Uninstall Intel Homebrew first (required)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Clean up remnants (after official uninstaller)
./cleanup-homebrew-remnants.sh

# Then re-run installer
./install-homebrew-arm64.sh
```

**For complete uninstall workflow, see [UNINSTALL-GUIDE.md](UNINSTALL-GUIDE.md)**

---

### Issue: "brew command not found" after installation

**Cause:** Homebrew not in PATH

**Solution:**
```bash
# Add to shell configuration
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Verify
which brew
# Should output: /opt/homebrew/bin/brew
```

---

### Issue: Package installation fails

**Symptoms:**
```
Error: Failed to install <package>
```

**Solutions:**

1. **Check Homebrew health:**
   ```bash
   brew doctor
   ```

2. **Update Homebrew:**
   ```bash
   brew update
   ```

3. **Check package exists:**
   ```bash
   brew search <package>
   ```

4. **Manual installation:**
   ```bash
   brew install <package>
   ```

5. **View installation log:**
   ```bash
   cat install-log-*.txt
   ```

---

### Issue: pyenv/nvm not working after installation

**Cause:** Shell configuration not loaded

**Solution:**
```bash
# For pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc

# For nvm (if you kept it)
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
source ~/.zshrc

# For rbenv
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
```

---

## Post-Installation

### 1. Shell Configuration

**Add Homebrew to PATH:**
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

**Add version managers:**
```bash
# pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# rbenv (if installed)
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc

# fnm (if installed instead of nvm)
echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc

source ~/.zshrc
```

---

### 2. Install Language Versions

**Python via pyenv:**
```bash
# List available versions
pyenv install --list

# Install latest
pyenv install 3.12.1

# Set as global default
pyenv global 3.12.1

# Verify
python --version
which python  # Should be in ~/.pyenv/shims/
```

**Node.js via nvm:**
```bash
# Install latest LTS
nvm install --lts

# Set as default
nvm alias default lts/*

# Verify
node --version
which node  # Should be in ~/.nvm/versions/
```

**Ruby via rbenv:**
```bash
# Install latest
rbenv install 3.2.2

# Set as global
rbenv global 3.2.2

# Verify
ruby --version
which ruby  # Should be in ~/.rbenv/shims/
```

---

### 3. Set Up Shell Aliases (Optional)

**Add to ~/.zshrc:**
```bash
# Modern CLI tools
alias cat='bat'
alias ls='eza'
alias ll='eza -l -a'
alias tree='eza --tree'
alias grep='rg'
alias find='fd'

# Git helpers
alias gs='git status'
alias gd='git diff | delta'
alias gl='git log --oneline --graph'

# Zoxide (smart cd)
eval "$(zoxide init zsh)"
alias cd='z'

# FZF shortcuts
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

---

### 4. Configure Git with Modern Tools

**Use delta for better diffs:**
```bash
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
```

---

### 5. Verify ARM64 Architecture

**Check key tools:**
```bash
file $(which brew)    # Should show: arm64
file $(which git)     # Should show: arm64
file $(which python)  # Should show: arm64
file $(which node)    # Should show: arm64
file $(which ruby)    # Should show: arm64
```

**Check running processes:**
```bash
ps aux | grep -i rosetta
# Should be empty (no Rosetta processes)
```

---

### 6. Clean Up Old Files

```bash
# Run cleanup script
./cleanup-broken-files.sh

# Remove old logs
brew cleanup
```

---

### 7. Next Steps

**For Python development:**
```bash
pip install --upgrade pip
pip install virtualenv
pip install ipython jupyter
```

**For Node.js development:**
```bash
npm install -g yarn pnpm
npm install -g eslint prettier
```

**For DevOps work:**
```bash
# AWS CLI configuration
aws configure

# Kubernetes context
kubectl config get-contexts

# Terraform/OpenTofu
tofu --version
```

---

## Maintenance

### Keep Homebrew Updated

```bash
# Update Homebrew
brew update

# Upgrade packages
brew upgrade

# Clean up old versions
brew cleanup
```

### Keep Version Managers Updated

```bash
# pyenv
brew upgrade pyenv

# rbenv
brew upgrade rbenv

# fnm
brew upgrade fnm
```

---

## Getting Help

**Homebrew issues:**
```bash
brew doctor          # Health check
brew config          # Show configuration
brew --version       # Show version
```

**Script issues:**
- Check `install-log-*.txt` for detailed error messages
- Run with `--dry-run` to preview without installing
- File issue at repository (if applicable)

**Version manager issues:**
```bash
pyenv doctor         # Check pyenv setup
rbenv doctor         # Check rbenv setup
nvm debug           # Debug nvm issues
```

---

## Summary

This installation system provides a professional, best-practice approach to setting up Homebrew and development tools on Apple Silicon. By following version manager recommendations and installing modern CLI tools, you'll have a powerful, maintainable development environment.

**Key Takeaways:**
- ✅ Use version managers (pyenv, nvm, rbenv) instead of Homebrew for languages
- ✅ Install modern CLI tools (ripgrep, eza, fd) for better productivity
- ✅ Verify ARM64 architecture for all critical tools
- ✅ Keep Homebrew and version managers updated
- ✅ Use dry-run mode before major changes

**Happy coding! 🚀**
