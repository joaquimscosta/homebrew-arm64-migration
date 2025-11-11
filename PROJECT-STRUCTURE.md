# Project Structure

**Homebrew ARM64 Migration Tool - Repository Layout**

This document describes the organization of the repository and the purpose of each file.

---

## Directory Tree

```
homebrew-arm64-migration/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   └── bug_report.md              # Bug report template
│   └── workflows/
│       └── shellcheck.yml             # CI/CD: ShellCheck validation
│
├── docs/
│   ├── INSTALLATION-GUIDE.md          # Comprehensive installation guide (1000+ lines)
│   ├── MIGRATION-CASE-STUDY.md        # Real-world migration case study
│   ├── TROUBLESHOOTING.md             # Common issues and solutions
│   └── UNINSTALL-GUIDE.md             # Complete uninstall workflow (Intel → ARM64)
│
├── examples/
│   └── custom-packages.json           # Example custom package configuration
│
├── archive/                            # Personal analysis docs (git ignored)
│   ├── architecture-analysis.md
│   ├── homebrew-migration-audit.md
│   ├── GHOSTTY-ZSH-ISSUE-ANALYSIS.md
│   └── ... (other analysis documents)
│
├── .gitignore                          # Git ignore rules
├── CHANGELOG.md                        # Version history and release notes
├── CONTRIBUTING.md                     # Contribution guidelines
├── LICENSE                             # MIT License with disclaimer
├── README.md                           # Main project documentation
│
├── install-homebrew-arm64.sh           # Main installation script (850 lines)
├── cleanup-homebrew-remnants.sh       # Cleanup script for Intel remnants
├── package-categories.json             # Package manifest (510 lines)
│
└── PROJECT-STRUCTURE.md                # This file
```

---

## Core Files

### Scripts

#### `install-homebrew-arm64.sh` (850 lines)
**Purpose:** Main installation script with 12 sequential phases

**Features:**
- Strict ARM64 architecture verification
- Interactive category-based installation
- Version manager recommendations (uv, fnm, SDKMAN, rbenv, tfenv)
- Auto-upgrade deprecated packages
- Dry-run mode for preview
- Comprehensive logging
- Post-install health check

**Usage:**
```bash
./install-homebrew-arm64.sh              # Interactive mode
./install-homebrew-arm64.sh --dry-run    # Preview without installing
./install-homebrew-arm64.sh --auto-yes   # Auto-approve all prompts
./install-homebrew-arm64.sh --start-at=5 # Start at specific phase
```

**Phases:**
1. Homebrew Installation
2. Essential Tools (19 packages)
3. Version Managers (uv, fnm, rbenv, tfenv)
4. Language Runtimes (PHP, OpenJDK, Perl, Go)
5. Cloud/DevOps Tools (AWS, Azure, GCP CLIs)
6. Build Tools (cmake, autoconf, make)
7. Modern CLI Tools (ripgrep, eza, fd, bat, delta)
8. Database Clients (MySQL, PostgreSQL)
9. Media Processing (ImageMagick, FFmpeg)
10. AI Developer Tools (Claude Code, Codex, Gemini CLI)
11. GUI Applications (Casks)
12. Post-Install Report

#### `cleanup-homebrew-remnants.sh` (135 lines)
**Purpose:** Remove Intel Homebrew remnants after migration

**Features:**
- Interactive prompts before each deletion
- Preserves non-Homebrew software (Go, .NET SDK, Docker)
- Removes ~820MB of orphaned files
- Safety checks and confirmations

**Usage:**
```bash
./cleanup-homebrew-remnants.sh
```

**What it removes:**
- Main Homebrew directory (`/usr/local/Homebrew`)
- Python site-packages
- Orphaned npm global packages
- Configuration files
- Broken symlinks

**What it preserves:**
- Go installation
- .NET SDK
- Microsoft tools
- Docker binaries
- OSXFUSE libraries

---

### Configuration

#### `package-categories.json` (510 lines)
**Purpose:** Structured manifest of 146 analyzed packages

**Contents:**
- Package categorization (essential, version_managers, languages, cloud_devops, etc.)
- Version manager recommendations with rationale
- Deprecated package mappings
- Modern tool alternatives
- Installation order and priorities

**Categories:**
- `essential` - 19 must-have tools (auto-installed)
- `version_managers` - uv, pyenv, fnm, nvm, rbenv, tfenv
- `languages` - PHP, OpenJDK, Perl, Go
- `cloud_devops` - AWS CLI, Azure CLI, GCP CLI, Helm, K9s, Ansible
- `build_tools` - cmake, autoconf, make
- `cli_productivity` - ripgrep, eza, fd, bat, delta, fzf, zoxide, procs
- `database_clients` - MySQL, PostgreSQL, SQLite
- `media_processing` - ImageMagick, FFmpeg
- `casks` - GUI applications
- `deprecated` - Packages to skip/replace

**Example Entry:**
```json
"uv": {
  "package": "uv",
  "language": "Python",
  "priority": "highest_2025",
  "reason": "Modern unified Python toolkit...",
  "benefits": ["Unified workflow", "10-100x faster than pip", ...],
  "user_preference": "PREFERRED"
}
```

---

## Documentation

### `README.md`
**Purpose:** Main project documentation and entry point

**Sections:**
- Quick start (2-step safe install + curl-to-bash)
- Features and highlights
- Prerequisites
- Installation phases overview
- Version manager recommendations (uv, fnm, SDKMAN)
- Usage examples
- Security warnings
- Contributing guidelines
- License and disclaimer

**Target Audience:** Developers and Apple Silicon Mac users needing migration

### `docs/INSTALLATION-GUIDE.md` (1000+ lines)
**Purpose:** Comprehensive guide with phase-by-phase explanations

**Sections:**
- Detailed phase breakdowns
- Version manager comparisons (uv vs pyenv, fnm vs nvm)
- Package category descriptions
- Post-installation steps
- Shell configuration
- Language version installation
- Maintenance instructions
- Verification commands

**Target Audience:** Users wanting deep understanding of the installation process

### `docs/MIGRATION-CASE-STUDY.md`
**Purpose:** Real-world migration story from Intel to ARM64 Homebrew

**Sections:**
- Problem discovery (146 packages running under Rosetta 2)
- Root cause analysis (Intel Homebrew on Apple Silicon)
- Migration strategy (4 options evaluated)
- Execution (phased migration)
- Post-migration issues (Ghostty terminal shell configuration)
- Lessons learned
- Recommendations for others

**Target Audience:** Users facing similar Intel-to-ARM64 migration challenges

### `docs/TROUBLESHOOTING.md`
**Purpose:** Common issues and solutions

**Categories:**
- Installation issues
- Architecture problems
- Version manager issues
- Terminal/shell issues
- Package installation failures
- Post-migration issues
- Getting help

**Common Issues Covered:**
- Permission denied
- Architecture verification
- Mixed Intel/ARM64 in PATH
- Terminal fails to launch (shell configuration)
- `command not found` after migration
- Version manager setup

### `docs/UNINSTALL-GUIDE.md`
**Purpose:** Complete workflow for uninstalling Intel Homebrew and migrating to ARM64

**Sections:**
- Overview of when to use the guide
- Three-step process (Official Uninstaller → Cleanup → Install ARM64)
- Official Homebrew uninstaller commands and options
- What the official uninstaller removes vs. leaves behind (~820MB remnants)
- Cleanup script options (comprehensive vs. targeted)
- Post-uninstall verification steps
- Package restoration from Brewfile backup
- Troubleshooting uninstall issues
- Complete workflow checklist
- Real-world migration example

**Target Audience:** Users migrating from Intel Homebrew or performing clean reinstall

**Key Message:** Official uninstaller must run FIRST, then cleanup scripts handle remnants

---

## GitHub Integration

### `.github/workflows/shellcheck.yml`
**Purpose:** Automated shell script validation via GitHub Actions

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Changes to `*.sh` files

**Actions:**
- Runs ShellCheck on all shell scripts
- Checks `install-homebrew-arm64.sh`
- Checks `cleanup-homebrew-remnants.sh`
- Severity: warning level
- Ignores `archive/` directory

### `.github/ISSUE_TEMPLATE/bug_report.md`
**Purpose:** Standardized bug report template

**Sections:**
- Bug description
- Environment (macOS version, chip model, architecture)
- Steps to reproduce
- Expected vs actual behavior
- Error messages and logs
- Installation method
- Command-line options used
- Installation phase where error occurred
- Previous Homebrew installation details

---

## Examples

### `examples/custom-packages.json`
**Purpose:** Demonstrate custom package configurations

**Contents:**
- Custom category definitions
  - `web_development` - nginx, caddy, httpie
  - `data_science` - JupyterLab, pandas, numpy
  - `security_tools` - nmap, wireshark, hashcat
  - `productivity` - Notion, Obsidian, Raycast
  - `rust_toolchain` - rust, rustup-init
  - `container_tools` - Docker, kubectl, k9s

- Override defaults
  - Switch from uv to pyenv
  - Switch from fnm to Volta
  - Skip categories

- Custom casks (GUI applications)
  - Browsers, development tools, communication apps, utilities

- Usage examples
  - `minimal_install` - Basic development only
  - `full_stack_web` - Web development setup
  - `devops_engineer` - Infrastructure focus
  - `data_engineer` - Data science and analytics

**Future Use:**
- Template for teams to standardize setups
- Reference for script enhancement (custom config file support)

---

## Project Management

### `CHANGELOG.md`
**Purpose:** Version history following Keep a Changelog format

**Sections:**
- [Unreleased] - Planned features
- [1.0.0] - Initial release (January 2025)
  - Features added
  - Documentation created
  - Technical details
  - Tested on (macOS, hardware)
  - Security measures

**Format:** Semantic Versioning (MAJOR.MINOR.PATCH)

### `CONTRIBUTING.md`
**Purpose:** Contribution guidelines for community

**Sections:**
- Code of conduct
- Types of contributions (bugs, features, docs, testing)
- Development setup
- Coding standards (Bash style guide)
- Testing checklist
- Pull request process
- Bug report guidelines
- Feature request guidelines
- Package suggestion criteria

---

## Legal

### `LICENSE`
**Purpose:** MIT License with comprehensive disclaimer

**Contents:**
- MIT License text (permissive open-source)
- Copyright: 2025 Joaquim Costa
- Disclaimer section:
  - Backup warnings
  - Review before running warnings
  - Use at own risk notice
  - No warranty statement
  - System requirements

---

## Hidden Files

### `.gitignore`
**Purpose:** Specify files to exclude from version control

**Categories:**
- Personal/local files (`archive/`, `*.local.md`)
- Logs and temporary files (`*.log`, `.DS_Store`)
- Backup files (`*.bak`, `*.backup`)
- Editor/IDE files (`.vscode/`, `.idea/`)
- macOS artifacts (`.DS_Store`, `._*`)
- Testing outputs (`test_results/`)
- User-specific configurations (`*.local.json`)
- Security files (`.env`, `secrets.yml`, `*.key`)

**Key Exclusions:**
- `archive/` - Personal analysis documents (moved from root)
- `*.log` - Installation logs (user-specific)
- `.claude/settings.local.json` - User-specific Claude Code settings

---

## Archive (Git Ignored)

### `archive/` Directory
**Purpose:** Store personal analysis documents used during development

**Contents:**
- `architecture-analysis.md` - Initial x86_64 vs ARM64 analysis
- `homebrew-migration-audit.md` - Package audit (146 packages)
- `post-uninstall-assessment.md` - Post-uninstall system state
- `GHOSTTY-ZSH-ISSUE-ANALYSIS.md` - Terminal shell issue deep-dive
- `DOUBLE-CHECK-VERIFICATION.md` - Documentation verification
- `DOCUMENTATION-GAP-ANALYSIS.md` - Identified doc discrepancies
- `UPDATES-FOR-UV-AND-SDKMAN.md` - User preference updates
- `INSTALLATION-SUMMARY.md` - Quick reference (draft)
- `CLAUDE.md` - Claude Code project instructions

**Why Archived:**
- Personal analysis documents
- Contains user-specific references
- Serves as development history
- Not needed by end users
- Combined into `MIGRATION-CASE-STUDY.md` for public consumption

**Git Status:** Excluded via `.gitignore`

---

## File Sizes (Approximate)

| File | Lines | Purpose |
|------|-------|---------|
| `install-homebrew-arm64.sh` | 850 | Main installation script |
| `docs/UNINSTALL-GUIDE.md` | 700+ | Complete uninstall workflow |
| `docs/INSTALLATION-GUIDE.md` | 1000+ | Comprehensive guide |
| `docs/MIGRATION-CASE-STUDY.md` | 600+ | Real-world case study |
| `docs/TROUBLESHOOTING.md` | 500+ | Issue resolution |
| `package-categories.json` | 510 | Package manifest |
| `CONTRIBUTING.md` | 400+ | Contribution guide |
| `README.md` | 300+ | Main documentation |
| `examples/custom-packages.json` | 250+ | Custom config example |
| `cleanup-homebrew-remnants.sh` | 170 | Cleanup script (with pre-check) |
| `cleanup-broken-files.sh` | 300+ | Targeted cleanup (with pre-check) |
| `CHANGELOG.md` | 150+ | Version history |
| `.github/workflows/shellcheck.yml` | 40 | CI/CD workflow |
| `.github/ISSUE_TEMPLATE/bug_report.md` | 100+ | Bug report template |
| `.gitignore` | 100+ | Git exclusions |
| `LICENSE` | 50+ | MIT License + disclaimer |

**Total:** ~6,000+ lines of code and documentation

---

## Maintenance

### Files Requiring Updates on New Releases

1. **Version Numbers:**
   - `install-homebrew-arm64.sh` (header comment)
   - `cleanup-homebrew-remnants.sh` (header comment)
   - `package-categories.json` (metadata.version)
   - `CHANGELOG.md` (new version section)
   - `README.md` (version badges if added)

2. **Documentation:**
   - `CHANGELOG.md` (changes, features, fixes)
   - `README.md` (if features change significantly)
   - `docs/INSTALLATION-GUIDE.md` (if phases change)
   - `docs/TROUBLESHOOTING.md` (new issues discovered)

3. **Package Updates:**
   - `package-categories.json` (new packages, deprecated packages)
   - `install-homebrew-arm64.sh` (if new categories added)

---

## Best Practices

### When Adding New Files

1. **Scripts:** Place in root, add to shellcheck workflow
2. **Documentation:** Place in `docs/`, update README links
3. **Examples:** Place in `examples/`, document in README
4. **Templates:** Place in `.github/ISSUE_TEMPLATE/`
5. **Workflows:** Place in `.github/workflows/`

### When Modifying Scripts

1. Run shellcheck locally: `shellcheck script.sh`
2. Test with `--dry-run` first
3. Update version number in header
4. Document changes in CHANGELOG.md
5. Update relevant documentation

### When Updating Documentation

1. Maintain consistent formatting
2. Update table of contents if structure changes
3. Keep code examples tested and accurate
4. Update "Last Updated" timestamps
5. Cross-reference related documents

---

## Repository Statistics

- **Total Files (Public):** ~21 files
- **Total Lines:** ~6,000+ lines (code + docs)
- **Languages:** Bash, JSON, Markdown, YAML
- **Documentation Coverage:** Extensive (README, installation guide, uninstall guide, migration case study, troubleshooting)
- **Automation:** GitHub Actions (ShellCheck)
- **Testing:** Manual testing checklist, dry-run mode
- **License:** MIT (permissive open-source)

---

**Repository:** https://github.com/joaquimscosta/homebrew-arm64-migration
**Last Updated:** January 2025
**Version:** 1.0.0
