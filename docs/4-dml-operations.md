# 4. SELECT & DML (Data Modification Language)

* [4. SELECT & DML (Data Modification Language)](#4-select--dml-data-modification-language)
    * [SELECT](#select)
        * [WHERE](#where)
        * [ORDER BY](#order-by)
        * [DISTINCT](#distinct)
        * [TOP x](#top-x)
    * [INSERT](#insert)
    * [UPDATE](#update)
    * [DELETE](#delete)
    * [MERGE](#merge)
    * [Exercices](#exercices)

Les opéraitions DML sont celles qui permettent soit d'alimenter, soit de lire les données présentes dans les tables. Il existe donc des commandes pour lire `SELECT`, insérer `INSERT`, modifier `UPDATE` ou supprimer `DELETE` les données.

> À partir de là, nous allons utiliser la base Northwind.

## SELECT

Pour lire les données d'une table, on utilise la commande

```SQL
SELECT {
    *
    | <table_identifier>.<column_name>
    | <function_name>
} [ AS <new_name> ]
FROM <table_name> [ AS <table_identifier> ]
    <joins>
WHERE <logical_operations>
ORDER BY <column_name> [ , ...n ]
```

Le principe d'une requête `SELECT` est de choisir les informations que l'on souhaite afficher (située après le `SELECT`) à partir d'une source de données située après le `FROM`. De filtrer ce résultat avec une clause `WHERE` et de choisir l'ordre d'affichage des lignes avec la clause `ORDER BY`.

La syntaxe de base est relativement simple. La complexité viendra de plusieurs éléments :

* Des jointures entres les tables nombreuses et complexes.
* De sous-requêtes présentes dans les clauses `SELECT`, `FROM` ou `WHERE`.
* De clauses `WHERE` compliquées
* ...

> Pour obtenir la liste des produits vendus avec toutes les colonnes de la table :

```SQL
SELECT *
FROM [Production].[Product]
```

> Pour obtenir la liste des produits vendus avec leurs noms et leur code :

```SQL
SELECT P.[Name], P.[ProductNumber] AS [Code]
FROM [Production].[Product] P
```

### WHERE

La clause `WHERE` permet de filtrer un jeu de données. On effectue cela en écrivant des tests logiques et en les combinant avec des ET logiques `AND` ou des OU logiqes `OR`. Des parenthèses peuvent être utilisées pour indiquer de la précédence.

> Pour obtenir la liste des produits (nom et code) qui sont de couleur noire et dont le seuil de stock est supérieur à 500 et qu'il faut recommander si on en a moins de 1000 :

```SQL
SELECT P.[Name], P.[ProductNumber] AS [Code]
FROM [Production].[Product] P
WHERE P.[Color] = 'Black' AND (P.[SafetyStockLevel] > 500 OR P.[ReorderPoint] < 1000);
```

### ORDER BY

La clause `ORDER BY` permet de trier le résultat. Elle s'utilise en listant les colonnes sur lesquelles on souhaite trier et en ajoutant l'information si le tri doit être ascendant `ASC` ou descendant `DESC`.

> En partant de la requête filtrée, si on souhaite ordonner le résultat par seuil de stock ascendant et prix standard descendant :

```SQL
SELECT P.[Name], P.[ProductNumber] AS [Code]
FROM [Production].[Product] P
WHERE P.[Color] = 'Black' AND (P.[SafetyStockLevel] > 500 OR P.[ReorderPoint] < 1000)
ORDER BY P.[SafetyStockLevel] ASC, P.[StandardCost] DESC;
```

### DISTINCT

Le mot-clé `DISTINCT` permet de dédoublonner le résultat d'une requête. Chaque groupe de valeur n'apparaitra qu'une seule fois dans le résultat.

> Pour obtenir de façon unique tous les noms de groupe des départements :

```SQL
SELECT DISTINCT D.[GroupName]
FROM [HumanResources].[Department] D;
```

### TOP x

Le mot-clé `TOP <value> [ PERCENT ]` s'utilise avec une valeur numérique qui indique le nombre de ligne à ramener. Si le mot clé `PERCENT` est ajouté, la requête ramènera les X premier pourcent.

> Pour avoir un set de 10% des produits commandés :

```SQL
SELECT TOP 10 PERCENT *
FROM [Sales].[SalesOrderDetail]
```

> Attention, pour pouvoir utiliser le mot-clé `PERCENT`, le moteur de base de données doit calculer le nombre total de ligne ramené par la requête pour pouvoir convertir les X pourcents en valeur fixe. Cela peut être gourmand et ralentir la requête.

## INSERT

L'insertion de donées dans une table s'effectue avec le mot-clé `INSERT` :

```SQL
INSERT
{
    INTO <table_name> [ ( column_list ) ]
    {
        VALUES ( { DEFAULT | NULL | expression } [ ,...n ] ) [ ,...n ]
        | <dml_table_source>
    }
};

<dml_table_source> ::=
    SELECT <select_list>
    FROM ( <dml_statement_with_output_clause> ) [AS] table_alias
    [ WHERE <search_condition> ]
```

On peut donc soit insérer des données avec des valeurs fixes (utilisation de `VALUES`), soit insérer des données à partir d'une requête `SELECT`.

Lorsque l'on insère les données dans une table, il faut prendre en compte différents éléments :

* Est-ce qu'il a des colonnes avec des valeurs par défaut ?
* Est-ce que la clé primaire est une colonne entière auto-incrémentée ?
* Quels sont les colonnes acceptant NULL et celles qui doivent obligatoirement avoir une valeur ?

S'il n'y a de clé primaire auto-incrémentée, on peut omettre la liste des colonnes. Par contre, il faut que les données à insérer aient exactement le même format que la table.

Généralement, on liste plutôt les colonnes afin de contrôler au mieux l'insertion des données.

> Pour insérer une nouveau type d'adresse, on peut omettre la colonne AddressTypeId car c'est une clé primaire auto-incrémentée, les colonnes rowguid et ModifiedDate car elles ont une valeur par défaut. Par contre la colonne Name est obligatoire (NOT NULL) et n'a pas de valeur par défaut. On peut donc écrire :

```SQL
INSERT INTO [Person].[AddressType] ([Name]) VALUES
    ('Type1'),
    ('Type2');
```

ou

```SQL
INSERT INTO [Person].[AddressType] ([Name]) VALUES
    SELECT <column_name> FROM <table_name>;
```

## UPDATE

La modification des données dans une table s'effectue avec la commande `UPDATE` :

```SQL
-- Syntax for SQL Server and Azure SQL Database

[ WITH <common_table_expression> [...n] ]
UPDATE
    table_alias
    SET
        { column_name = { expression | DEFAULT | NULL } } [ ,...n ]
    [ FROM{ <table_source> } [ ,...n ] ]
    [ WHERE <search_condition> ]
[ ; ]
```

La commande comment par le mot clé `UPDATE` suivi de l'identifiant de la table où l'on souhaite modifier des valeurs. Ensuite, le mot-clé `SET` permet de spécifier les colonnes à modifier ainsi que les valeurs.

Pour limiter le nombre de lignes à modifier, on peut utiliser une clause `WHERE` classique (avec des prédicats) ou utiliser une autre requête avec le mot clé `FROM`.

## DELETE

La suppression de lignes dans une table s'effectue avec la commande `DELETE` :

```SQL
-- Syntax for SQL Server and Azure SQL Database

DELETE FROM table_alias
    [ WHERE <search_condition> ]
[; ]
```

La suppression est relativement simple. Il suffit d'indiquer après les mots-clés `DELETE FROM` le nom de la table et d'indiquer avec la clause `WHERE` les prédicats filtrant les lignes à supprimer. Attention, pour cette instruction, il faut obligatoirement un point-virgule pour finir l'instruction.

## MERGE

La commande `MERGE` permet, en une seule requête, de mixer les actions d'insertions, modifications et suppressions sur une table (appelé cible) par rapport à un jeu de données source.

```SQL
MERGE <target_table>
    USING <table_source> ON <merge_search_condition>
    [ WHEN MATCHED [ AND <clause_search_condition> ] THEN <merge_matched> ]
    [ WHEN NOT MATCHED [ BY TARGET ] [ AND <clause_search_condition> ] THEN <merge_not_matched> ]
    [ WHEN NOT MATCHED BY SOURCE [ AND <clause_search_condition> ] THEN <merge_matched> ] [ ...n ]
;

<table_source> ::=
{
    table_or_view_name [ [ AS ] table_alias ] [ <tablesample_clause> ]
    | rowset_function [ [ AS ] table_alias ]
    | user_defined_function [ [ AS ] table_alias ]
    | <joined_table>
}

<merge_matched>::= { UPDATE SET <set_clause> | DELETE }

<set_clause>::= SET column_name = { expression | DEFAULT | NULL } [ ,...n ]

<merge_not_matched>::=
{
    INSERT [ ( column_list ) ]
        {
            VALUES ( values_list )
            | DEFAULT VALUES
        }
}
```

La requête `MERGE` peut se décomposer en trois parties :

* La partie avec le mot-clé `MERGE` qui permet de définir la table que l'on souhaite modifier (aussi appelé la cible).
* La partie avec le mot-clé `USING` qui permet de définir un jeu de données qui sert à effectuer les modifications (aussi appelé la source) ainsi que le prédicat permettant de lier les données cibles et les données sources.
* Les parties commençant par `WHEN` qui indique les modifications à apporter :
    * `MATCHED` : Le prédicat fait qu'une ligne de la source est relié à une ligne de la cible. Dans ce cas, on peut soit faire un `UPDATE`, soit faire un `DELETE`.
    * `NOT MATCHED BY TARGET` : Le prédicat fait qu'aucune ligne de la cible ne peut être relié aux lignes de la source. Dans ce cas, on peut insérer les données manquante avec le mot-clé `INSERT`.
    * `NOT MATCHED BY SOURCE` : Le prédicat fait qu'une ligne de la cible ne peut être relié à aucune ligne de la source. On peut, dans ce cas, effectuer les opérations `UPDATE` ou `DELETE`.

> Généralement, on effecute un `UPDATE` sur le `MATCH` et un `DELETE` sur le `NOT MATCHED BY SOURCE`.

## Exercices

Voici ce que vous devez faire :

1. Les RH souhaitent connaitre tous les départements existants.
2. Les achats souhaitent avoir les produits mis en vente depuis le 1er janvier 2010 classé par prix standard croissant.
3. Ajouter un département 'French stores' dans le group 'Stores'.
4. Il y a une erreur dans la commande du magasin 'Seventh Bike Store' faite le 31 mai 2011. Ils souhaitaient commander 3 'Sport-100 Helmet, Black'. Faites un script de modification.
5. Finalement, il faut supprimer le département 'French stores'.
6. Créer une requête `MERGE` permettant de s'assurer que l'on a dans la table AddressType, les informations suivantes

| AddressTypeID | Name        | rowguid                              | ModifiedDate |
| ------------- | ----------- | ------------------------------------ | ------------ |
| 1             | Billing     | 00000000-0000-0000-0000-000000000001 | Date du jour |
| 2             | Home        | 00000000-0000-0000-0000-000000000002 | Date du jour |
| 3             | Main Office | 00000000-0000-0000-0000-000000000003 | Date du jour |
| 4             | Primary     | 00000000-0000-0000-0000-000000000004 | Date du jour |
| 5             | Shipping    | 00000000-0000-0000-0000-000000000005 | Date du jour |
| 6             | Archives    | 00000000-0000-0000-0000-000000000006 | Date du jour |
| 7             | Factory     | 00000000-0000-0000-0000-000000000007 | Date du jour |

> Tips: La première colonne est une colonne `IDENTITY`. Le moteur interdit donc de spécifier la valeur de cette colonne lors d'une insertion ou d'une modification. Il est possible de désactiver ce fonctionnement en utilisant la commande `SET IDENTITY_INSERT <table_name> ON | OFF`.