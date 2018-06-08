# Les fonctions d'agrégats

[Retour au sommaire](./../README.md#Sommaire)

Les fonctions d'aggrégation permettent de "regrouper" des lignes ensembles (en fonction de colonnes) et d'effectuer des fonctions d'aggregats sur d'autres. Cela permet de faire des sommes, des comptes, des moyennes sur des valeurs numériques ou de numéroter les lignes. Tout cela s'effectue avec un `SELECT`.

## Clause GROUP BY

Afin d'indiquer au moteur SQL sur quelles colonnes on regroupe les données, il faut mettre dans la requête SQL une clause `GROUP BY`. Voici sa syntaxe :

```SQL
GROUP BY {
      column-expression
} [ ,...n ]
```

## Clause HAVING

## Les principales fonctions

SUM / MAX / COUNT / MIN / AVG

## Les fonctions avancées (OVER / ORDER BY / PARTITION)

ROW_NUMBER / DENSE_RANK / RANK / etc.