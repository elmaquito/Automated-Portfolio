#!/bin/bash

# 🚀 Automated deployment script for OVH hosting
# This script builds the Hugo site and uploads it to OVH via SFTP

set -e

echo "🏗️ Building Hugo site..."
hugo --minify --enableGitInfo

echo "📊 Generating search index..."
node scripts/generate-search-index.js || echo "Search index generation skipped"

echo "🔍 Running link checker..."
linkinator public --recurse --skip "^mailto:" --verbosity error

echo "✅ Build completed successfully!"

if [ "$1" = "--deploy" ]; then
    echo "🚀 Deploying to OVH..."
    
    # Check if credentials are available
    if [ -z "$FTP_PASSWORD" ]; then
        echo "❌ FTP_PASSWORD environment variable not set"
        echo "💡 Set it with: export FTP_PASSWORD='your-password'"
        exit 1
    fi
    
    # Upload via SFTP (requires lftp)
    lftp -u martisx,$FTP_PASSWORD ftp.cluster021.hosting.ovh.net <<EOF
set ftp:ssl-allow no
set sftp:auto-confirm yes
mirror -R --delete --verbose public/ www/
bye
EOF
    
    echo "✅ Deployment completed!"
    echo "🌐 Site available at: https://www.martinezismael.fr"
else
    echo "💡 To deploy, run: ./scripts/deploy.sh --deploy"
fi