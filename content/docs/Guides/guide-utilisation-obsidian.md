---
title: "Guide d'utilisation du Portfolio Automatisé"
description: Documentation du workflow de documentation avec Obsidian et synchronisation automatique
tags:
 - guide
 - obsidian
 - workflow
 - documentation
 - portfolio
date: 2025-10-23
---

# Guide d'utilisation du Portfolio Automatisé

## Workflow de documentation

### Écriture avec Obsidian
- Utilisez ce vault (`docs-source/`) pour écrire vos notes
- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`
- Les images vont dans `attachments/`

### Synchronisation automatique
Le plugin Obsidian Git va :
1. **Auto-commit** vos changements
2. **Push** vers GitHub 
3. Déclencher la **GitHub Action** de sync
4. Convertir et déployer vers le **site web**

### Syntaxe supportée
- `{{< ref "liens-internes" >}}` → Convertis en liens Hugo
- `![Image](/images/docs/images.png)` → Images copiées automatiquement  
- **Métadonnées YAML** → Préservées pour Hugo
- **Markdown standard** → Supporté intégralement

## Configuration du plugin Obsidian Git

1. **Installer** le plugin "Obsidian Git"
2. **Activer** l'auto-backup
3. **Configurer** :
   - Auto backup interval: 5 minutes
   - Auto pull interval: 10 minutes
   - Commit message: "📝 Auto-sync Obsidian notes"

## Structure recommandée

```
docs-source/
├── Projects/          # Documentation projets
├── Guides/           # Tutoriels et guides  
├── Notes/            # Notes techniques
├── attachments/      # Images et fichiers
└── _index.md         # Page d'accueil docs
```

---

*Ce guide sera également synchronisé automatiquement !*