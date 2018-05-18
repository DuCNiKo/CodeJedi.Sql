# 2. Best practices

* [Retour au sommaire](./../README.md#Sommaire)
  * [1. Le modèle relationnel](./1-relational-model.md)
  * [3. La création du modèle](./3-ddl-operations.md)

Cette section concerne les habitudes à prendre quand on travaille sur SQL Server.

[Poor SQL](http://poorsql.com/)

## Indentation

Prenez l'habitude d'indenter les requêtes quand vous les écrivez. Cela vous permettra de relire plus facilement vos requêtes.

### Requête simple

Pour des requêtes avec beaucoup de colonnes, tables, il faut mieux séparer chaque élément sur des lignes différentes. Les séparateurs peuvent être placés indifféremment à la fin de la ligne précédente ou au début de la nouvelle ligne (l'avantage de les mettre au début de la ligne c'est que l'on peut commenter une ligne sans "casser" la syntaxe SQL).

```SQL
SELECT
    Col1
    , Col2
    , Col3
FROM Table1
    JOIN Table2 ON Predicat
WHERE Predicat1
    AND/OR Predicat2
ORDER BY
    OrderClause1
    , OrderClause2
```

Evidemment si la requête est très simple, on peut mettre tout une clause sur une seule ligne.

```SQL
SELECT Col1, Col2
FROM Table1 JOIN Table2 ON Predicat
```

### Sous-requêtes

Vous aurez souvent des sous-requêtes à taper. Dans ce cas, il est préférable d'indenter aussi la sous requête. Cela permet d'identifier plus rapidement l'objet de la sous-requête.

```SQL
SELECT
    Col1
    , Col2
FROM (
        SELECT Col3
        FROM Table3
    ) A
    JOIN Table1
```

## mot clé en majuscule

Toujours pour améliorer la lisibilité, pensez à mettre les mot clés en majuscule. Cela permet de différencier rapidement les mot-clés des identifiants de table/colonne.

## Crochet pour les colonnes

On utilise souvent des mot-clés en tant que colonne ou table (Name, Address, Type, ...). Lors d'utilisation d'application avec coloration syntaxique, ces colonnes apparaissent donc comme des mot-clés. Pour éviter cela, prenez l'habitude de mettre des crochets pour encadrer les noms de schémas, tables ou colonne.

```SQL
SELECT A.[Type], B.[Name]
FROM [dbo].[Table1] A
    INNER JOIN [dbo].[Table2] B ON A.[Table2Id] = B.[Id]
```

## Scripts de modifications de données en base

### BEGIN TRAN ... ROLLBACK

Lorsque vous avez un script de régule de données à effectuer. Commencez toujours par créer une transaction et effectuer un ROLLBACK de la-dite transaction. Cela permet de tester et contrôller que le script fonctionne sans pour autant impacter réellement les données.

```SQL
BEGIN TRAN

    -- Affiche l'ancienne valeur
    SELECT [Name] FROM [Table] WHERE [Id] = 5;

    -- Modifie la valeur
    UPDATE [Table] SET [Name] = 'NewName' WHERE [Id] = 5;

    -- Vérifie la nouvelle valeur
    SELECT [Name] FROM [Table] WHERE [Id] = 5;

ROLLBACK
```

### Status bar

C'est arrivé à tout le monde... Vous préparez une requête pour vider une table sur votre base de dev. Avant de l'exécuter, le client vous demande d'extraire des données de la prod. Vous revenez sur votre requête, faites F5 et là... Vous vous rendez compte que vous venez de vider la table en production.

Lorsque vous voulez exécuter une requête sur une base de données avec SSMS, avant de lancer la requête, vérifier que vous êtes bien sur la bonne instance et la bonne base de données. Vous pouvez contrôler cela avec la barre de statut :
![Status bar](./images/query-status-bar.png "Barre de status SSMS")

On y retrouve l'instance (ici AzureAD\NicolasWynhant...) ainsi que la base de données (AdventureWorks2016).