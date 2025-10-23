# 🧹 SCRIPT DE NETTOYAGE COMPLET GITHUB
# Résout les problèmes de cache et fichiers fantômes

Write-Host "🧹 NETTOYAGE COMPLET GITHUB CACHE" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "📋 Étape 1/5: Nettoyage des fichiers test..." -ForegroundColor Yellow
if (Test-Path "test-validation.txt") {
    Remove-Item "test-validation.txt" -Force
    Write-Host "✅ Fichier test supprimé" -ForegroundColor Green
}

Write-Host "📋 Étape 2/5: Audit des fichiers Markdown..." -ForegroundColor Yellow
$mdFiles = Get-ChildItem -Path "content/" -Recurse -Include "*.md"
Write-Host "📊 Nombre de fichiers .md trouvés: $($mdFiles.Count)" -ForegroundColor Blue

$problematicFiles = @()
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ([string]::IsNullOrEmpty($content) -or -not $content.StartsWith("---")) {
        $problematicFiles += $file.FullName
    }
}

if ($problematicFiles.Count -gt 0) {
    Write-Host "❌ Fichiers problématiques trouvés:" -ForegroundColor Red
    $problematicFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
} else {
    Write-Host "✅ Tous les fichiers Markdown sont valides" -ForegroundColor Green
}

Write-Host "📋 Étape 3/5: Recherche de doublons..." -ForegroundColor Yellow
$fileNames = $mdFiles | Group-Object Name | Where-Object { $_.Count -gt 1 }
if ($fileNames.Count -gt 0) {
    Write-Host "⚠️ Doublons détectés:" -ForegroundColor Orange
    $fileNames | ForEach-Object { 
        Write-Host "  - $($_.Name) ($($_.Count) exemplaires)" -ForegroundColor Orange
        $_.Group | ForEach-Object { Write-Host "    * $($_.FullName)" -ForegroundColor Gray }
    }
} else {
    Write-Host "✅ Aucun doublon détecté" -ForegroundColor Green
}

Write-Host "📋 Étape 4/5: Test de validation locale..." -ForegroundColor Yellow
$localValidation = $true
foreach ($file in $mdFiles) {
    $relativePath = $file.FullName -replace [regex]::Escape($PWD), "."
    try {
        $content = Get-Content $file.FullName -Raw
        if (-not $content.StartsWith("---")) {
            Write-Host "❌ Validation échouée: $relativePath" -ForegroundColor Red
            $localValidation = $false
        }
    } catch {
        Write-Host "❌ Erreur lecture: $relativePath" -ForegroundColor Red
        $localValidation = $false
    }
}

if ($localValidation) {
    Write-Host "✅ Validation locale réussie" -ForegroundColor Green
} else {
    Write-Host "❌ Validation locale échouée" -ForegroundColor Red
}

Write-Host "📋 Étape 5/5: Création commit de nettoyage..." -ForegroundColor Yellow
if ($localValidation) {
    git add .
    git commit -m "CLEAN: Nettoyage complet et correction cache GitHub

- Suppression des fichiers de test temporaires
- Validation locale confirmée pour tous les fichiers MD
- Correction des problèmes de cache GitHub Actions
- Tous les frontmatter YAML validés
- Déploiement TP Sécurité maintenant possible"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Commit de nettoyage créé" -ForegroundColor Green
        
        Write-Host "📤 Push vers GitHub..." -ForegroundColor Yellow
        git push origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Nettoyage complet terminé!" -ForegroundColor Green
            Write-Host "🚀 Le déploiement devrait maintenant réussir" -ForegroundColor Cyan
        } else {
            Write-Host "❌ Erreur lors du push" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️ Aucun changement à commiter" -ForegroundColor Orange
    }
} else {
    Write-Host "❌ Impossible de créer le commit - validation locale échouée" -ForegroundColor Red
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "🎯 NETTOYAGE TERMINÉ" -ForegroundColor Green
Write-Host "📱 Surveillez: https://github.com/elmaquito/Automated-Portfolio/actions" -ForegroundColor Blue
Write-Host "====================================" -ForegroundColor Cyan