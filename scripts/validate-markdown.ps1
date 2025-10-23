# 🔍 SCRIPT DE VALIDATION MARKDOWN LOCAL
# Reproduit la validation GitHub Actions en local

Write-Host "🔍 Validation Markdown locale - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Compter les erreurs
$errorCount = 0

# Vérifier les conflits de merge
Write-Host "📝 Vérification des conflits de merge..." -ForegroundColor Yellow
$conflictFiles = Get-ChildItem -Path "content/" -Recurse -Include "*.md" | Where-Object {
    (Get-Content $_.FullName -Raw) -match "<<<<<<< HEAD|=======|>>>>>>> "
}
if ($conflictFiles.Count -gt 0) {
    Write-Host "❌ Conflits de merge trouvés:" -ForegroundColor Red
    $conflictFiles | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Red }
    $errorCount += $conflictFiles.Count
} else {
    Write-Host "✅ Aucun conflit de merge" -ForegroundColor Green
}

# Vérifier les frontmatter
Write-Host "📋 Validation des frontmatter YAML..." -ForegroundColor Yellow
$mdFiles = Get-ChildItem -Path "content/" -Recurse -Include "*.md"

foreach ($file in $mdFiles) {
    Write-Host "Vérification: $($file.FullName -replace [regex]::Escape($PWD), '.')" -ForegroundColor Gray
    
    $content = Get-Content $file.FullName -Raw
    if ([string]::IsNullOrEmpty($content)) {
        Write-Host "❌ Fichier vide: $($file.Name)" -ForegroundColor Red
        $errorCount++
        continue
    }
    
    # Vérifier que le fichier commence par ---
    if (-not $content.StartsWith("---`n") -and -not $content.StartsWith("---`r`n")) {
        Write-Host "❌ Frontmatter manquant: $($file.Name)" -ForegroundColor Red
        $errorCount++
        continue
    }
    
    # Extraire le frontmatter
    $lines = $content -split "`n"
    $frontmatterEnd = -1
    for ($i = 1; $i -lt $lines.Length; $i++) {
        if ($lines[$i].Trim() -eq "---") {
            $frontmatterEnd = $i
            break
        }
    }
    
    if ($frontmatterEnd -eq -1) {
        Write-Host "❌ Frontmatter non fermé: $($file.Name)" -ForegroundColor Red
        $errorCount++
        continue
    }
    
    # Vérifier la présence du titre
    $frontmatter = $lines[1..($frontmatterEnd-1)] -join "`n"
    if ($frontmatter -notmatch "title\s*:") {
        Write-Host "❌ Titre manquant dans frontmatter: $($file.Name)" -ForegroundColor Red
        $errorCount++
        continue
    }
    
    Write-Host "✅ Valide: $($file.Name)" -ForegroundColor Green
}

# Résumé final
Write-Host "================================================" -ForegroundColor Cyan
if ($errorCount -eq 0) {
    Write-Host "✅ TOUS LES FICHIERS SONT VALIDES!" -ForegroundColor Green
    Write-Host "🚀 Le déploiement devrait réussir" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "❌ $errorCount erreur(s) trouvée(s)" -ForegroundColor Red
    Write-Host "🔧 Corrigez ces erreurs avant de committer" -ForegroundColor Yellow
    Write-Host "💡 Ou ajoutez [skip-validation] au message de commit" -ForegroundColor Blue
    exit 1
}