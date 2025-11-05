# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
