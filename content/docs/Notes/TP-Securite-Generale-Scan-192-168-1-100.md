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

{{< reading-time minutes="4" >}}{{< reading-time minutes="4" >}}

{{< api-reference >}}{{< api-reference >}}



  

# Rapport sommaire - Scan 192.168.1.100# Rapport sommaire - Scan 192.168.1.100



## 1. Contexte## 1. Contexte

- Cible : 192.168.1.100- Cible : 192.168.1.100

- Script : full_scan_192.168.1.100. sh- Script : full_scan_192.168.1.100. sh

- Mode agressif : false- Mode agressif : false



## 2. Résumé rapide## 2. Résumé rapide

- Ports ouverts détectés : 21,22,25,80,110,143- Ports ouverts détectés : 21,22,25,80,110,143



## 3. Détails des ports et services (extraits nmap)## 3. Détails des ports et services (extraits nmap)

``````

20/tcp closed ftp-data20/tcp closed ftp-data

21/tcp open ftp21/tcp open ftp

22/tcp open ssh22/tcp open ssh

25/tcp open smtp25/tcp open smtp

80/tcp open http80/tcp open http

110/tcp open pop3110/tcp open pop3

143/tcp open imap143/tcp open imap

443/tcp closed https443/tcp closed https

``````



## 4. Découvertes web## 4. Découvertes web

- Ports HTTP détectés : 80- Ports HTTP détectés : 80



### Port 80### Port 80

- En-têtes HTTP :- En-têtes HTTP :

``````

HTTP/1.1 200 OKHTTP/1.1 200 OK

Date: Thu, 23 Oct 2025 10:00:02 GMTDate: Thu, 23 Oct 2025 10:00:02 GMT

Server: Apache/2.0.55 (Unix) PHP/5.1.2Server: Apache/2.0.55 (Unix) PHP/5.1.2

X-Powered-By: PHP/5.1.2X-Powered-By: PHP/5.1.2

Content-Type: text/htmlContent-Type: text/html



``````

- robots. txt:- robots. txt:

``````

<! DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN"><! DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">

<html><head><html><head>

<title>404 Not Found</title><title>404 Not Found</title>

</head><body></head><body>

<h1>Not Found</h1><h1>Not Found</h1>

<p>The requested URL /robots. txt was not found on this server.</p><p>The requested URL /robots. txt was not found on this server.</p>

<hr><hr>

<address>Apache/2.0.55 (Unix) PHP/5.1.2 Server at 192.168.1.100 Port 80</address><address>Apache/2.0.55 (Unix) PHP/5.1.2 Server at 192.168.1.100 Port 80</address>

</body></html></body></html>

``````

- Résultats dirb (extraits) :- Résultats dirb (extraits) :

``````



----------------------------------

DIRB v2.22 DIRB v2.22 

By The Dark RaverBy The Dark Raver

----------------------------------



OUTPUT_FILE: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/dirb_80. txtOUTPUT_FILE: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/dirb_80. txt

START_TIME: Thu Oct 23 10:00:42 2025START_TIME: Thu Oct 23 10:00:42 2025

URL_BASE: http://192.168.1.100/URL_BASE: http://192.168.1.100/

WORDLIST_FILES: /usr/share/wordlists/dirb/common. txtWORDLIST_FILES: /usr/share/wordlists/dirb/common. txt



----------------------------------



GENERATED WORDS: 4612GENERATED WORDS: 4612



---- Scanning URL: http://192.168.1.100/ -------- Scanning URL: http://192.168.1.100/ ----

+ http://192.168.1.100/~ftp (CODE:403|SIZE:412)+ http://192.168.1.100/~ftp (CODE:403|SIZE:412)

+ http://192.168.1.100/cgi-bin/ (CODE:403|SIZE:297)+ http://192.168.1.100/cgi-bin/ (CODE:403|SIZE:297)

+ http://192.168.1.100/index. php (CODE:200|SIZE:1983)+ http://192.168.1.100/index. php (CODE:200|SIZE:1983)

+ http://192.168.1.100/info. php (CODE:200|SIZE:37924)+ http://192.168.1.100/info. php (CODE:200|SIZE:37924)



----------------------------------

END_TIME: Thu Oct 23 10:00:45 2025END_TIME: Thu Oct 23 10:00:45 2025

DOWNLOADED: 4612 - FOUND: 4DOWNLOADED: 4612 - FOUND: 4

``````

- Nikto (extraits) :- Nikto (extraits) :

``````

- Nikto v2.5.0/- Nikto v2.5.0/

+ Target Host: 192.168.1.100+ Target Host: 192.168.1.100

+ Target Port: 80+ Target Port: 80

+ GET /: Retrieved x-powered-by header: PHP/5.1.2.+ GET /: Retrieved x-powered-by header: PHP/5.1.2.

+ GET /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer. mozilla. org/en-US/docs/Web/HTTP/Headers/X-Frame-Options: + GET /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer. mozilla. org/en-US/docs/Web/HTTP/Headers/X-Frame-Options: 

+ GET /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www. netsparker. com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/: + GET /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www. netsparker. com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/: 

+ HEAD PHP/5.1.2 appears to be outdated (current is at least 8.1.5), PHP 7.4.28 for the 7.4 branch.+ HEAD PHP/5.1.2 appears to be outdated (current is at least 8.1.5), PHP 7.4.28 for the 7.4 branch.

+ HEAD Apache/2.0.55 appears to be outdated (current is at least Apache/2.4.54). Apache 2.2.34 is the EOL for the 2. x branch.+ HEAD Apache/2.0.55 appears to be outdated (current is at least Apache/2.4.54). Apache 2.2.34 is the EOL for the 2. x branch.

+ OPTIONS OPTIONS: Allowed HTTP Methods: GET, HEAD, POST, OPTIONS, TRACE.+ OPTIONS OPTIONS: Allowed HTTP Methods: GET, HEAD, POST, OPTIONS, TRACE.

+ ALHZXURF /: Web Server returns a valid response with junk HTTP methods which may cause false positives.+ ALHZXURF /: Web Server returns a valid response with junk HTTP methods which may cause false positives.

+ TRACE /: HTTP TRACE method is active which suggests the host is vulnerable to XST. See: https://owasp. org/www-community/attacks/Cross_Site_Tracing: + TRACE /: HTTP TRACE method is active which suggests the host is vulnerable to XST. See: https://owasp. org/www-community/attacks/Cross_Site_Tracing: 

+ GET PHP/5.1 - PHP 3/4/5 and 7.0 are End of Life products without support.+ GET PHP/5.1 - PHP 3/4/5 and 7.0 are End of Life products without support.

+ GET /?=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: + GET /?=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: 

+ GET /?=PHPE9568F36-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: + GET /?=PHPE9568F36-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: 

+ GET /?=PHPE9568F34-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: + GET /?=PHPE9568F34-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: 

+ GET /?=PHPE9568F35-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: + GET /?=PHPE9568F35-D428-11d2-A769-00AA001ACF42: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184: 

+ GET /info. php: Output from the phpinfo() function was found.+ GET /info. php: Output from the phpinfo() function was found.

+ GET /info. php: PHP is installed, and a test script which runs phpinfo() was found. This gives a lot of system information. See: CWE-552: + GET /info. php: PHP is installed, and a test script which runs phpinfo() was found. This gives a lot of system information. See: CWE-552: 

+ GET /icons/: Directory indexing found.+ GET /icons/: Directory indexing found.

+ GET /icons/README: Server may leak inodes via ETags, header found with file /icons/README, inode: 5081, size: 4872, mtime: Wed May 29 14:02:08 2058. See: CVE-2003-1418: + GET /icons/README: Server may leak inodes via ETags, header found with file /icons/README, inode: 5081, size: 4872, mtime: Wed May 29 14:02:08 2058. See: CVE-2003-1418: 

+ GET /icons/README: Apache default file found. See: https://www. vntweb. co. uk/apache-restricting-access-to-iconsreadme/: + GET /icons/README: Apache default file found. See: https://www. vntweb. co. uk/apache-restricting-access-to-iconsreadme/: 

+ GET /info. php? file=http://blog. cirt. net/rfiinc. txt: Remote File Inclusion (RFI) from RSnake's RFI list. See: https://gist. github. com/mubix/5d269c686584875015a2: + GET /info. php? file=http://blog. cirt. net/rfiinc. txt: Remote File Inclusion (RFI) from RSnake's RFI list. See: https://gist. github. com/mubix/5d269c686584875015a2: 

+ GET /#wp-config. php#: #wp-config. php# file found. This file contains the credentials.+ GET /#wp-config. php#: #wp-config. php# file found. This file contains the credentials.

``````



## 5. Vulnérabilités / observations (préliminaire)## 5. Vulnérabilités / observations (préliminaire)

- Voir les sorties complètes dans le dossier d'artefacts pour confirmation.- Voir les sorties complètes dans le dossier d'artefacts pour confirmation.

- Observations notables (à compléter après revue manuelle) :- Observations notables (à compléter après revue manuelle) :

 - Directory listing / fichiers exposés -> vérifier./gobuster_*. txt / dirb_*. txt - Directory listing / fichiers exposés -> vérifier./gobuster_*. txt / dirb_*. txt

 - Headers HTTP -> vérifier./curl_headers_*. txt - Headers HTTP -> vérifier./curl_headers_*. txt

 - TLS faibles suites ->./nmap_ssl. txt et./sslscan_443. txt - TLS faibles suites ->./nmap_ssl. txt et./sslscan_443. txt



## 6. Artefacts collectés## 6. Artefacts collectés

- nmap outputs: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/nmap_*- nmap outputs: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/nmap_*

- Web enumeration: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/whatweb_*, /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/gobuster_*, /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/nikto_*- Web enumeration: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/whatweb_*, /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/gobuster_*, /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/nikto_*

- Logs: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/scan. log- Logs: /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/scan. log

- Network artifacts (pcap): /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/192.168.1.100_capture. pcap (si activé)- Network artifacts (pcap): /home/adminsec/Bureau/scans/192.168.1.100_20251023_095547/192.168.1.100_capture. pcap (si activé)



## 7. Recommandations rapides## 7. Recommandations rapides

- Restreindre l'accès aux répertoires web (Deny indexing, add auth).- Restreindre l'accès aux répertoires web (Deny indexing, add auth).

- Appliquer mises à jour OS/app et corriger TLS/HTTP headers si faibles.- Appliquer mises à jour OS/app et corriger TLS/HTTP headers si faibles.

- Lancer une revue manuelle approfondie (Burp, tests authentifiés) et un pentest complet si nécessaire.- Lancer une revue manuelle approfondie (Burp, tests authentifiés) et un pentest complet si nécessaire.



## 8. Commandes exécutées (extrait)## 8. Commandes exécutées (extrait)

```bash```bash

nmap -sS -Pn -T4 -p- 192.168.1.100nmap -sS -Pn -T4 -p- 192.168.1.100

nmap -sV -sC -p <open_ports> 192.168.1.100nmap -sV -sC -p <open_ports> 192.168.1.100

whatweb, curl, nikto, gobuster/dirb (si disponibles)whatweb, curl, nikto, gobuster/dirb (si disponibles)

``````



## 9. Prochaines étapes suggérées## 9. Prochaines étapes suggérées

- Revue manuelle des pages découvertes, capture d'écran des fichiers sensibles (si trouvés) en minimisant la conservation des données sensibles.- Revue manuelle des pages découvertes, capture d'écran des fichiers sensibles (si trouvés) en minimisant la conservation des données sensibles.

- Si preuve de fuite de documents (paie), déclencher procédure RGPD / notifications internes.- Si preuve de fuite de documents (paie), déclencher procédure RGPD / notifications internes.



------

_Fin du rapport sommaire.__Fin du rapport sommaire._



## 💡 Astuces et Bonnes Pratiques## 💡 Astuces et Bonnes Pratiques



💻 **Code**: Commentez votre code et expliquez les parties complexes.💻 **Code**: Commentez votre code et expliquez les parties complexes.



🔗 **APIs**: Documentez les codes de retour et formats de réponse.🔗 **APIs**: Documentez les codes de retour et formats de réponse.



📚 **Longueur**: Considérez diviser en sections avec table des matières.📚 **Longueur**: Considérez diviser en sections avec table des matières.



📊 **Performance**: Mentionnez les implications de performance quand pertinent.📊 **Performance**: Mentionnez les implications de performance quand pertinent.



🔧 **Bonnes pratiques**: Toujours inclure les prérequis et dépendances.🔧 **Bonnes pratiques**: Toujours inclure les prérequis et dépendances.



🔄 **Maintenance**: Expliquez comment maintenir et déboguer le code.🔄 **Maintenance**: Expliquez comment maintenir et déboguer le code.



------
