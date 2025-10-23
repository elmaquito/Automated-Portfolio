# 🤖 PROMPTS IA OPTIMISÉS POUR TEMPLATES

## 🎯 **PROMPT UNIVERSEL POUR COMPLÉTER UN TEMPLATE**

```
CONTEXTE : Portfolio technique Hugo avec templates automatisés

MISSION : Complète ce template avec du contenu professionnel et pertinent

TEMPLATE À COMPLÉTER :
[COLLER LE CONTENU DU FICHIER GÉNÉRÉ]

SUJET : [DÉCRIRE LE SUJET PRÉCIS]

CONTRAINTES :
✅ Remplace TOUS les [PLACEHOLDERS] par du contenu réel
✅ Garde la structure exacte du template
✅ Utilise un ton professionnel mais accessible
✅ Ajoute des exemples concrets et du code fonctionnel
✅ Respecte les balises Hugo existantes
✅ Estime correctement le temps de lecture
✅ Ajoute des émojis pour la lisibilité

STYLE :
- Exemples pratiques et actionables
- Code testé et fonctionnel
- Métriques réalistes
- Recommandations concrètes

SORTIE : Template complètement rempli, prêt à publier
```

## 📋 **PROMPTS SPÉCIALISÉS PAR TYPE**

### PROMPT NOTE TECHNIQUE

```
Crée une note technique complète sur [SUJET] en utilisant ce template.

CONTEXTE TECHNIQUE :
- Environnement : [Windows/Linux/macOS + versions]
- Technologies : [langages, frameworks, outils]
- Niveau public : [débutant/intermédiaire/expert]
- Objectif : [résoudre problème/documenter/expliquer]

TEMPLATE DE BASE :
[COLLER LE TEMPLATE GÉNÉRÉ]

EXIGENCES CONTENU :
1. **Contexte** : Situation réelle et environnement précis
2. **Résumé** : 3 points clés actionnables
3. **Code** : Exemples testés et fonctionnels
4. **Métriques** : Données réelles (temps, performance, etc.)
5. **Recommandations** : Actions concrètes priorisées
6. **Troubleshooting** : Problèmes courants et solutions

STYLE :
- Très pratique et actionnable
- Code copy-paste ready
- Pas de blabla, que de l'utile
- Émojis pour structurer

ATTENTION : Garde absolument la structure YAML et les shortcodes Hugo
```

### PROMPT DOCUMENTATION PROJET

```
Documente ce projet en mode showcase professionnel.

PROJET : [DESCRIPTION DU PROJET]
REPO/DEMO : [LIENS SI DISPONIBLES]
TECHNOLOGIES : [STACK TECHNIQUE]
STATUT : [EN COURS/TERMINÉ/ABANDONNÉ]

TEMPLATE À REMPLIR :
[COLLER LE TEMPLATE PROJET]

FOCUS DOCUMENTATION :
1. **Problème résolu** : Quel besoin business/technique
2. **Solution apportée** : Architecture et choix techniques
3. **Résultats concrets** : Métriques, performances, adoption
4. **Apprentissages** : Difficultés et solutions trouvées
5. **Évolutions** : Roadmap réaliste

PREUVES À INCLURE :
- Screenshots ou GIFs de démo
- Métriques réelles (temps, performance, usage)
- Code snippets des parties importantes
- Liens vers repo/démo fonctionnels

AUDIENCE : Recruteurs, développeurs, clients potentiels

SORTIE : Documentation complète prête pour portfolio professionnel
```

### PROMPT GUIDE PRATIQUE

```
Crée un guide pratique étape par étape sur [SUJET].

OBJECTIF GUIDE : [À QUOI ÇA SERT]
PUBLIC CIBLE : [NIVEAU ET PROFIL]
CONTEXTE D'USAGE : [QUAND L'UTILISER]

TEMPLATE DE BASE :
[COLLER LE TEMPLATE GUIDE]

STRUCTURE REQUISE :
1. **Introduction** : Pourquoi ce guide, prérequis
2. **Étapes détaillées** : Actions concrètes numérotées
3. **Exemples pratiques** : Cas d'usage réels
4. **Validation** : Comment vérifier que ça marche
5. **Troubleshooting** : Problèmes fréquents
6. **Références** : Liens utiles et documentation

FORMAT :
- Étapes numérotées claires
- Code blocks avec syntaxe highlighting
- Captures d'écran si pertinent
- Checkboxes pour suivre la progression
- Warnings pour les points critiques

TONE : Tutorial YouTube écrit - claire, progressive, encourageante
```

## ⚡ **WORKFLOW OPTIMISÉ AVEC IA**

### Étape 1 : Génération du Template
```powershell
.\scripts\create-content-simple.ps1 -Type note -Title "Mon Sujet" -Description "Description courte"
```

### Étape 2 : Copie du Contenu
1. Ouvrir le fichier généré
2. Copier tout le contenu
3. Aller sur ChatGPT/Copilot

### Étape 3 : Prompt IA
```
[UTILISER UN DES PROMPTS CI-DESSUS]
TEMPLATE À COMPLÉTER :
[COLLER LE CONTENU DU FICHIER]

SUJET : [VOTRE SUJET PRÉCIS]
```

### Étape 4 : Remplacement
1. Copier la réponse de l'IA
2. Remplacer le contenu du fichier
3. Relire et ajuster si nécessaire

### Étape 5 : Validation
```powershell
.\scripts\validate-content.ps1 -FilePath "chemin/vers/fichier.md"
```

## 🎨 **PERSONNALISATION DES PROMPTS**

### Variables à Adapter

```
[VOTRE_EXPERTISE] = "développement web", "cybersécurité", "data science"
[VOTRE_STYLE] = "académique", "pratique", "business"
[VOTRE_PUBLIC] = "débutants", "professionnels", "étudiants"
[VOS_TECHNOS] = "JavaScript", "Python", "DevOps", "React"
```

### Exemple Personnalisé

```
Tu es un expert en [VOTRE_EXPERTISE] avec un style [VOTRE_STYLE].
Ton public est : [VOTRE_PUBLIC].
Tes technologies de prédilection : [VOS_TECHNOS].

[PROMPT DE BASE]

ADAPTATION SPÉCIFIQUE :
- Utilise des exemples en [VOS_TECHNOS]
- Niveau de détail adapté à [VOTRE_PUBLIC]
- Tons et références [VOTRE_STYLE]
```

## 📊 **MÉTRIQUES D'EFFICACITÉ**

### Objectifs de Performance
- **Temps de création** : < 10 minutes par note
- **Qualité** : Validation automatique OK à 100%
- **Cohérence** : Style uniforme sur tout le portfolio
- **Productivité** : 3-5 contenus de qualité par heure

### Indicateurs de Qualité
- ✅ Frontmatter YAML complet
- ✅ Shortcodes Hugo présents
- ✅ Structure logique respectée
- ✅ Code examples fonctionnels
- ✅ Métadonnées SEO optimales

---

*Guide d'utilisation optimisé pour maximiser l'efficacité des templates automatisés*