#!/usr/bin/env node

/**
 * 🔍 Search Index Generator for lunr.js
 * Generates a search index from Hugo-generated content
 */

const fs = require('fs');
const path = require('path');
const lunr = require('lunr');

// Configuration
const PUBLIC_DIR = 'public';
const OUTPUT_FILE = path.join(PUBLIC_DIR, 'search-index.json');
const CONTENT_DIRS = ['docs', 'projects', 'blog'];

/**
 * Extract text content from HTML files
 */
function extractTextFromHTML(html) {
    // Remove HTML tags and get clean text
    return html
        .replace(/<script[^>]*>.*?<\/script>/gis, '')
        .replace(/<style[^>]*>.*?<\/style>/gis, '')
        .replace(/<[^>]+>/g, '')
        .replace(/\s+/g, ' ')
        .trim();
}

/**
 * Get metadata from HTML head
 */
function extractMetadata(html) {
    const titleMatch = html.match(/<title[^>]*>(.*?)<\/title>/i);
    const descriptionMatch = html.match(/<meta[^>]*name="description"[^>]*content="([^"]*)"[^>]*>/i);
    const keywordsMatch = html.match(/<meta[^>]*name="keywords"[^>]*content="([^"]*)"[^>]*>/i);
    
    return {
        title: titleMatch ? titleMatch[1] : '',
        description: descriptionMatch ? descriptionMatch[1] : '',
        keywords: keywordsMatch ? keywordsMatch[1] : ''
    };
}

/**
 * Scan directory for HTML files
 */
function scanDirectory(dir) {
    const documents = [];
    
    function scanRecursive(currentDir) {
        const items = fs.readdirSync(currentDir);
        
        for (const item of items) {
            const itemPath = path.join(currentDir, item);
            const stat = fs.statSync(itemPath);
            
            if (stat.isDirectory()) {
                scanRecursive(itemPath);
            } else if (item.endsWith('.html') && !item.startsWith('.')) {
                try {
                    const html = fs.readFileSync(itemPath, 'utf8');
                    const metadata = extractMetadata(html);
                    const content = extractTextFromHTML(html);
                    
                    // Skip if no content
                    if (content.length < 50) continue;
                    
                    const relativePath = path.relative(PUBLIC_DIR, itemPath);
                    const url = '/' + relativePath.replace(/index\.html$/, '').replace(/\.html$/, '/');
                    
                    documents.push({
                        id: relativePath,
                        url: url,
                        title: metadata.title,
                        description: metadata.description,
                        keywords: metadata.keywords,
                        content: content.substring(0, 1000), // Limit content size
                        contentLength: content.length
                    });
                    
                    console.log(`✅ Indexed: ${url}`);
                } catch (error) {
                    console.error(`❌ Error processing ${itemPath}:`, error.message);
                }
            }
        }
    }
    
    if (fs.existsSync(dir)) {
        scanRecursive(dir);
    }
    
    return documents;
}

/**
 * Generate search index
 */
function generateSearchIndex() {
    console.log('🔍 Generating search index...');
    
    if (!fs.existsSync(PUBLIC_DIR)) {
        console.error(`❌ Public directory not found: ${PUBLIC_DIR}`);
        console.log('💡 Make sure to run "hugo" first to generate the site');
        process.exit(1);
    }
    
    let allDocuments = [];
    
    // Scan content directories
    for (const contentDir of CONTENT_DIRS) {
        const fullPath = path.join(PUBLIC_DIR, contentDir);
        console.log(`📁 Scanning: ${contentDir}/`);
        const documents = scanDirectory(fullPath);
        allDocuments = allDocuments.concat(documents);
    }
    
    // Also scan root directory for main pages
    console.log('📁 Scanning root pages...');
    const rootDocs = scanDirectory(PUBLIC_DIR).filter(doc => 
        !CONTENT_DIRS.some(dir => doc.url.startsWith(`/${dir}/`))
    );
    allDocuments = allDocuments.concat(rootDocs);
    
    if (allDocuments.length === 0) {
        console.log('⚠️ No documents found to index');
        return;
    }
    
    console.log(`📊 Found ${allDocuments.length} documents`);
    
    // Create lunr index
    const idx = lunr(function() {
        this.ref('id');
        this.field('title', { boost: 10 });
        this.field('description', { boost: 5 });
        this.field('keywords', { boost: 3 });
        this.field('content');
        
        // Add French language support
        this.use(lunr.fr);
        
        allDocuments.forEach(doc => {
            this.add(doc);
        });
    });
    
    // Prepare output data
    const searchData = {
        index: idx,
        documents: allDocuments.map(doc => ({
            id: doc.id,
            url: doc.url,
            title: doc.title,
            description: doc.description,
            keywords: doc.keywords
        })),
        meta: {
            generated: new Date().toISOString(),
            documentCount: allDocuments.length,
            version: '1.0.0'
        }
    };
    
    // Write to file
    fs.writeFileSync(OUTPUT_FILE, JSON.stringify(searchData, null, 2));
    
    console.log(`✅ Search index generated: ${OUTPUT_FILE}`);
    console.log(`📊 Indexed ${allDocuments.length} documents`);
    console.log('🔍 Search functionality ready!');
}

// Run if called directly
if (require.main === module) {
    try {
        generateSearchIndex();
    } catch (error) {
        console.error('❌ Error generating search index:', error);
        process.exit(1);
    }
}

module.exports = { generateSearchIndex };