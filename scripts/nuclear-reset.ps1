# 🔄 SCRIPT DE REMISE À NEUF COMPLÈTE
# ATTENTION: Supprime toutes les modifications locales

Write-Host "⚠️  REMISE À NEUF COMPLÈTE DU DÉPÔT" -ForegroundColor Red
Write-Host "====================================" -ForegroundColor Red
Write-Host "ATTENTION: Cette opération va supprimer toutes les modifications locales non committées!" -ForegroundColor Red
Write-Host ""

# Demander confirmation
$confirmation = Read-Host "Êtes-vous sûr de vouloir continuer? (tapez OUI pour confirmer)"
if ($confirmation -ne "OUI") {
    Write-Host "❌ Opération annulée par l'utilisateur" -ForegroundColor Yellow
    exit 0
}

Write-Host "🔄 Début de la remise à neuf..." -ForegroundColor Yellow

# 1. Sauvegarder le fichier TP Sécurité important
Write-Host "📋 Étape 1/6: Sauvegarde du TP Sécurité..." -ForegroundColor Yellow
if (Test-Path "content/docs/Notes/TP-Securite-Generale-Scan-192-168-1-100.md") {
    Copy-Item "content/docs/Notes/TP-Securite-Generale-Scan-192-168-1-100.md" "TP-Securite-BACKUP.md"
    Write-Host "✅ TP Sécurité sauvegardé" -ForegroundColor Green
}

# 2. Stasher tout le travail actuel
Write-Host "📋 Étape 2/6: Sauvegarde de tout le travail..." -ForegroundColor Yellow
git stash push -m "Sauvegarde complète avant reset - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

# 3. Annuler le rebase
Write-Host "📋 Étape 3/6: Annulation du rebase..." -ForegroundColor Yellow
git rebase --abort

# 4. Reset hard vers origin/main
Write-Host "📋 Étape 4/6: Reset complet vers origin/main..." -ForegroundColor Yellow
git fetch origin
git checkout main
git reset --hard origin/main
Write-Host "✅ Dépôt remis à neuf" -ForegroundColor Green

# 5. Restaurer le fichier TP Sécurité
Write-Host "📋 Étape 5/6: Restauration du TP Sécurité..." -ForegroundColor Yellow
if (Test-Path "TP-Securite-BACKUP.md") {
    Copy-Item "TP-Securite-BACKUP.md" "content/docs/Notes/TP-Securite-Generale-Scan-192-168-1-100.md"
    Remove-Item "TP-Securite-BACKUP.md"
    Write-Host "✅ TP Sécurité restauré" -ForegroundColor Green
}

# 6. État final
Write-Host "📋 Étape 6/6: Vérification finale..." -ForegroundColor Yellow
git status
Write-Host "✅ Remise à neuf terminée!" -ForegroundColor Green
Write-Host ""
Write-Host "🔄 Prochaines étapes recommandées:" -ForegroundColor Cyan
Write-Host "1. Vérifiez que le fichier TP Sécurité est présent" -ForegroundColor Blue
Write-Host "2. Exécutez le script fix-github-sync.ps1" -ForegroundColor Blue
Write-Host "3. Ou créez une nouvelle branche avec create-secure-branch.ps1" -ForegroundColor Blue

Write-Host "====================================" -ForegroundColor Red