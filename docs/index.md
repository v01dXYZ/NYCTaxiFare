# Prédire le prix d'une course de taxi
## Prétraitement des données
### Base de données

Pour traiter les données de manière efficace et facilement extensible, l'utilisation d'un système
de gestion de base de données relationnelle s'imposait

- Outil spécialisé et optimisé (indexation, plannificateur de requête, etc)
- Algèbre relationnelle (jointures en particulier)
- Code de traitement plus compréhensible en SQL qu'en R

Nous avons choisi **Postgres**. Ce choix fut conforté par la présence d'extensions pour Postgres:

- *PostGIS*: traitement des données géospatiales
- *cstore*: stockage orienté colonne offrant de bien meilleurs taux de compression

Avec de telles extensions, Postgres peut mettre en forme les données sans même passer par R. La 
procédure de prétraitement se retrouve ainsi simplifiée.

Malheureusement, même avec de petits jeu de données (50 millions de lignes, moins de 10 colonnes),
PostGres présente des performances moindres que d'autres systèmes. 

Nous avons donc décider d'utiliser plutôt **Clickhouse** pour les requêtes finales. 
Si nous ne l'avons pas utilisé directement, c'est à cause de son absence de gestion des données spatiales.
Nous préférons centraliser le prétraitement au niveau de Postgres et  laisser à Clickhouse une table 
qui soit facilement aggrégeable, domaine où Clickhouse est le plus efficace. 

Notre architecture est donc très simple puisque absolument pas distribuée mais elle permet déjà un 
traitement reproductible et plus performant qu'avec R seulement.

![alt-text](img/pipeline.svg)

### Opérations effectuées sur le jeu de données

Les informations suivantes sont pour chaque élément calculées et ajoutées:

- zone de taxi de départ de la course 
- zone de taxi d'arrivée de la course

##  Analyse descriptive des données
### Visualisation


[![alt-text](img/cartography-i.png)](map/leaflet-i.html)

[![alt-text](img/cartography-o.png)](map/leaflet-o.html)

[![alt-text](/img/avg_week.png)](/grafana/dashboard-solo/snapshot/t3TfiaFK4KBy0oUUrAcTp2FJ5C5us2Ir?orgId=1&panelId=4) 


