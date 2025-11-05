---
name: Bug Report
about: Report a bug or issue with the Homebrew ARM64 Migration Tool
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

**Clear and concise description of the bug:**


## Environment

**Please provide the following information:**

- **macOS Version:** (run `sw_vers` and paste output)
- **Chip Model:** (run `sysctl -n machdep.cpu.brand_string` and paste output)
- **Architecture:** (run `uname -m` and paste output)
- **Homebrew Version (if installed):** (run `brew --version` and paste output)
- **Script Version:** (e.g., v1.0.0 or commit SHA)

<details>
<summary>Click to expand system info</summary>

```bash
# Paste output of: sw_vers

# Paste output of: sysctl -n machdep.cpu.brand_string

# Paste output of: uname -m

# Paste output of: brew --version (if Homebrew is installed)
```

</details>

## Steps to Reproduce

**Please provide detailed steps to reproduce the issue:**

1.
2.
3.

## Expected Behavior

**What you expected to happen:**


## Actual Behavior

**What actually happened:**


## Error Messages and Logs

**Please paste any error messages or relevant log output:**

<details>
<summary>Click to expand error output</summary>

```
Paste error messages here
```

</details>

**Log file location (if available):**
- Path: (e.g., `homebrew-install-2025-01-04-143022.log`)

<details>
<summary>Click to expand relevant log sections</summary>

```
Paste relevant sections of the log file here
```

</details>

## Installation Method

**How did you install/run the script?**

- [ ] Two-step installation (downloaded, then ran locally)
- [ ] Curl-to-bash installation
- [ ] Other (please specify):

**Command used:**
```bash
# Paste the exact command you used
```

## Command-Line Options

**Did you use any command-line options?**

- [ ] `--dry-run`
- [ ] `--auto-yes`
- [ ] `--start-at=N` (specify N: ___)
- [ ] No options (default interactive mode)
- [ ] Other (please specify):

## Installation Phase

**At which phase did the error occur?**

- [ ] Phase 1: Homebrew Installation
- [ ] Phase 2: Essential Tools
- [ ] Phase 3: Version Managers (uv, nvm, rbenv, tfenv)
- [ ] Phase 4: Language Runtimes (PHP, OpenJDK, Perl, Go)
- [ ] Phase 5: Cloud/DevOps Tools
- [ ] Phase 6: Build Tools
- [ ] Phase 7: Modern CLI Tools
- [ ] Phase 8: Database Clients
- [ ] Phase 9: Media Processing
- [ ] Phase 10: GUI Applications (Casks)
- [ ] Phase 11: Post-Install Report
- [ ] Cleanup script (`cleanup-homebrew-remnants.sh`)
- [ ] Other/Unknown

## Previous Homebrew Installation

**Did you have Homebrew installed before running this script?**

- [ ] No previous Homebrew installation (fresh install)
- [ ] Intel Homebrew at `/usr/local` (migrating to ARM64)
- [ ] ARM64 Homebrew at `/opt/homebrew` (reinstalling/upgrading)
- [ ] Both Intel and ARM64 Homebrew (conflicting installations)
- [ ] Unknown

## Additional Context

**Any additional context that might be helpful:**
- Recent system changes or updates?
- Other package managers installed (MacPorts, Nix, etc.)?
- Custom shell configuration (.zshrc, .bash_profile)?
- VPN or proxy settings?
- External security software (antivirus, firewall)?


## Possible Solution (Optional)

**If you have ideas about what might be causing the issue or how to fix it:**


## Checklist

Before submitting, please ensure:

- [ ] I have searched existing issues to check if this has been reported
- [ ] I have provided my system information (macOS version, chip model, etc.)
- [ ] I have included error messages and/or log output
- [ ] I have described the steps to reproduce the issue
- [ ] I have tried running with `--dry-run` to isolate the issue

---

**Note:** The more information you provide, the easier it will be to diagnose and fix the issue. Thank you for helping improve this project!
