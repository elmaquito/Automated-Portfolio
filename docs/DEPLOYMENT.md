# 🚀 Guide de Déploiement

## Configuration OVH

### Credentials SFTP
- **Host**: `ftp.cluster021.hosting.ovh.net`
- **Username**: `martisx`
- **Password**: Stocké dans GitHub Secrets (`FTP_PASSWORD`)
- **Directory**: `/www/`

### GitHub Secrets Requis
```
FTP_PASSWORD=Pzz8F2SsJA6PcDYUa5ctuzjphstJ
```

## Déploiement Automatique

Le déploiement se fait automatiquement via GitHub Actions à chaque push sur `main`.

### Workflow de Déploiement

1. **Trigger**: Push sur branche `main`
2. **Build**: Hugo génère le site statique
3. **Validation**: Vérification Markdown et liens
4. **Deploy**: Upload SFTP vers OVH
5. **Verification**: Contrôle que le site est accessible

### Logs et Monitoring

- **GitHub Actions**: https://github.com/elmaquito/Automated-Portfolio/actions
- **Site Live**: https://www.martinezismael.fr

## Déploiement Manuel (Urgence)

### Prérequis
```bash
npm install
hugo version # Doit être 0.110.0+
```

### Commandes
```bash
# Build local
hugo

# Upload manuel (si GitHub Actions échoue)
npm run deploy:manual
```

## Troubleshooting

### Secret FTP manquant
1. Aller dans [Settings > Secrets](https://github.com/elmaquito/Automated-Portfolio/settings/secrets/actions)
2. Ajouter `FTP_PASSWORD` avec la valeur ci-dessus
3. Relancer le workflow

### Erreur de permissions
- Vérifier que le workflow a les permissions `contents: read` et `actions: write`

### Site "En construction"
- Vérifier que le build Hugo s'est bien exécuté
- Contrôler les logs GitHub Actions pour erreurs

### Échec upload SFTP
- Vérifier credentials OVH
- Tester connexion SFTP manuelle
- Contrôler quotas disque OVH

## Maintenance

### Mise à jour Hugo
```bash
# Mettre à jour dans package.json
npm run update:hugo
```

### Nettoyage Cache
```bash
hugo --gc
rm -rf public/ resources/
```

### Backup
Les sources sont sur GitHub, pas besoin de backup manuel du site.