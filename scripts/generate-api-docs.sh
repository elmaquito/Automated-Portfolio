#!/bin/bash

# 📚 API Documentation Generator
# Generates API documentation from code comments (Python/JavaScript)

set -e

LANG_TYPE="$1"

if [ -z "$LANG_TYPE" ]; then
    echo "Usage: $0 [python|javascript]"
    exit 1
fi

case "$LANG_TYPE" in
    "python")
        echo "🐍 Generating Python API documentation..."
        
        # Find Python files
        PYTHON_FILES=$(find . -name "*.py" -not -path "./venv/*" -not -path "./.venv/*" -not -path "./node_modules/*" | head -10)
        
        if [ -z "$PYTHON_FILES" ]; then
            echo "⚠️ No Python files found"
            exit 0
        fi
        
        # Create output directory
        mkdir -p content/docs/python
        
        # Generate Sphinx documentation
        cat > content/docs/python/_index.md <<EOF
---
title: "Documentation Python API"
description: "Documentation des APIs Python générée automatiquement"
weight: 20
---

# Documentation Python API

Documentation générée automatiquement depuis les docstrings Python.

$(date '+Generated on %Y-%m-%d at %H:%M:%S')

## Modules disponibles

EOF
        
        # Process each Python file
        echo "$PYTHON_FILES" | while read -r pyfile; do
            if [ -n "$pyfile" ]; then
                filename=$(basename "$pyfile" .py)
                echo "📄 Processing: $pyfile"
                
                # Extract docstrings and create markdown
                cat >> content/docs/python/_index.md <<EOF

### $filename

\`\`\`python
# File: $pyfile
\`\`\`

EOF
                # Basic docstring extraction (can be enhanced)
                grep -A 10 '"""' "$pyfile" | head -20 >> content/docs/python/_index.md || true
            fi
        done
        
        echo "✅ Python documentation generated"
        ;;
        
    "javascript")
        echo "📜 Generating JavaScript API documentation..."
        
        # Find JavaScript files
        JS_FILES=$(find . -name "*.js" -not -path "./node_modules/*" -not -path "./public/*" | head -10)
        
        if [ -z "$JS_FILES" ]; then
            echo "⚠️ No JavaScript files found"
            exit 0
        fi
        
        # Create output directory
        mkdir -p content/docs/javascript
        
        # Generate JSDoc documentation
        cat > content/docs/javascript/_index.md <<EOF
---
title: "Documentation JavaScript API"
description: "Documentation des APIs JavaScript générée automatiquement"
weight: 30
---

# Documentation JavaScript API

Documentation générée automatiquement depuis les commentaires JSDoc.

$(date '+Generated on %Y-%m-%d at %H:%M:%S')

## Modules disponibles

EOF
        
        # Process each JavaScript file
        echo "$JS_FILES" | while read -r jsfile; do
            if [ -n "$jsfile" ]; then
                filename=$(basename "$jsfile" .js)
                echo "📄 Processing: $jsfile"
                
                # Extract JSDoc comments and create markdown
                cat >> content/docs/javascript/_index.md <<EOF

### $filename

\`\`\`javascript
// File: $jsfile
\`\`\`

EOF
                # Basic JSDoc extraction (can be enhanced)
                grep -A 5 '/\*\*' "$jsfile" | head -15 >> content/docs/javascript/_index.md || true
            fi
        done
        
        echo "✅ JavaScript documentation generated"
        ;;
        
    *)
        echo "❌ Unsupported language: $LANG_TYPE"
        echo "Supported languages: python, javascript"
        exit 1
        ;;
esac

echo "🎉 API documentation generation completed for $LANG_TYPE"