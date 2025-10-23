# =========================================
# SCRIPT D'AUTOMATISATION DE RÉDACTION
# Portfolio Automatisé - Ismael Martinez
# =========================================

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("note", "projet", "guide", "troubleshooting")]
    [string]$Type,
    
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Notes", "Projects", "Guides")]
    [string]$Category = "Notes",
    
    [Parameter(Mandatory=$false)]
    [string]$Description = "",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("beginner", "intermediate", "advanced", "expert")]
    [string]$Difficulty = "intermediate"
)

function Write-ColoredOutput {
    param($Message, $Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Get-CurrentDate {
    return (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
}

function Create-FileName {
    param($Title, $Category)
    
    # Nettoyer le titre pour créer un nom de fichier valide
    $cleanTitle = $Title -replace '[^a-zA-Z0-9\s\-]', '' `
                        -replace '\s+', '-' `
                        -replace '-+', '-' `
                        -replace '^-|-$', ''
    
    return "content/docs/$Category/$cleanTitle.md"
}

function Get-Template {
    param($Type)
    
    $templatePath = "templates/$Type-template.md"
    
    if (Test-Path $templatePath) {
        return Get-Content $templatePath -Raw
    } else {
        Write-ColoredOutput "❌ Template $templatePath non trouvé" "Red"
        return $null
    }
}

function Replace-Variables {
    param($Content, $Title, $Description, $Difficulty)
    
    $currentDate = Get-CurrentDate
    
    $replacements = @{
        '\[TITRE_NOTE\]' = $Title
        '\[TITRE_PRINCIPAL\]' = $Title  
        '\[NOM_DU_PROJET\]' = $Title
        '\[SUJET\]' = $Title
        '\[DESCRIPTION_1_2_PHRASES\]' = $Description
        '\[DESCRIPTION_CLAIRE_DU_PROJET\]' = $Description
        '\[OBJECTIF_DU_GUIDE\]' = $Description
        '\[DATE_ISO\]' = $currentDate
        '\[beginner\|intermediate\|advanced\|expert\]' = $Difficulty
        '\[ESTIMATION\]' = "5"
        '\[RÉSUMÉ_EN_1_PHRASE\]' = $Description
        '\[RÉSUMÉ_GUIDE\]' = $Description
        '\[DATE\]' = $currentDate
    }
    
    $result = $Content
    foreach ($replacement in $replacements.GetEnumerator()) {
        $result = $result -replace $replacement.Key, $replacement.Value
    }
    
    return $result
}

function Create-ContentFile {
    param($Type, $Title, $Category, $Description, $Difficulty)
    
    Write-ColoredOutput "🚀 Création d'un nouveau $Type : $Title" "Cyan"
    Write-ColoredOutput "📁 Catégorie : $Category" "Yellow"
    Write-ColoredOutput "📝 Description : $Description" "Gray"
    Write-ColoredOutput "⚡ Difficulté : $Difficulty" "Magenta"
    
    # Obtenir le template
    $template = Get-Template $Type
    if (-not $template) {
        return
    }
    
    # Créer le nom de fichier
    $fileName = Create-FileName $Title $Category
    $fullPath = $fileName
    
    # Vérifier si le dossier existe
    $directory = Split-Path $fullPath -Parent
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
        Write-ColoredOutput "📁 Dossier créé : $directory" "Green"
    }
    
    # Remplacer les variables
    $content = Replace-Variables $template $Title $Description $Difficulty
    
    # Vérifier si le fichier existe déjà
    if (Test-Path $fullPath) {
        $response = Read-Host "⚠️  Le fichier $fullPath existe déjà. Écraser ? (y/N)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            Write-ColoredOutput "❌ Création annulée" "Red"
            return
        }
    }
    
    # Créer le fichier
    $content | Out-File -FilePath $fullPath -Encoding UTF8
    
    Write-ColoredOutput "✅ Fichier créé : $fullPath" "Green"
    
    # Ouvrir dans VS Code si disponible
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Write-ColoredOutput "🎯 Ouverture dans VS Code..." "Blue"
        & code $fullPath
    }
    
    # Instructions suivantes
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "📋 PROCHAINES ÉTAPES :" "Yellow"
    Write-ColoredOutput "1. ✏️  Compléter le contenu en remplaçant les [PLACEHOLDERS]" "White"
    Write-ColoredOutput "2. 🏷️  Ajuster les tags dans le frontmatter YAML" "White"
    Write-ColoredOutput "3. ⚡ Vérifier le niveau de difficulté" "White"
    Write-ColoredOutput "4. ⏱️  Estimer le temps de lecture" "White"
    Write-ColoredOutput "5. 💾 Sauvegarder et committer avec Obsidian Git" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "🔗 Le fichier sera automatiquement synchronisé vers le site web !" "Green"
}

function Show-Help {
    Write-ColoredOutput "📚 AIDE - Script de création automatique de contenu" "Cyan"
    Write-ColoredOutput "=====================================================" "Cyan"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "UTILISATION :" "Yellow"
    Write-ColoredOutput "  .\scripts\create-content.ps1 -Type [TYPE] -Title ""[TITRE]"" [-Category [CATEGORIE]] [-Description ""[DESC]""] [-Difficulty [NIVEAU]]" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "PARAMÈTRES :" "Yellow"
    Write-ColoredOutput "  -Type        : note | projet | guide | troubleshooting" "White"
    Write-ColoredOutput "  -Title       : Titre du contenu (obligatoire)" "White"
    Write-ColoredOutput "  -Category    : Notes | Projects | Guides (défaut: Notes)" "White"
    Write-ColoredOutput "  -Description : Description courte (optionnel)" "White"
    Write-ColoredOutput "  -Difficulty  : beginner | intermediate | advanced | expert (défaut: intermediate)" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "EXEMPLES :" "Yellow"
    Write-ColoredOutput "  # Créer une note technique" "Gray"
    Write-ColoredOutput "  .\scripts\create-content.ps1 -Type note -Title ""Configuration Docker"" -Description ""Guide de configuration Docker pour le développement""" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "  # Créer un projet" "Gray"
    Write-ColoredOutput "  .\scripts\create-content.ps1 -Type projet -Title ""API REST Node.js"" -Category Projects -Difficulty advanced" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "  # Créer un guide" "Gray"
    Write-ColoredOutput "  .\scripts\create-content.ps1 -Type guide -Title ""Git Workflow"" -Category Guides -Difficulty beginner" "White"
}

# =========================================
# EXÉCUTION PRINCIPALE
# =========================================

Write-ColoredOutput "🎨 GÉNÉRATEUR DE CONTENU - Portfolio Automatisé" "Cyan"
Write-ColoredOutput "=================================================" "Cyan"

if ($args -contains "-help" -or $args -contains "--help" -or $args -contains "/?" -or $args -contains "-h") {
    Show-Help
    exit 0
}

try {
    # Vérifier que nous sommes dans le bon répertoire
    if (-not (Test-Path "templates") -or -not (Test-Path "content")) {
        Write-ColoredOutput "❌ Erreur : Ce script doit être exécuté depuis la racine du projet Portfolio Automatisé" "Red"
        Write-ColoredOutput "📁 Vérifiez que vous êtes dans le bon répertoire (doit contenir /templates et /content)" "Yellow"
        exit 1
    }
    
    # Créer le contenu
    Create-ContentFile $Type $Title $Category $Description $Difficulty
    
} catch {
    Write-ColoredOutput "❌ Erreur lors de la création : $($_.Exception.Message)" "Red"
    exit 1
}

Write-ColoredOutput "" "White"
Write-ColoredOutput "🎉 Script terminé avec succès !" "Green"