#!/bin/bash

# 🚨 Script d'urgence - Suppression temporaire des fichiers problématiques
# Usage: bash emergency-fix.sh

echo "🚨 EMERGENCY: Removing problematic files temporarily..."
echo "==============================================="

# Sauvegarder les fichiers problématiques
mkdir -p .backup/content/docs/
mkdir -p .backup/content/blog/

# Backup
cp content/docs/_index.md .backup/content/docs/
cp content/docs/Guides/Guide-Utilisation-Obsidian.md .backup/content/docs/
cp content/docs/Projects/Premier-Test-Obsidian.md .backup/content/docs/
cp content/blog/automatiser-portfolio-hugo-github-actions.md .backup/content/blog/

echo "📥 Files backed up to .backup/"

# Supprimer temporairement les fichiers problématiques
rm content/docs/Guides/Guide-Utilisation-Obsidian.md
rm content/docs/Projects/Premier-Test-Obsidian.md

echo "🗑️ Removed problematic files temporarily"

# Créer des versions minimales sans shortcodes
cat > content/docs/_index.md << 'EOF'
---
title: "Documentation"
description: "Documentation technique générée depuis Obsidian"
weight: 10
---

# Documentation

Cette section contient la documentation technique de mes projets, synchronisée automatiquement depuis Obsidian.

## 🏗️ Structure

- **Projets** : Documentation des projets individuels
- **Guides** : Tutoriels et guides techniques  
- **API** : Documentation des APIs (générée automatiquement)
- **Notes** : Notes techniques et mémos

## 📝 Workflow Obsidian

1. **Écrire** dans Obsidian (ce dossier `docs-source/`)
2. **Sauvegarder** - Auto-commit Git via plugin Obsidian
3. **GitHub Action** convertit et déploie automatiquement
4. **Site live** en quelques minutes sur martinezismael.fr

## 🔗 Syntaxe supportée

- Liens internes Obsidian → Convertis automatiquement en liens Hugo
- Images → Copiées dans `/static/images/docs/`
- Métadonnées YAML → Préservées pour Hugo
- Tags et dossiers → Structure maintenue

---

*Commencez à écrire votre documentation ici. Tous les fichiers `.md` seront synchronisés automatiquement.*
EOF

echo "✅ Created minimal docs index"
echo ""
echo "🎯 Next: Commit and test Hugo build"
echo "💡 Files can be restored from .backup/ later"