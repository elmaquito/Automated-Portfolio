# 🚀 Portfolio Automatisé - Ismael Martinez

Portfolio professionnel avec documentation technique automatisée, monitoring et détection d'anomalies.

## ✨ Fonctionnalités

### Portfolio & Documentation
- 🏗️ **Site statique Hugo** avec layouts personnalisés Bootstrap 5
- 📝 **Sync Obsidian automatique** - Écrivez en Markdown, publiez automatiquement
- 🔄 **CI/CD complet** - GitHub Actions → Build → Deploy OVH
- 📱 **Responsive & Performance** - Mobile-first, optimisations automatiques
- ✅ **Validation automatique** - Markdown, YAML frontmatter, liens
- 📊 **Portfolio projets** - Showcase automatique depuis documentation

### Phase 1: Data Collection & Anomaly Detection (NEW)
- 🔍 **Time Series Generator** - Synthetic data with multiple anomaly types
- 📈 **Monitoring Stack** - Kafka, Prometheus, Grafana, ELK
- 🚨 **Anomaly Detection** - Spike, drift, level shift, missing values detection
- 📊 **Visualization** - Grafana dashboards and Kibana exploration
- 🔄 **Data Pipeline** - Complete ETL pipeline for time series metrics

## 🏗️ Architecture

```
Automated-Portfolio/
├── .github/workflows/       # GitHub Actions (CI/CD)
├── content/                # Contenu Hugo (portfolio)
├── infra/                  # Infrastructure (NEW - Phase 1)
│   ├── dockerfiles/       # Docker images
│   ├── prometheus/        # Prometheus config
│   ├── grafana/           # Grafana dashboards
│   ├── elk/               # ELK stack config
│   └── kafka/             # Kafka config
├── src/                    # Application code (NEW - Phase 1)
│   ├── collector/         # Data generation & collection
│   ├── ingestion/         # Kafka consumer & preprocessing
│   ├── models/            # ML models (training & serving)
│   └── tests/             # Unit tests
├── notebooks/              # Jupyter notebooks (NEW - Phase 1)
├── data/                   # Sample datasets (NEW - Phase 1)
├── scripts/                # Automation scripts (Enhanced)
│   ├── bootstrap.sh       # Environment setup
│   ├── init.sh            # Infrastructure initialization
│   ├── seed-data.sh       # Data generation
│   └── kafka_playback.py  # Data replay tool
├── docs/                   # Project documentation (Enhanced)
│   └── phase1/            # Phase 1 documentation
├── layouts/               # Templates Hugo personnalisés
├── static/                # Assets (images, CSS, JS)
├── docker-compose.yml     # Infrastructure orchestration (NEW)
└── requirements.txt       # Python dependencies (NEW)
```

## 🚀 Déploiement

### Installation

```bash
# Cloner le repository
git clone https://github.com/elmaquito/Automated-Portfolio.git
cd Automated-Portfolio

# Installer les dépendances
npm install

# Développement local
hugo server -D

# Build de production
hugo --minify
```

## 📝 Workflow Obsidian

### Configuration

1. Cloner le repo localement
2. Ouvrir `docs-source/` comme vault Obsidian
3. Installer le plugin **Obsidian Git**
4. Configurer auto-commit sur sauvegarde

### Publication Automatique

1. **Écrire** dans Obsidian (`docs-source/`)
2. **Auto-commit** Git (plugin Obsidian)
3. **GitHub Action** convertit et déploie automatiquement
4. **Site live** en quelques minutes sur https://www.martinezismael.fr

### Formats Supportés

- Frontmatter YAML automatiquement préservé
- Liens internes Obsidian convertis automatiquement
- Images optimisées et déployées
- Structure de dossiers maintenue

## 🛠️ Scripts Disponibles

```bash
npm run dev          # Serveur de développement Hugo
npm run build        # Build de production
npm run validate     # Validation Markdown
```

## 🔧 Configuration OVH

### GitHub Secrets Requis
```
FTP_PASSWORD=Pzz8F2SsJA6PcDYUa5ctuzjphstJ
```

### Hébergement
- **Host**: `ftp.cluster021.hosting.ovh.net`
- **Username**: `martisx`
- **Directory**: `/www/`
- **Site**: https://www.martinezismael.fr

## 📚 Documentation

- [🚀 Guide de Déploiement](docs/DEPLOYMENT.md)
- [🛠️ Guide de Développement](docs/DEVELOPMENT.md)  
- [🔧 Guide de Dépannage](docs/TROUBLESHOOTING.md)

## 🎯 Roadmap

### Phase 1 ✅
- [x] Structure Hugo optimisée
- [x] Layouts Bootstrap 5 personnalisés
- [x] Workflows GitHub Actions
- [x] Déploiement OVH automatique
- [x] Validation Markdown intégrée

### Phase 2 🚧
- [x] Sync Obsidian fonctionnel
- [ ] Formulaire contact Formspree
- [ ] Système commentaires Giscus
- [ ] Analytics Plausible

### Phase 3 📋
- [ ] Recherche lunr.js
- [ ] Génération API docs Python/JS
- [ ] Versioning documentation
- [ ] Optimisations performance avancées

## 📞 Support

- 📧 [Contact](https://www.martinezismael.fr/contact/)
- 🐛 [Issues GitHub](https://github.com/elmaquito/Automated-Portfolio/issues)
- 📖 [Documentation](https://www.martinezismael.fr/docs/)

## 📄 Licence

MIT © [Ismael Martinez](https://github.com/elmaquito)

---

*Généré automatiquement avec ❤️ par Hugo + GitHub Actions*

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