# 🌿 SCRIPT NOUVELLE BRANCHE SÉCURISÉE
# Crée une branche spécifique pour le TP Sécurité

Write-Host "🌿 CRÉATION D'UNE BRANCHE SÉCURISÉE" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# 1. Annuler le rebase
Write-Host "📋 Étape 1/7: Annulation du rebase..." -ForegroundColor Yellow
git rebase --abort

# 2. Retour sur main clean
Write-Host "📋 Étape 2/7: Retour sur main propre..." -ForegroundColor Yellow
git checkout main
git fetch origin
git reset --hard origin/main

# 3. Créer la nouvelle branche
Write-Host "📋 Étape 3/7: Création de la branche feature/tp-securite..." -ForegroundColor Yellow
git checkout -b feature/tp-securite

# 4. Ajouter uniquement le TP Sécurité
Write-Host "📋 Étape 4/7: Ajout du fichier TP Sécurité..." -ForegroundColor Yellow
git add content/docs/Notes/TP-Securite-Generale-Scan-192-168-1-100.md
git add layouts/shortcodes/prerequisites.html
git add layouts/shortcodes/api-reference.html

# 5. Commit dédié
Write-Host "📋 Étape 5/7: Commit du TP Sécurité..." -ForegroundColor Yellow
git commit -m "ADD: TP Sécurité Générale - Scan 192.168.1.100

- Rapport complet de scan de sécurité sur 192.168.1.100
- Détection de 6 ports ouverts (21,22,25,80,110,143)
- Analyse des vulnérabilités web (Apache 2.0.55, PHP 5.1.2)
- Recommandations de sécurisation
- Ajout des shortcodes manquants pour l'affichage"

# 6. Push de la nouvelle branche
Write-Host "📋 Étape 6/7: Push de la branche vers GitHub..." -ForegroundColor Yellow
git push origin feature/tp-securite

# 7. Instructions pour la Pull Request
Write-Host "📋 Étape 7/7: Instructions finales..." -ForegroundColor Yellow
Write-Host "✅ Branche créée et pushée avec succès!" -ForegroundColor Green
Write-Host "🔄 Prochaines étapes:" -ForegroundColor Cyan
Write-Host "1. Allez sur: https://github.com/elmaquito/Automated-Portfolio/pulls" -ForegroundColor Blue
Write-Host "2. Cliquez sur 'New Pull Request'" -ForegroundColor Blue  
Write-Host "3. Sélectionnez: feature/tp-securite → main" -ForegroundColor Blue
Write-Host "4. Créez la Pull Request" -ForegroundColor Blue
Write-Host "5. Mergez une fois les vérifications passées" -ForegroundColor Blue

Write-Host "=====================================" -ForegroundColor Cyan