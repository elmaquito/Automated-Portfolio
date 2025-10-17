------

title: "Guide d'utilisation Obsidian"title: "Guide d'utilisation Obsidian"

description: "Guide pour utiliser Obsidian avec le portfolio automatisé"description: "Guide pour utiliser Obsidian avec le portfolio automatisé"

tags: ["guide", "obsidian", "workflow"]tags: ["guide", "obsidian", "workflow"]

date: 2025-10-17date: 2025-10-17

------



# Guide d'utilisation du Portfolio Automatisé# Guide d'utilisation du Portfolio Automatisé



## Workflow de documentation## Workflow de documentation



### Écriture avec Obsidian### Écriture avec Obsidian

- Utilisez ce vault (`docs-source/`) pour écrire vos notes- Utilisez ce vault (`docs-source/`) pour écrire vos notes

- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`

- Les images vont dans `attachments/`- Les images vont dans `attachments/`



### Synchronisation automatique

Le plugin Obsidian Git va :

1. **Auto-commit** vos changements## Workflow de documentation### Synchronisation automatique

2. **Push** vers GitHub 

3. Déclencher la **GitHub Action** de syncLe plugin Obsidian Git va :

4. Convertir et déployer vers le **site web**

### Écriture avec Obsidian1. **Auto-commit** vos changements

### Syntaxe supportée

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo- Utilisez ce vault (`docs-source/`) pour écrire vos notes2. **Push** vers GitHub 

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  

- **Métadonnées YAML** → Préservées pour Hugo- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`3. Déclencher la **GitHub Action** de sync

- **Markdown standard** → Supporté intégralement

- Les images vont dans `attachments/`4. Convertir et déployer vers le **site web**

## Configuration du plugin Obsidian Git



1. **Installer** le plugin "Obsidian Git"

2. **Activer** l'auto-backup### Synchronisation automatique### Syntaxe supportée

3. **Configurer** :

   - Auto backup interval: 5 minutesLe plugin Obsidian Git va :- `{{< ref "/docs/projects/premier-test-obsidian" >}}` → Convertis en liens Hugo

   - Auto pull interval: 10 minutes

   - Commit message: "📝 Auto-sync Obsidian notes"1. **Auto-commit** vos changements- `![Image](/images/docs/images.png)` → Images copiées automatiquement  



## Structure recommandée2. **Push** vers GitHub - **Métadonnées YAML** → Préservées pour Hugo



```3. Déclencher la **GitHub Action** de sync- **Markdown standard** → Supporté intégralement

docs-source/

├── Projects/          # Documentation projets4. Convertir et déployer vers le **site web**

├── Guides/           # Tutoriels et guides  

├── Notes/            # Notes techniques## Configuration du plugin Obsidian Git

├── attachments/      # Images et fichiers

└── _index.md         # Page d'accueil docs### Syntaxe supportée

```

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo1. **Installer** le plugin "Obsidian Git"

---

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  2. **Activer** l'auto-backup

*Ce guide sera également synchronisé automatiquement !*
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