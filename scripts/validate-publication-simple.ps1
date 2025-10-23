# Script de validation publication simplifie
param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = ""
)

function Write-ColoredOutput {
    param($Message, $Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-FileNameValidity {
    param($FilePath)
    
    $fileName = Split-Path $FilePath -Leaf
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    
    $issues = @()
    
    if ($baseName -match '[^a-zA-Z0-9\-_]') {
        $issues += "Caracteres non autorises dans le nom"
    }
    
    if ($baseName.Length -gt 50) {
        $issues += "Nom trop long (max 50 caracteres)"
    }
    
    if (-not $fileName.EndsWith('.md')) {
        $issues += "Extension incorrecte (doit etre .md)"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Test-FrontmatterFormat {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $issues = @()
    
    if (-not ($content -match '^---\r?\n.*?\r?\n---\r?\n')) {
        $issues += "Frontmatter YAML manquant ou mal formate"
        return @{ Valid = $false; Issues = $issues }
    }
    
    $frontmatterMatch = [regex]::Match($content, '^---\r?\n(.*?)\r?\n---\r?\n', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $frontmatterMatch.Success) {
        $issues += "Impossible d'extraire le frontmatter"
        return @{ Valid = $false; Issues = $issues }
    }
    
    $frontmatter = $frontmatterMatch.Groups[1].Value
    
    $requiredFields = @('title', 'description', 'tags', 'date')
    foreach ($field in $requiredFields) {
        if (-not ($frontmatter -match "$field\s*:")) {
            $issues += "Champ obligatoire manquant: $field"
        }
    }
    
    if ($frontmatter -match 'tags:\s*\n\s*-') {
        $issues += "Tags au format multiligne detecte - utiliser format array"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Invoke-PublicationValidation {
    param($FilePath)
    
    Write-ColoredOutput "Validation publication : $FilePath" "Cyan"
    Write-ColoredOutput "=================================" "Cyan"
    
    if (-not (Test-Path $FilePath)) {
        Write-ColoredOutput "Fichier non trouve : $FilePath" "Red"
        return $false
    }
    
    $allValid = $true
    
    # Test nom de fichier
    Write-ColoredOutput "Test nom de fichier..." "Yellow"
    $nameResult = Test-FileNameValidity $FilePath
    if ($nameResult.Valid) {
        Write-ColoredOutput "OK Nom de fichier valide" "Green"
    } else {
        Write-ColoredOutput "ERREUR Problemes de nom de fichier :" "Red"
        foreach ($issue in $nameResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        $allValid = $false
    }
    
    # Test frontmatter
    Write-ColoredOutput "Test frontmatter YAML..." "Yellow"
    $frontmatterResult = Test-FrontmatterFormat $FilePath
    if ($frontmatterResult.Valid) {
        Write-ColoredOutput "OK Frontmatter valide" "Green"
    } else {
        Write-ColoredOutput "ERREUR Problemes de frontmatter :" "Red"
        foreach ($issue in $frontmatterResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        $allValid = $false
    }
    
    # Test generation Hugo
    Write-ColoredOutput "Test generation Hugo..." "Yellow"
    $output = hugo --cleanDestinationDir --gc --minify 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-ColoredOutput "OK Generation Hugo reussie" "Green"
    } else {
        Write-ColoredOutput "ERREUR Generation Hugo echouee" "Red"
        $allValid = $false
    }
    
    Write-ColoredOutput "" "White"
    if ($allValid) {
        Write-ColoredOutput "VALIDATION REUSSIE ! Fichier pret pour publication." "Green"
    } else {
        Write-ColoredOutput "VALIDATION ECHOUEE ! Corriger les problemes." "Red"
    }
    
    return $allValid
}

# Execution principale
Write-ColoredOutput "VALIDATEUR PUBLICATION - Portfolio Automatise" "Cyan"
Write-ColoredOutput "=============================================" "Cyan"

if ($FilePath -ne "") {
    $result = Invoke-PublicationValidation $FilePath
    exit $(if ($result) { 0 } else { 1 })
} else {
    Write-ColoredOutput "Usage: .\scripts\validate-publication-simple.ps1 -FilePath 'chemin/fichier.md'" "Yellow"
    exit 1
}