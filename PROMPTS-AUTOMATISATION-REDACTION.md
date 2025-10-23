SYSTÈME DE PROMPTS POUR AUTOMATISATION RÉDACTION
===============================================

## 🎯 **PROMPTS PAR TYPE DE CONTENU**

### 1. 📝 **PROMPT NOUVELLES NOTES TECHNIQUES**

```
Créez une note technique suivant ce template :

---
title: "[TITRE DESCRIPTIF]"
description: "[DESCRIPTION 1-2 PHRASES]"
tags:
 - note
 - technique
 - [DOMAINE] # ex: reseau, securite, dev, ia
 - [TECHNOLOGIE] # ex: python, bash, docker
 - [CONTEXTE] # ex: limayrac, personnel, projet
date: [DATE ISO FORMAT]
summary: "[RÉSUMÉ EN 1 PHRASE]"
---

{{< difficulty level="[beginner|intermediate|advanced|expert]" >}}

{{< reading-time minutes="[ESTIMATION]" >}}

# [TITRE PRINCIPAL]

## 1. Contexte
- **Objectif** : [Que cherchez-vous à accomplir ?]
- **Environnement** : [OS, versions, outils]
- **Prérequis** : [Ce qu'il faut savoir/avoir]

## 2. Résumé rapide
- **Point clé 1** : [Résultat principal]
- **Point clé 2** : [Découverte importante]
- **Point clé 3** : [Recommandation]

## 3. Détails techniques
[Commandes, code, captures d'écran]

## 4. Analyse et résultats
[Interprétation des résultats]

## 5. Recommandations
### Priorité haute
1. [Action urgente]
2. [Correction critique]

### Priorité moyenne
1. [Amélioration]
2. [Optimisation]

## 6. Conclusion
[Synthèse en 2-3 phrases]

---
*Généré le [DATE] - [CONTEXTE]*
```

### 2. 🚀 **PROMPT DOCUMENTATION PROJET**

```
Documentez ce projet selon le template :

---
title: "[NOM DU PROJET]"
description: "[DESCRIPTION CLAIRE DU PROJET]"
tags:
  - projet
  - [TECHNOLOGIE_PRINCIPALE]
  - [DOMAINE] # web, api, automation, tool
  - [STATUT] # dev, prod, maintenance
date: [DATE]
technologies:
  - [TECH_1]
  - [TECH_2]
status: [🚧 En développement|✅ Terminé|🔧 Maintenance|📦 Déployé]
github: [URL_REPO]
demo: [URL_DEMO]
---

{{< difficulty level="[NIVEAU]" >}}

{{< reading-time minutes="[TEMPS]" >}}

# [NOM DU PROJET]

## 🎯 Objectif
[Problème résolu et valeur apportée]

## ⚡ Fonctionnalités

### [Catégorie 1]
- **[Feature]** : [Description avec émoji]
- **[Feature]** : [Description avec émoji]

### [Catégorie 2]  
- **[Feature]** : [Description avec émoji]

## 🏗️ Architecture

### Stack technique
- **Frontend** : [Technologies]
- **Backend** : [Technologies]
- **Base de données** : [Technologies]
- **DevOps** : [Technologies]

### Structure du projet
```
[ARBORESCENCE_SIMPLIFIED]
```

## 🚀 Installation et utilisation

### Prérequis
- [PREREQ_1]
- [PREREQ_2]

### Installation
```bash
[COMMANDES_INSTALLATION]
```

### Configuration
```yaml
[EXEMPLE_CONFIG]
```

## 📊 Résultats et métrics
- **Performance** : [Metrics]
- **Utilisation** : [Stats]
- **Impact** : [Résultats mesurables]

## 🔄 Évolutions prévues
- [ ] [FEATURE_FUTURE_1]
- [ ] [FEATURE_FUTURE_2]

## 📝 Lessons learned
[Ce qui a été appris pendant le développement]
```

### 3. 📖 **PROMPT GUIDES TECHNIQUES**

```
Rédigez un guide technique avec cette structure :

---
title: "Guide [SUJET]"
description: "[OBJECTIF DU GUIDE]"
tags:
 - guide
 - [DOMAINE]
 - [TECHNOLOGIE]
 - [NIVEAU]
date: [DATE]
summary: "[RÉSUMÉ GUIDE]"
---

{{< difficulty level="[NIVEAU]" >}}

{{< reading-time minutes="[TEMPS]" >}}

# 📖 Guide [SUJET]

## 🎯 Objectif de ce guide
[Que va apprendre le lecteur]

## 📋 Prérequis
- [PREREQ_1]
- [PREREQ_2]

## 🏁 Étapes

### Étape 1 : [TITRE_ETAPE]
[DESCRIPTION_DETAILLEE]

```bash/js/py
[CODE_EXEMPLE]
```

**Vérification** : [Comment vérifier que ça marche]

### Étape 2 : [TITRE_ETAPE]
[DESCRIPTION_DETAILLEE]

### Étape 3 : [TITRE_ETAPE]
[DESCRIPTION_DETAILLEE]

## ⚠️ Points d'attention
- **[ATTENTION_1]** : [Détail]
- **[ATTENTION_2]** : [Détail]

## 🐛 Troubleshooting

### Problème : [DESCRIPTION]
**Solution** : [RÉSOLUTION]

### Problème : [DESCRIPTION]
**Solution** : [RÉSOLUTION]

## ✅ Validation finale
[Checklist pour vérifier que tout fonctionne]

## 📚 Ressources additionnelles
- [LIEN_1] : [Description]
- [LIEN_2] : [Description]
```

### 4. 🔧 **PROMPT TROUBLESHOOTING**

```
Documentez ce problème et sa résolution :

---
title: "[PROBLÈME] - Résolution"
description: "Résolution du problème [DESCRIPTION_COURTE]"
tags:
 - troubleshooting
 - [TECHNOLOGIE]
 - [COMPOSANT]
 - [ERREUR_TYPE]
date: [DATE]
summary: "[RÉSUMÉ_SOLUTION]"
---

{{< difficulty level="intermediate" >}}

# 🐛 [PROBLÈME_TITLE]

## ⚠️ Symptômes
[Description de ce qui ne fonctionne pas]

```
[ERREUR_LOG_OU_CAPTURE]
```

## 🔍 Diagnostic

### Environnement
- **OS** : [SYSTEM]
- **Version** : [VERSIONS]
- **Configuration** : [CONFIG_RELEVANTE]

### Analyse
[Étapes d'investigation suivies]

## ✅ Solution

### Étapes de résolution
1. **[ÉTAPE_1]** : [Action précise]
2. **[ÉTAPE_2]** : [Action précise]
3. **[ÉTAPE_3]** : [Action précise]

```bash
[COMMANDES_SOLUTION]
```

### Vérification
[Comment confirmer que c'est résolu]

## 🛡️ Prévention
[Comment éviter que ça se reproduise]

## 📋 Checklist de résolution
- [ ] [VERIF_1]
- [ ] [VERIF_2]
- [ ] [VERIF_3]
```

## 🎨 **PROMPTS POUR IA/COPILOT**

### Prompt Génération de Contenu
```
Tu es un expert en documentation technique. Génère un [TYPE_CONTENU] pour [SUJET] en suivant EXACTEMENT le template du portfolio automatisé d'Ismael Martinez.

CONTEXTE DU PROJET :
- Portfolio Hugo avec synchronisation Obsidian automatique
- Shortcodes disponibles: {{< difficulty >}}, {{< reading-time >}}
- Tags obligatoires selon type de contenu
- Formalisme technique précis requis

INSTRUCTIONS :
1. Utilise le template [TYPE] ci-dessus
2. Remplis TOUS les champs entre [CROCHETS]
3. Adapte le niveau de difficulté au contenu
4. Estime le temps de lecture réalistement
5. Utilise des émojis pour améliorer la lisibilité
6. Structure le contenu de manière logique et progressive

CONTENU À DOCUMENTER :
[DESCRIPTION_DU_CONTENU]

SORTIE ATTENDUE :
Markdown complet prêt à être copié dans Obsidian, avec frontmatter YAML valide et structure complète.
```

### Prompt Amélioration de Contenu Existant
```
Améliore ce contenu selon les standards du portfolio automatisé :

CONTENU ACTUEL :
[CONTENU_EXISTANT]

AMÉLIORATIONS REQUISES :
1. ✅ Ajouter frontmatter YAML complet si manquant
2. ✅ Structurer avec les bonnes sections
3. ✅ Ajouter shortcodes appropriés {{< difficulty >}} {{< reading-time >}}
4. ✅ Améliorer les titres avec émojis
5. ✅ Ajouter exemples de code si pertinent
6. ✅ Créer sections troubleshooting si technique
7. ✅ Harmoniser le tone et style

STYLE REQUIS :
- Technique mais accessible
- Exemples concrets
- Structure claire et logique
- Métadonnées complètes
- Optimisé pour le web
```

## 🤖 **AUTOMATISATION AVANCÉE**

### Script de Génération Automatique
```bash
# Créer automatiquement une nouvelle note
create-note() {
    local type=$1
    local title=$2
    local category=$3
    
    # Générer template selon le type
    case $type in
        "note") template="note-technique-template.md" ;;
        "projet") template="projet-template.md" ;;
        "guide") template="guide-template.md" ;;
        *) echo "Type non supporté" && return 1 ;;
    esac
    
    # Créer fichier avec template
    cp "templates/$template" "docs-source/$category/$title.md"
    
    # Remplacer variables
    sed -i "s/\[DATE\]/$(date -u +%Y-%m-%dT%H:%M:%SZ)/g" "docs-source/$category/$title.md"
    sed -i "s/\[TITRE\]/$title/g" "docs-source/$category/$title.md"
    
    echo "✅ Note créée : docs-source/$category/$title.md"
}
```

### Validation Automatique
```bash
# Valider le contenu avant commit
validate-content() {
    local file=$1
    
    # Vérifier frontmatter
    if ! head -n 20 "$file" | grep -q "^---$"; then
        echo "❌ Frontmatter manquant dans $file"
        return 1
    fi
    
    # Vérifier tags obligatoires
    if ! grep -q "tags:" "$file"; then
        echo "❌ Tags manquants dans $file"
        return 1
    fi
    
    # Vérifier structure minimale
    if ! grep -q "^# " "$file"; then
        echo "❌ Titre principal manquant dans $file"
        return 1
    fi
    
    echo "✅ $file validé"
}
```

---

## 📋 **CHECKLIST D'UTILISATION**

### Avant de créer du contenu :
- [ ] Identifier le type de contenu (Note, Projet, Guide, Troubleshooting)
- [ ] Choisir le template approprié
- [ ] Préparer les informations requises (tags, technos, niveau)

### Pendant la rédaction :
- [ ] Suivre la structure du template
- [ ] Remplir TOUS les champs du frontmatter
- [ ] Ajouter les shortcodes appropriés
- [ ] Structurer avec des sections claires

### Après la rédaction :
- [ ] Valider le frontmatter YAML
- [ ] Vérifier la syntaxe Markdown
- [ ] Tester les liens internes
- [ ] Commit avec message descriptif

---

*Système de prompts v1.0 - Optimisé pour Portfolio Automatisé Ismael Martinez*