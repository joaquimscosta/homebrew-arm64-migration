# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **AI Developer Tools Phase**: New optional category for Claude Code, Codex, and Gemini CLI
  - Interactive prompts default to "No" for each tool to avoid accidental installs
  - Integrates as Phase 10 between Media Processing and GUI Applications
  - Shared rationale block explains when to enable these assistants
- **Tools Catalog** (`TOOLS_CATALOG.md`): Comprehensive documentation of all 72 tools
  - Detailed descriptions for each tool (Essential, Version Managers, Languages, Cloud/DevOps, Build Tools, Modern CLI, Database, Media, GUI)
  - Official website and GitHub repository links for every tool
  - Quick reference table with tool categories and auto-install status
  - "Why use this?" callouts for key tools
  - Phase information showing when each tool is installed
- **Shell Alias Report**: Automatic generation of recommended shell aliases
  - Context-aware alias recommendations based on installed tools
  - Comprehensive coverage of modern CLI replacements (bat, eza, ripgrep, fd, zoxide)
  - Kubernetes shortcuts (kubectl, kubectx/kubens)
  - Git enhancements (delta configuration)
  - Version manager initialization commands
  - Safety warnings for aliases that override default commands
  - Copy-paste ready format for `.zshrc`/`.bashrc`
- **Tealdeer**: Fast Rust-based tldr client as essential tool
  - 10-100x faster than Python/Node.js tldr clients
  - Provides quick command-line examples as alternative to verbose man pages
  - Auto-installed in Phase 2 (Essential Tools)
  - Replaces deprecated tldr package
- **.aliases File**: Automatic generation of shell aliases file
  - Creates `.aliases` file with all recommended aliases
  - Organized by category (CLI tools, Kubernetes, Git, etc.)
  - Ready to source in ~/.zshrc or ~/.bashrc
  - Includes usage instructions and safety warnings
  - Displayed in post-install Next Steps section

### Changed
- **Cask Installs**: Added `safe_brew_cask_install` helper so Google Cloud SDK, GUI apps, and new AI tools share consistent logging and dry-run output
- **GUI Applications**: Changed to opt-in by default (prompts now show `[y/N]` instead of `[Y/n]`)
- **Terminal Emulator**: Replaced iTerm2 with Ghostty (modern GPU-accelerated terminal)
- **Alias Report Positioning**: Moved recommended shell aliases to appear before health check in post-install report
- **Tool Count**: 71 → 72 total tools, 18 → 19 essential tools (added tealdeer, removed deprecated tldr)

### Fixed
- **Critical Package Issues**:
  - Removed non-existent `kubens` package installation (bundled with kubectx)
  - Fixed `google-cloud-sdk` installation method (now correctly installs as cask)
  - Updated script to reflect that kubectx includes kubens binary
- **Documentation Accuracy**:
  - Corrected category assignments in TOOLS_CATALOG.md
  - Moved ansible and ansible-lint to correct Cloud & DevOps section
  - Updated all tool counts across documentation files
- **Shellcheck Compliance**: Resolved all shellcheck errors and warnings
  - Fixed SC2199: Array expansion syntax in conditionals
  - Removed unused variables (MANIFEST_FILE, description parameter)
  - Cleaned up incomplete START_AT_PHASE feature
- **Shell Initialization Compatibility**: Fixed issues with non-interactive shells
  - Added interactive shell checks to zoxide, fzf, and kubectl completion initialization
  - Prevents initialization errors in automation tools and CI/CD environments
  - Uses `[[ -o interactive ]]` guard to only initialize in interactive shells
  - Fixed kubectl aliases generation (detect `kubernetes-cli` package name)

### Improved
- **Installation Script** (`install-homebrew-arm64.sh`):
  - Enhanced broken file detection and handling
  - Improved output formatting throughout all phases
  - Better error messages and user guidance
  - Added comments explaining kubectx/kubens relationship
- **Post-Install Experience**:
  - Comprehensive alias report displayed after installation
  - Organized by category (CLI replacements, Kubernetes, Git, etc.)
  - Clear instructions for applying aliases
  - Version manager setup guidance included in report

### Documentation
- **Uninstall Guide** (`UNINSTALL.md`): Complete three-step uninstall workflow
  - Official Homebrew uninstaller instructions
  - Cleanup scripts usage and safety checks
  - ARM64 installation preparation steps
  - Real-world migration examples (~820MB remnants)
  - Troubleshooting section for common uninstall issues
- **Enhanced Safety**:
  - Pre-checks in cleanup scripts verify official uninstaller ran first
  - Warnings prevent premature cleanup leaving systems inconsistent
  - Clear guidance in README and INSTALLATION-GUIDE about required workflow

### Planned
- Community feedback integration
- Additional version manager support (asdf, mise)
- macOS version compatibility testing (Ventura, Sonoma)
- CI/CD integration examples

---

## [1.0.0] - 2025-11-05

### Added
- Initial release of Homebrew ARM64 Migration Tool
- Interactive installation script with 11 sequential phases
- Strict ARM64 architecture verification
- Version manager recommendations with explanations:
  - **uv** for Python (unified toolkit, 10-100x faster than pip)
  - **fnm** for Node.js (40x faster than nvm)
  - **SDKMAN** for Java/JVM (industry standard)
  - **rbenv** for Ruby (lightweight, transparent)
  - **tfenv** for Terraform/OpenTofu
- Essential tools auto-installation (19 packages)
- Modern CLI tools support (ripgrep, eza, fd, bat, delta, fzf, zoxide, procs)
- Multi-cloud CLI support (AWS, Azure, Google Cloud)
- Interactive prompts with educational explanations
- Package categories manifest (146 packages analyzed)
- Dry-run mode for safe preview
- Comprehensive logging system
- Post-install health check and verification
- Cleanup script for Intel Homebrew remnants
- Comprehensive documentation:
  - Installation guide with detailed phase explanations
  - Migration case study from real-world Intel to ARM64 migration
  - Troubleshooting guide
  - Contributing guidelines
- GitHub Actions workflow for shellcheck validation
- Bug report issue template
- MIT License with comprehensive disclaimer
- Security warnings for curl-to-bash installation

### Features
- **Smart Package Management**
  - Auto-upgrade deprecated packages (python@2, terraform)
  - Dependency auto-installation detection
  - Version manager prioritization over direct Homebrew installations
- **Safety Features**
  - Interactive confirmations before destructive operations
  - Preservation of non-Homebrew software (Go, .NET SDK, Docker)
  - Rollback guidance in documentation
  - Comprehensive verification steps
- **Educational Approach**
  - Explains WHY modern tools are recommended (not just WHAT)
  - Speed comparisons (uv vs pip, fnm vs nvm)
  - Industry trends and best practices for 2025
  - Real-world use cases and examples

### Documentation
- README.md with quick start, features, and usage examples
- INSTALLATION-GUIDE.md with phase-by-phase explanations (1000+ lines)
- MIGRATION-CASE-STUDY.md combining real-world migration analysis
- TROUBLESHOOTING.md for common issues
- CONTRIBUTING.md with contribution guidelines
- package-categories.json manifest with rationale for each category

### Technical Details
- Bash script with strict error handling (`set -euo pipefail`)
- Modular architecture with dedicated functions for each phase
- ARM64 binary verification using `file` command
- Homebrew path detection and validation
- Color-coded output for better readability
- Progress tracking through installation phases
- Logging to timestamped log files

### Tested On
- macOS Sequoia 15.6.1
- Apple M3 Max (14-core CPU, 36GB RAM)
- Homebrew 4.6.20

### Security
- Two-step installation method recommended (download + review)
- SHA256 checksum guidance (to be added in releases)
- Security notice in README
- Disclaimer in LICENSE
- Interactive prompts prevent silent installations

---

## Version History

### Version Numbering
This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR** version (1.x.x): Incompatible API/behavior changes
- **MINOR** version (x.1.x): New features, backward-compatible
- **PATCH** version (x.x.1): Bug fixes, backward-compatible

### Release Notes
- **1.0.0** (January 2025): Initial public release

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Reporting bugs
- Suggesting features
- Submitting pull requests
- Code style and testing

---

## Links

- [GitHub Repository](https://github.com/joaquimscosta/homebrew-arm64-migration)
- [Issue Tracker](https://github.com/joaquimscosta/homebrew-arm64-migration/issues)
- [Documentation](docs/)

---

[Unreleased]: https://github.com/joaquimscosta/homebrew-arm64-migration/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/joaquimscosta/homebrew-arm64-migration/releases/tag/v1.0.0
