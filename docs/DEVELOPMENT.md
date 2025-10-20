# 🛠️ Guide de Développement

## Architecture Hugo

### Structure du Projet
```
Automated-Portfolio/
├── content/          # Contenu du site (généré depuis docs-source)
├── docs-source/      # Vault Obsidian (source de vérité)
├── layouts/          # Templates Hugo personnalisés
├── static/           # Assets statiques
├── config/           # Configuration Hugo
└── scripts/          # Scripts d'automatisation
```

### Workflow Obsidian → Hugo

1. **Écriture**: Créer/modifier dans `docs-source/` (Obsidian)
2. **Auto-commit**: Plugin Obsidian Git commit automatique
3. **Sync**: GitHub Action copie vers `content/`
4. **Build**: Hugo génère le site
5. **Deploy**: Upload automatique vers OVH

## Développement Local

### Prérequis
```bash
# Node.js 18+
node --version

# Hugo Extended 0.110+
hugo version

# Installer dépendances
npm install
```

### Commandes de Développement
```bash
# Serveur de développement
npm run dev
# ou
hugo server -D --bind 0.0.0.0

# Build de production
npm run build
# ou
hugo --minify

# Nettoyage
npm run clean
```

### Configuration Hugo

#### Fichiers de Configuration
- `hugo.toml` : Configuration principale
- `config/_default/` : Configuration par environnement

#### Modules et Thèmes
- Pas de thème externe (layouts personnalisés)
- Bootstrap 5 + Font Awesome via CDN
- Pas de modules npm complexes

## Corrections de Template

### Problèmes Résolus

#### 1. Conflits Docsy
```
Error: template: swagger/list.html:8: bad character U+002D '-'
```
**Solution** : Docsy désactivé, layouts personnalisés créés

#### 2. Configuration Dépréciée
```
WARN deprecated: site config key privacy.twitter.enableDNT
```
**Solution** : `privacy.twitter.enableDNT` → `privacy.x.enableDNT`

#### 3. Module Conflicts
```
hugo: downloading modules … Error: Process completed with exit code 1
```
**Solution** : Modules commentés, layouts intégrés utilisés

### Layouts Personnalisés

- `layouts/_default/baseof.html` : Template de base
- `layouts/_default/single.html` : Pages individuelles
- `layouts/_default/list.html` : Pages de listing
- `layouts/index.html` : Page d'accueil
- `layouts/projects/list.html` : Portfolio projets

## Validation Markdown

### Checks Automatiques
- **Frontmatter YAML** : Validation syntaxe
- **Merge Conflicts** : Détection marqueurs Git
- **Links** : Vérification liens internes/externes (TODO)

### Frontmatter Requis
```yaml
---
title: "Titre du document"
description: "Description courte"
date: 2024-XX-XX
draft: false
tags: ["tag1", "tag2"]
weight: 10  # Optionnel, pour ordre
---
```

### Conversion Obsidian

#### Liens Internes
```markdown
# Obsidian
[[Page Interne]]

# Hugo
{{< ref "page-interne" >}}
```

#### Images
```markdown
# Obsidian
![[image.png]]

# Hugo
![Alt text](image.png)
```

## Scripts Utiles

### Sync Obsidian Manuel
```bash
npm run sync:obsidian
# ou
node scripts/sync-obsidian.js
```

### Génération Index Recherche
```bash
npm run search:index
```

### Tests et Validation
```bash
npm run test          # Tests complets
npm run validate      # Validation Markdown
npm run linkcheck     # Vérification liens
```

## Debugging

### Logs Hugo
```bash
hugo server --verbose --debug
```

### Validation Template
```bash
hugo server --disableFastRender
```

### Variables Disponibles
```html
<!-- Debug variables Hugo -->
{{ printf "%#v" . }}
```

### Erreurs Fréquentes

1. **Frontmatter invalide** : Vérifier syntaxe YAML
2. **Images manquantes** : Vérifier chemin dans static/
3. **Template errors** : Vérifier syntaxe Go templates
4. **Encoding issues** : Utiliser UTF-8 sans BOM