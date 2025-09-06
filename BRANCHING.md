# Git Branching Strategy for DND-5e-LaTeX-Template Fork

## Overview

This document outlines the branching strategy for maintaining a fork of ashonit/DND-5e-LaTeX-Template with upstream sync, targeted contributions, and personal modifications.

## Branch Structure

### Core Branches

- **`main`** - Clean mirror of upstream (ashonit/main)
- **`dev`** - Integration branch with all personal changes
- **`upstream-sync`** - Temporary branch for upstream updates

### Feature Branches

- **`fix/description`** - Individual fixes for upstream PRs
- **`feat/feature-name`** - Individual features for upstream PRs  
- **`local/feature-name`** - Personal changes not intended for upstream

## Remotes Configuration

```bash
git remote add upstream https://github.com/ashonit/DND-5e-LaTeX-Template.git
git remote add origin git@github.com:sargeant/DND-5e-LaTeX-Template.git
```

## Workflow

### 1. Upstream Sync (Weekly/As Needed)

```bash
# Fetch latest from upstream
git fetch upstream

# Update main to match upstream exactly
git checkout main
git reset --hard upstream/main
git push origin main --force-with-lease

# Update dev branch with upstream changes
git checkout dev
git rebase main
# Resolve any conflicts
git push origin dev --force-with-lease
```

### 2. Creating Upstream PRs

For fixes/features intended for ashonit:

```bash
# Create feature branch from clean main
git checkout main
git checkout -b fix/description-formatting

# Make targeted changes
# ... edit files ...

# Commit and push
git add .
git commit -m "fix: improve description list formatting"
git push origin fix/description-formatting

# Create PR to ashonit via GitHub CLI or web interface
gh pr create --repo ashonit/DND-5e-LaTeX-Template \
  --title "Fix description list formatting" \
  --body "Improves spacing in description lists within sidebars"

# Merge into dev branch
git checkout dev
git merge fix/description-formatting
git push origin dev
```

### 3. Personal Changes

For changes you want locally but not upstream:

```bash
# Create local feature branch from main
git checkout main  
git checkout -b local/custom-spacing

# Make personal changes
# ... edit files ...

# Commit and merge to dev
git add .
git commit -m "local: adjust monster stat block spacing"
git checkout dev
git merge local/custom-spacing
git push origin dev

# Keep local branch for future reference
git push origin local/custom-spacing
```

### 4. Emergency Hotfixes

For urgent fixes that bypass normal workflow:

```bash
git checkout dev
git checkout -b hotfix/critical-bug
# Make minimal fix
git add .
git commit -m "hotfix: resolve critical LaTeX compilation error"
git checkout dev
git merge hotfix/critical-bug
git push origin dev
```

## Branch Maintenance

### Cleaning Up Merged Branches

After PR is merged upstream:

```bash
# Delete local feature branch
git branch -d fix/description-formatting
git push origin --delete fix/description-formatting

# Sync main with upstream (see Upstream Sync workflow)
```

### Handling Conflicts During Rebase

When rebasing dev onto updated main:

```bash
git checkout dev
git rebase main
# If conflicts occur:
# 1. Resolve conflicts in affected files
# 2. git add .
# 3. git rebase --continue
# 4. Repeat until rebase complete
git push origin dev --force-with-lease
```

## Testing Strategy

### Before Pushing to dev

```bash
# Test compilation of key documents
pdflatex example.tex
pdflatex bestiary.tex

# Run any available tests
npm test  # if available
make test # if available
```

### Before Creating PRs

```bash
# Test on clean main branch
git checkout main
git checkout -b test/pr-verification
git merge fix/feature-branch --no-commit
# Test compilation and functionality
# If successful, proceed with PR
```

## Integration with External Codebase

Your LaTeX-generating codebase should:

1. **Target the `dev` branch** - Contains all your changes
2. **Pin to specific commits** when stable - Use commit SHAs in your generator
3. **Test against `main`** periodically - Ensure upstream compatibility

### Suggested Integration Pattern

```bash
# In your LaTeX generator project
git submodule add -b dev https://github.com/sargeant/DND-5e-LaTeX-Template.git template
# Or use specific commit for stability:
# git submodule add https://github.com/sargeant/DND-5e-LaTeX-Template.git template
# cd template && git checkout <specific-commit-sha>
```

## Recovery Procedures

### If dev branch becomes corrupted

```bash
git checkout main
git checkout -b dev-new

# Cherry-pick local changes from backup branches
git merge local/custom-spacing
git merge local/other-feature
# etc.

# Replace dev branch
git branch -D dev
git branch -m dev-new dev
git push origin dev --force-with-lease
```

### If main drifts from upstream

```bash
git checkout main
git reset --hard upstream/main
git push origin main --force-with-lease
```

## Best Practices

1. **Never commit directly to main** - Always work through feature branches
2. **Keep commits atomic** - One logical change per commit
3. **Use descriptive commit messages** - Follow conventional commits format
4. **Test before merging** - Ensure LaTeX compilation succeeds
5. **Regular upstream sync** - Weekly or before starting new features
6. **Document breaking changes** - Update this file if workflow changes

## Commit Message Conventions

- `fix:` - Bug fixes for upstream PRs
- `feat:` - New features for upstream PRs  
- `local:` - Personal changes not for upstream
- `chore:` - Maintenance tasks
- `docs:` - Documentation updates

## File Organization

- Keep this `BRANCHING.md` updated with workflow changes
- Document any local customizations in separate `LOCAL_CHANGES.md`
- Use clear commit messages to track change intent