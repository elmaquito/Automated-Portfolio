# =========================================
# SCRIPT DE VALIDATION DE CONTENU
# Portfolio Automatisé - Ismael Martinez  
# =========================================

param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = ""
)

function Test-FrontmatterYAML {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw
    
    # Vérifier présence du frontmatter
    if (-not ($content -match '^---\r?\n.*?\r?\n---\r?\n')) {
        return @{
            Valid = $false
            Error = "Frontmatter YAML manquant ou mal formaté"
        }
    }
    
    # Extraire le frontmatter
    $frontmatterMatch = [regex]::Match($content, '^---\r?\n(.*?)\r?\n---\r?\n', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $frontmatter = $frontmatterMatch.Groups[1].Value
    
    # Vérifier champs obligatoires
    $requiredFields = @("title", "description", "tags", "date")
    $missingFields = @()
    
    foreach ($field in $requiredFields) {
        if (-not ($frontmatter -match "$field\s*:")) {
            $missingFields += $field
        }
    }
    
    if ($missingFields.Count -gt 0) {
        return @{
            Valid = $false
            Error = "Champs manquants : $($missingFields -join ', ')"
        }
    }
    
    return @{
        Valid = $true
        Error = $null
    }
}

function Test-ContentStructure {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw
    
    $issues = @()
    
    # Vérifier titre principal
    if (-not ($content -match '^# ')) {
        $issues += "Titre principal (# ) manquant"
    }
    
    # Vérifier sections
    if (-not ($content -match '^## ')) {
        $issues += "Aucune section (## ) trouvée"
    }
    
    # Vérifier shortcodes si présents
    if ($content -match '\{\{<\s*(\w+)') {
        $shortcodes = [regex]::Matches($content, '\{\{<\s*(\w+)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
        $validShortcodes = @("difficulty", "reading-time", "api-reference", "prerequisites", "contact-form")
        
        foreach ($shortcode in $shortcodes) {
            if ($shortcode -notin $validShortcodes) {
                $issues += "Shortcode non reconnu : $shortcode"
            }
        }
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Test-MarkdownSyntax {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw
    $issues = @()
    
    # Vérifier liens cassés (basique)
    $internalLinks = [regex]::Matches($content, '\[.*?\]\((.*?)\)')
    foreach ($match in $internalLinks) {
        $link = $match.Groups[1].Value
        if ($link.StartsWith('/') -or $link.StartsWith('./') -or $link.StartsWith('../')) {
            # Lien interne - vérification basique
            if ($link -match '\s') {
                $issues += "Lien avec espaces : $link"
            }
        }
    }
    
    # Vérifier blocs de code fermés
    $codeBlocks = [regex]::Matches($content, '```')
    if ($codeBlocks.Count % 2 -ne 0) {
        $issues += "Blocs de code mal fermés (``` impairs)"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Invoke-ContentValidation {
    param($FilePath)
    
    Write-Host "🔍 Validation du fichier : $FilePath" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "❌ Fichier non trouvé : $FilePath" -ForegroundColor Red
        return $false
    }
    
    $allValid = $true
    
    # Test 1: Frontmatter YAML
    Write-Host "📋 Test frontmatter YAML..." -ForegroundColor Yellow
    $frontmatterResult = Test-FrontmatterYAML $FilePath
    if ($frontmatterResult.Valid) {
        Write-Host "✅ Frontmatter YAML valide" -ForegroundColor Green
    } else {
        Write-Host "❌ $($frontmatterResult.Error)" -ForegroundColor Red
        $allValid = $false
    }
    
    # Test 2: Structure du contenu
    Write-Host "🏗️  Test structure du contenu..." -ForegroundColor Yellow  
    $structureResult = Test-ContentStructure $FilePath
    if ($structureResult.Valid) {
        Write-Host "✅ Structure du contenu valide" -ForegroundColor Green
    } else {
        Write-Host "❌ Problèmes de structure :" -ForegroundColor Red
        foreach ($issue in $structureResult.Issues) {
            Write-Host "   - $issue" -ForegroundColor Red
        }
        $allValid = $false
    }
    
    # Test 3: Syntaxe Markdown
    Write-Host "📝 Test syntaxe Markdown..." -ForegroundColor Yellow
    $markdownResult = Test-MarkdownSyntax $FilePath
    if ($markdownResult.Valid) {
        Write-Host "✅ Syntaxe Markdown valide" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Problèmes Markdown détectés :" -ForegroundColor Yellow
        foreach ($issue in $markdownResult.Issues) {
            Write-Host "   - $issue" -ForegroundColor Yellow
        }
    }
    
    Write-Host "" -ForegroundColor White
    if ($allValid) {
        Write-Host "🎉 VALIDATION RÉUSSIE ! Le fichier est prêt pour la publication." -ForegroundColor Green
    } else {
        Write-Host "⚠️  VALIDATION ÉCHOUÉE ! Corrigez les erreurs avant de publier." -ForegroundColor Red
    }
    
    return $allValid
}

function Find-MarkdownFiles {
    param($Directory)
    
    $mdFiles = Get-ChildItem -Path $Directory -Recurse -Filter "*.md" | Where-Object { 
        -not ($_.FullName -match "node_modules|\.git|public") 
    }
    
    return $mdFiles
}

# =========================================
# EXÉCUTION PRINCIPALE
# =========================================

Write-Host "🔍 VALIDATEUR DE CONTENU - Portfolio Automatisé" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

if ($FilePath -ne "") {
    # Validation d'un fichier spécifique
    $result = Invoke-ContentValidation $FilePath
    exit $(if ($result) { 0 } else { 1 })
} else {
    # Validation de tous les fichiers Markdown
    Write-Host "📁 Recherche de tous les fichiers Markdown..." -ForegroundColor Yellow
    
    $markdownFiles = Find-MarkdownFiles "content"
    Write-Host "📝 Trouvé $($markdownFiles.Count) fichiers Markdown" -ForegroundColor Blue
    
    $validFiles = 0
    $invalidFiles = 0
    
    foreach ($file in $markdownFiles) {
        Write-Host "" -ForegroundColor White
        $result = Invoke-ContentValidation $file.FullName
        if ($result) {
            $validFiles++
        } else {
            $invalidFiles++
        }
    }
    
    Write-Host "" -ForegroundColor White
    Write-Host "📊 RÉSUMÉ DE VALIDATION" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    Write-Host "✅ Fichiers valides : $validFiles" -ForegroundColor Green
    Write-Host "❌ Fichiers invalides : $invalidFiles" -ForegroundColor Red
    Write-Host "📁 Total analysé : $($markdownFiles.Count)" -ForegroundColor Blue
    
    if ($invalidFiles -eq 0) {
        Write-Host "" -ForegroundColor White
        Write-Host "🎉 TOUS LES FICHIERS SONT VALIDES !" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "" -ForegroundColor White
        Write-Host "⚠️  Corrigez les erreurs avant de publier." -ForegroundColor Yellow
        exit 1
    }
}