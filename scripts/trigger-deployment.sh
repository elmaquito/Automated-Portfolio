#!/bin/bash

# Script pour déclencher manuellement le workflow de déploiement
# Usage: bash trigger-deployment.sh

echo "🚀 Triggering manual deployment workflow..."
echo "Repository: elmaquito/Automated-Portfolio" 
echo "Workflow: Deploy v2.0 (No Node.js)"
echo "========================================="

# Note: Ce script nécessite GitHub CLI (gh) installé et configuré
# Installation: https://cli.github.com/

# Déclencher le workflow manuellement
if command -v gh &> /dev/null; then
    echo "📡 Triggering workflow via GitHub CLI..."
    gh workflow run "🚀 Build and Deploy to OVH (v2.0 - No Node.js)" 
    
    echo "✅ Workflow triggered successfully!"
    echo "🔍 Monitor progress at: https://github.com/elmaquito/Automated-Portfolio/actions"
    
    # Attendre 5 secondes et vérifier le status
    echo "⏳ Waiting for workflow to start..."
    sleep 5
    gh run list --limit 3
else
    echo "❌ GitHub CLI not installed"
    echo "💡 Manual trigger options:"
    echo "1. Go to: https://github.com/elmaquito/Automated-Portfolio/actions"
    echo "2. Select '🚀 Build and Deploy to OVH (v2.0 - No Node.js)'"
    echo "3. Click 'Run workflow' > 'Run workflow'"
    echo ""
    echo "🔧 Or install GitHub CLI:"
    echo "winget install GitHub.cli"
fi

echo ""
echo "🎯 What to expect:"
echo "✅ Hugo setup and build (should work)"
echo "❌ FTP deployment (needs FTP_PASSWORD secret)"
echo "💡 Configure secret at: https://github.com/elmaquito/Automated-Portfolio/settings/secrets/actions"