# Troubleshooting Guide

Common issues and solutions when using the Homebrew ARM64 Migration Tool.

---

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Architecture Problems](#architecture-problems)
3. [Version Manager Issues](#version-manager-issues)
4. [Terminal/Shell Issues](#terminalshell-issues)
5. [Package Installation Failures](#package-installation-failures)
6. [Post-Migration Issues](#post-migration-issues)
7. [Getting Help](#getting-help)

---

## Installation Issues

### Script Won't Run: "Permission Denied"

**Problem:**
```bash
$ ./install-homebrew-arm64.sh
-bash: ./install-homebrew-arm64.sh: Permission denied
```

**Solution:**
```bash
chmod +x install-homebrew-arm64.sh
./install-homebrew-arm64.sh
```

---

### Script Fails: "Not ARM64 Architecture"

**Problem:**
```
ERROR: This script requires Apple Silicon (ARM64)
Current architecture: x86_64
```

**Cause:** You're running on an Intel Mac or under Rosetta 2.

**Solution:**

**If you have Apple Silicon Mac:**
```bash
# Check your architecture
uname -m

# If it shows x86_64, your terminal is running under Rosetta 2
# Open Terminal app preferences:
# 1. Right-click Terminal.app in Applications
# 2. Get Info
# 3. UNCHECK "Open using Rosetta"
# 4. Quit and reopen Terminal
```

**If you have Intel Mac:**
- This script is designed for Apple Silicon only
- Intel Macs should use standard Homebrew installation at `/usr/local`

---

### Homebrew Installation Fails: "Command Line Tools Not Installed"

**Problem:**
```
Error: Xcode Command Line Tools not found
```

**Solution:**
```bash
# Install Command Line Tools
xcode-select --install

# Wait for installation to complete, then retry
./install-homebrew-arm64.sh
```

---

## Architecture Problems

### Checking Binary Architecture

**Problem:** How do I know if my tools are ARM64 or Intel?

**Solution:**
```bash
# Check a specific binary
file $(which brew)
# ARM64: "Mach-O 64-bit executable arm64"
# Intel:  "Mach-O 64-bit executable x86_64"

# Check multiple tools
for tool in brew git python3 node ruby; do
    echo "$tool: $(file $(which $tool) 2>/dev/null || echo 'not found')"
done
```

---

### Mixed Architecture in PATH

**Problem:**
```bash
$ which brew
/usr/local/bin/brew  # Intel

$ file $(which brew)
Mach-O 64-bit executable x86_64
```

**Cause:** You have both Intel and ARM64 Homebrew, and Intel is first in PATH.

**Solution:**
```bash
# Check your PATH
echo $PATH

# ARM64 Homebrew should come BEFORE /usr/local
# Edit ~/.zshrc and ensure this is at the TOP:
eval "$(/opt/homebrew/bin/brew shellenv)"

# Reload shell
source ~/.zshrc

# Verify
which brew
# Should show: /opt/homebrew/bin/brew
```

**Nuclear Option (if still broken):**
```bash
# Remove Intel Homebrew completely
sudo rm -rf /usr/local/Homebrew
sudo rm -rf /usr/local/Cellar
sudo rm -rf /usr/local/Caskroom

# Clean PATH references
# Edit ~/.zshrc and remove any /usr/local/bin references before /opt/homebrew
```

---

## Version Manager Issues

### uv: Command Not Found

**Problem:**
```bash
$ uv python install 3.12
-bash: uv: command not found
```

**Solution:**
```bash
# Check if uv is installed
brew list uv

# If not installed
brew install uv

# Ensure /opt/homebrew/bin is in PATH
echo $PATH | grep /opt/homebrew/bin

# If missing, add to ~/.zshrc:
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.zshrc
```

---

### fnm: Command Not Found After Installation

**Problem:**
```bash
$ fnm --version
-bash: fnm: command not found
```

**Solution:**
```bash
# fnm requires shell initialization
# Add to ~/.zshrc:
eval "$(fnm env --use-on-cd)"

# Reload shell
source ~/.zshrc

# Verify
fnm --version
```

---

### SDKMAN Installation Fails

**Problem:**
```bash
$ curl -s "https://get.sdkman.io" | bash
# Hangs or fails
```

**Solution:**
```bash
# Try with verbose output
curl -v "https://get.sdkman.io" | bash

# If network issue, try different DNS
# If still failing, manual installation:
# 1. Download from https://get.sdkman.io
# 2. Review the script
# 3. Run: bash ./get.sdkman.io
```

---

### Python Version Conflicts (uv vs System Python)

**Problem:**
```bash
$ which python3
/usr/bin/python3  # System Python, not uv

$ python3 --version
Python 3.9.6  # Old version
```

**Solution:**
```bash
# Install Python with uv
uv python install 3.12

# Pin for current directory
cd ~/projects/myapp
uv python pin 3.12

# Create virtual environment
uv venv

# Activate
source .venv/bin/activate

# Now python3 will use uv-managed version
python3 --version  # Python 3.12.x
```

**For Global uv Python:**
```bash
# uv doesn't set global Python by default (by design)
# Use system Python or create aliases
alias python3="uv run python"
```

---

## Terminal/Shell Issues

### Terminal Fails to Launch After Migration

**Problem:**
```
bash: /usr/local/bin/zsh: No such file or directory
Cannot execute: No such file or directory
```

**Cause:** Your default shell is set to Homebrew zsh that no longer exists.

**Solution:**
```bash
# Check your default shell
dscl . -read /Users/$USER UserShell

# If it shows /usr/local/bin/zsh or other missing path:
# Change to system zsh
chsh -s /bin/zsh

# Enter your password when prompted

# Verify
dscl . -read /Users/$USER UserShell
# Should show: UserShell: /bin/zsh

# Restart terminal
```

**Alternative (if chsh doesn't work):**
```bash
# Set shell via System Preferences
# 1. System Settings → Users & Groups
# 2. Right-click your user → Advanced Options
# 3. Login Shell: /bin/zsh
# 4. Click OK
```

---

### zsh: command not found After Migration

**Problem:**
```bash
$ git
zsh: command not found: git
```

**Cause:** PATH doesn't include `/opt/homebrew/bin`.

**Solution:**
```bash
# Temporarily fix (this session only)
export PATH="/opt/homebrew/bin:$PATH"

# Permanent fix - add to ~/.zshrc:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc

# Reload
source ~/.zshrc

# Verify
echo $PATH
# Should show /opt/homebrew/bin near the beginning
```

---

## Package Installation Failures

### Package Installation Timeout

**Problem:**
```
Error: Download timeout
curl: (28) Operation timed out after 300000 milliseconds
```

**Solution:**
```bash
# Increase timeout
export HOMEBREW_CURL_TIMEOUT=600

# Retry installation
brew install <package>

# Or use --verbose to see what's happening
brew install <package> --verbose
```

---

### "Package not found" Error

**Problem:**
```
Error: No available formula with the name "example-tool"
```

**Solutions:**

**1. Update Homebrew:**
```bash
brew update
brew install example-tool
```

**2. Check if it's a cask:**
```bash
brew install --cask example-tool
```

**3. Check if package is deprecated:**
```bash
brew search example-tool
# May suggest alternatives
```

**4. Check ARM64 compatibility:**
```bash
# Some packages may not have ARM64 builds yet
brew info example-tool
# Look for "arm64_big_sur" or similar in bottle info
```

---

### Build from Source Failures

**Problem:**
```
Error: Building from source failed
configure: error: C compiler cannot create executables
```

**Solution:**
```bash
# Ensure Command Line Tools are properly installed
xcode-select --install

# Reset Command Line Tools path
sudo xcode-select --reset

# Verify compiler works
gcc --version
clang --version

# Retry installation
brew install <package>
```

---

### Dependency Conflicts

**Problem:**
```
Error: Cannot install <package-a> because <package-b> conflicts
```

**Solution:**
```bash
# Try unlinking the conflicting package
brew unlink <package-b>
brew install <package-a>
brew link <package-b>

# If that doesn't work, check formulas
brew info <package-a>
brew info <package-b>

# May need to use alternative versions or wait for upstream fix
```

---

## Post-Migration Issues

### Old Package Configurations Persist

**Problem:**
After migration, old configurations from Intel packages still being used.

**Solution:**
```bash
# Check for old config files
ls -la ~/.*rc
ls -la ~/.config/

# Common culprits:
# ~/.pyenv        (if switched to uv)
# ~/.nvm          (if switched to fnm)
# ~/.rvm          (if switched to rbenv)

# Review and clean up manually
# Don't blindly delete - check what's in them first
```

---

### "brew doctor" Shows Warnings

**Problem:**
```
$ brew doctor
Warning: You have unlinked kegs in your Cellar
```

**Solution:**
```bash
# Run doctor to see all issues
brew doctor

# Common fixes:
brew cleanup              # Remove old versions
brew link --overwrite <package>  # Fix symlinks
brew uninstall --force <package> && brew install <package>  # Reinstall
```

---

### Permission Errors in /opt/homebrew

**Problem:**
```
Error: Permission denied @ dir_s_mkdir - /opt/homebrew/Cellar
```

**Solution:**
```bash
# Fix ownership
sudo chown -R $(whoami):admin /opt/homebrew

# Or specific directory
sudo chown -R $(whoami):admin /opt/homebrew/Cellar

# Retry installation
brew install <package>
```

---

## Getting Help

### Before Opening an Issue

1. **Run brew doctor:**
   ```bash
   brew doctor
   ```

2. **Check architecture:**
   ```bash
   uname -m
   file $(which brew)
   ```

3. **Check Homebrew version:**
   ```bash
   brew --version
   brew config
   ```

4. **Enable verbose output:**
   ```bash
   ./install-homebrew-arm64.sh --dry-run
   ```

5. **Check logs:**
   ```bash
   # Script logs to current directory
   ls -la install-log-*.log
   tail -50 install-log-*.log
   ```

---

### Gathering Debug Information

When reporting issues, include:

```bash
# System info
sw_vers
uname -m
sysctl -n machdep.cpu.brand_string

# Homebrew info
which brew
file $(which brew)
brew --version
brew config

# Shell info
echo $SHELL
dscl . -read /Users/$USER UserShell

# PATH
echo $PATH

# Recent installation log (if available)
tail -100 install-log-*.log
```

---

### Where to Get Help

1. **Documentation:**
   - [Installation Guide](INSTALLATION-GUIDE.md)
   - [Migration Case Study](MIGRATION-CASE-STUDY.md)
   - [README](../README.md)

2. **GitHub Issues:**
   - Search existing issues: https://github.com/joaquimscosta/homebrew-arm64-migration/issues
   - Open new issue with debug info and steps to reproduce

3. **Homebrew Resources:**
   - Homebrew troubleshooting: `brew doctor`
   - Homebrew discussions: https://github.com/Homebrew/brew/discussions

---

## Common Error Messages Reference

| Error Message | Likely Cause | Solution |
|--------------|--------------|----------|
| `command not found` | Missing from PATH | Add `/opt/homebrew/bin` to PATH |
| `Permission denied` | Script not executable | `chmod +x script.sh` |
| `Not ARM64 architecture` | Running under Rosetta 2 or Intel Mac | Disable Rosetta for Terminal app |
| `C compiler cannot create executables` | Command Line Tools missing | `xcode-select --install` |
| `curl: (28) Timeout` | Slow network | Increase timeout, check connection |
| `No such file or directory: /usr/local/bin/zsh` | Shell configuration stale | `chsh -s /bin/zsh` |
| `Cannot link <package>` | Conflicting files | `brew unlink` then `brew link --overwrite` |

---

**Last Updated:** January 2025
**For More Help:** https://github.com/joaquimscosta/homebrew-arm64-migration/issues
