---
title: "Bases IA : Statistiques"
description: Note de cours concernant les statistiques appliqués à l'IA.
tags:
  - note
  - technique
  - obsidian
  - IA
  - Limayrac
  - Bases
date: 2025-10-17
---
 # Statistiques et Probabilités pour l'Intelligence Artificielle
---

Intervenant : Nicolas Metivier

Contexte:
 double activité
	 supervision, automatisation et IA.

En mathématique, Statistiques et Probabilités:

### Pourquoi les statistiques au coeur de l'IA
 L'IA repose sur des données
 les stats permettent de resumer, interpreter et fiabiliser, les proba permettent de modeliser l'incertitude et les aleas et donc de prendre des decisions en consequence.
Exemples:
	 - Machine Learning : algorithmes qui apprennent des données (Modèles probabilistes, régressions, arbres de décision))
	 - Deep Learning :  reseaux de neurones profonds (apprentissage par couches successives, optimisation de fonctions couts))
	 - NLP : Natural Language Processing(analyse et génération de texte (modèles de langage, analyse de sentiments, traduction automatique))
	 - Vision par ordinateur : reconnaissance d'images, de visages, de texte

### Définitions de bases
Population : ensemble complet d'individus ou d'objets d'intérêt
Echantillon : sous-ensemble représentatif de la population
Variable : caractéristique mesurée ou observée (quantitative ou qualitative)
Distribution : répartition des valeurs d'une variable dans une population ou un échantillon

### types de variables:
 - Quantitative (discrète, continue) : valeurs numériques (ex : âge, taille, poids)
 - Qualitative (nominale, ordinale) : catégories ou labels (ex : sexe, couleur, niveau d'éducation)

### Variable aléatoire:
 - Discrète : prend des valeurs spécifiques (ex : nombre d'enfants)
 - Continue : prend des valeurs dans un intervalle (ex : taille, poids)

#### Notations:
 - Moyenne : μ (population), x̄ (échantillon)
 - Variance : σ² (population), s² (échantillon)
 - Ecart-type : σ (population), s (échantillon)
 - Probabilité : P(A) pour un événement A
 - Espérance : E(X) pour une variable aléatoire X
#### exemple : 
 - Lancer un dé : espace échantillonal {1,2,3,4,5,6}, événement A = obtenir un nombre pair {2,4,6}, P(A) = 3/6 = 0.5

### Visualiser une distribution :
 - Histogramme : pour les variables quantitatives
 - Diagramme en barres : pour les variables qualitatives
 - Boîte à moustaches : pour visualiser la dispersion et les outliers

La moyenne n'a de sens que si on connait la distribution des données.

## Mesurer et interpréter
### statistiques descriptives :
 - Tendance centrale : Moyenne, médiane, mode
 - Variance, écart-type
 - Quartiles, percentiles
 - forme de la distribution : asymétrie, kurtosis

#### Qu'est ce que la statistique descriptive?
 - Résumer et décrire les caractéristiques principales d'un ensemble de données
 - Utiliser des mesures numériques et des représentations graphiques
 - Aider à comprendre la distribution, la tendance centrale et la dispersion des données

#### Mesurer les tendances centrales:
 - Moyenne : somme des valeurs divisée par le nombre de valeurs
 - Médiane : valeur centrale lorsque les données sont ordonnées
 - Mode : valeur la plus fréquente dans l'échantillon
Exemple :
 - Données : [3, 1, 4, 4, 5, 2, 6]
 - Moyenne : (3+1+4+4+5+2+6)/7 = 3.57
 - Médiane : 4 (données ordonnées : [1,2,3,4,4,5,6])
 - Mode : 4 (apparaît deux fois)
Observation : Prendre un exemple plus simple pour illustrer 

#### Mesurer la dispersion:
 - Variance : moyenne des carrés des écarts par rapport à la moyenne ( σ² = Σ(xi - μ)² / N )
 - Ecart-type : racine carrée de la variance
 - Étendue : différence entre la valeur maximale et minimale
 - Quartiles : divisent les données en quatre parties égales
Exemple vulgarisé :
 - Données : [3, 1, 4, 4, 5, 2, 6]
 - Moyenne : 3.57
 - Variance : ((3-3.57)² + (1-3.57)² + (4-3.57)² + (4-3.57)² + (5-3.57)² + (2-3.57)² + (6-3.57)²) / 7 = 2.29
 - Ecart-type : √2.29 = 1.51
 - Étendue : 6 - 1 = 5

Asymétrie et aplatissment:
 - Asymétrie : mesure de la symétrie de la distribution (positive, négative, nulle)
	![[Pasted image 20251013141254.png]]
 - Kurtosis : mesure de la "pointedness" de la distribution (leptokurtique, platykurtique, mésokurtique)
![[Pasted image 20251013141342.png]]
 
Exemple :
 - Données : [1, 2, 2, 3, 4, 5, 6, 7, 8, 9]
 - Asymétrie : proche de 0 (distribution symétrique)
 - Kurtosis : proche de 3 (distribution normale)

Représentation graphique :
 - Histogramme : pour visualiser la distribution des données quantitatives
	 ex : Âge des individus dans un échantillon
 - Diagramme en barres : pour les données qualitatives
	 ex : Couleur préférée dans un échantillon
 - Boîte à moustaches : pour visualiser la dispersion, la médiane et les outliers sur une dimension (X)
	 ex : Salaire des employés dans une entreprise
 - Nuage de points : pour visualiser la relation entre deux variables quantitatives (X et Y))
	 ex : Taille vs Poids
 
### Les quantiles
 - Divisent les données en parties égales
 - Quartiles : Q1 (25%), Q2 (médiane, 50%), Q3 (75%)
 - Percentiles : divisent les données en 100 parties égales
 - déciles : divisent les données en 10 parties égales
 - Centiles : divisent les données en 100 parties égales

#### Les valeurs abéerrantes (outliers) :
 - Points de données qui s'écartent significativement de la tendance générale
 - Peuvent influencer la moyenne et la variance
 - Identifier avec des boîtes à moustaches ou des z-scoresrrantes (outliers) :
 - Points de données qui s'écartent significativement des autres
 - Peuvent influencer la moyenne et la variance
 - Identifier avec des boîtes à moustaches ou des z-scores

zscore = (xi - μ) / σ
 - Traiter en les supprimant, les transformant ou les analysant séparément
 - Exemple : Données : [3, 1, 4, 4, 5, 2, 100] (100 est un outlier)

### Covariance et corrélation:
 - Covariance : mesure de la façon dont deux variables varient ensemble
	 Cov(X,Y) = Σ((xi - μx)(yi - μy)) / N
 - Corrélation : mesure normalisée de la relation linéaire entre deux variables (entre -1 et 1)
	 Corr(X,Y) = Cov(X,Y) / (σx * σy)
 - Exemple :
	 Données X : [1, 2, 3, 4, 5]
	 Données Y : [2, 4, 6, 8, 10]
	 Cov(X,Y) = 8
	 Corr(X,Y) = 1 (relation linéaire parfaite)

### matrice de corrélation:
 - Tableau carré montrant les corrélations entre plusieurs variables
 - Utile pour identifier les relations entre différentes caractéristiques dans un dataset
 exemple :
	|     | Var1 | Var2 | Var3 |
	|-----|------|------|------|
	| Var1|  1   | 0.8  | -0.5 |
	| Var2| 0.8  |  1   | -0.3 |
	| Var3| -0.5 | -0.3 |  1   |

![[Pasted image 20251013143212.png]]
## carte des corrélations:
 - Représentation visuelle (heatmap) de la matrice de corrélation
 - Utilise des couleurs pour indiquer la force et la direction des corrélations
 - Aide à identifier rapidement les relations importantes entre les variables
 
### Statistiques inférentielles
Estimation : inférer des paramètres de la population à partir de l'échantillon
Intervalle de confiance : plage de valeurs dans laquelle un paramètre de la population est susceptible de se trouver
Test d'hypothèse : évaluer une hypothèse sur la population à partir de l'échantillon

| Concept      | Description                                                                  | Exemple                                                     |
| ------------ | ---------------------------------------------------------------------------- | ----------------------------------------------------------- |
| Population   | Ensemble complet d'individus ou d'objets d'intérêt                           | Tous les étudiants d'une université                         |
| Echantillon  | Sous-ensemble représentatif de la population                                 | 100 étudiants sélectionnés au hasard                        |
| Variable     | Caractéristique mesurée ou observée (quantitative ou qualitative)            | Âge (quantitative), Sexe (qualitative)                      |
| Distribution | Répartition des valeurs d'une variable dans une population ou un échantillon | Distribution des notes d'un examen                          |
| Moyenne      | Somme des valeurs divisée par le nombre de valeurs                           | Moyenne des âges dans un échantillon                        |
| Médiane      | Valeur centrale lorsque les données sont ordonnées                           | Médiane des salaires dans une entreprise                    |
| Mode         | Valeur la plus fréquente dans l'échantillon                                  | Mode de la couleur préférée dans un sondage                 |
| Variance     | Moyenne des carrés des écarts par rapport à la moyenne                       | Variance des scores d'un test                               |
| Ecart-type   | Racine carrée de la variance                                                 | Ecart-type des poids dans une population                    |
| Quartiles    | Divisent les données en quatre parties égales                                | Q1, Q2 (médiane), Q3 des revenus dans une entreprise        |
| Outliers     | Points de données qui s'écartent significativement de la tendance générale   | Salaire exceptionnellement élevé dans un groupe de salariés |

## Statistiques inférentielle

### Estimation
 - Inférer des paramètres de la population à partir de l'échantillon
 - Méthodes : estimateurs ponctuels (moyenne, variance), estimateurs par intervalle (IC)
 - Exemple : Estimer la moyenne d'une population à partir d'un échantillon

#### Différences avec la statistique descriptive
 - Descriptive : résumer et décrire les données
 - Inférentielle : tirer des conclusions sur une population à partir d'un échantillon

#### Echantillonnage
 - Techniques : aléatoire simple, stratifié, par grappes
 - Importance : représentativité, biais, variance
 - Exemple : Tirer un échantillon aléatoire de 100 individus dans une population de 1000
- Biais d'échantillonnage : erreurs systématiques dans la sélection de l'échantillon
 - Réduction : techniques d'échantillonnage appropriées, ajustements statistiques
 - Exemple : Sur-représentation d'un groupe dans un sondage
 
 #### Types d'échantillonnage
 - Aléatoire simple : chaque individu a une chance égale d'être sélectionné
 - Stratifié : diviser la population en sous-groupes (strates) et échantillonner dans chaque strate
 - Par grappes : diviser la population en grappes (groupes) et échantillonner des grappes entières
 - SYSTEMATIQUE : sélectionner chaque k-ième individu dans une liste ordonnée


#### Estimation ponctuelle
 - Estimation ponctuelle : valeur unique estimée à partir de l'échantillon
 - Exemple : Moyenne d'un échantillon comme estimation ponctuelle de la moyenne de la population

#### Intervalle de confiance
 - Plage de valeurs dans laquelle un paramètre de la population est susceptible de se trouver
 - Niveau de confiance : probabilité que l'intervalle contienne le paramètre (ex : 95%)
 - Exemple : IC à 95% pour la moyenne d'un échantillon

#### Erreur type et taille d'échantillon
 - Erreur type : mesure de la variabilité de l'estimateur (σ/√n)
 - Taille d'échantillon : influence la précision de l'estimation
 - Exemple : Calculer l'erreur type pour un échantillon de taille n=100 

### Tests d'hypothèse
 - Évaluer une hypothèse sur la population à partir de l'échantillon
 - Étapes : 
	 - formuler H0 (Hypothèse nulle) et H1(alternative) : H0 : μ = μ0, H1 : μ ≠ μ0
	 - Choisir un niveau de signification (α) : ex 0.05
	 - Calculer la statistique de test : z = (x̄ - μ0) / (σ/√n)
	 - Prendre une décision : reject H0 if p-value < α
 - Exemple : Tester si la moyenne d'une population est égale à une valeur spécifique

#### Exemples de tests
Test z:
 - Comparer la moyenne d'un échantillon à une valeur connue (test unilatéral ou bilatéral)
 - Exemple : Tester si la moyenne des scores d'un test est différente de 75, avec σ connu
test t de student:
 - Comparer la moyenne d'un échantillon à une valeur connue (test unilatéral ou bilatéral)
 - Exemple : Tester si la moyenne des scores d'un test est différente de 75
test khi-deux : 
 - Comparer des proportions ou des distributions observées
 - Exemple : Tester l'indépendance entre deux variables qualitatives dans un tableau de contingence
ANOVA : analyse de la variance
 - Comparer les moyennes de plusieurs groupes
 - Exemple : Comparer les scores moyens de trois groupes d'étudiants

### Applications IA
Inférence bayésienne : mise à jour des croyances avec de nouvelles données
 - Exemple : Classifier des emails en spam ou non-spam avec Naive Bayes
Apprentissage supervisé : évaluer la performance des modèles
 - Exemple : Utiliser des tests d'hypothèse pour comparer deux algorithmes de classification
Sélection de modèles : choisir le meilleur modèle parmi plusieurs
 - Exemple : Utiliser AIC ou BIC pour sélectionner un modèle de régression

### Définitions:
Intelligence Artificielle :
 - Simulation de l'intelligence humaine par des machines
 - Sous-domaines : apprentissage automatique, traitement du langage naturel, vision par ordinateur
 - Applications : chatbots, recommandations, reconnaissance faciale
 
Machine Learning :
 - Algorithmes permettant aux machines d'apprendre à partir de données
 - Types : supervisé, non supervisé, par renforcement
 - Applications : classification, régression, clustering

Deep Learning :
 - Sous-domaine du machine learning utilisant des réseaux de neurones profonds
 - Architectures : CNN, RNN, GAN
 - Applications : reconnaissance d'images, traduction automatique, génération de texte

Notes : systèmes expert :
 - Systèmes basés sur des règles pour simuler la prise de décision humaine
 - Composants : base de connaissances, moteur d'inférence
 - Applications : diagnostic médical, assistance juridique
Il suit une procédure logique (if... then...)

Histoire en bref
 - 1950s-60s : débuts de l'IA, premiers algorithmes. Turing, perceptron
 - 1970s-80s : systèmes experts, IA symbolique. Datalog, Prolog
 - 1990s-2000s : apprentissage automatique, big data. SVM, Random Forest
 - 2010s-présent : deep learning, IA générative. TensorFlow, PyTorch