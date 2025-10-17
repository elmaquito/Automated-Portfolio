#!/bin/bash

# Script pour vérifier le status des GitHub Actions via l'API GitHub
# Usage: ./check-build-status.sh

echo "🔍 Checking GitHub Actions status for Automated-Portfolio..."
echo "Repository: elmaquito/Automated-Portfolio"
echo "========================================="

# Récupérer les 3 dernières executions
curl -s -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/elmaquito/Automated-Portfolio/actions/runs?per_page=3" \
  | jq -r '.workflow_runs[] | "🔹 Run #\(.run_number) - \(.status) - \(.conclusion // "in_progress") - \(.head_commit.message[0:60])..."'

echo ""
echo "📊 Latest workflow status:"
curl -s -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/elmaquito/Automated-Portfolio/actions/runs?per_page=1" \
  | jq -r '.workflow_runs[0] | "Status: \(.status)\nConclusion: \(.conclusion // "N/A")\nCommit: \(.head_commit.message)\nURL: \(.html_url)"'

echo ""
echo "💡 To monitor in real-time: https://github.com/elmaquito/Automated-Portfolio/actions"