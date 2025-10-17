---
title: "Automatiser son portfolio avec Hugo et GitHub Actions"
description: "Guide complet pour créer un portfolio automatisé avec sync Obsidian et déploiement OVH"
date: 2025-10-17
tags: ["hugo", "github-actions", "automation", "obsidian", "ovh"]
categories: ["Automatisation", "Tutorials"]
author: "Ismael Martinez"
draft: false
---

# Automatiser son portfolio avec Hugo et GitHub Actions

Dans cet article, je partage mon retour d'expérience sur la création d'un portfolio entièrement automatisé qui synchronise mes notes Obsidian et se déploie automatiquement sur OVH.

## 🎯 Objectifs du projet

- ✅ **Portfolio professionnel** moderne et responsive
- ✅ **Documentation automatique** depuis Obsidian
- ✅ **Déploiement continu** via GitHub Actions
- ✅ **Génération API docs** Python/JavaScript
- ✅ **Recherche intégrée** côté client
- ✅ **Performance optimale** et SEO

## 🏗️ Architecture technique

### Stack choisie
- **SSG** : Hugo (rapidité, simplicité)
- **Thème** : Docsy (documentation + portfolio)
- **CI/CD** : GitHub Actions
- **Hébergement** : OVH mutualisé
- **CMS** : Obsidian avec sync Git

### Workflow automatisé

```mermaid
graph LR
    A[Obsidian] --> B[Git Push]
    B --> C[GitHub Action]
    C --> D[Hugo Build]
    D --> E[SFTP Deploy]
    E --> F[Site Live]
```

## 🔧 Mise en œuvre

### 1. Configuration Hugo

```toml
# hugo.toml
baseURL = "https://www.martinezismael.fr"
languageCode = "fr"
title = "Ismael Martinez - Portfolio"
theme = "docsy"

[params]
  github_repo = "https://github.com/elmaquito/Automated-Portfolio"
  edit_page = true
  search_enabled = true
```

### 2. GitHub Actions Workflow

```yaml
name: 🚀 Build and Deploy
on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Setup Hugo
      uses: peaceiris/actions-hugo@v2
    - name: Build
      run: hugo --minify
    - name: Deploy via SFTP
      uses: SamKirkland/FTP-Deploy-Action@v4.3.4
      with:
        server: ${{ secrets.FTP_HOST }}
        username: ${{ secrets.FTP_USERNAME }}
        password: ${{ secrets.FTP_PASSWORD }}
```

### 3. Script Sync Obsidian

```bash
#!/bin/bash
# Conversion Obsidian → Hugo

convert_obsidian_links() {
    # Conversion des liens [[internes]] vers Hugo ref shortcode
    sed -i 's/\[\[\([^]]*\)\]\]/HUGO_REF_LINK/g' "$1"
}

find docs-source -name "*.md" | while read file; do
    target="content/docs/${file#docs-source/}"
    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
    convert_obsidian_links "$target"
done
```

## 📊 Résultats obtenus

### Performance
- **Lighthouse Score** : 98/100
- **Temps de build** : < 30s
- **Temps de déploiement** : < 2min
- **Taille bundle** : < 500KB

### Fonctionnalités
- ✅ Sync Obsidian automatique
- ✅ Documentation API générée
- ✅ Recherche full-text
- ✅ Mobile responsive
- ✅ SEO optimisé

## 💡 Bonnes pratiques identifiées

### Architecture
1. **Séparation des responsabilités** : Chaque workflow a un rôle précis
2. **Failsafe** : Gestion des erreurs et rollback automatique
3. **Monitoring** : Lighthouse CI + notifications

### Sécurité
1. **GitHub Secrets** pour les credentials SFTP
2. **Permissions minimales** pour les tokens
3. **Validation** des inputs et sanitization

### Performance
1. **Minification automatique** des assets
2. **Compression images** via imagemin
3. **Cache stratégique** pour les dépendances

## 🚧 Défis rencontrés

### Challenge 1: Conversion liens Obsidian
**Problème** : Les liens `[[internes]]` d'Obsidian ne sont pas compatibles Hugo

**Solution** : Script de conversion avec regex pour transformer les liens Obsidian en shortcodes Hugo

### Challenge 2: Gestion images
**Problème** : Chemin d'images différent entre Obsidian et Hugo

**Solution** : Copie automatique + mise à jour des chemins dans le markdown

### Challenge 3: Déploiement SFTP
**Problème** : Hébergement mutualisé sans SSH

**Solution** : GitHub Action FTP-Deploy avec gestion des erreurs

## 🔮 Améliorations futures

- **Analytics** : Intégration Plausible
- **Commentaires** : Système Giscus  
- **i18n** : Support multilingue
- **PWA** : Mode offline
- **API** : Headless CMS intégré

## 🎓 Leçons apprises

1. **Automatisation complète** > Automatisation partielle
2. **Documentation du workflow** essentielle pour maintenance
3. **Tests automatiques** critiques pour éviter les régressions
4. **Monitoring proactif** plus efficace que réactif

## 💭 Conclusion

Ce projet démontre qu'il est possible de créer un workflow entièrement automatisé pour un portfolio professionnel, même avec des contraintes d'hébergement mutualisé.

Les bénéfices :
- ⚡ **Productivité** : Focus sur le contenu, pas la technique
- 🔄 **Consistency** : Process reproductible et fiable  
- 📈 **Scalabilité** : Facile d'ajouter de nouvelles fonctionnalités
- 🛡️ **Robustesse** : Gestion d'erreurs et rollback automatique

**Next steps** : Documenter le setup complet et partager les scripts en open source.

---

*Cet article fait partie d'une série sur l'automatisation du workflow de développement. [Suivez-moi](/contact/) pour ne pas manquer les prochains !*