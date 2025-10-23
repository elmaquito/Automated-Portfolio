# 📋 PRÉREQUIS COMPLETS POUR PUBLICATION DE PAGES

## 🎯 **GUIDE TECHNIQUE COMPLET**

*Basé sur l'analyse approfondie des problèmes rencontrés lors de la publication de la fiche synthétique Hugo & GitHub Actions*

---

## 1. **📁 STRUCTURE DE FICHIERS REQUISE**

### ✅ Structure obligatoire
```
content/
├── docs/
│   ├── _index.md (obligatoire)
│   ├── Notes/
│   │   └── votre-fichier.md
│   ├── Projects/
│   │   └── votre-projet.md
│   └── Guides/
│       └── votre-guide.md
├── blog/
├── projects/
└── about/
```

### ⚠️ Problèmes identifiés
- **Dossiers vides** : Hugo ignore les dossiers sans `_index.md`
- **Noms avec caractères spéciaux** : Éviter accents, espaces, caractères unicode

---

## 2. **🏗️ CONFIGURATION HUGO (hugo.toml)**

### ✅ Configuration minimale requise
```toml
baseURL = "https://votre-domaine.com"
languageCode = "fr"
title = "Votre Titre"

contentDir = "content"
publishDir = "public"
enableGitInfo = true
enableEmoji = true

[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true  # OBLIGATOIRE pour shortcodes HTML
    [markup.goldmark.parser]
      [markup.goldmark.parser.attribute]
        block = true
        title = true

defaultContentLanguage = "fr"
```

### ⚠️ Problèmes identifiés
- **Thème désactivé** : Sans thème actif, besoins de layouts personnalisés
- **Configuration markup** : `unsafe = true` obligatoire pour les shortcodes
- **Langue** : Doit correspondre au contenu

---

## 3. **🎨 LAYOUTS OBLIGATOIRES**

### ✅ Fichiers requis dans `layouts/`
```
layouts/
├── _default/
│   ├── baseof.html      # Template de base (OBLIGATOIRE)
│   ├── single.html      # Pages individuelles (OBLIGATOIRE)
│   └── list.html        # Pages de liste (OBLIGATOIRE)
├── shortcodes/
│   ├── difficulty.html  # Shortcode niveau
│   └── reading-time.html # Shortcode temps lecture
└── index.html           # Page d'accueil
```

### ⚠️ Vérifications obligatoires
```bash
# Vérifier que les layouts existent
Test-Path "layouts/_default/baseof.html"
Test-Path "layouts/_default/single.html" 
Test-Path "layouts/_default/list.html"
```

---

## 4. **📝 FORMAT FRONTMATTER STRICT**

### ✅ Format YAML obligatoire
```yaml
---
title: "Titre Sans Accents"
description: "Description sans caracteres speciaux"
tags: ["tag1", "tag2", "tag3"]  # FORMAT ARRAY OBLIGATOIRE
date: 2025-10-23T13:15:05Z      # FORMAT ISO OBLIGATOIRE
summary: "Resume court"
---
```

### ❌ Formats problématiques identifiés
```yaml
# ❌ ÉVITER - Tags multilignes (causent des erreurs)
tags:
 - tag1
 - tag2

# ❌ ÉVITER - Caractères spéciaux
title: "Fiche Synthétique"  # Accents
description: "Déscription avec accents"

# ❌ ÉVITER - Date mal formatée
date: 2025-10-23  # Pas assez précis
```

### ✅ Format correct validé
```yaml
---
title: "Fiche Synthetique Hugo GitHub Actions"
description: "Guide complet Hugo et GitHub Actions sans accents"
tags: ["hugo", "github-actions", "deployment"]
date: 2025-10-23T13:15:05Z
summary: "Guide deploiement automatise"
---
```

---

## 5. **📄 NOMMAGE DES FICHIERS**

### ✅ Conventions obligatoires
- **Caractères autorisés** : `a-z`, `A-Z`, `0-9`, `-`, `_`
- **Extension** : `.md` obligatoire
- **Casse** : Peu importe (Hugo normalise)

### ✅ Exemples valides
```
note-technique.md              → public/docs/notes/note-technique/
hugo-github-actions.md         → public/docs/notes/hugo-github-actions/
guide-utilisation.md           → public/docs/guides/guide-utilisation/
```

### ❌ Noms problématiques identifiés
```
❌ Fiche-Synthetique-Hugo-GitHub-Actions.md  # Trop long, caractères spéciaux
❌ Note Technique.md                          # Espaces
❌ Guide_Français.md                          # Accents
❌ test@example.md                            # Caractères spéciaux
```

### 🔧 Solutions de nommage
```bash
# Règle : Maximum 50 caractères, snake_case ou kebab-case
hugo-github-actions.md          ✅
fiche-synthetique-hugo.md       ✅ 
guide-utilisation-obsidian.md   ✅
```

---

## 6. **🔧 SHORTCODES OBLIGATOIRES**

### ✅ Shortcodes requis pour les templates
```html
<!-- layouts/shortcodes/difficulty.html -->
{{ $level := .Get "level" | default "beginner" }}
<div class="difficulty-badge">
    <span>Niveau: {{ $level }}</span>
</div>

<!-- layouts/shortcodes/reading-time.html -->
{{ $minutes := .Get "minutes" | default "5" }}
<div class="reading-time-badge">
    <span>Temps: {{ $minutes }} min</span>
</div>
```

### ✅ Utilisation dans le contenu
```markdown
{{< difficulty level="intermediate" >}}
{{< reading-time minutes="8" >}}
```

---

## 7. **⚡ PROCESSUS DE GÉNÉRATION**

### ✅ Commandes de build recommandées
```bash
# 1. Nettoyage complet (obligatoire après problèmes)
hugo --cleanDestinationDir

# 2. Build de production
hugo --gc --minify

# 3. Build avec drafts pour test
hugo --buildDrafts

# 4. Vérification du build
hugo --dry-run
```

### ⚠️ Vérifications post-build
```powershell
# Vérifier que la page est générée
Test-Path "public/docs/notes/votre-fichier/index.html"

# Compter les pages générées
(Get-ChildItem "public" -Recurse -Filter "*.html").Count

# Vérifier la structure
Get-ChildItem "public/docs/notes" -Name
```

---

## 8. **🔍 DÉBOGAGE ET DIAGNOSTICS**

### ✅ Checklist de débogage
```bash
# 1. Vérifier la structure
hugo config | grep -E "(contentDir|publishDir)"

# 2. Vérifier les erreurs
hugo --debug

# 3. Lister les pages trouvées
hugo list all

# 4. Build verbose
hugo --verbose --debug
```

### ⚠️ Problèmes courants identifiés
1. **Cache Hugo** : Utiliser `--cleanDestinationDir`
2. **Frontmatter mal formaté** : Vérifier syntaxe YAML
3. **Nom de fichier problématique** : Renommer avec conventions
4. **Shortcodes manquants** : Vérifier `layouts/shortcodes/`
5. **Templates manquants** : Vérifier `layouts/_default/`

---

## 9. **📊 VALIDATION AUTOMATIQUE**

### ✅ Script de validation amélioré
```powershell
# scripts/validate-publication.ps1
param($FilePath)

Write-Host "🔍 Validation publication : $FilePath" -ForegroundColor Cyan

# Test 1: Existence du fichier
if (-not (Test-Path $FilePath)) {
    Write-Host "❌ Fichier non trouvé" -ForegroundColor Red
    exit 1
}

# Test 2: Nom de fichier valide
$fileName = Split-Path $FilePath -Leaf
if ($fileName -match '[^a-zA-Z0-9\-_.]') {
    Write-Host "❌ Nom de fichier contient des caractères invalides" -ForegroundColor Red
    exit 1
}

# Test 3: Frontmatter YAML
$content = Get-Content $FilePath -Raw
if (-not ($content -match '^---\r?\n.*?\r?\n---\r?\n')) {
    Write-Host "❌ Frontmatter YAML manquant ou mal formaté" -ForegroundColor Red
    exit 1
}

# Test 4: Tags au format array
if ($content -match 'tags:\s*\n\s*-') {
    Write-Host "❌ Tags au format multiligne détecté - utiliser format array" -ForegroundColor Red
    exit 1
}

# Test 5: Génération Hugo
hugo --dry-run 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreurs de génération Hugo" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Validation réussie - Prêt pour publication" -ForegroundColor Green
```

---

## 10. **🚀 CHECKLIST COMPLÈTE AVANT PUBLICATION**

### 📋 Checklist obligatoire
```
□ Nom de fichier respecte les conventions (a-z, A-Z, 0-9, -, _)
□ Frontmatter YAML correct avec tags au format array
□ Shortcodes difficulty et reading-time présents
□ Contenu sans accents ni caractères spéciaux problématiques
□ Layouts _default/ complets (baseof.html, single.html, list.html)
□ Shortcodes définis dans layouts/shortcodes/
□ hugo --cleanDestinationDir avant génération
□ hugo --gc --minify réussit sans erreur
□ Page générée visible dans public/
□ Test d'accès à l'URL finale
```

### 🔧 Commandes de validation finale
```bash
# 1. Validation du fichier
.\scripts\validate-publication.ps1 -FilePath "content/docs/Notes/mon-fichier.md"

# 2. Génération propre
hugo --cleanDestinationDir && hugo --gc --minify

# 3. Vérification post-génération
Test-Path "public/docs/notes/mon-fichier/index.html"

# 4. Test local
hugo server --buildDrafts
```

---

## 🏁 **RÉSUMÉ DES PROBLÈMES RÉSOLUS**

### ❌ Problème initial
- Fichier `Fiche-Synthetique-Hugo-GitHub-Actions.md` non publié
- Hugo générait 100 pages mais fichier absent du public/

### ✅ Causes identifiées
1. **Nom de fichier trop complexe** avec caractères spéciaux
2. **Format frontmatter** avec tags multilignes
3. **Cache Hugo** non nettoyé
4. **Validation insuffisante** avant publication

### 🎯 Solution appliquée
1. **Renommage** : `hugo-github-actions.md` (simple et propre)
2. **Frontmatter corrigé** : tags au format array
3. **Nettoyage cache** : `--cleanDestinationDir`
4. **Checklist systématique** pour éviter récidive

---

*Guide créé suite à l'analyse complète des problèmes de publication*
*Version 1.0 - Portfolio Automatisé Ismael Martinez - 2025-10-23*