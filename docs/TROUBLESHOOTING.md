# 🔧 Guide de Troubleshooting

## Problèmes Fréquents

### 1. Échec de Déploiement

#### Secret FTP_PASSWORD manquant
**Symptôme** : `Error: Process completed with exit code 1` dans deploy workflow
**Solution** :
1. Aller dans [Settings > Secrets](https://github.com/elmaquito/Automated-Portfolio/settings/secrets/actions)
2. Ajouter `FTP_PASSWORD` avec valeur `Pzz8F2SsJA6PcDYUa5ctuzjphstJ`
3. Relancer le workflow

#### Permissions workflow insuffisantes
**Symptôme** : `Permission denied` dans GitHub Actions
**Solution** : Vérifier dans le workflow :
```yaml
permissions:
  contents: write
  actions: write
```

### 2. Erreurs Hugo Build

#### Module conflicts
**Symptôme** : 
```
Error: module "project" is not compatible with this Hugo version
```
**Solution** : Module Docsy désactivé dans `hugo.toml`, utiliser layouts personnalisés

#### Template errors
**Symptôme** :
```
Error: template: swagger/list.html:8: bad character U+002D '-'
```
**Solution** : Layouts personnalisés créés, pas de thème externe

#### Frontmatter invalide
**Symptôme** : `❌ Missing frontmatter in: file.md`
**Solution** : Ajouter frontmatter YAML :
```yaml
---
title: "Titre"
date: 2024-XX-XX
draft: false
---
```

### 3. Sync Obsidian

#### Fichiers non synchronisés
**Symptôme** : Nouvelles notes n'apparaissent pas sur le site
**Solution** :
1. Vérifier que les fichiers sont dans `docs-source/`
2. Commiter et pusher les changements
3. Le workflow `obsidian-sync.yml` se déclenche automatiquement

#### Conversion liens échoue
**Symptôme** : Liens `[[Internal Link]]` cassés
**Solution** : Le script convertit automatiquement, vérifier logs du workflow

### 4. Performance et Cache

#### Site lent à charger
**Solution** :
```bash
# Nettoyer cache Hugo
hugo --gc
rm -rf public/ resources/

# Rebuild
hugo --minify
```

#### Images non optimisées
**Solution** : Utiliser formats WebP, optimiser tailles dans `/static/`

### 5. Hébergement OVH

#### Quota disque dépassé
**Symptôme** : Upload SFTP échoue
**Solution** : 
1. Vérifier quota dans panel OVH
2. Nettoyer anciens fichiers si nécessaire

#### Certificat SSL expiré
**Symptôme** : Site en HTTPS inaccessible
**Solution** : Renouveler certificat dans panel OVH

### 6. Workflows GitHub Actions

#### Workflow en boucle infinie
**Symptôme** : Workflows se déclenchent en continu
**Solution** : Vérifier conditions de trigger, ajouter `[skip ci]` au commit

#### Timeout dans les jobs
**Symptôme** : Job échoue après 6h
**Solution** : 
```yaml
timeout-minutes: 10  # Limiter à 10min
```

## Logs Utiles

### Hugo Verbose
```bash
hugo server --verbose --debug
```

### GitHub Actions
- Aller dans [Actions](https://github.com/elmaquito/Automated-Portfolio/actions)
- Cliquer sur le workflow échoué
- Examiner les logs détaillés

### Validation manuelle
```bash
# Valider Markdown
npm run validate

# Tester build local
hugo

# Vérifier liens
npm run linkcheck
```

## Contacts Support

### Hugo
- [Documentation Hugo](https://gohugo.io/documentation/)
- [Forum communauté](https://discourse.gohugo.io/)

### GitHub Actions
- [Documentation officielle](https://docs.github.com/en/actions)
- [Marketplace actions](https://github.com/marketplace?type=actions)

### OVH
- [Support OVH](https://www.ovh.com/fr/support/)
- [Guide hébergement web](https://docs.ovh.com/fr/hosting/)

## Procédure d'Urgence

Si le site est complètement cassé :

1. **Rollback immédiat** :
   ```bash
   git revert HEAD
   git push origin main
   ```

2. **Build manuel** :
   ```bash
   hugo
   # Upload manuel via FTP si nécessaire
   ```

3. **Page de maintenance** :
   - Créer `static/index.html` temporaire
   - Commit et push pour deploy rapide

4. **Investigation** :
   - Analyser logs GitHub Actions
   - Tester build en local
   - Vérifier configuration Hugo