# NYCTaxiFare

## Configuration de PostGresql

- Création utilisateur administrateur au niveau UNIX (typiquement *postgres*)
- Création du répertoire censé contenir le groupe de base de données
- Passage en utilisateur *postgres*
- *initdb* option importante pour initialisation base de données
  - --pgdata/-D : chemin vers le répertoire du cluster
  - --pwprompt/-W : mot de passe admin DB
  - --locale typiquement "en_US.UTF-8"
  - -E encodage "UTF8"
- Fichiers importants
   - Postgresql.conf : paramètres importants pour le processus (ressource allocation, logging, ...)
   - pg_hba.conf
- Extensions (en particulier intégration des langages R et Python ayavec Posgres)
- Création des utilisateurs avec leurs droits associés

## Création de la table

On a mise en place la base de données avec:
```{sql}
CREATE TABLE fare(
       id char(40),
       fare numeric(5, 2),
       date timestamp,
       ilong double precision,
       ilat double precision,
       olong double precision,
       olat double precision,
       pcount integer);
```

On va fournir importer les dix premièrs éléments de notre base de données:
```{sql}
\copy fare FROM '10.csv.gz' WITH (FORMAT CSV);
```

On peut aussi importer des données compressées:
```{sh}
gzip -dc sorted.csv.gz |  psql -c '\copy fare FROM stdin WITH (FORMAT CSV);'
```
