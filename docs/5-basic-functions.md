# 5. Les fonctions de base

* [Retour au sommaire](./../README.md#Sommaire)
  * [4. Les opérations de bases](./4-dml-operations.md)
  * [6. Les jointures](./6-joins.md)

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