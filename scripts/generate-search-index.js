#!/usr/bin/env node
/**
 * Génère public/search-index.json à partir des fichiers HTML dans public/
 * - Aucun package externe requis
 * - Lit tous les .html sous public/, extrait title/h1 et un extrait texte
 */

const fs = require('fs');
const path = require('path');

function walk(dir, cb) {
  if (!fs.existsSync(dir)) return;
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const e of entries) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, cb);
    else cb(p);
  }
}

function stripHtml(html) {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, ' ')
    .replace(/<style[\s\S]*?<\/style>/gi, ' ')
    .replace(/<\/?[^>]+(>|$)/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

const publicDir = path.join(process.cwd(), 'public');

if (!fs.existsSync(publicDir)) {
  console.log('public/ not found — skipping search index generation');
  process.exit(0);
}

const items = [];

walk(publicDir, (file) => {
  if (!file.endsWith('.html')) return;
  try {
    const html = fs.readFileSync(file, 'utf8');
    const rel = path.relative(publicDir, file).replace(/\\/g, '/');
    // Build a friendly URL: remove trailing index.html
    let url = '/' + rel;
    url = url.replace(/index\.html$/, '');
    url = url.replace(/\.html$/, '');
    
    const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i);
    const h1Match = html.match(/<h1[^>]*>([^<]+)<\/h1>/i);
    const title = (h1Match && h1Match[1].trim()) || (titleMatch && titleMatch[1].trim()) || '';
    
    const text = stripHtml(html);
    const excerpt = text.slice(0, 400);
    
    items.push({ url, title, excerpt });
  } catch (err) {
    console.error('Error reading', file, err && err.message);
  }
});

const outPath = path.join(publicDir, 'search-index.json');
fs.writeFileSync(outPath, JSON.stringify(items, null, 2), 'utf8');
console.log(`✅ Wrote ${outPath} (${items.length} entries)`);
process.exit(0);