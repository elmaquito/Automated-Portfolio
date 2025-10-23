# GUIDE BONNES PRATIQUES - Caracteres et Encodage
=====================================================

## PROBLEMATIQUE

Les caracteres speciaux et accents causent des problemes d'encodage dans :
- GitHub Actions (environnements Linux/Windows)
- Hugo builds (parsing YAML/Markdown)
- PowerShell scripts (execution cross-platform)
- Synchronisation Obsidian (Git hooks)

## REGLES A RESPECTER

### 1. TEMPLATES
- **INTERDIRE** : àáâäçéèêëïîôöùúûü
- **UTILISER** : aeiouc sans accents
- **EMOJIS** : Eviter dans les templates (OK dans le contenu final)

### 2. NOMS DE FICHIERS
- **FORMAT** : kebab-case uniquement
- **CARACTERES** : a-z, 0-9, tirets uniquement
- **EXEMPLES** :
  - ✅ `guide-installation-docker.md`
  - ❌ `guide-installation-côté-serveur.md`

### 3. VARIABLES DE TEMPLATES
- **FORMAT** : MAJUSCULES_AVEC_UNDERSCORES
- **EXEMPLES** :
  - ✅ `[RESUME_GUIDE]`
  - ❌ `[RÉSUMÉ_GUIDE]`

### 4. CONTENU MARKDOWN
- **TITRES** : Pas d'accents dans les # (affectent les anchors)
- **METADATA** : Frontmatter YAML sans accents pour les cles
- **CONTENU** : OK pour les accents dans le texte final

## LISTE DE REMPLACEMENT

### Mots courants à remplacer :
```
à → a
é → e  
è → e
ê → e
ë → e
î → i
ï → i
ô → o
ö → o
ù → u
ú → u  
û → u
ü → u
ç → c

Résumé → Resume
Prérequis → Prerequis
Étapes → Etapes
Création → Creation
Sécurité → Securite
Données → Donnees
Métrique → Metrique
Évolution → Evolution
Fonctionnalité → Fonctionnalite
Amélioration → Amelioration
Bénéfice → Benefice
Précaution → Precaution
Vérification → Verification
Intérêt → Interet
Complémentaire → Complementaire
Créé → Cree
Générée → Generee
Dernière → Derniere
```

## SCRIPT DE VALIDATION

```powershell
# Detecter les caracteres problematiques
function Test-AccentedCharacters {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw
    $accentedChars = @('à','á','â','ä','ç','é','è','ê','ë','í','ì','î','ï','ó','ò','ô','ö','ú','ù','û','ü','ý','ÿ')
    
    foreach ($char in $accentedChars) {
        if ($content -match $char) {
            Write-Host "❌ Caractere accentue detecte : $char" -ForegroundColor Red
            return $false
        }
    }
    
    Write-Host "✅ Aucun caractere accentue detecte" -ForegroundColor Green
    return $true
}
```

## CONFIGURATION EDITEURS

### VS Code settings.json
```json
{
    "files.encoding": "utf8",
    "files.eol": "\n",
    "markdown.validate.enabled": true,
    "markdown.validate.ignoredLinks": ["#"]
}
```

### Git configuration
```bash
git config core.autocrlf false
git config core.safecrlf warn
```

## CHECKLIST PRE-COMMIT

- [ ] Aucun accent dans les noms de fichiers
- [ ] Aucun accent dans les cles YAML frontmatter  
- [ ] Variables de templates en MAJUSCULES sans accents
- [ ] Titres Markdown (#) sans caracteres speciaux
- [ ] Test d'encodage UTF-8 passe

## CORRECTION AUTOMATIQUE

### Script de nettoyage
```powershell
function Clean-AccentedCharacters {
    param($FilePath)
    
    $replacements = @{
        'à'='a'; 'á'='a'; 'â'='a'; 'ä'='a'
        'é'='e'; 'è'='e'; 'ê'='e'; 'ë'='e'  
        'í'='i'; 'ì'='i'; 'î'='i'; 'ï'='i'
        'ó'='o'; 'ò'='o'; 'ô'='o'; 'ö'='o'
        'ú'='u'; 'ù'='u'; 'û'='u'; 'ü'='u'
        'ç'='c'; 'ý'='y'; 'ÿ'='y'
    }
    
    $content = Get-Content $FilePath -Raw
    
    foreach ($replacement in $replacements.GetEnumerator()) {
        $content = $content -replace $replacement.Key, $replacement.Value
    }
    
    $content | Out-File -FilePath $FilePath -Encoding UTF8
    Write-Host "✅ Fichier nettoye : $FilePath" -ForegroundColor Green
}
```

## IMPACT SUR LE PROJET

### Fichiers a corriger :
1. **Templates** : ✅ Corriges
2. **Scripts PowerShell** : ✅ Corriges  
3. **Documentation existante** : 🔄 A corriger
4. **Fichiers de contenu** : 🔄 A auditer

### Actions recommandees :
1. Audit complet des fichiers existants
2. Correction systematique des accents
3. Mise a jour des scripts de validation
4. Documentation des bonnes pratiques pour l'equipe

---
*Guide cree le 2025-10-23 - Version sans accents optimisee*