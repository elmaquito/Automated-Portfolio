# 🚀 Portfolio Automatisé - Ismael Martinez

Portfolio professionnel avec documentation technique automatisée, généré avec Hugo et déployé sur OVH.

## ✨ Fonctionnalités

- 🏗️ **Site statique Hugo** avec thème Docsy professionnel
- 📝 **Sync Obsidian automatique** - Écrivez en Markdown, publiez automatiquement
- 🔄 **CI/CD complet** - GitHub Actions → Build → Deploy OVH
- 📚 **API Documentation** - Génération auto Python (Sphinx) + JavaScript (JSDoc)
- 🔍 **Recherche intégrée** - lunr.js pour recherche full-text côté client
- 📱 **Responsive & Performance** - Mobile-first, optimisations automatiques
- 📧 **Contact & Commentaires** - Formspree + Giscus intégrés
- 📊 **Analytics** - Plausible privacy-friendly
- 🏷️ **Versioning** - Documentation versionnée par tags Git

## 🏗️ Architecture

```
Automated-Portfolio/
├── .github/workflows/       # GitHub Actions (CI/CD)
├── config/                 # Configuration Hugo
├── content/                # Contenu du site
│   ├── projects/          # Portfolio projets
│   ├── docs/              # Documentation technique
│   ├── blog/              # Articles
│   └── about/             # Pages statiques
├── static/                # Assets (images, CSS, JS)
├── layouts/               # Templates Hugo personnalisés
├── scripts/               # Scripts d'automatisation
├── docs-source/           # Vault Obsidian (source)
└── themes/                # Thème Hugo Docsy
```

## 🚀 Déploiement

### Prérequis

1. **Hébergement OVH** configuré (credentials SFTP)
2. **GitHub Secrets** configurés :
   - `FTP_PASSWORD` : Mot de passe SFTP OVH
3. **Node.js 18+** et **Hugo Extended 0.110+**

### Installation

```bash
# Cloner le repository
git clone https://github.com/elmaquito/Automated-Portfolio.git
cd Automated-Portfolio

# Installer les dépendances
npm install

# Initialiser Hugo modules
hugo mod init github.com/elmaquito/Automated-Portfolio
hugo mod get -u

# Développement local
npm run dev

# Build de production
npm run build
```

## 📝 Workflow Obsidian

### Configuration Obsidian

1. Cloner le repo localement
2. Ouvrir `docs-source/` comme vault Obsidian
3. Installer le plugin **Obsidian Git**
4. Configurer auto-commit sur sauvegarde

### Écriture et Publication

1. **Écrire** dans Obsidian (`docs-source/`)
2. **Auto-commit** Git (plugin Obsidian)
3. **GitHub Action** convertit et déploie automatiquement
4. **Site live** en quelques minutes

### Conversion Automatique

- `[[Liens internes]]` → `{{< ref >}}`
- Images Obsidian → Static assets Hugo
- Métadonnées YAML préservées
- Structure de dossiers maintenue

## 📚 API Documentation

### Python Documentation

```bash
# Créer branche python-docs
git checkout -b python-docs

# Ajouter code Python avec docstrings
# Commit → GitHub Action génère docs Sphinx automatiquement
```

### JavaScript Documentation

```bash
# Créer branche js-docs
git checkout -b js-docs

# Ajouter code JS avec JSDoc comments
# Commit → GitHub Action génère docs JSDoc automatiquement
```

## 🛠️ Scripts Disponibles

```bash
npm run dev          # Serveur de développement Hugo
npm run build        # Build de production
npm run deploy       # Déploiement manuel OVH
npm run sync-obsidian # Sync manuel Obsidian
npm run generate-api-docs # Génération docs API
npm run search-index # Génération index de recherche
npm run test         # Tests + link checker
```

## 📊 Intégrations Services

### Formspree (Formulaire Contact)
```toml
# config/params.toml
[contact]
formspree_endpoint = \"YOUR_FORMSPREE_ID\"
```

### Plausible (Analytics)
```toml
# config/params.toml  
[analytics]
plausible_domain = \"martinezismael.fr\"
```

### Giscus (Commentaires)
```toml
# config/params.toml
[comments]
giscus_repo = \"elmaquito/Automated-Portfolio\"
giscus_category = \"Documentation Comments\"
```

## 🔧 Configuration OVH

### Credentials SFTP
- **Host**: `ftp.cluster021.hosting.ovh.net`
- **Username**: `martisx`
- **Password**: Stocké dans GitHub Secrets
- **Directory**: `/www/`

### GitHub Secrets Required
```
FTP_PASSWORD=Pzz8F2SsJA6PcDYUa5ctuzjphstJ
```

## 🎯 Roadmap

### Phase 1 ✅
- [x] Structure Hugo de base
- [x] Thème Docsy configuré
- [x] Workflows GitHub Actions
- [x] Déploiement OVH automatique

### Phase 2 🚧
- [ ] Sync Obsidian fonctionnel
- [ ] Génération API docs Python/JS
- [ ] Formulaire contact Formspree
- [ ] Système commentaires Giscus

### Phase 3 📋
- [ ] Recherche lunr.js
- [ ] Analytics Plausible
- [ ] Versioning documentation
- [ ] Optimisations performance

## 📞 Support

- 📧 [Contact](https://www.martinezismael.fr/contact/)
- 🐛 [Issues GitHub](https://github.com/elmaquito/Automated-Portfolio/issues)
- 📖 [Documentation](https://www.martinezismael.fr/docs/)

## 📄 Licence

MIT © [Ismael Martinez](https://github.com/elmaquito)

---

*Généré automatiquement avec ❤️ par Hugo + GitHub Actions*