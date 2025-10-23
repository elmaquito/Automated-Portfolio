# Script d'automatisation de redaction - Portfolio Automatise
# Ismael Martinez - 2025

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

function New-FileName {
    param($Title, $Category)
    
    # Nettoyer le titre pour creer un nom de fichier valide
    $cleanTitle = $Title -replace '[^a-zA-Z0-9\s\-]', '' `
                        -replace '\s+', '-' `
                        -replace '-+', '-' `
                        -replace '^-|-$', ''
    
    return "content/docs/$Category/$cleanTitle.md"
}

function Get-Template {
    param($Type)
    
    # Mapping des types vers les noms de templates
    $templateMap = @{
        "note" = "note-technique-template.md"
        "projet" = "projet-template.md"
        "guide" = "guide-template.md"
        "troubleshooting" = "note-technique-template.md"
    }
    
    $templateName = $templateMap[$Type]
    $templatePath = "templates/$templateName"
    
    if (Test-Path $templatePath) {
        return Get-Content $templatePath -Raw
    } else {
        Write-ColoredOutput "Template $templatePath non trouve" "Red"
        return $null
    }
}

function Set-TemplateVariables {
    param($Content, $Title, $Description, $Difficulty)
    
    $currentDate = Get-CurrentDate
    
    $result = $Content -replace '\[TITRE_NOTE\]', $Title
    $result = $result -replace '\[TITRE_PRINCIPAL\]', $Title  
    $result = $result -replace '\[NOM_DU_PROJET\]', $Title
    $result = $result -replace '\[SUJET\]', $Title
    $result = $result -replace '\[DESCRIPTION_1_2_PHRASES\]', $Description
    $result = $result -replace '\[DESCRIPTION_CLAIRE_DU_PROJET\]', $Description
    $result = $result -replace '\[OBJECTIF_DU_GUIDE\]', $Description
    $result = $result -replace '\[DATE_ISO\]', $currentDate
    $result = $result -replace '\[beginner\|intermediate\|advanced\|expert\]', $Difficulty
    $result = $result -replace '\[ESTIMATION\]', "5"
    $result = $result -replace '\[RESUME_EN_1_PHRASE\]', $Description
    $result = $result -replace '\[RESUME_GUIDE\]', $Description
    $result = $result -replace '\[DATE\]', $currentDate
    
    return $result
}

function New-ContentFile {
    param($Type, $Title, $Category, $Description, $Difficulty)
    
    Write-ColoredOutput "Creation d'un nouveau $Type : $Title" "Cyan"
    Write-ColoredOutput "Categorie : $Category" "Yellow"
    Write-ColoredOutput "Description : $Description" "Gray"
    Write-ColoredOutput "Difficulte : $Difficulty" "Magenta"
    
    # Obtenir le template
    $template = Get-Template $Type
    if (-not $template) {
        return $false
    }
    
    # Creer le nom de fichier
    $fileName = New-FileName $Title $Category
    $fullPath = $fileName
    
    # Verifier si le dossier existe
    $directory = Split-Path $fullPath -Parent
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
        Write-ColoredOutput "Dossier cree : $directory" "Green"
    }
    
    # Remplacer les variables
    $content = Set-TemplateVariables $template $Title $Description $Difficulty
    
    # Verifier si le fichier existe deja
    if (Test-Path $fullPath) {
        $response = Read-Host "Le fichier $fullPath existe deja. Ecraser ? (y/N)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            Write-ColoredOutput "Creation annulee" "Red"
            return $false
        }
    }
    
    # Creer le fichier
    $content | Out-File -FilePath $fullPath -Encoding UTF8
    
    Write-ColoredOutput "Fichier cree : $fullPath" "Green"
    
    # Ouvrir dans VS Code si disponible
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Write-ColoredOutput "Ouverture dans VS Code..." "Blue"
        & code $fullPath
    }
    
    # Instructions suivantes
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "PROCHAINES ETAPES :" "Yellow"
    Write-ColoredOutput "1. Completer le contenu en remplacant les [PLACEHOLDERS]" "White"
    Write-ColoredOutput "2. Ajuster les tags dans le frontmatter YAML" "White"
    Write-ColoredOutput "3. Verifier le niveau de difficulte" "White"
    Write-ColoredOutput "4. Estimer le temps de lecture" "White"
    Write-ColoredOutput "5. Sauvegarder et committer avec Obsidian Git" "White"
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "Le fichier sera automatiquement synchronise vers le site web !" "Green"
    
    return $true
}

# EXECUTION PRINCIPALE
Write-ColoredOutput "GENERATEUR DE CONTENU - Portfolio Automatise" "Cyan"
Write-ColoredOutput "=============================================" "Cyan"

try {
    # Verifier que nous sommes dans le bon repertoire
    if (-not (Test-Path "templates") -or -not (Test-Path "content")) {
        Write-ColoredOutput "Erreur : Ce script doit etre execute depuis la racine du projet" "Red"
        Write-ColoredOutput "Verifiez que vous etes dans le bon repertoire" "Yellow"
        exit 1
    }
    
    # Creer le contenu
    $success = New-ContentFile $Type $Title $Category $Description $Difficulty
    
    if ($success) {
        Write-ColoredOutput "Script termine avec succes !" "Green"
        exit 0
    } else {
        Write-ColoredOutput "Echec de la creation du contenu" "Red"
        exit 1
    }
    
} catch {
    Write-ColoredOutput "Erreur lors de la creation : $($_.Exception.Message)" "Red"
    exit 1
}