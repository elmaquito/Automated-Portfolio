# 🔍 Guide des Validations Markdown - Workflow GitHub Actions

## 🎯 Vue d'ensemble

Le workflow GitHub Actions inclut maintenant des validations automatiques pour s'assurer que tous les fichiers Markdown sont corrects avant le déploiement.

## ✅ Validations Automatiques

### 1. **Vérification des conflits Git**
- Détecte les marqueurs `<<<<<<< HEAD`, `=======`, `>>>>>>> `
- Bloque le déploiement si des conflits non résolus sont trouvés

### 2. **Validation YAML Frontmatter**
- Vérifie que chaque fichier `.md` commence par `---`
- S'assure que le frontmatter contient au minimum un `title:`
- Détecte les frontmatters vides ou malformés

### 3. **Vérification des références internes**
- Identifie les liens `{{< ref >}}` avec chemins relatifs
- Recommande l'usage de chemins absolus (`/docs/...`)
- Détecte les références potentiellement cassées

### 4. **Build Hugo robuste**
- Capture et analyse les erreurs Hugo
- Fournit des solutions spécifiques pour `REF_NOT_FOUND`
- Diagnostique les erreurs YAML pendant le build

## 🚫 Comment Skip les Validations

### Option 1 : Skip via commit message
```bash
git commit -m "Update docs [skip-validation]"
# ou
git commit -m "Fix urgent issue [skip-md]"
```

### Option 2 : Skip temporaire dans le workflow
Ajoutez `continue-on-error: true` à l'étape spécifique :
```yaml
- name: ✅ Validate Markdown files
  continue-on-error: true  # Skip si erreurs non-critiques
```

## 📋 Types d'Erreurs et Solutions

### ❌ **Merge Conflicts**
```
❌ Merge conflict markers found in content files!
```
**Solution :**
1. Résoudre manuellement les conflits
2. Supprimer tous les marqueurs `<<<<<<<`, `=======`, `>>>>>>>`
3. Recommiter

### ❌ **YAML Frontmatter Invalide**
```
❌ Missing frontmatter in: content/docs/example.md
```
**Solution :**
```yaml
---
title: "Votre Titre"
description: "Description"
date: 2025-10-20
---
```

### ❌ **Références Cassées**
```
REF_NOT_FOUND: Ref "liens-internes": page not found
```
**Solution :**
```markdown
# Au lieu de :
{{< ref "liens-internes" >}}

# Utiliser :
{{< ref "/docs/guides/liens-internes.md" >}}
```

## 🛠️ Workflow de Debugging

### 1. **Erreur dans GitHub Actions**
1. Aller dans **Actions** tab
2. Cliquer sur le workflow échoué
3. Examiner l'étape "Validate Markdown files"
4. Corriger les fichiers identifiés

### 2. **Test local avant commit**
```bash
# Vérifier les conflits
grep -r "<<<<<<< HEAD" content/

# Vérifier les frontmatters
find content/ -name "*.md" -exec head -n 3 {} \;

# Test Hugo local
hugo --minify --enableGitInfo
```

### 3. **Bypass d'urgence**
Si correction impossible immédiatement :
```bash
git commit -m "Emergency fix [skip-validation]"
git push
```

## 📊 Monitoring des Validations

### Statuts dans GitHub Actions
- ✅ **Green** : Toutes validations passées
- ⚠️ **Yellow** : Warnings mais continue
- ❌ **Red** : Erreurs bloquantes

### Logs détaillés
Chaque validation affiche :
- Fichiers vérifiés ✅
- Erreurs trouvées ❌  
- Solutions suggérées 💡

## 🔧 Configuration Avancée

### Variables d'environnement
```yaml
env:
  SKIP_MD_VALIDATION: false    # Force skip
  VALIDATION_LEVEL: strict     # strict|warn|skip
```

### Personnalisation des règles
Modifiez `.github/workflows/deploy.yml` section "Validate Markdown files" pour :
- Ajouter nouvelles vérifications
- Modifier les patterns de détection
- Changer les messages d'erreur

## 💡 Bonnes Pratiques

### Structure recommandée
```
content/
├── docs/
│   ├── _index.md           # Page d'accueil docs
│   ├── guides/
│   │   └── guide.md        # {{< ref "/docs/guides/guide.md" >}}
│   └── projects/
│       └── project.md      # {{< ref "/docs/projects/project.md" >}}
```

### Frontmatter minimal
```yaml
---
title: "Titre Obligatoire"
description: "Description recommandée" 
date: 2025-10-20
tags: ["tag1", "tag2"]          # Optionnel
---
```

### Liens internes sécurisés
```markdown
# ✅ Recommandé (chemin absolu)
[Lien vers guide]({{< ref "/docs/guides/guide.md" >}})

# ⚠️ Éviter (chemin relatif)
[Lien vers guide]({{< ref "guide" >}})
```

---

**Mis à jour :** 20 octobre 2025  
**Version workflow :** v2.1 avec validations  
**Prochaine révision :** Décembre 2025