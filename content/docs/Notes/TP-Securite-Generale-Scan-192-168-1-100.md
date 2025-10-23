---
title: "TP Securite Generale : Scans de cible"
description: "Rapport d'exécution d'un script de scan de cible"
tags:
 - note
 - technique
 - obsidian
 - IA
 - Limayrac
 - TP
 - Reseau
 - Securite
 - Scan
 - Bash
date: 2025-10-23T09:00:00Z
summary: "Analyse de sécurité complète de la cible 192.168.1.100"
---

{{< difficulty level="intermediate" >}}

{{< reading-time minutes="4" >}}

# Rapport sommaire - Scan 192.168.1.100

## 1. Contexte

- Cible : 192.168.1.100
- Script : full_scan_192.168.1.100.sh
- Mode agressif : false

## 2. Résumé rapide

- Ports ouverts détectés : 21,22,25,80,110,143

## 3. Détails des ports et services (extraits nmap)

```
21/tcp open ftp
22/tcp open ssh
25/tcp open smtp
80/tcp open http
110/tcp open pop3
143/tcp open imap
443/tcp closed https
```

## 4. Découvertes web

- Ports HTTP détectés : 80

### Port 80

- En-têtes HTTP :

```
HTTP/1.1 200 OK
Date: Thu, 23 Oct 2025 10:00:02 GMT
Server: Apache/2.0.55 (Unix) PHP/5.1.2
X-Powered-By: PHP/5.1.2
Content-Type: text/html
```

- robots.txt:

```
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL /robots.txt was not found on this server.</p>
</body></html>
```

## 5. Analyse des vulnérabilités

### Ports sensibles ouverts
- **FTP (21)** : Service potentiellement vulnérable
- **SSH (22)** : Accès d'administration 
- **SMTP (25)** : Relais mail possible
- **HTTP (80)** : Site web avec Apache ancien

### Versions détectées
- **Apache 2.0.55** : Version obsolète (2005)
- **PHP 5.1.2** : Version très ancienne, vulnérabilités connues

## 6. Recommandations

### Priorité haute
1. Mise à jour Apache vers version récente
2. Mise à jour PHP vers version supportée
3. Audit de sécurité du service FTP

### Priorité moyenne  
1. Renforcement configuration SSH
2. Vérification configuration SMTP
3. Implémentation HTTPS

## 7. Conclusion

La cible présente plusieurs vulnérabilités liées à l'ancienneté des services. Une mise à jour urgente des composants web est recommandée.