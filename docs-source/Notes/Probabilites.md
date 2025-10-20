---
title: "Bases IA : Probabilites"
description: Note de cours concernant les Probabilites appliqués à l'IA.
tags:
  - note
  - obsidian
  - IA
  - Limayrac
  - Bases
  - Probabilites
  - theorie
date: 2025-10-17
---
Intervenant : Nicolas Metivier

 L'univers et les evènements : 
- Univers : ensemble des éléments d'étude
- Espace échantillonal : ensemble de tous les résultats possibles d'une expérience aléatoire
- Evénement : sous-ensemble de l'espace échantillonal
- Evenement élémentaire : événement ne contenant qu'un seul résultat
- Evenement certain : événement qui se produit toujours
- Evenement impossible : événement qui ne se produit jamais
- Evenement contraire : complémentaire d'un événement
- Evenement incompatible : événements qui ne peuvent pas se produire simultanément
- Evenement complémentaire : la réalisation d'un événement n'affecte pas la probabilité d'un autre

#### Opérations sur les évènements :
- Union (A ∪ B) : événement qui se produit si A ou B se produit
	- Ex:emple : lancer un dé, A = obtenir un nombre pair {2,4,6}, B = obtenir un nombre supérieur à 4 {5,6}, A ∪ B = {2,4,5,6}
- Intersection (A ∩ B) : événement qui se produit si A et B se produisent simultanément
	- Exemple : lancer un dé, A = obtenir un nombre pair {2,4,6}, B = obtenir un nombre supérieur à 4 {5,6}, A ∩ B = {6}
- Différence (A \ B) : événement qui se produit si A se produit mais pas B
	- Exemple : lancer un dé, A = obtenir un nombre pair {2,4,6}, B = obtenir un nombre supérieur à 4 {5,6}, A \ B = {2,4}
- Complémentaire (A') : événement qui se produit si A ne se produit pas
	- Exemple : lancer un dé, A = obtenir un nombre pair {2,4,6}, A' = {1,3,5}
- Loi des grands nombres : avec un grand nombre d'essais, la fréquence relative d'un événement converge vers sa probabilité théorique
- Indépendance : deux événements A et B sont indépendants si la réalisation de l'un n'affecte pas la probabilité de l'autre (P(A ∩ B) = P(A) * P(B))

### Axiome des probabilités :
- Non-négativité : P(A) ≥ 0 pour tout événement A
- Normalisation : P(Ω) = 1, où Ω est l'univers
- Additivité : pour des événements mutuellement exclusifs A1, A2, ..., An, P(A1 ∪ A2 ∪ ... ∪ An) = P(A1) + P(A2) + ... + P(An)

![[15_union_intersection_difference_symmetric-347325689.png]]
#### Probabilités d'un évènement
- Probabilité d'un événement A : P(A) = nombre de cas favorables / nombre de cas possibles
	- Exemple : lancer un dé, A = obtenir un nombre pair {2,4,6}, P(A) = 3/6 = 0.5
	- Espace échantillonal : {1,2,3,4,5,6}
	- Cas favorables : {2,4,6}
	- Cas possibles : {1,2,3,4,5,6}
	- P(A) = 3/6 = 0.5
	- 

#### Probabilités conditionnelle
- Probabilité conditionnelle (P(A|B)) : probabilité de A sachant que B s'est produit
	- Exemple : lancer deux dés, A = obtenir un total de 7, B = obtenir un 4 sur le premier dé, P(A|B) = 1/6
	- Formule de Bayes : P(A|B) = (P(B|A) * P(A)) / P(B)
	- Exemple : maladie et test médical, P(M|T) = (P(T|M) * P(M)) / P(T)

#### Indépendance des évènements
- Deux événements A et B sont indépendants si P(A ∩ B) = P(A) * P(B)
	- Exemple : lancer deux pièces, A = obtenir face sur la première, B = obtenir face sur la deuxième, P(A ∩ B) = 1/4 = P(A) * P(B) = 1/2 * 1/2
	- Si A et B sont indépendants, alors P(A|B) = P(A) et P(B|A) = P(B)

### Loi des grands Nombres
- La loi des grands nombres stipule que la fréquence relative d'un événement converge vers sa probabilité théorique à mesure que le nombre d'essais augmente
	- Exemple : lancer une pièce 1000 fois, la fréquence de face devrait être proche de 0.5

#### Espérance Mathématique
- Espérance (E(X)) : moyenne pondérée des valeurs possibles d'une variable aléatoire X
	- Exemple : lancer un dé, X = valeur obtenue, E(X) = (1+2+3+4+5+6)/6 = 3.5
	- Formule : E(X) = Σ [xi * P(X=xi)] pour toutes les valeurs xi de X
	- Propriétés : E(aX + b) = aE(X) + b, pour toute constante a et b

#### Variance et Ecart-type
- Variance (Var(X)) : mesure de la dispersion des valeurs autour de l'espérance
	- Exemple : lancer un dé, X = valeur obtenue, Var(X) = E(X²) - [E(X)]² = (1²+2²+3²+4²+5²+6²)/6 - (3.5)² = 2.9167
	- Formule : Var(X) = E[(X - E(X))²] = Σ [(xi - E(X))² * P(X=xi)]

### Interprétation graphique et Intuition IA
Les probabilités sont fondamentales en IA pour modéliser l'incertitude et prendre des décisions basées sur des données incomplètes ou bruitées. Elles permettent de :
- Modéliser des distributions de données (ex : Naive Bayes, modèles génératifs)
- Estimer des paramètres (ex : Maximum de vraisemblance)
- Faire des inférences (ex : réseaux bayésiens)
- Gérer l'incertitude (ex : filtres de Kalman, processus de Markov)
- Évaluer des modèles (ex : validation croisée, métriques probabilistes)
- Optimiser des fonctions (ex : algorithmes de Monte Carlo, optimisation bayésienne)

#### Loi uniforme discrète
- La loi uniforme discrète modélise une situation où chaque résultat d'un ensemble fini a la même probabilité de se produire.
	- Exemple : lancer un dé équilibré, chaque face (1 à 6) a une probabilité égale de 1/6.
	- Propriétés : 
		- Nombre de résultats possibles : n
		- Probabilité de chaque résultat : P(X=xi) = 1/n pour i = 1, 2, ..., n
		- Espérance : E(X) = (n + 1) / 2
		- Variance : Var(X) = (n² - 1) / 12

#### Loi binomiale
- La loi binomiale modélise le nombre de succès dans une séquence de n essais indépendants, chacun ayant une probabilité p de succès.
	- Exemple : lancer une pièce 10 fois, X = nombre de faces obtenues, X suit une loi binomiale B(n=10, p=0.5).
	- Propriétés :
		- Nombre d'essais : n
		- Probabilité de succès : p
		- Probabilité d'échec : q = 1 - p
		- Fonction de probabilité : P(X=k) = C(n,k) * p^k * q^(n-k) pour k = 0, 1, ..., n
		- Espérance : E(X) = n * p
		- Variance : Var(X) = n * p * q

Loi géométrique
- La loi géométrique modélise le nombre d'essais nécessaires pour obtenir le premier succès dans une séquence d'essais indépendants, chacun ayant une probabilité p de succès.
	- Exemple : lancer une pièce jusqu'à obtenir face, X = nombre de lancers nécessaires, X suit une loi géométrique G(p=0.5).
	- Propriétés :
		- Probabilité de succès : p
		- Probabilité d'échec : q = 1 - p
		- Fonction de probabilité : P(X=k) = q^(k-1) * p pour k = 1, 2, ...
		- Espérance : E(X) = 1 / p
		- Variance : Var(X) = q / p²

Loi de poisson
- La loi de Poisson modélise le nombre d'événements se produisant dans un intervalle de temps ou d'espace donné, lorsque ces événements se produisent avec une moyenne constante et indépendamment du temps écoulé depuis le dernier événement.
	- Exemple : nombre d'appels reçus par un centre d'appel en une heure, X suit une loi de Poisson P(λ=5) si en moyenne 5 appels sont reçus par heure.
	- Propriétés :
		- Paramètre : λ (taux moyen d'événements par intervalle)
		- Fonction de probabilité : P(X=k) = (e^(-λ) * λ^k) / k! pour k = 0, 1, 2, ...
		- Espérance : E(X) = λ
		- Variance : Var(X) = λ

Lois continues
- Les lois continues modélisent des variables aléatoires pouvant prendre une infinité de valeurs dans un intervalle donné.
	- Exemple : taille, poids, temps d'attente
	- Fonction de densité de probabilité (f(x)) : décrit la probabilité relative d'une variable aléatoire continue prenant une valeur spécifique
	- Probabilité d'un intervalle : P(a ≤ X ≤ b) = ∫[a à b] f(x) dx
	- Espérance : E(X) = ∫[−∞ à +∞] x * f(x) dx
	- Variance : Var(X) = ∫[−∞ à +∞] (x - E(X))² * f(x) dx

Loi uniforme continue
- La loi uniforme continue modélise une situation où chaque valeur dans un intervalle [a, b] a la même probabilité de se produire.
	- Exemple : choisir un nombre aléatoire entre 0 et 1, X suit une loi uniforme continue U(a=0, b=1).
	- Propriétés : 
		- Intervalle : [a, b]
		- Fonction de densité : f(x) = 1/(b-a) pour x dans [a, b], f(x) = 0 ailleurs
		- Espérance : E(X) = (a + b) / 2
		- Variance : Var(X) = (b - a)² / 12

Choisir la bonne loi:
- Comprendre la nature des données (discrètes vs continues)
- Analyser les caractéristiques des données (moyenne, variance, forme de la distribution)
- Utiliser des tests statistiques (ex : test de Kolmogorov-Smirnov, test de Chi-carré)
- Visualiser les données (histogrammes, Q-Q plots)
- Consulter des ressources et des experts en statistique si nécessaire
- Exemples d'application en IA:
- Classification : Naive Bayes utilise des probabilités conditionnelles pour classer les données
- Réseaux bayésiens : modélisent les relations de dépendance entre variables
- Apprentissage par renforcement : utilise des probabilités pour modéliser les récompenses et les transitions d'état
- Traitement du langage naturel : modèles de langage probabilistes (ex : n-grammes)
- Vision par ordinateur : modèles génératifs pour la synthèse d'images (ex : GANs)
- Modèles de Markov cachés : utilisés pour la reconnaissance vocale et la bioinformatique
- Algorithmes de Monte Carlo : utilisés pour l'optimisation et la simulation
- Optimisation bayésienne : utilisée pour l'optimisation de fonctions coûteuses à évaluer
- Ressources supplémentaires:
Livres : "Probabilités pour les sciences de l'ingénieur" de Sheldon Ross, "Pattern Recognition and Machine Learning" de Christopher Bishop