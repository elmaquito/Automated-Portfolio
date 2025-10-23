# 🚀 GUIDE PRATIQUE - Système de Prompts pour l'Automatisation

## 🎯 **UTILISATION RAPIDE**

### Commandes PowerShell

```bash
# Créer une nouvelle note technique
.\scripts\create-content.ps1 -Type note -Title "Configuration Docker" -Description "Guide complet de configuration Docker"

# Créer un nouveau projet
.\scripts\create-content.ps1 -Type projet -Title "API REST Node.js" -Category Projects -Difficulty advanced

# Créer un guide
.\scripts\create-content.ps1 -Type guide -Title "Git Workflow" -Category Guides -Difficulty beginner

# Valider un fichier spécifique
.\scripts\validate-content.ps1 -FilePath "content/docs/Notes/mon-fichier.md"

# Valider tous les fichiers
.\scripts\validate-content.ps1
```

## 🤖 **PROMPTS POUR IA (COPILOT/CHATGPT)**

### 1. **Prompt Création de Note Technique**

```
Crée une note technique sur [SUJET] en suivant exactement ce template :

CONTEXTE :
- Portfolio Hugo avec sync Obsidian automatique
- Utilise les shortcodes {{< difficulty >}} et {{< reading-time >}}
- Tags obligatoires : note, technique, [domaine], [technologie]
- Format frontmatter YAML strict

TEMPLATE À SUIVRE :
[Copier le template note-technique-template.md]

SUJET : [DÉCRIRE LE SUJET TECHNIQUE]

INSTRUCTIONS :
1. Remplace TOUS les [PLACEHOLDERS] par du contenu pertinent
2. Utilise des exemples concrets et du code
3. Structure logique : Contexte → Résultats → Analyse → Recommandations
4. Ajoute des émojis pour la lisibilité
5. Estime le temps de lecture réalistement

SORTIE : Markdown complet prêt à copier dans Obsidian
```

### 2. **Prompt Documentation de Projet**

```
Génère la documentation complète pour ce projet :

PROJET : [DESCRIPTION DU PROJET]
TECHNOS : [LISTE DES TECHNOLOGIES]
STATUS : [ÉTAT ACTUEL]

Utilise le template projet-template.md en adaptant :
- Fonctionnalités réelles du projet
- Architecture technique précise
- Métriques de performance si disponibles
- Roadmap basée sur les besoins réels
- Lessons learned authentiques

Structure requise :
✅ Frontmatter YAML complet
✅ Shortcodes {{< difficulty >}} {{< reading-time >}}
✅ Sections : Objectif, Fonctionnalités, Architecture, Installation, Résultats
✅ Code examples fonctionnels
✅ Émojis pour sections

FOCUS : Documentation utile pour développeurs et utilisateurs
```

### 3. **Prompt Amélioration de Contenu Existant**

```
Améliore ce contenu selon les standards du portfolio automatisé :

CONTENU ACTUEL :
[COLLER LE CONTENU À AMÉLIORER]

AMÉLIORATIONS REQUISES :
1. ✅ Ajouter frontmatter YAML si manquant (title, description, tags, date, summary)
2. ✅ Restructurer avec sections logiques et émojis
3. ✅ Ajouter {{< difficulty level="X" >}} et {{< reading-time minutes="X" >}}
4. ✅ Harmoniser le style technique mais accessible
5. ✅ Ajouter exemples concrets et code si pertinent
6. ✅ Créer sections troubleshooting pour contenu technique
7. ✅ Optimiser pour SEO et lisibilité web

STYLE CIBLE :
- Professionnel mais accessible
- Exemples pratiques et actionnables
- Structure claire avec navigation facile
- Métadonnées complètes pour Hugo

SORTIE : Version améliorée complète en Markdown
```

## 📝 **WORKFLOWS D'UTILISATION**

### Workflow 1 : Nouvelle Note Technique

1. **Préparation** (2 min)
   ```bash
   # Créer la structure de base
   .\scripts\create-content.ps1 -Type note -Title "Ma Note" -Description "Description courte"
   ```

2. **Rédaction avec IA** (10 min)
   - Ouvrir le fichier généré
   - Utiliser le prompt "Création de Note Technique" avec l'IA
   - Copier le résultat et remplacer le contenu template

3. **Validation** (2 min)
   ```bash
   # Vérifier la conformité
   .\scripts\validate-content.ps1 -FilePath "content/docs/Notes/ma-note.md"
   ```

4. **Publication** (1 min)
   - Sauvegarder dans Obsidian
   - Auto-commit via plugin Obsidian Git
   - Déploiement automatique via GitHub Actions

### Workflow 2 : Documentation de Projet

1. **Analyse** (5 min)
   - Lister les fonctionnalités principales
   - Identifier les technologies utilisées
   - Rassembler métriques et captures d'écran

2. **Génération** (15 min)
   ```bash
   .\scripts\create-content.ps1 -Type projet -Title "Mon Projet" -Category Projects
   ```
   - Utiliser prompt IA "Documentation de Projet"
   - Adapter avec informations réelles

3. **Enrichissement** (10 min)
   - Ajouter captures d'écran
   - Inclure liens GitHub/demo
   - Compléter métriques réelles

4. **Validation et publication** (3 min)

### Workflow 3 : Amélioration de Contenu Existant

1. **Audit** (5 min)
   ```bash
   .\scripts\validate-content.ps1
   ```

2. **Sélection** (2 min)
   - Identifier les fichiers à améliorer
   - Prioriser selon l'impact

3. **Amélioration** (10 min par fichier)
   - Utiliser prompt "Amélioration de Contenu"
   - Appliquer les suggestions IA
   - Adapter au contexte spécifique

4. **Validation** (2 min)
   ```bash
   .\scripts\validate-content.ps1 -FilePath "fichier-améliore.md"
   ```

## 🎨 **PERSONNALISATION DES PROMPTS**

### Variables à adapter dans vos prompts :

```
[VOTRE_DOMAINE] = "développement web" | "sécurité" | "data science" | ...
[NIVEAU_CIBLE] = "débutant" | "intermédiaire" | "expert"
[STYLE_PREFERE] = "académique" | "pratique" | "tutoriel" | ...
[TECHNOS_FOCUS] = "JavaScript" | "Python" | "DevOps" | ...
```

### Exemple de prompt personnalisé :

```
Tu es un expert en [VOTRE_DOMAINE] écrivant pour un public [NIVEAU_CIBLE].
Crée un [TYPE_CONTENU] sur [SUJET_SPECIFIQUE] en adoptant un style [STYLE_PREFERE].

CONTRAINTES TECHNIQUES :
- Portfolio Hugo + Obsidian sync
- Shortcodes : {{< difficulty >}} {{< reading-time >}}
- Tags : [VOTRE_DOMAINE], [TECHNOS_FOCUS], [CATEGORIE]
- Ton : [PROFESSIONNEL/DÉCONTRACTÉ/ACADÉMIQUE]

[TEMPLATE_APPROPRIÉ]

ADAPTATION REQUISE :
[INSTRUCTIONS_SPÉCIFIQUES_À_VOTRE_CAS]
```

## ⚡ **OPTIMISATIONS AVANCÉES**

### Automatisation complète avec GitHub Copilot

1. **Setup de workspace** :
   ```json
   // .vscode/settings.json
   {
     "github.copilot.enable": {
       "markdown": true
     },
     "markdown.preview.breaks": true,
     "files.associations": {
       "*.md": "markdown"
     }
   }
   ```

2. **Snippets personnalisés** :
   ```json
   // .vscode/markdown.json
   {
     "Note Technique Template": {
       "prefix": "note-tech",
       "body": [
         "---",
         "title: \"$1\"",
         "description: \"$2\"",
         "tags:",
         " - note",
         " - technique",
         " - $3",
         "date: $CURRENT_YEAR-$CURRENT_MONTH-${CURRENT_DATE}T09:00:00Z",
         "---",
         "",
         "{{< difficulty level=\"intermediate\" >}}",
         "",
         "{{< reading-time minutes=\"5\" >}}",
         "",
         "# $1",
         "",
         "## 1. Contexte",
         "$0"
       ]
     }
   }
   ```

3. **Hooks Git pour validation automatique** :
   ```bash
   # .git/hooks/pre-commit
   #!/bin/bash
   
   echo "🔍 Validation automatique du contenu..."
   powershell -ExecutionPolicy Bypass -File scripts/validate-content.ps1
   
   if [ $? -ne 0 ]; then
       echo "❌ Validation échouée. Commit annulé."
       exit 1
   fi
   
   echo "✅ Validation réussie. Commit autorisé."
   ```

## 📊 **MÉTRIQUES ET SUIVI**

### Indicateurs de qualité :

- **Temps de création** : < 15 min par note technique
- **Taux de validation** : > 95% au premier passage
- **Cohérence style** : Templates respectés à 100%
- **SEO** : Métadonnées complètes sur tous les fichiers

### Dashboard de suivi :

```bash
# Statistiques rapides
Get-ChildItem content -Recurse -Filter "*.md" | Measure-Object | Select-Object Count
.\scripts\validate-content.ps1 | Select-String "✅|❌"
```

---

*Guide créé pour optimiser la productivité de rédaction technique*
*Version 1.0 - Portfolio Automatisé Ismael Martinez*