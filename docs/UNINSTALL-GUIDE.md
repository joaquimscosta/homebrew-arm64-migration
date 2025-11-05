# Homebrew Uninstall & Migration Guide

**Complete workflow for removing Intel Homebrew and migrating to ARM64 on Apple Silicon Macs**

---

## Overview

This guide walks you through the **complete uninstall → cleanup → install workflow** for Homebrew on Apple Silicon Macs. Whether you're migrating from Intel Homebrew (`/usr/local`) to native ARM64 Homebrew (`/opt/homebrew`), or performing a clean reinstall, this guide provides a safe, step-by-step process.

### When to Use This Guide

- **Migrating from Intel to ARM64**: You have Intel Homebrew at `/usr/local` and want native ARM64 at `/opt/homebrew`
- **Clean reinstall**: Starting fresh with Homebrew on your Mac
- **Troubleshooting**: Fixing a corrupted Homebrew installation
- **Dual architecture cleanup**: Removing x86_64 binaries from Rosetta 2 environment

### What You'll Learn

1. How to safely backup your current Homebrew packages
2. How to run the official Homebrew uninstaller
3. How to clean up remnants left behind (~820MB typically)
4. How to install ARM64 Homebrew properly
5. How to verify your migration was successful

---

## ⚠️ Important: The Three-Step Process

**DO NOT skip Step 1!** The cleanup scripts in this repository are designed to remove **remnants** after the official uninstaller runs. Running them without the official uninstaller first will leave your system in an inconsistent state.

```
┌─────────────────────────────────────────────────────────────┐
│  Step 1: Official Homebrew Uninstaller (REQUIRED FIRST)    │
│  ↓                                                          │
│  Step 2: Cleanup Remnants (Our Scripts)                    │
│  ↓                                                          │
│  Step 3: Install ARM64 Homebrew                            │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 1: Official Homebrew Uninstaller (REQUIRED)

### Before You Uninstall: Backup Your Packages

**Highly recommended!** Create a backup of your installed packages before uninstalling:

```bash
# Navigate to a safe directory (e.g., your home folder)
cd ~

# Export all installed packages to a Brewfile
brew bundle dump --file=Brewfile.backup --describe

# Verify the backup was created
ls -lh Brewfile.backup
```

This creates a `Brewfile.backup` containing all your installed formulae, casks, taps, and Mac App Store apps. You can use this later to reinstall packages on ARM64 Homebrew.

### Run the Official Uninstaller

#### Option 1: Standard Uninstall (Recommended for Most Users)

For Intel Homebrew installed at the default location (`/usr/local`):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

This will:
- Prompt for your password (uses `sudo` for `/usr/local` access)
- Display what will be removed
- Ask for confirmation before proceeding
- Remove the main Homebrew installation

#### Option 2: Non-Interactive Uninstall (For Scripts/Automation)

If you want to run the uninstaller without interactive prompts:

```bash
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

**⚠️ Use with caution** - This bypasses confirmation prompts.

#### Option 3: Custom Prefix Uninstall (Advanced)

If you installed Homebrew to a non-standard location, specify the path:

```bash
# Download the uninstaller first
curl -fsSLO https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh

# Run with custom path
/bin/bash uninstall.sh --path /usr/local

# View all options
/bin/bash uninstall.sh --help
```

### What the Official Uninstaller Removes

The official Homebrew uninstaller removes:

✅ Core Homebrew directories:
- `/usr/local/Homebrew`
- `/usr/local/Caskroom`
- `/usr/local/Cellar`

✅ Homebrew cache and metadata:
- `~/Library/Caches/Homebrew`
- `~/Library/Logs/Homebrew`

✅ Most symlinks in `/usr/local/bin`

### What the Official Uninstaller LEAVES BEHIND

Based on real-world migrations, the official uninstaller typically leaves **~820MB of remnants**:

❌ **NOT removed by official uninstaller:**

| Directory | Typical Size | Description |
|-----------|--------------|-------------|
| `/usr/local/lib/python*/site-packages` | ~135MB | Python packages installed via pip |
| `/usr/local/lib/node_modules` | ~48MB | Global npm packages |
| `/usr/local/etc/` | ~1MB | Configuration files (OpenSSL, Git, etc.) |
| `/usr/local/var/homebrew` | Varies | Homebrew data directories |
| `/usr/local/share/` | ~10MB | Documentation, man pages, zsh completions |
| Broken symlinks | N/A | Orphaned links in `/usr/local/bin` |

**This is why Step 2 (cleanup scripts) exists!**

---

## Step 2: Cleanup Remnants

After running the official uninstaller, use one of the cleanup scripts from this repository to remove the leftover remnants.

### Prerequisites

- Step 1 (official uninstaller) must be completed first
- Administrator access (scripts use `sudo`)
- Basic command-line familiarity

### Choose Your Cleanup Approach

#### Option A: Comprehensive Cleanup (Recommended)

**Removes:** Intel Homebrew directories, Python site-packages, orphaned npm packages, config files (~820MB total)

**Preserves:** Non-Homebrew software (Go, .NET SDK, Docker, Microsoft tools)

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/cleanup-homebrew-remnants.sh -o cleanup-homebrew-remnants.sh

# Make it executable
chmod +x cleanup-homebrew-remnants.sh

# Run the cleanup
./cleanup-homebrew-remnants.sh
```

**What it does:**
1. Checks if you've run the official uninstaller first
2. Shows estimated space to be freed (~820MB)
3. Prompts for confirmation before each deletion phase
4. Removes 8 categories of remnants
5. Optionally removes `.keepme` files and man pages
6. Displays a summary of what was kept (Go, .NET, etc.)

#### Option B: Targeted Cleanup (Conservative)

**Removes:** Only specific broken symlinks and scripts

**Preserves:** All directories and legitimate software

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/cleanup-broken-files.sh -o cleanup-broken-files.sh

# Make it executable
chmod +x cleanup-broken-files.sh

# Preview what will be removed (dry run)
./cleanup-broken-files.sh --dry-run

# Run the cleanup
./cleanup-broken-files.sh
```

**What it does:**
1. Checks if you've run the official uninstaller first
2. Finds and removes only broken Python scripts
3. Removes broken npm CLI symlinks
4. Removes broken man pages
5. Safer approach if you're uncertain about full cleanup

### Recommendation

**For most users:** Use Option A (Comprehensive Cleanup) for a complete migration. It's safe and preserves non-Homebrew software.

**For cautious users:** Use Option B (Targeted Cleanup) if you want minimal changes, then manually review `/usr/local` afterward.

---

## Step 3: Install ARM64 Homebrew

After completing Steps 1 and 2, you're ready to install native ARM64 Homebrew.

### Quick Installation

```bash
# Download the installation script
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/install-homebrew-arm64.sh -o install-homebrew-arm64.sh

# Make it executable
chmod +x install-homebrew-arm64.sh

# Preview first (no changes made)
./install-homebrew-arm64.sh --dry-run

# Run installation (interactive prompts)
./install-homebrew-arm64.sh
```

This script provides:
- ✅ Strict ARM64 verification (no Rosetta 2 x86_64 binaries)
- ✅ Educational prompts explaining modern tools (uv, fnm, SDKMAN)
- ✅ 11 sequential installation phases
- ✅ Smart package selection (146 packages analyzed)
- ✅ Post-install health checks

See the main [README.md](../README.md) for full installation options.

---

## Verification: Confirm Successful Migration

After completing all three steps, verify your ARM64 Homebrew installation:

### 1. Check Homebrew Architecture

```bash
# Should show: /opt/homebrew/bin/brew
which brew

# Should show: arm64
brew config | grep "CPU:"

# Should show version and ARM64 confirmation
brew --version
```

### 2. Verify Binary Architecture

```bash
# Should show: arm64
file $(which brew)

# Test a package (e.g., wget)
brew install wget
file $(which wget)  # Should show: arm64
```

### 3. Check for Intel Remnants

```bash
# Should be empty or only show non-Homebrew software
ls -la /usr/local/

# Should NOT exist
ls -la /usr/local/Homebrew
```

### 4. Test Package Installation

```bash
# Install a test package
brew install tree

# Verify it works
tree --version

# Confirm it's ARM64
file $(which tree)  # Should show: Mach-O 64-bit executable arm64
```

---

## Restoring Your Packages

If you created a `Brewfile.backup` in Step 1, restore your packages:

```bash
# Navigate to where you saved the backup
cd ~

# Review the Brewfile first
cat Brewfile.backup

# Restore all packages (may take 30-60 minutes)
brew bundle --file=Brewfile.backup

# Or restore selectively (edit Brewfile.backup first)
```

**Note:** Some packages may have architecture-specific issues or may no longer be available. The installation script will skip those and continue.

---

## Troubleshooting

### Issue: "brew: command not found" After Uninstall

**Cause:** Shell configuration still references old Homebrew path

**Solution:**

```bash
# Check your shell configuration
cat ~/.zshrc | grep -i homebrew
cat ~/.bash_profile | grep -i homebrew

# Remove old Homebrew PATH entries referencing /usr/local
# Then add ARM64 Homebrew:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Reload your shell
exec zsh
```

### Issue: Cleanup Script Says "Homebrew Still Installed"

**Cause:** You skipped Step 1 (official uninstaller)

**Solution:**

```bash
# Run the official uninstaller first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Then run the cleanup script
./cleanup-homebrew-remnants.sh
```

### Issue: Some Packages Won't Install on ARM64

**Cause:** Package doesn't have ARM64 support yet

**Solution:**

```bash
# Check if package supports ARM64
brew info <package-name>

# Use Rosetta 2 as fallback (not recommended for regular use)
arch -x86_64 brew install <package-name>

# Or find an alternative package with ARM64 support
```

### Issue: High Disk Usage After Migration

**Cause:** Old Homebrew caches still present

**Solution:**

```bash
# Remove old caches
rm -rf ~/Library/Caches/Homebrew/*

# Clean new Homebrew installation
brew cleanup -s

# Check disk usage
du -sh /opt/homebrew
```

---

## Safety & Best Practices

### Before You Start

✅ **Backup important data** - While these scripts are safe, backups are always recommended

✅ **Export Brewfile** - Save your package list with `brew bundle dump`

✅ **Review scripts** - Always review scripts before running them:
```bash
curl -fsSL https://raw.githubusercontent.com/joaquimscosta/homebrew-arm64-migration/main/cleanup-homebrew-remnants.sh | less
```

✅ **Use dry-run mode** - Preview changes before executing

✅ **Have admin access** - You'll need `sudo` password for cleanup

### During Cleanup

✅ **Read all prompts** - Cleanup scripts ask for confirmation before each phase

✅ **Preserve non-Homebrew software** - Scripts automatically skip Go, .NET SDK, Docker, etc.

✅ **Keep a terminal log** - If issues arise, logs help troubleshooting:
```bash
./cleanup-homebrew-remnants.sh 2>&1 | tee cleanup.log
```

### After Migration

✅ **Test critical applications** - Ensure your development tools still work

✅ **Update shell configuration** - Remove old `/usr/local` PATH references

✅ **Run health checks** - Use `brew doctor` to verify installation

---

## Complete Workflow Checklist

Use this checklist to track your migration progress:

- [ ] **Step 0: Preparation**
  - [ ] Backup important data
  - [ ] Export Brewfile: `brew bundle dump --file=Brewfile.backup`
  - [ ] Close all applications using Homebrew

- [ ] **Step 1: Official Uninstaller**
  - [ ] Run official uninstaller: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"`
  - [ ] Confirm `/usr/local/Homebrew` is removed
  - [ ] Note remnants left behind

- [ ] **Step 2: Cleanup Remnants**
  - [ ] Download cleanup script (comprehensive or targeted)
  - [ ] Make script executable: `chmod +x cleanup-*.sh`
  - [ ] Run cleanup script
  - [ ] Verify `/usr/local` only contains non-Homebrew software

- [ ] **Step 3: Install ARM64 Homebrew**
  - [ ] Download installation script
  - [ ] Run with `--dry-run` first
  - [ ] Run interactive installation
  - [ ] Update shell configuration (`.zprofile`)

- [ ] **Step 4: Verification**
  - [ ] Confirm `which brew` shows `/opt/homebrew/bin/brew`
  - [ ] Verify architecture: `brew config | grep CPU`
  - [ ] Test package installation: `brew install tree`
  - [ ] Restore packages from Brewfile

- [ ] **Step 5: Post-Migration**
  - [ ] Run `brew doctor` to check health
  - [ ] Test critical development tools
  - [ ] Clean up old caches: `brew cleanup -s`
  - [ ] Remove backup files if no longer needed

---

## Why Three Steps? Understanding the Process

### The Official Uninstaller's Scope

The official Homebrew uninstaller is maintained by the Homebrew team and focuses on:
- Removing core Homebrew installation directories
- Cleaning up Homebrew's own caches and logs
- Removing most Homebrew-created symlinks

**However**, it's designed to be **conservative** and doesn't remove:
- User-installed packages' configuration files (safety)
- Python/Node packages installed via Homebrew's pip/npm
- Shared libraries that might be used by other software

### Why Our Cleanup Scripts Are Necessary

Based on real-world migration data, the official uninstaller leaves behind ~820MB of remnants:

| Category | Size | Why Official Uninstaller Skips It |
|----------|------|-----------------------------------|
| Python site-packages | ~135MB | User data, might be used elsewhere |
| npm global packages | ~48MB | Node version managers might coexist |
| Configuration files | ~1MB | Safety (e.g., SSH, Git configs) |
| Homebrew var | Varies | Database/service data preservation |

Our cleanup scripts safely remove these remnants **after** confirming the official uninstaller ran successfully, ensuring a complete Intel → ARM64 migration.

---

## Real-World Migration Example

**System:** MacBook Pro M3 Max, macOS Sequoia 15.6.1

**Before:**
- Intel Homebrew at `/usr/local` (146 packages)
- Total space used: ~4.2GB

**Process:**
1. Exported Brewfile (5 minutes)
2. Ran official uninstaller (2 minutes)
3. Ran comprehensive cleanup script (1 minute)
4. Installed ARM64 Homebrew with migration script (45 minutes)

**After:**
- ARM64 Homebrew at `/opt/homebrew`
- All packages reinstalled and verified
- Freed ~820MB from `/usr/local`
- Performance improvement: 15-40% faster builds (native ARM64)

**See [MIGRATION-CASE-STUDY.md](MIGRATION-CASE-STUDY.md) for the complete story.**

---

## Additional Resources

- **[README.md](../README.md)** - Project overview and features
- **[INSTALLATION-GUIDE.md](INSTALLATION-GUIDE.md)** - Comprehensive installation guide for ARM64 Homebrew
- **[MIGRATION-CASE-STUDY.md](MIGRATION-CASE-STUDY.md)** - Real-world migration walkthrough
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions
- **[Official Homebrew Docs](https://docs.brew.sh/)** - Homebrew documentation
- **[Homebrew Uninstaller Source](https://github.com/Homebrew/install#uninstall-homebrew)** - Official uninstaller repository

---

## Getting Help

### Found an Issue?

1. Check [existing GitHub issues](https://github.com/joaquimscosta/homebrew-arm64-migration/issues)
2. Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. Create a new issue with:
   - macOS version: `sw_vers`
   - Chip model: `sysctl -n machdep.cpu.brand_string`
   - Error message and logs
   - Steps to reproduce

### Contributing

This project is maintained on a best-effort basis. See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

## Summary

**Three-Step Process:**

1. **Official Homebrew Uninstaller** - Removes core Homebrew (required)
2. **Cleanup Remnants** - Removes ~820MB leftover files (our scripts)
3. **Install ARM64 Homebrew** - Native Apple Silicon installation

**Key Takeaways:**

- Always run the official uninstaller first
- Cleanup scripts handle remnants the official uninstaller leaves
- Verify ARM64 architecture after installation
- Keep your Brewfile backup for easy package restoration

**Time Investment:** ~60 minutes total (mostly package reinstallation)

**Result:** Clean, native ARM64 Homebrew with 15-40% performance improvement

---

**Made with ❤️ for the Apple Silicon community**
