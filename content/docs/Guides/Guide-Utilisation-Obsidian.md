---# Guide d'utilisation du Portfolio Automatisé

title: "Guide d'utilisation Obsidian"

description: "Guide pour utiliser Obsidian avec le portfolio automatisé"## Workflow de documentation

tags: ["guide", "obsidian", "workflow"]

date: 2025-10-17### Écriture avec Obsidian

---- Utilisez ce vault (`docs-source/`) pour écrire vos notes

- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`

# Guide d'utilisation du Portfolio Automatisé- Les images vont dans `attachments/`



## Workflow de documentation### Synchronisation automatique

Le plugin Obsidian Git va :

### Écriture avec Obsidian1. **Auto-commit** vos changements

- Utilisez ce vault (`docs-source/`) pour écrire vos notes2. **Push** vers GitHub 

- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`3. Déclencher la **GitHub Action** de sync

- Les images vont dans `attachments/`4. Convertir et déployer vers le **site web**



### Synchronisation automatique### Syntaxe supportée

Le plugin Obsidian Git va :- `{{< ref "/docs/projects/premier-test-obsidian" >}}` → Convertis en liens Hugo

1. **Auto-commit** vos changements- `![Image](/images/docs/images.png)` → Images copiées automatiquement  

2. **Push** vers GitHub - **Métadonnées YAML** → Préservées pour Hugo

3. Déclencher la **GitHub Action** de sync- **Markdown standard** → Supporté intégralement

4. Convertir et déployer vers le **site web**

## Configuration du plugin Obsidian Git

### Syntaxe supportée

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo1. **Installer** le plugin "Obsidian Git"

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  2. **Activer** l'auto-backup

- **Métadonnées YAML** → Préservées pour Hugo3. **Configurer** :

- **Markdown standard** → Supporté intégralement   - Auto backup interval: 5 minutes

   - Auto pull interval: 10 minutes

## Configuration du plugin Obsidian Git   - Commit message: "📝 Auto-sync Obsidian notes"



1. **Installer** le plugin "Obsidian Git"## Structure recommandée

2. **Activer** l'auto-backup

3. **Configurer** :```

   - Auto backup interval: 5 minutesdocs-source/

   - Auto pull interval: 10 minutes├── Projects/          # Documentation projets

   - Commit message: "📝 Auto-sync Obsidian notes"├── Guides/           # Tutoriels et guides  

├── Notes/            # Notes techniques

## Structure recommandée├── attachments/      # Images et fichiers

└── _index.md         # Page d'accueil docs

``````

docs-source/

├── Projects/          # Documentation projets---

├── Guides/           # Tutoriels et guides  

├── Notes/            # Notes techniques*Ce guide sera également synchronisé automatiquement !*
├── attachments/      # Images et fichiers
└── _index.md         # Page d'accueil docs
```

---

*Ce guide sera également synchronisé automatiquement !*