# Maintenance Guide

**For the maintainer (you!) - Quick reference for managing this project with limited time**

---

## 🎯 Your Maintenance Philosophy

**"Best-effort, community-driven, fork-friendly"**

You don't have much time, and that's okay! This guide helps you manage contributions without guilt or burnout.

---

## ⚡ Quick Actions (When You Have 5 Minutes)

### Check Notifications (Weekly)

```bash
# Via GitHub web:
https://github.com/joaquimscosta/homebrew-arm64-migration/issues
https://github.com/joaquimscosta/homebrew-arm64-migration/pulls

# Quick triage:
1. Read issue titles
2. Close spam/duplicates
3. Thank people for PRs (even if you can't review yet)
4. Point urgent needs to fork option
```

### Template Response for PRs You Can't Review Yet:

```markdown
Thanks for the PR! 🙏

Quick note: This project is maintained on a best-effort basis, so it may take 2-4 weeks (or longer) for review.

If you need this urgently:
- Fork this repo and maintain your version
- Share your fork link here so others can benefit

I'll review when I can! Thanks for understanding.
```

---

## 📋 Monthly Tasks (15 minutes)

1. **Check Stale Bot** - GitHub Actions auto-handles this
   - Stale bot runs weekly (Sundays)
   - PRs inactive 60 days → labeled "stale"
   - PRs stale 7 more days → auto-closed
   - You don't need to do anything!

2. **Quick Security Check**
   ```bash
   # GitHub will alert you to security issues in dependencies
   # Check: https://github.com/joaquimscosta/homebrew-arm64-migration/security
   ```

3. **Review Easy Wins** (optional)
   - Simple typo fixes → Quick merge
   - Clear bug fixes with tests → Merge if safe
   - Anything complex → Comment "looks good, will test when I have time"

---

## 🚫 What You DON'T Need to Do

- ❌ Review every PR immediately
- ❌ Feel guilty about slow responses
- ❌ Merge PRs you're unsure about
- ❌ Explain why you're busy (it's in README/CONTRIBUTING)
- ❌ Maintain other people's forks
- ❌ Provide 24/7 support

---

## ✅ When to Merge a PR (Checklist)

Only merge if **ALL** are true:

- [ ] You have 30+ minutes to test it
- [ ] ShellCheck CI passed (green checkmark)
- [ ] You understand what it does
- [ ] It doesn't break existing functionality
- [ ] It follows the project style
- [ ] No security concerns
- [ ] Small enough to review properly

**If ANY are false → Leave it for later or ask for changes**

---

## 🍴 Encouraging Forks (Your Secret Weapon)

Forks are your friend! They:
- Let community move fast without you
- Remove pressure to merge everything
- Create ecosystem of variants for different needs
- MIT license allows it freely

### When Someone Opens a PR for Major Changes:

```markdown
This looks interesting! However, given the scope and my time constraints, I'd suggest:

1. **Fork this repo** and publish your changes there
2. Open an issue describing your fork with the repo link
3. Community can use your fork if they need this feature
4. I'll keep this PR open for future consideration

This way the community benefits immediately. Thanks for understanding!
```

---

## 📊 GitHub Settings Recommendations

### Enable:
- ✅ Issues (for bug reports and discussions)
- ✅ Discussions (optional - for Q&A)
- ✅ Wiki (disabled - use docs/ instead)
- ✅ Projects (disabled - you don't have time)

### Branch Protection (main):
```yaml
Require PR reviews: NO (you're solo maintainer)
Require status checks: YES (ShellCheck must pass)
Require branches up to date: NO (less friction)
```

### Notifications:
- Watch: "Participating and @mentions" (not "All Activity")
- Email: Only for @mentions and PRs
- Mute threads you can't handle right now

---

## 🎁 When You DO Have Time (Rare!)

### High-Value Activities:

1. **Version Bump** (1-2 hours)
   ```bash
   # Update version numbers
   # Test with --dry-run
   # Create GitHub release
   # Update CHANGELOG.md
   ```

2. **Merge Accumulated Typo Fixes** (30 min)
   - Batch merge multiple small typo/doc PRs
   - One commit: "Merge documentation fixes from community"

3. **Security Updates** (important!)
   - If Homebrew changes paths/behavior
   - If vulnerabilities found
   - Mark as "security" label so stale bot skips

4. **Thank Contributors** (5 min)
   - Comment on old PRs: "Thanks for this! Sorry for delay, reviewing soon"
   - Makes people feel heard

---

## 🚨 What Requires Immediate Action

Only these need fast response:

1. **Security vulnerabilities** (within 72 hours)
   - Script creates security risk
   - Someone reports data loss
   - Malicious PR attempt

2. **Broken main branch** (within 24 hours)
   - CI failing
   - Scripts completely broken
   - Can't be downloaded/run

3. **Everything else** → "Best effort" (days/weeks okay)

---

## 💡 Community Self-Service

Point people to:

- **Troubleshooting Guide**: `docs/TROUBLESHOOTING.md`
- **Forks**: Encourage them to create and share
- **Discussions**: GitHub Discussions for Q&A (if enabled)
- **Issues**: Search existing issues first

---

## 📅 Realistic Maintenance Schedule

### Your Commitment:
- **Weekly** (5 min): Skim notifications, close spam
- **Monthly** (15 min): Check stale bot, security alerts
- **Quarterly** (1-2 hours): Merge easy wins, maybe version bump
- **Annually** (2-3 hours): Major version update if needed

**Total: ~3-5 hours/year** - Very sustainable!

---

## 🎉 Success Metrics

Your project is successful if:

1. ✅ People use it (stars, forks, downloads)
2. ✅ Issues get opened (means people care)
3. ✅ Forks exist (ecosystem thriving)
4. ✅ You don't burn out (most important!)

You DON'T need:
- ❌ Fast PR reviews
- ❌ Constant updates
- ❌ 24/7 availability
- ❌ Every feature merged

---

## 🏃 Emergency: "I Can't Do This Anymore"

If it becomes too much:

### Option 1: Archive the repo
```yaml
# GitHub Settings → Archive this repository
# Readme: "Project archived, forks encouraged"
```

### Option 2: Transfer to community org
```yaml
# Find 2-3 active contributors
# Transfer ownership to a GitHub org
# Stay involved or step away
```

### Option 3: Add co-maintainer
```yaml
# Find someone who:
  - Has contributed quality PRs
  - Understands the project
  - Has time to help
# Add them as collaborator
```

---

## 📝 Templates for Common Scenarios

### "Can you review my PR?"
```markdown
Thanks for the PR! This project is on a best-effort maintenance schedule (see CONTRIBUTING.md).

Reviews may take 2-4 weeks or longer. If urgent, consider maintaining a fork and sharing the link here.

I'll review when I have time. Thanks for understanding! 🙏
```

### "Why was my PR closed?"
```markdown
Your PR was auto-closed due to 60 days of inactivity (see stale policy in README).

You can reopen by:
1. Adding a comment here
2. Pushing new commits

Or maintain your changes in a fork - MIT license allows this freely.
```

### "When will you add feature X?"
```markdown
Thanks for the suggestion! I maintain this on a best-effort basis with limited time.

Options:
1. Open a PR (but review may take weeks)
2. Fork the repo and add it yourself
3. Wait and hope I get to it someday

Fork option is fastest. Share your fork link here so others can benefit!
```

---

## 🎯 Remember:

- **You created something valuable** - People are using it!
- **Your time matters** - Don't feel guilty for boundaries
- **Forks are good** - Community thriving is success
- **Burnout helps no one** - Sustainable > perfect

**You're doing great by being honest about your availability!** 🌟

---

**Questions?** Read your own CONTRIBUTING.md - you wrote it well! 😄
