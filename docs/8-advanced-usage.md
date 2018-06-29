# Les fonctionnalités avancées

* [Les fonctionnalités avancées](#les-fonctionnalités-avancées)
  * [Les fonctions d'aggrégat avancées](#les-fonctions-daggrégat-avancées)
    * [OVER (ORDER BY / PARTITION BY / ROWS)](#over-order-by--partition-by--rows)
    * [ROW_NUMBER, RANK et DENSE_RANK](#row_number-rank-et-dense_rank)
  * [Common Table Expression (CTE)](#common-table-expression-cte)
    * [Récursivité](#récursivité)
  * [Les curseurs](#les-curseurs)
  * [Procédure stockées](#procédure-stockées)
  * [Functions](#functions)
  * [Tables temporaires](#tables-temporaires)
  * [Exercices](#exercices)

## Les fonctions d'aggrégat avancées

Toutes les fonctions d'aggrégat peuvent être utilisée avec des mots-clés particuliers qui permettent de limiter et trier le jeu de lignes utilisés pour appliquer la fonction. Cela se fait avec le mot-clé `OVER`.

### OVER (ORDER BY / PARTITION BY / ROWS)

La syntaxe est la suivante :

```SQL
OVER (
  [ <PARTITION BY clause> ]  
  [ <ORDER BY clause> ]
  [ <ROW or RANGE clause> ]  
)  

<PARTITION BY clause> ::=
  PARTITION BY value_expression , ... [ n ]  

<ORDER BY clause> ::=  
ORDER BY order_by_expression  
  [ COLLATE collation_name ]
  [ ASC | DESC ]
  [ ,...n ]  

<ROW or RANGE clause> ::=  
{ ROWS | RANGE } <window frame extent>  

<window frame extent> ::=
{
  <window frame preceding>  
  | <window frame between>  
}

<window frame between> ::=
  BETWEEN <window frame bound> AND <window frame bound>  

<window frame bound> ::=
{
  <window frame preceding>  
  | <window frame following>  
}  

<window frame preceding> ::=
{  
  UNBOUNDED PRECEDING  
  | <unsigned_value_specification> PRECEDING  
  | CURRENT ROW  
}  

<window frame following> ::=
{  
  UNBOUNDED FOLLOWING  
  | <unsigned_value_specification> FOLLOWING  
  | CURRENT ROW  
}  

<unsigned value specification> ::=
{  <unsigned integer literal> }
```

On utilise la clause `OVER` juste après la fonction d'aggrégat. La clause se décompose en trois éléments que l'on place entre parenthèse (`PARTITION BY`, `ORDER BY`, `ROWS` ou `RANGE`).

`PARTITION BY` divise le jeu de résultat en partition (ensemble plus petit). La fonction d'aggrégat est alors appliquée sur cette partition et non sur l'ensemble de la requête.

`ORDER BY` permet de trier la partition (ou le jeu complet s'il n'y a pas de partition).

`ROWS` et `RANGE` permet de limiter la partition en indiquant une plage de lignes à prendre en compte ou le nombre de ligne.

Pour mieux comprendre cela, je vous conseille d'aller sur les [exemples](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-2017#examples) présents sur la page MSDN

### ROW_NUMBER, RANK et DENSE_RANK

`ROW_NUMBER` permet de numéroter les lignes de 1 à n. La clause dans le `PARTITION BY` va permettre de recommencer la numérotation à 1. L'ordre de la numérotation est données par la clause `ORDER BY`. Cette clause permet d'avoir une numérotation continue sans doublons.

`RANK` permet de données le rang des lignes. Il s'agit aussi d'une numérotation de 1 à n (les clauses `PARTITION BY` et `ORDER BY` ont les mêmes effets). La différence se situe au niveau de la numérotation. Si n éléments d'une même partition ont la même valeur dans la clause `ORDER BY`, elles auront le même rang et la numérotation sautera autant de valeur que n.

| ORDER BY | RANK |
| --------:| ----:|
| 1        | 1    |
| 2        | 2    |
| 2        | 2    |
| 3        | 4    |

`DENSE_RANK` fonctionne comme `RANK` mais ne saute pas de valeur en cas d'égalité.

| ORDER BY | RANK |
| --------:| ----:|
| 1        | 1    |
| 2        | 2    |
| 2        | 2    |
| 3        | 3    |

## Common Table Expression (CTE)

Les CTE permettent de spécifier un jeu de données temporaire, nommé et utilisable dans une requête finale. On peut les comparer à des vues temporaires, c'est à dire que le moteur va exécuter la requête, mettre le résultat dans un jeu de données que l'on peut utiliser dans la requête suivante. On peut avoir autant de jeu de données que l'on souhaite. Voici la syntaxe :

```SQL
[ WITH <common_table_expression> [ ,...n ] ]

<common_table_expression>::=
    expression_name [ ( column_name [ ,...n ] ) ]  
    AS  
    ( CTE_query_definition )
```

Les CTE démarrent avec le mot-clé `WITH`. Après ce mot-clé, on met le nom du jeu de données puis `AS` et la requête SQL entre parenthèse. Chaque jeu de données est séparé par une virgule. Très souvent, c'est utilisé pour simplifier les requêtes complexes nécessitant de nombreuses jointures entre les tables. Cela permet d'avoir des requêtes plus petites représentant un jeu de données cohérent que l'on va lier ensemble par la suite. Lisez cet [article](https://sqlpro.developpez.com/cours/sqlserver/cte-recursives/) (un peu vieux mais toujours d'actualité) qui explique à quoi servent et comment fonctionnent les CTE.

### Récursivité

Tel que l'on a vu les CTE, elles sont pratiques mais essentiellement pour des soucis de lisibilité/simplicité de requête. Par contre, il est possible d'utiliser les CTE pour effectuer des requêtes **récursives**. C'est réalisable car il est possible d'utiliser la CTE nommée dans la requête définissant la CTE (comme on le ferait avec un méthode recursive).

Pour ce faire, il faut commencer par mettre le point de départ dans une requête SQL et avec le mot-clé `UNION ALL` mettre dans une autre requête la correlation entre le l'itération _N_ et l'itération _N+1_.

Le plus simple est de regarder les exemples directement. Les exemples se base sur la table [chapter8].[Véhicule] qui contient une arborescence des véhicule :

```None
  All
  |-- Sea
  |   |-- Boat
  |   --- Submarine
  |-- Earth
  |   |-- Four wheels
  |       |-- Car
  |       --- Truck
  |   --- Two wheels
  |       --- Motorcycle
  |-- Air
      |-- Plane
      --- Shuttle
```

Le premier exemple permet de récupérer la hierarchie ascendante de la voiture (Car => Earth => All). Le deuxième permet d'afficher pour chaque noeud finaux (sans enfant), le chemin pour y accéder (Car : All => Earth => Car, Plane: All => Air => Plane, etc.).

Le troisième permet de splitter une chaîne de caractères. On stocke dans une table UserRole, un identifiant d'utilisateur et ses rôles séparés par des virgules. Cette requête permet d'obtenir pour un utilisateur, la liste de ses rôles mais sous forme de lignes.

## Les curseurs

Les curseurs sont un type particulier dans SQL Server. Ce sont des objets qui permettent d'itérer sur un jeu de résultat et d'effectuer, pour chaque ligne, d'autres requêtes. Il faut le voir comme une boucle `for` sur un jeu de données où chaque colonne du jeu de données est stocké dans une variable propre.

> Attention à deux choses :
> * Les curseurs sont lents et prennent beaucoup de resources sur le moteur de base de données. Ce n'est à utiliser que dans le cas de scripts de régulation complexe où de simples requêtes ne suffisent pas.
> * Ce sont des objets ayant des pointeurs et des empreintes mémoires élevées. Il faut donc toujours penser à clôturer et supprimer un curseur. Sinon, on se trouve avec une fuite mémoire. De plus, les curseurs étant nommés, s'il n'est pas clôturé et supprimé, on ne peut réutiliser le même nom pour un deuxième curseur.

Un curseur doit tout d'abord être déclaré avec les mots-clés `DECLARE cursor_name CURSOR`. Une fois déclaré, il faut l'exécuter avec le mot-clé `OPEN cursor_name`. Puis, il faut mettre les valeurs de la requête dans des variables avec le mot-clé `FETCH NEXT cursor_name INTO variable1,... , variablen`. Chaque appel au mot-clé `FETCH` passe le curseur à la ligne suivante. On peut encapsuler cet appel dans une boucle `WHILE` pour itérer. La variable système `@@FETCH_STATUS` indique s'il y a de nouvelles lignes ou non. Pour fermer un curseur, on utilise le mot-clé `CLOSE cursor_name`. Enfin, pour supprimer le curseur de la mémoire, il faut utiliser le mot clé `DEALLOCATE cursor_name`.

En résumé, voici la syntaxe que l'on utilise le plus souvent (aller voir la [documentation](https://docs.microsoft.com/en-us/sql/t-sql/language-elements/cursors-transact-sql?view=sql-server-2017) pour voir les options possibles) :

```SQL
-- Déclaration des variables
DECLARE @Val1 <type>, @ValN <type>;

-- Création du curseur
DECLARE cursor_name CURSOR
     FOR select_statement
[;]

-- Démarrage du curseur
OPEN cursor_name;
-- Récupération des valeurs de la première ligne
FETCH NEXT cursor_name INTO @Val1, @ValN;

-- Itération
WHILE @@FETCH_STATUS = 0
BEGIN
  -- Opération à faire pour chaque ligne en utilisant les variables @Val1, @ValN

  -- Récupération des valeurs des autres lignes
  FETCH NEXT cursor_name INTO @Val1, @ValN;
END

-- Fermeture du curseur
CLOSE cursor_name;
-- Suppression du curseur
DEALLOCATE cursor_name;
```

C'est l'opération `FETCH` qui permet de mettre à jour la variable `@@FETCH_STATUS`. C'est pour cela qu'il y a un `FETCH` avant la boucle et un dans la boucle. Il est conseillé d'utiliser toujours cette suite d'instruction car elle permet d'ouvrir, fermer et supprimer le curseur proprement.

## Procédure stockées

Les procédures stockées sont des ensembles d'instructions SQL qui sont stockés au niveau de la base de données (comme les tables, vues, etc.) et qui permettent généralement d'effectuer des opérations complexes qu'il n'est pas possible de faire en une seule requête (pour des raisons de complexité de la requête ou de performances). Les procédures peuvent être créer `CREATE PROCEDURE` , modifier `ALTER PROCEDURE` ou supprimer `DROP PROCEDURE`. De plus, on peut passer des paramètres à la procédure stockées. Chaque `SELECT` présent dans la procédure sera affichée dans les résultat (ie. s'il y a deux requête, on verra deux jeu de résultats). Une procédure renvoie toujours une valeur (quand la valeur de retour est omise, elle renvoie 0 par défaut). On peut comparer une procédure stockées à une fonction en C#. Elle a un nom, des paramètres et un retour.

```SQL
-- Création ou modification de procédure
CREATE [ OR ALTER ] { PROC | PROCEDURE }
    [schema_name.] procedure_name [ ; number ]
    [ { @parameter [ type_schema_name. ] data_type }  
        [ VARYING ] [ = default ] [ OUT | OUTPUT | [READONLY]  
    ] [ ,...n ]
AS { [ BEGIN ] sql_statement [;] [ ...n ] [ END ] }  
[;]

-- Suppression de procédure
DROP { PROC | PROCEDURE } [schema_name.] procedure_name [;]
```

Par défaut, les paramètres sont des paramètres entrant. C'est à dire qu'on donne une valeur à la procédure. Si la valeur est modifiée dans la procédure, l'appelant de la procédure n'obtient pas la valeur calculée. On peut définir des paramètres entrant/sortant (le paramètre est passé à la procédure qui modifie le paramètre, dans ce cas, l'appelant obtiendra la nouvelle valeur) Si on a besoin de renvoyer plus d'une valeur, on peut explicitement indiquer que des paramètres sont des paramètres de sortie (comme le `out` en C#).

## Functions

## Tables temporaires


## Exercices

1. Ordonner les employées par ordre d'arrivée dans leur département.