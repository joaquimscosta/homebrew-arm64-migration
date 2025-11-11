# Homebrew ARM64 Migration Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![macOS](https://img.shields.io/badge/macOS-Sequoia%2015.6+-blue.svg)](https://www.apple.com/macos/)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-M1%20|%20M2%20|%20M3%20|%20M4-purple.svg)](https://support.apple.com/en-us/116943)

**Intelligent, interactive Homebrew ARM64 installation system for Apple Silicon Macs.**

Migrating from Intel Homebrew (`/usr/local`) to native ARM64 Homebrew (`/opt/homebrew`)? Or setting up Homebrew for the first time on an M-series Mac? This script provides a comprehensive, safe, and educational installation experience with modern best practices for 2025.

---

## ✨ Features

- **🔒 Strict ARM64 Verification** - Ensures you're installing native ARM64 binaries, not x86_64 under Rosetta 2
- **🎓 Educational Prompts** - Explains *why* to use modern tools (uv, fnm, SDKMAN) over traditional approaches
- **⚡ Modern Version Managers** - Prioritizes uv for Python, fnm/Volta for Node.js, SDKMAN for Java/JVM
- **📦 Smart Package Selection** - 146+ packages analyzed, organized into 12 installation phases
- **🔄 Auto-Upgrade Deprecated** - Automatically replaces python@2, terraform, etc. with modern alternatives
- **☁️ Multi-Cloud Support** - AWS CLI, Azure CLI, Google Cloud SDK with post-install setup guidance
- **🛡️ Safe & Reversible** - Dry-run mode, comprehensive logging, health checks
- **🎨 Modern CLI Tools** - ripgrep, eza, fd, bat, delta, fzf, zoxide, and more
- **🔧 Smart Aliases** - Safe non-overriding aliases by default; POSIX overrides commented out

---

## 🚀 Quick Start

### Two-Step Safe Installation (Recommended)

```bash
# 1. Download and review the script
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/install-homebrew-arm64.sh -o install-homebrew-arm64.sh
chmod +x install-homebrew-arm64.sh

# 2. Preview first (no changes made)
./install-homebrew-arm64.sh --dry-run

# 3. Run installation (interactive prompts)
./install-homebrew-arm64.sh
```

### One-Line Installation (Review First!)

```bash
# ⚠️ SECURITY WARNING: Only use this if you trust the source
# Review the script at the GitHub URL above before running
bash -c "$(curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/install-homebrew-arm64.sh)"
```

---

## 📋 Prerequisites

- **Apple Silicon Mac** (M1, M2, M3, or M4)
- **macOS Sequoia 15.6+** (may work on older versions, but tested on 15.6+)
- **Command Line Tools** installed (`xcode-select --install`)
- **Administrator access** (for installing Homebrew and changing shell)

---

## 📖 What This Script Does

### Installation Phases

The script guides you through **12 sequential phases**:

1. **Homebrew Installation** - Installs ARM64 Homebrew to `/opt/homebrew`
2. **Essential Tools** - Auto-installs 19 must-have developer tools
3. **Version Managers** - Prompts for uv (Python), fnm (Node.js), rbenv (Ruby), tfenv (Terraform/OpenTofu)
4. **Language Runtimes** - Interactive prompts for PHP, OpenJDK, Perl, Go
5. **Cloud/DevOps Tools** - AWS CLI, Azure CLI, GCP CLI, Helm, K9s, Ansible
6. **Build Tools** - cmake, autoconf, make, etc. (for compiling from source)
7. **Modern CLI Tools** - ripgrep, eza, fd, bat, delta, fzf, zoxide, procs
8. **Database Clients** - MySQL, PostgreSQL client libraries
9. **Media Processing** - ImageMagick, FFmpeg (optional, large)
10. **AI Developer Tools** - Optional installs for Claude Code, Codex, Gemini CLI
11. **GUI Applications** - Homebrew Cask apps (Alfred, Ghostty, Firefox, etc.)
12. **Post-Install Report** - Health check, verification, next steps

### Version Manager Recommendations

#### Python: uv (Unified Toolkit - 2025 Standard)

**Why uv over pyenv?**
- Unified workflow (versions + dependencies + tools in one)
- 10-100x faster than pip (Rust-based)
- Pre-built binaries (install Python in seconds, not minutes)
- Drop-in pip replacement
- No compilation required

```bash
# After installing uv
uv python install 3.12
uv python pin 3.12
uv venv
uv pip install requests
```

#### Node.js: fnm or Volta (40x Faster than nvm)

**Why fnm?**
- Rust-based, blazingly fast
- Same commands as nvm
- Cross-platform

```bash
# After installing fnm
fnm install --lts
fnm default lts-latest
```

#### Java/JVM: SDKMAN (Industry Standard)

**Why SDKMAN over Homebrew?**
- Manages multiple JVM distributions (Amazon Corretto, GraalVM, Temurin)
- Handles Gradle, Maven, Kotlin, Scala, Groovy
- Industry-standard tool

```bash
# After installing SDKMAN
sdk install java 21.0.1-tem
sdk default java 21.0.1-tem
```

---

## 🔧 Usage

### Command-Line Options

```bash
./install-homebrew-arm64.sh [OPTIONS]

Options:
  --dry-run         Preview installation without making changes
  --auto-yes        Auto-approve all prompts (use with caution)
  --start-at=N      Start at specific phase (1-12)
  --help            Show help message
```

### Examples

```bash
# Preview what will be installed
./install-homebrew-arm64.sh --dry-run

# Interactive installation (recommended)
./install-homebrew-arm64.sh

# Install everything without prompts (use carefully)
./install-homebrew-arm64.sh --auto-yes

# Resume from Phase 5 (Cloud/DevOps tools)
./install-homebrew-arm64.sh --start-at=5
```

---

## 🔧 Shell Aliases & Modern CLI Tools

The installer generates a `.aliases` file with recommended shell aliases for modern CLI tools.

### 🔒 Safety-First Approach

**NEW in v1.1.0:** POSIX command overrides are now **commented out by default** for safety.

#### ✅ Enabled by Default (Safe)

Non-overriding aliases that don't interfere with standard commands:

```bash
# Modern CLI tools with safe names
alias batcat='bat'           # Syntax-highlighted cat
alias ezals='eza --icons'    # Modern ls with icons
alias rgg='rg'               # Fast grep (ripgrep)
alias fdf='fd'               # Simpler find
alias procps='procs'         # Better ps viewer

# Helpful shortcuts
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --icons'
```

#### ⚠️ Commented Out by Default (Review Before Enabling)

Command overrides that may break scripts:

```bash
# 🔴 HIGH RISK - Uncomment only after testing
# alias cat='bat'       # Breaks scripts using pipelines with -n flag
# alias grep='rg'       # Different options, recursion behavior
# alias find='fd'       # Only ~80% of find functionality

# 🟡 MEDIUM RISK - Output format differences
# alias ls='eza'        # May break scripts parsing ls output
# alias ps='procs'      # Different column format
```

### Risk Levels (Based on 2023-2025 Research)

- **🔴 HIGH RISK**: `cat`, `grep`, `find` - Breaks pipelines, incompatible options
- **🟡 MEDIUM RISK**: `ls`, `ps` - Output format/parsing issues
- **✅ SAFE**: Non-overriding aliases (`batcat`, `ezals`, `rgg`, etc.)

### Usage

After installation, add to your `~/.zshrc`:

```bash
# Load custom aliases (must be last to avoid breaking initialization)
if [ -f "${HOME}/.aliases" ]; then
    source "${HOME}/.aliases"
fi
```

Then reload: `source ~/.zshrc`

### Accessing Original Commands

Use backslash prefix to access original commands when needed:

```bash
\cat file.txt      # Original cat, not bat
\ls -la            # Original ls, not eza
\grep pattern      # Original grep, not ripgrep
```

---

## 🧹 Uninstall & Cleanup

Migrating from Intel Homebrew to ARM64? Follow this **three-step workflow** for a complete, safe migration:

> **⚠️ IMPORTANT:** If you have existing Homebrew installed, you **must** run the official Homebrew uninstaller **first**, then use our cleanup scripts to remove remnants. See **[docs/UNINSTALL-GUIDE.md](docs/UNINSTALL-GUIDE.md)** for the complete workflow.

### Step 1: Official Homebrew Uninstaller (Required First)

Before using our cleanup scripts, remove the main Homebrew installation:

```bash
# Standard uninstall (for /usr/local)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Or for custom prefix
curl -fsSLO https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh
/bin/bash uninstall.sh --path /usr/local
```

**What this removes:** Core Homebrew installation (~3-4GB)
**What remains:** ~820MB of remnants (Python packages, npm globals, configs)

### Step 2: Cleanup Remnants (Choose One)

After the official uninstaller completes, remove leftover files:

#### Option A: Comprehensive Cleanup (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/cleanup-homebrew-remnants.sh -o cleanup-homebrew-remnants.sh
chmod +x cleanup-homebrew-remnants.sh
./cleanup-homebrew-remnants.sh
```

**Removes:** ~820MB remnants (Python site-packages, npm globals, configs, broken symlinks)
**Preserves:** Non-Homebrew software (Go, .NET SDK, Docker, Microsoft tools)

#### Option B: Targeted Cleanup (Conservative)

```bash
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/cleanup-broken-files.sh -o cleanup-broken-files.sh
chmod +x cleanup-broken-files.sh
./cleanup-broken-files.sh --dry-run  # Preview first
./cleanup-broken-files.sh
```

**Removes:** Only broken symlinks and scripts
**Preserves:** All directories and legitimate software

### Step 3: Install ARM64 Homebrew

After cleanup, install native ARM64 Homebrew using our installation script (see **Quick Start** above).

**Complete Guide:** See **[docs/UNINSTALL-GUIDE.md](docs/UNINSTALL-GUIDE.md)** for detailed instructions, verification steps, and troubleshooting.

---

## 📚 Documentation

- **[Uninstall Guide](docs/UNINSTALL-GUIDE.md)** - Complete workflow for Intel → ARM64 migration
- **[Installation Guide](docs/INSTALLATION-GUIDE.md)** - Comprehensive guide with detailed explanations
- **[Migration Case Study](docs/MIGRATION-CASE-STUDY.md)** - Real-world migration from Intel to ARM64
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

---

## ⚠️ Security Notice

**Always review scripts before running them, especially with `curl | bash`.**

This script:
- ✅ Is open-source and auditable
- ✅ Provides `--dry-run` mode for preview
- ✅ Uses interactive prompts (not silent installation)
- ✅ Includes comprehensive logging
- ✅ Only installs from official Homebrew repositories

**Best practice:**
1. Download the script first
2. Review the code
3. Run with `--dry-run` to preview
4. Execute when comfortable

---

## 🤝 Contributing

**Maintenance Level:** Light / Best-Effort Basis

This project is maintained on a **best-effort basis** due to time constraints. Here's what to expect:

### What You Can Do

✅ **Issues** - Feel free to open issues for:
- Bug reports (please include system info)
- Feature requests
- Questions about migration
- Sharing your migration story

✅ **Pull Requests** - PRs are welcome but:
- May take 2-4 weeks (or longer) for review
- No guarantee of merge even for good PRs
- Please be patient - this is a side project

✅ **Forks** - Highly encouraged!
- Need a fix urgently? Fork it!
- Want to add features? Fork it!
- MIT license allows you to maintain your own version
- Share your fork in an issue so others can benefit

### Stale PR Policy

To keep the repository manageable:
- PRs inactive for 60 days will be labeled "stale"
- Stale PRs will be closed after 7 more days
- You can always reopen by adding a comment
- This keeps the PR list clean while respecting your work

### Ways to Contribute

- Report bugs via [GitHub Issues](https://github.com/joaquimscosta/homebrew-arm64-migration/issues)
- Suggest new packages or version managers
- Improve documentation
- Share your migration story
- **Create and maintain forks** for specific use cases

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

**Disclaimer:** This software is provided "as is", without warranty of any kind. Use at your own risk. Always back up your system before making significant changes. The authors are not responsible for any data loss or system issues.

---

## 🙏 Acknowledgments

- **Homebrew** - The missing package manager for macOS
- **Astral** - Creators of uv and Ruff (modern Python tooling)
- **SDKMAN** - The JVM version manager
- **Community** - All the developers of modern CLI tools (ripgrep, eza, fd, bat, etc.)
- **Research** - Best practices gathered from 2025 industry trends

---

## 📊 Project Status

**Status:** Active maintenance (light updates)
**Latest Version:** 1.0.0
**Last Updated:** January 2025
**Tested On:** macOS Sequoia 15.6.1, Apple M3 Max

---

## 🐛 Reporting Issues

Found a bug? Have a suggestion?

1. Check existing [GitHub Issues](https://github.com/joaquimscosta/homebrew-arm64-migration/issues)
2. Create a new issue with:
   - macOS version (`sw_vers`)
   - Chip model (`sysctl -n machdep.cpu.brand_string`)
   - Error message and logs
   - Steps to reproduce

---

## ⭐ Star This Project

If this tool helped you migrate to ARM64 Homebrew or set up your new Mac, consider giving it a star! It helps others discover the project.

---

**🔧 Crafted for seamless ARM64 migration**
