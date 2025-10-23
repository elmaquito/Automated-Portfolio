#!/usr/bin/env node
/**
 * 🔍 VALIDATION COMPLÈTE PRÉ-DÉPLOIEMENT
 * Vérifie frontmatter YAML, scripts requis, et génère un rapport
 */

const fs = require('fs');
const path = require('path');

console.log('🔍 VALIDATION PRÉ-DÉPLOIEMENT');
console.log('=============================');

let errors = 0;
let warnings = 0;

// 1. Vérifier les scripts requis
console.log('\n📋 Vérification des scripts requis...');
const requiredScripts = [
  'scripts/generate-search-index.js',
  'scripts/validate-markdown.ps1',
  'scripts/clean-github-cache.ps1'
];

requiredScripts.forEach(script => {
  if (fs.existsSync(script)) {
    console.log(`✅ ${script}`);
  } else {
    console.log(`❌ MANQUANT: ${script}`);
    errors++;
  }
});

// 2. Validation YAML des fichiers Markdown
console.log('\n📋 Validation YAML frontmatter...');

function walkMdFiles(dir, files = []) {
  if (!fs.existsSync(dir)) return files;
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walkMdFiles(fullPath, files);
    } else if (entry.name.endsWith('.md')) {
      files.push(fullPath);
    }
  }
  return files;
}

const mdFiles = walkMdFiles('content');
console.log(`Trouvé ${mdFiles.length} fichiers Markdown`);

mdFiles.forEach(file => {
  try {
    const content = fs.readFileSync(file, 'utf8');
    const lines = content.split('\n');
    
    // Vérifier le début du frontmatter
    if (!lines[0].trim().startsWith('---')) {
      console.log(`❌ ${file}: Frontmatter manquant`);
      errors++;
      return;
    }
    
    // Trouver la fin du frontmatter
    let endIndex = -1;
    for (let i = 1; i < Math.min(lines.length, 50); i++) {
      if (lines[i].trim() === '---') {
        endIndex = i;
        break;
      }
    }
    
    if (endIndex === -1) {
      console.log(`❌ ${file}: Frontmatter non fermé`);
      errors++;
      return;
    }
    
    // Vérifier la structure YAML de base
    const frontmatter = lines.slice(1, endIndex).join('\n');
    
    // Vérifications basiques
    if (!frontmatter.includes('title:')) {
      console.log(`❌ ${file}: Titre manquant`);
      errors++;
      return;
    }
    
    // Vérifier les valeurs non-quotées avec ":"
    const problematicLines = [];
    lines.slice(1, endIndex).forEach((line, index) => {
      if (line.includes(':') && !line.startsWith(' ') && !line.startsWith('-')) {
        const [key, ...valueParts] = line.split(':');
        const value = valueParts.join(':').trim();
        if (value && !value.startsWith('"') && !value.startsWith("'") && value.includes(':')) {
          problematicLines.push(index + 2); // +2 car on commence à la ligne 1 et on a sauté la première ---
        }
      }
    });
    
    if (problematicLines.length > 0) {
      console.log(`⚠️  ${file}: Valeurs potentiellement problématiques aux lignes ${problematicLines.join(', ')}`);
      warnings++;
    } else {
      console.log(`✅ ${file}: YAML valide`);
    }
    
  } catch (err) {
    console.log(`❌ ${file}: Erreur de lecture - ${err.message}`);
    errors++;
  }
});

// 3. Vérifier la structure Hugo
console.log('\n📋 Vérification structure Hugo...');
const hugoStructure = [
  'hugo.toml',
  'layouts',
  'content',
  'static'
];

hugoStructure.forEach(item => {
  if (fs.existsSync(item)) {
    console.log(`✅ ${item}`);
  } else {
    console.log(`❌ MANQUANT: ${item}`);
    errors++;
  }
});

// 4. Test de build Hugo (simulation)
console.log('\n📋 Test de configuration Hugo...');
try {
  if (fs.existsSync('hugo.toml')) {
    const config = fs.readFileSync('hugo.toml', 'utf8');
    if (config.includes('baseURL')) {
      console.log('✅ Configuration Hugo basique présente');
    } else {
      console.log('⚠️  Configuration Hugo incomplète');
      warnings++;
    }
  }
} catch (err) {
  console.log(`❌ Erreur lecture config Hugo: ${err.message}`);
  errors++;
}

// 5. Rapport final
console.log('\n=============================');
console.log('📊 RAPPORT FINAL');
console.log('=============================');

if (errors === 0 && warnings === 0) {
  console.log('🎉 VALIDATION RÉUSSIE - Prêt pour le déploiement !');
  process.exit(0);
} else {
  console.log(`❌ Erreurs: ${errors}`);
  console.log(`⚠️  Avertissements: ${warnings}`);
  
  if (errors > 0) {
    console.log('\n🔧 Actions recommandées:');
    console.log('1. Corriger les erreurs YAML frontmatter');
    console.log('2. Ajouter les scripts manquants');
    console.log('3. Re-exécuter cette validation');
    process.exit(1);
  } else {
    console.log('\n✅ Déploiement possible avec avertissements');
    process.exit(0);
  }
}