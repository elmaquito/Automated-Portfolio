# Script de validation publication - Portfolio Automatise
# Basé sur l'analyse complète des prérequis
# Ismael Martinez - 2025

param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$FixProblems = $false
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
    
    # Test caractères autorisés
    if ($baseName -match '[^a-zA-Z0-9\-_]') {
        $issues += "Caractères non autorisés dans le nom (utilisez seulement a-z, A-Z, 0-9, -, _)"
    }
    
    # Test longueur
    if ($baseName.Length -gt 50) {
        $issues += "Nom trop long (max 50 caractères, actuel: $($baseName.Length))"
    }
    
    # Test extension
    if (-not $fileName.EndsWith('.md')) {
        $issues += "Extension incorrecte (doit être .md)"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
        Suggestion = if ($issues.Count -gt 0) { 
            ($baseName -replace '[^a-zA-Z0-9\-_]', '-' -replace '-+', '-' -replace '^-|-$', '').Substring(0, [Math]::Min(50, $baseName.Length)) + '.md'
        } else { $null }
    }
}

function Test-FrontmatterFormat {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $issues = @()
    
    # Test présence frontmatter
    if (-not ($content -match '^---\r?\n.*?\r?\n---\r?\n')) {
        $issues += "Frontmatter YAML manquant ou mal formaté"
        return @{ Valid = $false; Issues = $issues }
    }
    
    # Extraire frontmatter
    $frontmatterMatch = [regex]::Match($content, '^---\r?\n(.*?)\r?\n---\r?\n', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $frontmatterMatch.Success) {
        $issues += "Impossible d'extraire le frontmatter"
        return @{ Valid = $false; Issues = $issues }
    }
    
    $frontmatter = $frontmatterMatch.Groups[1].Value
    
    # Test champs obligatoires
    $requiredFields = @('title', 'description', 'tags', 'date')
    foreach ($field in $requiredFields) {
        if (-not ($frontmatter -match "$field\s*:")) {
            $issues += "Champ obligatoire manquant: $field"
        }
    }
    
    # Test format tags (doit être array, pas multiligne)
    if ($frontmatter -match 'tags:\s*\n\s*-') {
        $issues += "Tags au format multiligne détecté - utiliser format array: tags: [""tag1"", ""tag2""]"
    }
    
    # Test format date
    if ($frontmatter -match 'date:\s*(\d{4}-\d{2}-\d{2})$') {
        $issues += "Format de date incomplet - utiliser format ISO: 2025-10-23T13:15:05Z"
    }
    
    # Test caractères spéciaux dans title/description
    if ($frontmatter -match 'title:.*[àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ]') {
        $issues += "Accents détectés dans le titre - remplacer par équivalents sans accent"
    }
    
    if ($frontmatter -match 'description:.*[àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ]') {
        $issues += "Accents détectés dans la description - remplacer par équivalents sans accent"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Test-ShortcodesPresent {
    param($FilePath)
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $issues = @()
    
    # Test présence des shortcodes obligatoires
    if (-not ($content -match '\{\{<\s*difficulty\s+level=')) {
        $issues += "Shortcode difficulty manquant - ajouter: {{< difficulty level=""intermediate"" >}}"
    }
    
    if (-not ($content -match '\{\{<\s*reading-time\s+minutes=')) {
        $issues += "Shortcode reading-time manquant - ajouter: {{< reading-time minutes=""5"" >}}"
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Test-HugoGeneration {
    param($FilePath)
    
    Write-ColoredOutput "🔧 Test de génération Hugo..." "Yellow"
    
    # Test dry-run
    $output = hugo --dry-run 2>&1
    if ($LASTEXITCODE -ne 0) {
        return @{
            Valid = $false
            Issues = @("Erreurs de génération Hugo détectées", "Output: $output")
        }
    }
    
    # Test génération réelle
    $output = hugo --cleanDestinationDir --gc --minify 2>&1
    if ($LASTEXITCODE -ne 0) {
        return @{
            Valid = $false
            Issues = @("Échec de génération Hugo", "Output: $output")
        }
    }
    
    # Vérifier que le fichier est généré
    $relativePath = $FilePath -replace [regex]::Escape($PWD.Path + "\content\"), ""
    $expectedPath = $relativePath -replace '\.md$', '' -replace '\\', '/' -replace 'docs/', 'docs/' | ForEach-Object { $_.ToLower() }
    $expectedFullPath = "public/$expectedPath/index.html"
    
    if (-not (Test-Path $expectedFullPath)) {
        # Essayer de trouver où le fichier a été généré
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath).ToLower()
        $foundFiles = Get-ChildItem "public" -Recurse -Name "index.html" | Where-Object { $_ -match $fileName }
        
        if ($foundFiles) {
            Write-ColoredOutput "ℹ️  Fichier généré à: $($foundFiles[0])" "Blue"
            return @{ Valid = $true; Issues = @() }
        } else {
            return @{
                Valid = $false
                Issues = @("Fichier non généré dans public/ - attendu: $expectedFullPath")
            }
        }
    }
    
    return @{ Valid = $true; Issues = @() }
}

function Test-LayoutsPresent {
    Write-ColoredOutput "🎨 Test des layouts..." "Yellow"
    
    $requiredLayouts = @(
        "layouts/_default/baseof.html",
        "layouts/_default/single.html", 
        "layouts/_default/list.html",
        "layouts/shortcodes/difficulty.html",
        "layouts/shortcodes/reading-time.html"
    )
    
    $issues = @()
    foreach ($layout in $requiredLayouts) {
        if (-not (Test-Path $layout)) {
            $issues += "Layout manquant: $layout"
        }
    }
    
    return @{
        Valid = $issues.Count -eq 0
        Issues = $issues
    }
}

function Invoke-PublicationValidation {
    param($FilePath)
    
    Write-ColoredOutput "🔍 VALIDATION PUBLICATION : $FilePath" "Cyan"
    Write-ColoredOutput "=" * 60 "Cyan"
    
    if (-not (Test-Path $FilePath)) {
        Write-ColoredOutput "❌ Fichier non trouvé : $FilePath" "Red"
        return $false
    }
    
    $allValid = $true
    $allIssues = @()
    
    # Test 1: Layouts
    Write-ColoredOutput "🎨 Test 1: Layouts et templates..." "Yellow"
    $layoutsResult = Test-LayoutsPresent
    if ($layoutsResult.Valid) {
        Write-ColoredOutput "✅ Layouts présents" "Green"
    } else {
        Write-ColoredOutput "❌ Layouts manquants :" "Red"
        foreach ($issue in $layoutsResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        $allValid = $false
        $allIssues += $layoutsResult.Issues
    }
    
    # Test 2: Nom de fichier
    Write-ColoredOutput "📄 Test 2: Nom de fichier..." "Yellow"
    $nameResult = Test-FileNameValidity $FilePath
    if ($nameResult.Valid) {
        Write-ColoredOutput "✅ Nom de fichier valide" "Green"
    } else {
        Write-ColoredOutput "❌ Problèmes de nom de fichier :" "Red"
        foreach ($issue in $nameResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        if ($nameResult.Suggestion) {
            Write-ColoredOutput "💡 Suggestion : $($nameResult.Suggestion)" "Yellow"
        }
        $allValid = $false
        $allIssues += $nameResult.Issues
    }
    
    # Test 3: Frontmatter
    Write-ColoredOutput "📋 Test 3: Frontmatter YAML..." "Yellow"
    $frontmatterResult = Test-FrontmatterFormat $FilePath
    if ($frontmatterResult.Valid) {
        Write-ColoredOutput "✅ Frontmatter valide" "Green"
    } else {
        Write-ColoredOutput "❌ Problèmes de frontmatter :" "Red"
        foreach ($issue in $frontmatterResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        $allValid = $false
        $allIssues += $frontmatterResult.Issues
    }
    
    # Test 4: Shortcodes
    Write-ColoredOutput "🔧 Test 4: Shortcodes..." "Yellow"
    $shortcodesResult = Test-ShortcodesPresent $FilePath
    if ($shortcodesResult.Valid) {
        Write-ColoredOutput "✅ Shortcodes présents" "Green"
    } else {
        Write-ColoredOutput "❌ Shortcodes manquants :" "Red"
        foreach ($issue in $shortcodesResult.Issues) {
            Write-ColoredOutput "   - $issue" "Red"
        }
        $allValid = $false
        $allIssues += $shortcodesResult.Issues
    }
    
    # Test 5: Génération Hugo (seulement si les autres tests passent)
    if ($allValid) {
        Write-ColoredOutput "🚀 Test 5: Génération Hugo..." "Yellow"
        $hugoResult = Test-HugoGeneration $FilePath
        if ($hugoResult.Valid) {
            Write-ColoredOutput "✅ Génération Hugo réussie" "Green"
        } else {
            Write-ColoredOutput "❌ Problèmes de génération :" "Red"
            foreach ($issue in $hugoResult.Issues) {
                Write-ColoredOutput "   - $issue" "Red"
            }
            $allValid = $false
            $allIssues += $hugoResult.Issues
        }
    } else {
        Write-ColoredOutput "⏭️  Test génération Hugo ignoré (corriger les erreurs précédentes)" "Yellow"
    }
    
    Write-ColoredOutput "" "White"
    if ($allValid) {
        Write-ColoredOutput "🎉 VALIDATION RÉUSSIE ! Fichier prêt pour publication." "Green"
        Write-ColoredOutput "🌐 Le fichier sera disponible après déploiement." "Blue"
    } else {
        Write-ColoredOutput "⚠️  VALIDATION ÉCHOUÉE ! $($allIssues.Count) problèmes détectés." "Red"
        Write-ColoredOutput "" "White"
        Write-ColoredOutput "🔧 ACTIONS RECOMMANDÉES :" "Yellow"
        Write-ColoredOutput "1. Corriger les problèmes listés ci-dessus" "White"
        Write-ColoredOutput "2. Relancer la validation" "White"
        Write-ColoredOutput "3. Une fois validé, committer et pousser" "White"
    }
    
    return $allValid
}

# =========================================
# EXÉCUTION PRINCIPALE
# =========================================

Write-ColoredOutput "🔍 VALIDATEUR PUBLICATION - Portfolio Automatisé" "Cyan"
Write-ColoredOutput "===============================================" "Cyan"

if ($FilePath -ne "") {
    # Validation d'un fichier spécifique
    $result = Invoke-PublicationValidation $FilePath
    exit $(if ($result) { 0 } else { 1 })
} else {
    # Validation de tous les fichiers récents
    Write-ColoredOutput "📁 Recherche des fichiers Markdown modifiés..." "Yellow"
    
    $recentFiles = Get-ChildItem "content" -Recurse -Filter "*.md" | Where-Object { 
        $_.LastWriteTime -gt (Get-Date).AddDays(-1) 
    }
    
    if ($recentFiles.Count -eq 0) {
        Write-ColoredOutput "ℹ️  Aucun fichier modifié récemment trouvé." "Blue"
        Write-ColoredOutput "💡 Spécifiez un fichier : .\scripts\validate-publication.ps1 -FilePath ""chemin/fichier.md""" "Yellow"
        exit 0
    }
    
    Write-ColoredOutput "📝 Trouvé $($recentFiles.Count) fichiers modifiés récemment" "Blue"
    
    $validFiles = 0
    $invalidFiles = 0
    
    foreach ($file in $recentFiles) {
        Write-ColoredOutput "" "White"
        $result = Invoke-PublicationValidation $file.FullName
        if ($result) {
            $validFiles++
        } else {
            $invalidFiles++
        }
    }
    
    Write-ColoredOutput "" "White"
    Write-ColoredOutput "📊 RÉSUMÉ GLOBAL" "Cyan"
    Write-ColoredOutput "===============" "Cyan"
    Write-ColoredOutput "✅ Fichiers prêts : $validFiles" "Green"
    Write-ColoredOutput "❌ Fichiers problématiques : $invalidFiles" "Red"
    Write-ColoredOutput "📁 Total analysé : $($recentFiles.Count)" "Blue"
    
    if ($invalidFiles -eq 0) {
        Write-ColoredOutput "" "White"
        Write-ColoredOutput "🎉 TOUS LES FICHIERS SONT PRÊTS POUR PUBLICATION !" "Green"
        exit 0
    } else {
        Write-ColoredOutput "" "White"
        Write-ColoredOutput "⚠️  Corrigez les erreurs avant de publier." "Yellow"
        exit 1
    }
}