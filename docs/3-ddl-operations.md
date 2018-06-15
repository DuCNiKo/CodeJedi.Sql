# 3. DDL (Data Definition Language)

* [3. DDL (Data Definition Language)](#3-ddl-data-definition-language)
  * [Création (CREATE)](#création-create)
    * [Les colonnes](#les-colonnes)
    * [Les contraintes](#les-contraintes)
  * [Suppression (DROP)](#suppression-drop)
  * [Modification (ALTER)](#modification-alter)
    * [Ajout](#ajout)
    * [Suppression](#suppression)
    * [Modification](#modification)
  * [Exercice](#exercice)
    * [Premières tables](#premières-tables)
    * [Modifications des tables](#modifications-des-tables)

Les opérations de DDL permettent de créer dans la base de données, tous les éléments qui ne sont pas des données à proprement parlé. Par exemple, elles permettent de créer les tables, colonnes, contraintes mais aussi les procédure stockées, les fonctions, les utilisateurs qui accèdent à la base de données, leurs droits, ...

Nous verrons ici uniquement ce qui concerne les tables, colonnes et les contraintes.

## Création (CREATE)

`CREATE` est le mot-clé qui permet de créer un élément dans la base de données. Ce mot clé doit être accompagné de l'élément que l'on souhaite créer :

* `CREATE TABLE` permet de créer une table
* `CREATE PROCEDURE` permet de créer une base de données

> Pour les colonnes et les contraintes, on ne les crée pas réellement, on modifie la table pour ajouter ces éléments. La commande sera donc un `ALTER TABLE <NomTable> ADD <Element>...`.

```SQL
CREATE TABLE [ database_name . [ schema_name ] . | schema_name . ] table_name (
    {
        <column_definition>
        | <constraint_definition>
    } [ ,...n ] );

<column_definition> ::= column_name <data_type>
    [ IDENTITY [ ( <seed> , <increment> ) ]
    [ NULL | NOT NULL ]
    [ DEFAULT ( <default_value> ) ]

<column_constraint> ::= CONSTRAINT constraint_name
    {
        { PRIMARY KEY | UNIQUE } ( column_name )
        | FOREIGN KEY ( column_name ) REFERENCES [ schema_name . ] referenced_table_name [ ( ref_column ) ]
            [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
            [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
        | CHECK ( logical_expression )
    }
```

> Il s'agit là d'une version simplifiée de la commande. La vrai commande est beaucoup plus complexe mais il est rare d'avoir à utiliser les autres spécifité de cette commande. Pour plus d'information, voici [le lien de la page MSDN](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql?view=sql-server-2017).

La création d'une table commence toujours par l'instruction `CREATE TABLE`. Cette insctruction doit être suivie du nom de la table `table_name`. Ce nom de table peut être pré-fixée par le nom du schéma dans lequel il se situe `schema_name` et le nom de la base de données `database_name`.

Après le nom de la table, il faut mettre entre parenthèses les différentes colonnes et contraintes à appliquer à la table.

### Les colonnes

Les colonnes sont séprées par des virgules. Elles doivent obligatoirement avoir un nom `column_name` et un type `data_type`.

Les clés primaires sont généralement des colonnes de types `INT`. Cela impose, à chaque insertion, de savoir quelles valeurs sont déjà présentes et quelles valeurs ne le sont pas pour pouvoir affecter au nouvel enregistrement une valeur n'existant pas. Tous les moteurs de bases de données ont un système permettant de ne pas avoir à gérer cet élément. En Transac-SQL, cela se fait avec le mot-clé `IDENTITY`. Il permet d'indiquer au moteur qu'il doit, à chaque insertion, mettre une valeur qu'il incrémentera à chaque besoin. On peut spécifier la valeur de départ (par défaut, il s'agit de 1) et la valeur de l'incrément (par défaut 1 aussi).
> On pourrait très bien créer une colonne démarrant à 10 et s'incrémentant de 12 en 12 avec la clause IDENTITY suivante : `IDENTITY(10, 12)`.

Par défaut, les colonnes créées acceptent la valeur NULL. Cela peut aussi être spécifié explicitement en mettant le mot-clé `NULL` dans la création de la colonne. Pour empêcher de saisir NULL dans une colonne, il faut mettre les mots-clés `NOT NULL` dans la création de la colonne.

Enfin, il est possible de mettre une valeur par défaut `DEFAULT` à une colonne. Cela permet de ne pas avoir à spécifier cette colonne lors de l'insertion de données, la valeur par défaut sera automatiquement mise.

### Les contraintes

Lors de la création d'une table, on peut spécifier les contraintes de celle-ci. Cela se fait en rajoutant des lignes spécifiques commençant par le mot-clé `CONSTRAINT`.
> Il est possible de mettre une contrainte sur une colonne en mettant les mots-clés de la contrainte directement dans la définition de la colonne. Mais je trouve que l'on perd en lisibilité. J'ai tendance à mettre les contraintes sur des lignes à part.

Après le mot-clé `CONSTRAINT`, on doit mettre le nom de la contraintes. Encore une fois, le moteur de base de données est capable de créer le nom de la contrainte mais il est préférable de la définir pour des soucis de lecture et de maintenabilité.

Ensuite, il faut mettre le type de la contrainte (`PRIMARY KEY | UNIQUE | FOREIGN KEY | CHECK`). Chaque contrainte à un format propre.

* `PRIMARY KEY` et `UNIQUE` doivent être suivis du nom de la ou des colonnes sur lesquelles se base la contrainte entre parenthèses.
* `FOREIGN KEY` doit aussi être suivie du nom des colonnes entre parenthèses mais en plus, il faut indiquer au moteur sur quelles clés-primaires d'une autre table cela fait référence. Pour cela, on utilise le mot-clé `REFERENCES` puis on indique le nom de la table et le nom des colonnes entre parenthèses.
* `CHECK` est suivi d'une expression logique entre parenthèse.

## Suppression (DROP)

Pour supprimer une table, il faut utiliser la commande suivante:

```SQL
DROP TABLE <table_name>;
```

## Modification (ALTER)

Cette commande permet de modifier une table. Cela inclu l'ajout d'une colonne ou d'une contrainte, la suppression d'une colonne ou d'une contrainte ainsi que leurs modifications. Encore une fois, nous allons voir une version simplifiée de la commande. La commande complète se trouve [là](https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-table-transact-sql?view=sql-server-2017).

### Ajout

La commande pour ajouter une colonne ou une contrainte est

```SQL
ALTER TABLE <table_name> ADD {
    <column_definition>
    | <constraint_definition>
}
```

La définition des colonnes ou des contraintes est la même que pour la création d'une table.

### Suppression

La commande pour supprimer une colonne ou une contrainte est

```SQL
ALTER TABLE <table_name> DROP {
    COLUMN <column_name>
    | CONSTRAINT <constraint_name>
}
```

> Attention, dans le cas de la suppression, il faut indiquer au moteur quel élément on souhaite supprimer. C'est pour cela qu'il faut mettre après le `DROP` soit `COLUMN` soit `CONSTRAINT`.

### Modification

La commande pour modifier une colonne est

```SQL
ALTER TABLE <table_name> ALTER {
    COLUMN <column_definition>
}
```

> Attention, dans le cas de la modification, il n'est pas possible de modifier une contrainte. Il faut la supprimer et la re-créer. Pour les colonnes, il ne faut pas oublier de mettre `COLUMN` après `ALTER`.

## Exercice

### Premières tables

Créer une base relationnel permettant de stocker les données répondants aux règles ci-dessous :

* Nous allons stocker des personnes et leur adresses mails.
* Une personne a un nom, un prénom et une date de naissance.
* Une personne peut avoir 0 ou n adresse mails.

### Modifications des tables

Après utilisation, on s'est rendu compte qu'il faut modifier la base pour que :

* La date de naissance soit obligatoirement inférieure à la date du jour.
* Les adresses mail ne doivent pas être en doublons.
* Il faut pouvoir savoir si une addresse a été vérifiée.