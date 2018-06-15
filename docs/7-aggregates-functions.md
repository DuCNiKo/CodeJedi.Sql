# Les fonctions d'agrégats

* [Les fonctions d'agrégats](#les-fonctions-dagrégats)
  * [Clause GROUP BY](#clause-group-by)
  * [Les principales fonctions](#les-principales-fonctions)
    * [COUNT](#count)
    * [MIN et MAX](#min-et-max)
    * [SUM et AVG](#sum-et-avg)
  * [Clause HAVING](#clause-having)
  * [Exercice](#exercice)

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

Toute colonne dans la clause `SELECT` qui n'a pas de fonction d'aggrégat doit obligatoirement se trouver dans la clause `GROUP BY`. Il est possible de ne pas mettre la clause `GROUP BY` si la clause `SELECT` ne renvoie qu'une fonction d'aggrégat.

```SQL
-- Nombre d'opération
SELECT COUNT(1)
FROM [chapter7].[AccountMouvement];

-- Nombre d'opérations regroupés par nom.
SELECT [Name], COUNT(1)
FROM [chapter7].[AccountMouvement]
GROUP BY [Name];
```

## Les principales fonctions

### COUNT

Cette fonction d'aggrégat permet de compter. Elle permet soit de compter les lignes en mettant `COUNT(*)` ou `COUNT(1)`, soit de compter les valeurs distincts d'une colonne avec `COUNT(DISTINCT <NomColonne>)`.

Si l'expression du `COUNT` renvoie NULL, la ligne ne sera pas comptée.

```SQL
-- 1000 lignes => 1000 valeurs dans la colonne [Name]
SELECT COUNT([Name])
FROM [chapter7].[AccountMouvement];

-- 1000 lignes => 22 valeurs différentes dans la colonne [Name]
SELECT COUNT(DISTINCT [Name])
FROM [chapter7].[AccountMouvement];
```

### MIN et MAX

Ces deux fonctions d'aggrégat permettent d'obtenir la plus petite `MIN` et la plus grande `MAX` valeur d'une expression. Elle fonctionne sur tous les types de colonnes (même les chaîne de caractère).

Ici le mot-clé `DISTINCT` n'est pas utilisable.

```SQL
-- La date de la première opération
SELECT MIN([MouvementDate])
FROM [chapter7].[AccountMouvement];

-- Le montant maximum d'une opération
SELECT MAX([Amount])
FROM [chapter7].[AccountMouvement];

-- Par nom, la date de la première opération et le montant maximum
SELECT [Name], MIN([MouvementDate]), MAX([Amount])
FROM [chapter7].[AccountMouvement]
GROUP BY [Name];
```

### SUM et AVG

Ces fonctions d'aggrégat permettent de faire des calculs sur une colonnes de type numérique. `SUM` permet de faire la somme alors que `AVG` permet de faire la moyenne.

```SQL
-- Par année et par mois, la somme et la moyenne des mouvements
SELECT DATEPART(YEAR, [MouvementDate]), DATEPART(MONTH, [MouvementDate]), SUM([Amount]), AVG([Amount])
FROM [chapter7].[AccountMouvement]
GROUP BY DATEPART(YEAR, [MouvementDate]), DATEPART(MONTH, [MouvementDate])
ORDER BY 1, 2;
```

## Clause HAVING

La clause `HAVING` permet d'appliquer un filtre avec les fonctions d'aggrégat. Par exemple, elle permet de filtrer un jeu de données en s'assurant qu'une somme est supérieur à une valeur ou que le compte de lignes est supérieur à 1.

```SQL
-- En repartant de l'exemple précédent, on filtre ici sur les mois ayant au moins 75 opérations et dont l'opération moyenne est supérieur à -50
SELECT DATEPART(YEAR, [MouvementDate]), DATEPART(MONTH, [MouvementDate]), SUM([Amount]), AVG([Amount]), COUNT(1)
FROM [chapter7].[AccountMouvement]
GROUP BY DATEPART(YEAR, [MouvementDate]), DATEPART(MONTH, [MouvementDate])
HAVING COUNT(1) > 75 AND AVG([Amount]) > -50
ORDER BY 1, 2;
```

## Exercice

1. Compter les employés en les regroupants par nom de département.
2. Calculer le prix unitaire * quantité des commandes ayant au moins 20 produits sur l'année 2012 et regrouper le résultat par numéro de commande et nom de magasin.