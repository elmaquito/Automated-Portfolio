------

title: "Guide d'utilisation Obsidian"title: "Guide d'utilisation Obsidian"

description: "Guide pour utiliser Obsidian avec le portfolio automatisé"description: "Guide pour utiliser Obsidian avec le portfolio automatisé"

tags: ["guide", "obsidian", "workflow"]tags: ["guide", "obsidian", "workflow"]

date: 2025-10-17date: 2025-10-17

------



# Guide d'utilisation du Portfolio Automatisé# Guide d'utilisation du Portfolio Automatisé



## Workflow de documentation



### Écriture avec Obsidian## Workflow de documentationdate: 2025-10-17description: "Guide pour utiliser Obsidian avec le portfolio automatisé"description: "Guide pour utiliser Obsidian avec le portfolio automatisé"

- Utilisez ce vault (`docs-source/`) pour écrire vos notes

- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`

- Les images vont dans `attachments/`

### Écriture avec Obsidian---

### Synchronisation automatique

Le plugin Obsidian Git va :- Utilisez ce vault (`docs-source/`) pour écrire vos notes

1. **Auto-commit** vos changements

2. **Push** vers GitHub - Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`tags: ["guide", "obsidian", "workflow"]tags: ["guide", "obsidian", "workflow"]

3. Déclencher la **GitHub Action** de sync

4. Convertir et déployer vers le **site web**- Les images vont dans `attachments/`



### Syntaxe supportée# Guide d'utilisation du Portfolio Automatisé

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  ### Synchronisation automatique

- **Métadonnées YAML** → Préservées pour Hugo

- **Markdown standard** → Supporté intégralementLe plugin Obsidian Git va :date: 2025-10-17date: 2025-10-17



## Configuration du plugin Obsidian Git1. **Auto-commit** vos changements



1. **Installer** le plugin "Obsidian Git"2. **Push** vers GitHub ## Workflow de documentation

2. **Activer** l'auto-backup

3. **Configurer** :3. Déclencher la **GitHub Action** de sync

   - Auto backup interval: 5 minutes

   - Auto pull interval: 10 minutes4. Convertir et déployer vers le **site web**------

   - Commit message: "📝 Auto-sync Obsidian notes"



## Structure recommandée

### Syntaxe supportée### Écriture avec Obsidian

```

docs-source/- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo

├── Projects/          # Documentation projets

├── Guides/           # Tutoriels et guides  - `![Image](/images/docs/images.png)` → Images copiées automatiquement  - Utilisez ce vault (`docs-source/`) pour écrire vos notes

├── Notes/            # Notes techniques

├── attachments/      # Images et fichiers- **Métadonnées YAML** → Préservées pour Hugo

└── _index.md         # Page d'accueil docs

```- **Markdown standard** → Supporté intégralement- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`



---



*Ce guide sera également synchronisé automatiquement !*## Configuration du plugin Obsidian Git- Les images vont dans `attachments/`# Guide d'utilisation du Portfolio Automatisé# Guide d'utilisation du Portfolio Automatisé

=======

1. **Installer** le plugin "Obsidian Git"# Guide d'utilisation du Portfolio Automatisé

2. **Activer** l'auto-backup>>>>>>> origin/main

3. **Configurer** :

   - Auto backup interval: 5 minutes## Workflow de documentation

   - Auto pull interval: 10 minutes

   - Commit message: "📝 Auto-sync Obsidian notes"### Écriture avec Obsidian

- Utilisez ce vault (`docs-source/`) pour écrire vos notes

## Structure recommandée- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`

- Les images vont dans `attachments/`

```

docs-source/### Synchronisation automatique

├── Projects/          # Documentation projetsLe plugin Obsidian Git va :

├── Guides/           # Tutoriels et guides  <<<<<<< HEAD

├── Notes/            # Notes techniques

├── attachments/      # Images et fichiers1. **Auto-commit** vos changements## Workflow de documentation## Workflow de documentation

└── _index.md         # Page d'accueil docs

```2. **Push** vers GitHub 



---3. Déclencher la **GitHub Action** de sync



*Ce guide sera également synchronisé automatiquement !*4. Convertir et déployer vers le **site web**

### Écriture avec Obsidian### Écriture avec Obsidian

### Syntaxe supportée

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo- Utilisez ce vault (`docs-source/`) pour écrire vos notes- Utilisez ce vault (`docs-source/`) pour écrire vos notes

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  

- **Métadonnées YAML** → Préservées pour Hugo- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`

- **Markdown standard** → Supporté intégralement

- Les images vont dans `attachments/`- Les images vont dans `attachments/`

## Configuration du plugin Obsidian Git



1. **Installer** le plugin "Obsidian Git"

2. **Activer** l'auto-backup### Synchronisation automatique

3. **Configurer** :

   - Auto backup interval: 5 minutesLe plugin Obsidian Git va :

   - Auto pull interval: 10 minutes

   - Commit message: "📝 Auto-sync Obsidian notes"1. **Auto-commit** vos changements## Workflow de documentation### Synchronisation automatique



## Structure recommandée2. **Push** vers GitHub 



```3. Déclencher la **GitHub Action** de syncLe plugin Obsidian Git va :

docs-source/

├── Projects/          # Documentation projets4. Convertir et déployer vers le **site web**

├── Guides/           # Tutoriels et guides  

├── Notes/            # Notes techniques### Écriture avec Obsidian1. **Auto-commit** vos changements

├── attachments/      # Images et fichiers

└── _index.md         # Page d'accueil docs### Syntaxe supportée

```

- `{{< ref "/docs/projects/premier-test-obsidian.md" >}}` → Convertis en liens Hugo- Utilisez ce vault (`docs-source/`) pour écrire vos notes2. **Push** vers GitHub 

---

- `![Image](/images/docs/images.png)` → Images copiées automatiquement  

*Ce guide sera également synchronisé automatiquement !*
- **Métadonnées YAML** → Préservées pour Hugo- Organisez vos fichiers dans les dossiers `Projects/`, `Guides/`, `Notes/`3. Déclencher la **GitHub Action** de sync

=======
1. **Auto-commit** vos changements
2. **Push** vers GitHub 
3. Déclencher la **GitHub Action** de sync
4. Convertir et déployer vers le **site web**

### Syntaxe supportée
- `{{< ref "liens-internes" >}}` → Convertis en liens Hugo
- `![Image](/images/docs/images.png)` → Images copiées automatiquement  
- **Métadonnées YAML** → Préservées pour Hugo
>>>>>>> origin/main
- **Markdown standard** → Supporté intégralement

## Configuration du plugin Obsidian Git

1. **Installer** le plugin "Obsidian Git"
2. **Activer** l'auto-backup
3. **Configurer** :
   - Auto backup interval: 5 minutes
   - Auto pull interval: 10 minutes
   - Commit message: "📝 Auto-sync Obsidian notes"

## Structure recommandée

```
docs-source/
├── Projects/          # Documentation projets
├── Guides/           # Tutoriels et guides  
├── Notes/            # Notes techniques
├── attachments/      # Images et fichiers
└── _index.md         # Page d'accueil docs
```

---

*Ce guide sera également synchronisé automatiquement !*