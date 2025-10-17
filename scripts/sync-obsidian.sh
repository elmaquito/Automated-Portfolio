#!/bin/bash

# 📝 Obsidian to Hugo synchronization script
# Converts Obsidian markdown files to Hugo-compatible format

set -e

SOURCE_DIR="docs-source"
TARGET_DIR="content/docs"
IMAGES_SOURCE="docs-source/attachments"
IMAGES_TARGET="static/images/docs"

echo "📝 Starting Obsidian sync..."

# Create target directories if they don't exist
mkdir -p "$TARGET_DIR"
mkdir -p "$IMAGES_TARGET"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "📁 Creating Obsidian source directory: $SOURCE_DIR"
    mkdir -p "$SOURCE_DIR"
    
    # Create initial structure
    cat > "$SOURCE_DIR/_index.md" <<EOF
---
title: "Documentation"
description: "Documentation technique générée depuis Obsidian"
weight: 10
---

# Documentation

Cette section contient la documentation technique de mes projets, synchronisée automatiquement depuis Obsidian.

## Structure

- **Projets** : Documentation des projets individuels
- **Guides** : Tutoriels et guides techniques
- **API** : Documentation des APIs (générée automatiquement)
- **Notes** : Notes techniques et mémos
EOF

    echo "✅ Obsidian structure created"
    exit 0
fi

echo "🔄 Converting Obsidian files..."

# Function to convert Obsidian links to Hugo refs
convert_obsidian_links() {
    local file="$1"
    
    # Convert ![[image.ext]] to proper image syntax first
    sed -i 's/!\[\[\([^]]*\)\]\]/![Image](\/images\/docs\/\1)/g' "$file"
    
    # Convert [[Page Name]] to lowercase with hyphens and proper ref
    # This handles spaces and special characters
    sed -i 's/\[\[\([^]]*\)\]\]/{{< ref "\L\1" >}}/g' "$file"
    
    # Clean up refs: convert spaces and slashes to hyphens
    sed -i 's/{{< ref "\([^"]*\)[ \/]\([^"]*\)" >}}/{{< ref "\1-\2" >}}/g' "$file"
    sed -i 's/{{< ref "\([^"]*\)[ \/]\([^"]*\)[ \/]\([^"]*\)" >}}/{{< ref "\1-\2-\3" >}}/g' "$file"
    
    # Convert to lowercase and clean special chars in refs
    sed -i 's/{{< ref "\([^"]*\)" >}}/\L&/g' "$file"
}

# Copy and convert markdown files
find "$SOURCE_DIR" -name "*.md" -type f | while read -r file; do
    # Get relative path and target file
    rel_path="${file#$SOURCE_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    
    # Create target directory
    mkdir -p "$(dirname "$target_file")"
    
    # Copy and convert file
    cp "$file" "$target_file"
    convert_obsidian_links "$target_file"
    
    echo "✅ Converted: $rel_path"
done

# Copy images and attachments
if [ -d "$IMAGES_SOURCE" ]; then
    echo "🖼️ Copying images..."
    cp -r "$IMAGES_SOURCE"/* "$IMAGES_TARGET"/ 2>/dev/null || true
    echo "✅ Images copied"
fi

echo "🎉 Obsidian sync completed!"
echo "📁 Files synced to: $TARGET_DIR"
echo "🖼️ Images synced to: $IMAGES_TARGET"