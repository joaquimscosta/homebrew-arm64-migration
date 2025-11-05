# Contributing to Homebrew ARM64 Migration Tool

First off, thank you for considering contributing to this project! 🎉

---

## ⚠️ Important: Maintenance Status

**This project is maintained on a best-effort basis** due to time constraints.

### What This Means for Contributors:

- ✅ **Issues are welcome** - Bug reports, feature requests, questions
- ⚠️ **PRs may take time** - Reviews may take 2-4 weeks or longer
- 💡 **Forks encouraged** - If you need changes urgently, fork and maintain your own version
- 🏷️ **Stale policy** - Inactive PRs (60 days) will be labeled stale and closed after 7 more days

### Before Contributing a PR:

Ask yourself:
1. **Is this urgent?** → Consider maintaining a fork instead
2. **Can this wait weeks?** → PR is fine, but be patient
3. **Is this a small fix?** → PRs more likely to be merged quickly
4. **Is this a major change?** → Open an issue first to discuss

**Alternative:** Fork this project, make your changes, and share your fork link in an issue. The community can benefit from your work immediately while respecting the maintainer's time.

---

This document provides guidelines for contributing. Following these helps maintain code quality and makes reviews smoother (when they happen!).

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
3. [Development Setup](#development-setup)
4. [Coding Standards](#coding-standards)
5. [Testing](#testing)
6. [Submitting Changes](#submitting-changes)
7. [Reporting Bugs](#reporting-bugs)
8. [Suggesting Enhancements](#suggesting-enhancements)

---

## Code of Conduct

This project follows a simple code of conduct:

- **Be respectful** and considerate in your communication
- **Be collaborative** and welcoming to newcomers
- **Focus on what is best** for the community and the project
- **Show empathy** towards other community members

Unacceptable behavior will not be tolerated.

---

## How Can I Contribute?

### Types of Contributions

We welcome contributions in many forms:

1. **Bug Reports** - Found an issue? Let us know!
2. **Feature Requests** - Have an idea? Share it!
3. **Documentation** - Improve guides, fix typos, add examples
4. **Code** - Fix bugs, add features, improve performance
5. **Testing** - Test on different macOS versions and chip models
6. **Package Suggestions** - Recommend new packages or version managers

---

## Development Setup

### Prerequisites

- Apple Silicon Mac (M1, M2, M3, or M4)
- macOS Sequoia 15.6+ (may work on older versions)
- Command Line Tools: `xcode-select --install`
- ShellCheck for linting: `brew install shellcheck`

### Getting Started

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/homebrew-arm64-migration.git
cd homebrew-arm64-migration

# 3. Create a feature branch
git checkout -b feature/your-feature-name
```

---

## Coding Standards

### Shell Script Style

#### General Guidelines

- **Use Bash** (not sh, zsh-specific features, etc.)
- **Strict Mode**: All scripts should start with `set -euo pipefail`
- **Comments**: Explain WHY, not WHAT (code should be self-documenting for WHAT)
- **Functions**: Use functions for reusability and clarity
- **Variables**: Use `${variable}` syntax, not `$variable`
- **Constants**: UPPERCASE_WITH_UNDERSCORES
- **Functions**: lowercase_with_underscores

#### Example

```bash
#!/usr/bin/env bash

# Exit on error, undefined variable, pipe failure
set -euo pipefail

# Constants
readonly HOMEBREW_ARM64_PATH="/opt/homebrew"
readonly SCRIPT_VERSION="1.0.0"

# Function to check architecture
check_architecture() {
    local arch
    arch="$(uname -m)"

    if [[ "${arch}" != "arm64" ]]; then
        echo "Error: This script requires Apple Silicon (ARM64)" >&2
        return 1
    fi
}

# Main execution
main() {
    check_architecture
    # ... rest of script
}

main "$@"
```

### Naming Conventions

**Files:**
- Shell scripts: `kebab-case.sh`
- Markdown docs: `SCREAMING-KEBAB-CASE.md`
- JSON files: `kebab-case.json`

**Functions:**
- Use descriptive names: `install_homebrew()`, not `ih()`
- Start with verb: `check_`, `install_`, `verify_`, `print_`

**Variables:**
- Local variables: `lowercase_with_underscores`
- Global constants: `UPPERCASE_WITH_UNDERSCORES`
- Avoid single-letter names except for loop counters

### Code Organization

```bash
#!/usr/bin/env bash
set -euo pipefail

# ================================
# Constants
# ================================

readonly SCRIPT_VERSION="1.0.0"

# ================================
# Helper Functions
# ================================

print_error() {
    echo "ERROR: $*" >&2
}

# ================================
# Core Functions
# ================================

install_package() {
    # Implementation
}

# ================================
# Main Function
# ================================

main() {
    # Script logic
}

# ================================
# Execution
# ================================

main "$@"
```

---

## Testing

### Manual Testing Checklist

Before submitting a pull request, test the following:

- [ ] **Fresh Installation** - Test on a Mac without Homebrew
- [ ] **Migration** - Test migrating from Intel to ARM64
- [ ] **Dry-run Mode** - Verify `--dry-run` doesn't make changes
- [ ] **Error Handling** - Test with invalid inputs
- [ ] **Interrupted Installation** - Test Ctrl-C behavior
- [ ] **Architecture Check** - Verify ARM64 enforcement works
- [ ] **Different macOS Versions** - Test on multiple macOS versions if possible

### ShellCheck

All shell scripts MUST pass ShellCheck validation:

```bash
# Install shellcheck
brew install shellcheck

# Lint the main installation script
shellcheck --severity=warning --shell=bash install-homebrew-arm64.sh

# Lint the cleanup script
shellcheck --severity=warning --shell=bash cleanup-homebrew-remnants.sh
```

**Fix all warnings before submitting.** If you must ignore a warning, add a comment explaining why:

```bash
# shellcheck disable=SC2034  # Variable used in sourced file
SOME_VARIABLE="value"
```

---

## Submitting Changes

### Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow coding standards
   - Add comments where necessary
   - Update documentation if needed

3. **Test thoroughly**
   - Run ShellCheck
   - Test on your system
   - Test dry-run mode

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your feature branch
   - Fill out the PR template

### Pull Request Guidelines

**Title:**
- Use imperative mood: "Add feature" not "Added feature"
- Be concise but descriptive
- Examples:
  - ✅ "Add support for asdf version manager"
  - ✅ "Fix architecture detection on M4 chips"
  - ❌ "Update script"
  - ❌ "Fixed a bug"

**Description:**
- Explain WHAT changed
- Explain WHY it changed
- Link related issues: "Fixes #123"
- Include testing notes

**Example PR Description:**

```markdown
## Summary
Add support for `mise` (formerly rtx) as an alternative version manager.

## Changes
- Added `mise` to version manager recommendations in Phase 3
- Updated package-categories.json with mise configuration
- Added post-install instructions for mise
- Updated INSTALLATION-GUIDE.md with mise examples

## Why
mise is gaining popularity as a unified version manager (similar to asdf)
and is faster due to Rust implementation. Users should have the option.

## Testing
- [x] Tested fresh install with mise selected
- [x] Verified dry-run mode works
- [x] Confirmed post-install instructions are correct
- [x] Passed ShellCheck

Fixes #45
```

---

## Reporting Bugs

### Before Submitting a Bug Report

1. **Check existing issues** - Your bug might already be reported
2. **Test with latest version** - Ensure you're using the most recent release
3. **Test in dry-run mode** - Isolate the issue
4. **Gather system information** - Run diagnostics

### Bug Report Template

Use the [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md) and include:

- macOS version (`sw_vers`)
- Chip model (`sysctl -n machdep.cpu.brand_string`)
- Architecture (`uname -m`)
- Homebrew version (if installed)
- Error messages and logs
- Steps to reproduce
- Expected vs actual behavior

---

## Suggesting Enhancements

### Feature Request Guidelines

**Before Submitting:**
1. Check if the feature already exists
2. Search existing feature requests
3. Consider if it fits the project scope

**Feature Request Should Include:**
- **Problem**: What problem does this solve?
- **Proposed Solution**: How should it work?
- **Alternatives**: What other solutions did you consider?
- **Use Case**: When would users need this?
- **Examples**: Show how it would be used

### Enhancement Examples

**Good Enhancement Request:**

> **Problem**: Users with slow internet connections struggle with large FFmpeg downloads in Phase 9.
>
> **Proposed Solution**: Add a `--skip-large-packages` flag that automatically skips packages over 100MB.
>
> **Use Case**: Users on metered connections or slow internet who want essential tools but not multimedia processing.
>
> **Alternative**: Could also add size estimates in prompts so users can decide per-package.

**Poor Enhancement Request:**

> "Add more packages"
>
> (Not specific, no use case, no problem statement)

---

## Package Suggestions

### Criteria for New Packages

Packages should meet one or more criteria:

1. **Wide Applicability** - Used by many developers (not niche)
2. **Modern Best Practice** - Current industry standard (2025)
3. **ARM64 Compatible** - Works natively on Apple Silicon
4. **Actively Maintained** - Not abandoned or deprecated
5. **Clear Category** - Fits existing installation phases

### How to Suggest a Package

Open an issue with:

```markdown
**Package Name**: example-tool

**Category**: Modern CLI Tools (Phase 7)

**Why Include**:
- Replaces traditional `oldtool` with 10x performance
- 20k+ GitHub stars, actively maintained
- ARM64 native support
- Industry adoption: used by Google, Netflix, etc.

**Installation**:
brew install example-tool

**Post-Install**:
Add to ~/.zshrc: eval "$(example-tool init)"

**Documentation**:
https://example-tool.dev
```

---

## Questions?

If you have questions about contributing:

1. Check the [INSTALLATION-GUIDE.md](docs/INSTALLATION-GUIDE.md)
2. Search [existing issues](https://github.com/joaquimscosta/homebrew-arm64-migration/issues)
3. Open a [new issue](https://github.com/joaquimscosta/homebrew-arm64-migration/issues/new) with the "question" label

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing! 🚀**
