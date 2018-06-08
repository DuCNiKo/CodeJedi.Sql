# Les fonctions d'agrégats

[Retour au sommaire](./../README.md#Sommaire)

Les fonctions d'aggrégation permettent de "regrouper" des lignes ensembles (en fonction de colonnes) et d'effectuer des fonctions d'aggregats sur d'autres. Cela permet de faire des sommes, des comptes, des moyennes sur des valeurs numériques ou de numéroter les lignes. Tout cela s'effectue avec un `SELECT`.

> Dans les exemples, on utlisera la table suivante :
> id, clientid, paysid, montant, date

## Clause GROUP BY

Afin d'indiquer au moteur SQL sur quelles colonnes on regroupe les données, il faut mettre dans la requête SQL une clause `GROUP BY`. Voici sa syntaxe :

```SQL
GROUP BY {
      column-expression
} [ ,...n ]
```

Après les mots-clés `GROUP BY`, on liste les colonnes (séparées par une virgule) ou les fonctions (on peut faire une addition ou utiliser un ISNULL) sur lesquelles on veut grouper.

## Les principales fonctions

SUM / MAX / COUNT / MIN / AVG

## Clause HAVING


## Les fonctions avancées (OVER / ORDER BY / PARTITION)

ROW_NUMBER / DENSE_RANK / RANK / etc.