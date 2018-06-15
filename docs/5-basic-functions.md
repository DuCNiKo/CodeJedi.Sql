# 5. Les fonctions de base

* [5. Les fonctions de base](#5-les-fonctions-de-base)
  * [ISNULL](#isnull)
  * [EXISTS](#exists)
  * [CASE ... WHEN](#case--when)
  * [CAST et CONVERT](#cast-et-convert)
    * [CAST](#cast)
    * [CONVERT](#convert)
  * [Fonctions de dates](#fonctions-de-dates)
    * [GETDATE](#getdate)
    * [DATEADD](#dateadd)
    * [DATEDIFF](#datediff)
    * [DATEPART](#datepart)
  * [Exercices](#exercices)

On va voir ici les fonctions existantes dans SQL Server qui servent le plus souvent.

## ISNULL

La fonction `ISNULL` permet de donner une valeur par défaut à une valeur qui est `NULL`. C'est l'équivalent SQL de l'opération `??` en C#.

> Par exemple, on peut s'en servir quand on filtre une requête en fonction d'un paramètre. On a une table (MaTable) avec une valeur (MaValeur) et un paramètre qui indique si l'on souhaite filtrer sur cette valeur (@MonParametre = X) ou non (@MonParametre = NULL).

```SQL
-- Filtre clasique
SELECT * FROM [MaTable] WHERE @MonParametre IS NULL OR @MonParametre = [MaValeur];

-- Utilisation de ISNULL
SELECT * FROM [MaTable] WHERE ISNULL(@MonParametre, [MaValeur]) = [MaValeur];
```

## EXISTS

Syntaxe:

```SQL
  EXISTS( subquery )
```

Cette fonction revoie un booléen indiquant si la sous-requête renvoie des lignes ou non.

## CASE ... WHEN

Cette fonction permet d'effectuer des tests et de renvoyer une valeur en fonction du résultat du ou des tests. La syntaxe est la suivante :

```SQL
-- Simple CASE expression
CASE input_expression
     WHEN when_expression THEN result_expression [ ...n ]
     [ ELSE else_result_expression ]
END

-- Searched CASE expression:  
CASE  
     WHEN Boolean_expression THEN result_expression [ ...n ]
     [ ELSE else_result_expression ]
END
```

Si on met une expression avec le `CASE`, les `WHEN` ne contiendront que des valeurs qui seront comparées à la première expression. Si on ne met pas d'expression dans le `CASE`, il faut, dans chaque `WHEN` avoir une expression booléenne. C'est cette dernière qui sera évaluée par le moteur pour sélectionner quelle valeur à retourner.

La valeur `NULL` ne peux pas être mise dans les clauses `WHEN` car `NULL` n'est égale à aucune valeur (même pas à lui-même). Si on souhaite tester la nullité d'une valeur, il faut utiliser la deuxième forme (sans l'input_expression) et mettre `IS NULL` dans les clauses `WHEN`.

Dans tous les cas, le moteur itère sur les `WHEN` et renvoie **la première valeur** (après le `THEN`) qui correspond. S'il y a deux clauses qui sont vraies, la valeur retournée sera celle de la première. Enfin, il est possible d'utiliser le mot-clé `ELSE` pour renvoyer une valeur si aucun prédicat n'est vrai.

Le mot-clé `END` permet d'indiquer la fin de l'instruction.

## CAST et CONVERT

Les fonctions `CAST` et `CONVERT` permettent de convertir un type de données en un autre. La différence entre les deux commandes est que `CAST` est un commande SQL utilisable sur tous les moteurs de bases de données SQL alors que `CONVERT` est une fonction existante uniquement sur SQL Server.

### CAST

voici la syntaxe pour l'utilisation de la commande :

```SQL
CAST(<valeur> AS <type>)

-- Exemple
SELECT CAST(1 AS VARCHAR)
```

### CONVERT

Cette fonction étant spécifique à SQL Server, contient plus d'options qui permettent de choisir le formattage de sortie (en particulier avec les conversions de date en chaîne de caractères). Je vous laisser aller voir la [documentation](https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017) pour trouver toutes les options.

```SQL
CONVERT(<type>, <valeur>, <options>)

-- Exemple
SELECT CONVERT(VARCHAR, 1);

-- La valeur 103 permet de formatter une date au format dd/MM/yyyy
SELECT CONVERT(VARCHAR, <aDate>, 103)
```

## Fonctions de dates

Toutes les fonctions de date/heure se trouvent [ici](https://docs.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-2017).

> | datepart    | Abbreviations |
> | ----------- | ------------- |
> | year        | yy, yyyy      |
> | quarter     | qq, q         |
> | month       | mm, m         |
> | dayofyear   | dy, y         |
> | day         | dd, d         |
> | week        | wk, ww        |
> | weekday     | dw, w         |
> | hour        | hh            |
> | minute      | mi, n         |
> | second      | ss, s         |
> | millisecond | ms            |
> | microsecond | mcs           |
> | nanosecond  | ns            |

Pour créer un objet datetime à partir d'un texte tapé, il est préférable d'utiliser la notation suivante : `yyyy-MM-dd HH:mm:ss.nnnn`. SQL Server traduira automatiquement ce texte en type DATETIME et avec les bonnes valeurs. Cela évite d'être dépendant de la langue du serveur, de l'instance ou de la base de données. En américain, les dates sont au format MM/dd/yyyy alors qu'en français, elles sont au format dd/MM/yyyy. Cela évite les confusions amenées par '02/06/2018' qui se traduit par 6 février en américain et 2 juin en français.

### GETDATE

Cette fonction permet d'obtenir la date/heure courante.

```SQL
SELECT GETDATE()
```

### DATEADD

Cette fonction permet d'ajouter une valeur à une date. La syntaxe est:

```SQL
DATEADD(<datepart>, <value>, <date>)

-- Exemple ajouter un jour à la date courante.
DATEADD(d, 1, GETDATE())
-- Exemple enlever 5 heures à la date courante.
DATEADD(h, -5, GETDATE())
```

### DATEDIFF

Cette fonction permet d'obtenir la différence entre deux dates. Elle renvoie une valeur entière.

```SQL
DATEDIFF(<datepart>, <startDate>, <endDate>)

-- Exemple différence en minute entre deux jours
DATEDIFF(mi, GETDATE(), DATEADD(d, 1, GETDATE()))
```

### DATEPART

Cette fonction permet d'extraire d'une date, une partie.

```SQL
DATEPART(<datepart>, <date>)

-- Exemple obtenir le mois courant
DATEPART(m, GETDATE())
```

## Exercices

A partir de sa date de naissace, obtenir les informations suivantes :

1. La date 125 jours après la naissance.
2. L'âge que l'on aura durant l'année.
3. L'âge en minutes.
4. Obtenir dans 3 colonnes différentes, le jour, le mois et l'année de naissance.