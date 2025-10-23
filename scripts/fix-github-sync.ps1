# 🛠️ SCRIPT DE RÉPARATION RAPIDE
# Résout le problème de synchronisation GitHub

Write-Host "🔧 DÉBUT DE LA RÉPARATION GITHUB SYNC" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# 1. Annuler le rebase problématique
Write-Host "📋 Étape 1/6: Annulation du rebase bloqué..." -ForegroundColor Yellow
git rebase --abort
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Rebase annulé avec succès" -ForegroundColor Green
} else {
    Write-Host "⚠️ Pas de rebase à annuler ou erreur" -ForegroundColor Orange
}

# 2. Revenir sur main
Write-Host "📋 Étape 2/6: Retour sur la branche main..." -ForegroundColor Yellow
git checkout main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Sur la branche main" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors du checkout main" -ForegroundColor Red
    exit 1
}

# 3. Synchroniser avec le remote
Write-Host "📋 Étape 3/6: Synchronisation avec GitHub..." -ForegroundColor Yellow
git fetch origin
git pull origin main --rebase
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Synchronisation réussie" -ForegroundColor Green
} else {
    Write-Host "⚠️ Conflits possibles - résolution manuelle nécessaire" -ForegroundColor Orange
}

# 4. Ajouter les fichiers modifiés
Write-Host "📋 Étape 4/6: Ajout des fichiers modifiés..." -ForegroundColor Yellow
git add content/docs/Notes/TP-Securite-Generale-Scan-192-168-1-100.md
git add content/docs/Notes/Probabilites.md
git add content/docs/Notes/Statistiques.md
git add content-validation-report.json
git add layouts/shortcodes/prerequisites.html
git add layouts/shortcodes/api-reference.html
Write-Host "✅ Fichiers ajoutés" -ForegroundColor Green

# 5. Créer le commit
Write-Host "📋 Étape 5/6: Création du commit..." -ForegroundColor Yellow
git commit -m "SYNC: Ajout TP Sécurité et corrections de contenu

- Ajout du fichier TP-Securite-Generale-Scan-192-168-1-100.md
- Corrections des fichiers Probabilités et Statistiques  
- Ajout des shortcodes manquants (prerequisites, api-reference)
- Mise à jour du rapport de validation"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit créé avec succès" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors du commit" -ForegroundColor Red
    Write-Host "Vérifiez s'il y a des conflits à résoudre" -ForegroundColor Yellow
    git status
    exit 1
}

# 6. Push vers GitHub
Write-Host "📋 Étape 6/6: Push vers GitHub..." -ForegroundColor Yellow
git push origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Push réussi vers GitHub!" -ForegroundColor Green
    Write-Host "🚀 Le déploiement automatique va commencer..." -ForegroundColor Cyan
    Write-Host "📱 Surveillez: https://github.com/elmaquito/Automated-Portfolio/actions" -ForegroundColor Blue
} else {
    Write-Host "❌ Erreur lors du push" -ForegroundColor Red
    exit 1
}

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "✅ RÉPARATION TERMINÉE AVEC SUCCÈS!" -ForegroundColor Green
Write-Host "🌐 Votre site sera disponible dans quelques minutes à:" -ForegroundColor Cyan
Write-Host "    https://www.martinezismael.fr/docs/notes/tp-securite-generale-scan-192-168-1-100/" -ForegroundColor Blue
Write-Host "===========================================" -ForegroundColor Cyan