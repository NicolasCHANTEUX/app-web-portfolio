---
title: "Git Workflow - Convention Commits"
description: "Workflow Git avec Conventional Commits pour historique propre et changelog automatique."
type: "snippet"
tags: ["Git", "DevOps", "Best Practices", "Versioning"]
language: "bash"
difficulty: "beginner"
---

## 🎯 Contexte

Un historique Git clair facilite le debug, le code review et la génération de changelogs. J'utilise **Conventional Commits** pour standardiser mes messages.

## 📜 Format standard

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## 🏷️ Types de commits

| Type | Usage | Emoji | Exemple |
|------|-------|-------|---------|
| `feat` | Nouvelle fonctionnalité | ✨ | `feat(showroom): add project filters` |
| `fix` | Correction bug | 🐛 | `fix(api): correct image path resolution` |
| `refactor` | Refactoring (pas de feat/fix) | ♻️ | `refactor(components): extract ProjectCard logic` |
| `perf` | Amélioration performance | ⚡ | `perf(nginx): enable gzip compression` |
| `docs` | Documentation | 📝 | `docs(readme): add deployment instructions` |
| `style` | Formatage (pas de logique) | 💄 | `style(labo): fix sidebar spacing` |
| `test` | Ajout tests | ✅ | `test(api): add projects endpoint tests` |
| `chore` | Tâches maintenance | 🔧 | `chore(deps): update Astro to 5.17.1` |
| `ci` | CI/CD | 👷 | `ci(docker): add health checks` |

## ✍️ Exemples réels du projet

```bash
# Feature
git commit -m "feat(labo): add Content Collections for markdown items"

# Bugfix avec scope
git commit -m "fix(showroom): change API URL from /projects.php to /projects"

# Breaking change (footer)
git commit -m "feat(api)!: migrate from MySQL to MariaDB

BREAKING CHANGE: Database port changed from 3306 to 3307"

# Multi-line avec body
git commit -m "refactor(docker): optimize Alpine image sizes

- Remove unnecessary packages
- Use multi-stage builds
- Total size reduced from 350MB to 233MB"
```

## 🔄 Workflow personnel

```bash
# 1. Créer branche feature
git checkout -b feat/labo-page

# 2. Commits atomiques (1 feature = 1 commit)
git add frontend/src/pages/labo.astro
git commit -m "feat(labo): create labo page with VS Code layout"

git add frontend/src/content/config.ts
git commit -m "feat(content): add Content Collections schema"

# 3. Push branche
git push origin feat/labo-page

# 4. Merge sur main (squash ou merge commit)
git checkout main
git merge --squash feat/labo-page
git commit -m "feat(labo): complete Labo page implementation"

# 5. Tag version (semantic versioning)
git tag -a v1.2.0 -m "Release 1.2.0 - Add Labo page"
git push origin v1.2.0
```

## 📦 Génération Changelog automatique

Avec **conventional-changelog**:

```bash
# Install
npm install -g conventional-changelog-cli

# Générer CHANGELOG.md
conventional-changelog -p angular -i CHANGELOG.md -s

# Output exemple:
# ## [1.2.0] - 2024-01-15
# ### Features
# * **labo**: add Content Collections for markdown items
# * **showroom**: implement project filters
# ### Bug Fixes
# * **api**: correct image path resolution
```

## 🎨 Aliases Git pratiques

```bash
# Ajouter à ~/.gitconfig
[alias]
    # Commits rapides
    cf = "!git add -A && git commit -m 'feat: '"
    cx = "!git add -A && git commit -m 'fix: '"
    
    # Log élégant
    lg = log --oneline --graph --decorate --all
    
    # Undo dernier commit (garde changes)
    undo = reset --soft HEAD^
    
    # Commit amend sans changer message
    amend = commit --amend --no-edit
```

## 💡 Tips

1. **Commits atomiques**: 1 commit = 1 action cohérente (pas de `feat + fix` mélangés)
2. **Scope utile**: `(api)`, `(frontend)`, `(docker)` aide à filtrer l'historique
3. **Description impérative**: `add feature` pas `added feature` ou `adds feature`
4. **Breaking changes**: Toujours documenter avec `!` et footer `BREAKING CHANGE:`

## 🔍 Rechercher dans l'historique

```bash
# Tous les commits d'un fichier
git log --follow -- frontend/src/pages/labo.astro

# Commits de type feat uniquement
git log --oneline --grep="^feat"

# Commits entre deux tags
git log v1.1.0..v1.2.0 --oneline

# Qui a modifié cette ligne ? (blame)
git blame -L 45,55 frontend/src/pages/showroom.astro
```

## 🌱 Impact sur la collaboration

- **Code review facilité**: Scope + type signalent immédiatement l'impact
- **Changelog auto**: Releases documentées sans effort manuel
- **Historique navigable**: `git log --grep` pour retrouver features/fixes
- **CI/CD intelligent**: Déclencher actions selon type (feat → deploy staging)
