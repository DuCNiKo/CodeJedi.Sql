# 1. Le modèle relationnel

* [1. Le modèle relationnel](#1-le-modèle-relationnel)
  * [Introduction](#introduction)
  * [Tables, colonnes et lignes](#tables-colonnes-et-lignes)
  * [Contraintes](#contraintes)
    * [Clé primaire (PRIMARY KEY)](#clé-primaire-primary-key)
    * [Clé étrangère (FOREIGN KEY)](#clé-étrangère-foreign-key)
    * [Contrainte d'unicité](#contrainte-dunicité)
    * [NOT NULL](#not-null)
    * [Contraintes de valeur (CHECK)](#contraintes-de-valeur-check)
  * [Types de données](#types-de-données)
  * [Vues](#vues)
  * [Schémas](#schémas)
  * [La suite](#la-suite)
  * [Questions orales à prévoir](#questions-orales-à-prévoir)

## Introduction

**Le modèle relationnel** est une manière de modéliser les relations existantes entre plusieurs informations, et de les ordonner entre elles *(source [WikiPedia](https://fr.wikipedia.org/wiki/Mod%C3%A8le_relationnel))*.

Autrement dit, cela permet de stocker des entités ayant différents formats et d'établir des relations entre ces entités.

## Tables, colonnes et lignes

Les entités sont stockées dans des **tables**. Chaque table a un nombre définit de **colonnes**. Chaque colonne permet de stocker une informations différentes sur une entité. Chaque **ligne** de la table est une entité.

> Par exemple, si on souhaite stocker les informations d'une personne (nom, prénom et date de naissance), on va créer une table *Person* ayant les colonnes suivantes :
>
> * *Firstname* : le prénom
> * *Lastname* : le nom
> * *BirthDate* : la date de naissance
>
> Cela donne :
>
> Firstname|Lastname|BirthDate
> ---|---|---
> Elon|Musk|29/06/1971
> Bill|Gates|22/10/1955

| Firstname | Lastname | BirthDate  |
| --------- | -------- | ---------- |
| Elon      | Musk     | 29/06/1971 |
| Bill      | Gates    | 22/10/1955 |

Dans une table, les colonnes ont un type (chaines de caractères fixe ou variable, entier, nombre décimaux, date, ...). Le type définit comment sera stocké l'information. Quelque soit le type (à moins que cela soit interdit par une contrainte), une colonne peut avoir la valeur *NULL*. Il s'agit d'une valeur particulière indiquant justement qu'il n'y a pas de valeur :)

## Contraintes

Il est possible de définir, sur les colonnes des tables, des contraintes. Ces contraintes permettent d'imposer un fonctionnement aux données présentes dans la table. Il existe de nombreuses contraintes différentes (clé primaire, clé étrangère, unicité, valeur par défaut, ...). Nous n'allons pas voir toutes les contraintes mais celles qui sont le plus utilisées.

### Clé primaire (PRIMARY KEY)

Les contraintes de clés primaires permettent d'indiquer au moteur de base de données qu'elle est l'identifiant d'une ligne dans une table. Il s'agit d'une colonne (ou d'un regroupement de colonne) qui permet d'**identifier de façon unique** une seule ligne d'une table. Cela veut dire que deux lignes ne peuvent pas avoir la même clé primaire. Si on essaie d'insérer dans la table une ligne avec une clé primaire déjà utilisé, le moteur de base de données ne le fera pas et renvoiera une erreur.

> Dans l'exemple des personnes, aucune des données de la table ne permet d'identifier de façon unique les lignes. Il peut exister plusieurs 'Elon', 'Musk' ou plusieurs personnes peuvent avoir la même date de naissance. C'est pour cela que généralement, on utilise un identifiant technique. Le plus simple est de créer une colonne *PersonId* qui sera un entier. Comme cela, on saura que la personne avec l'identifiant 1 est Elon Musk.
>
> PersonId|Firstname|Lastname|BirthDate
> ---|---|---|---
> 1|Elon|Musk|29/06/1971
> 2|Bill|Gates|22/10/1955

Dans certains cas, il est possible de créer une clé primaire **composite**. Cela veut dire que la clé primaire n'est pas basée sur l'unicité d'une seule colonne mais d'un ensemble de colonnes.

TODO : Trouver un exemple

### Clé étrangère (FOREIGN KEY)

Les contraintes de clés étrangères permettent d'établir les relations entre les tables. **Elles lient une (ou plusieurs colonnes) d'une table à la clé primaire d'une autre table**.

> Si on souhaite stocker plusieurs adresses emails par personnes, on va créer une table EmailAddress qui aura :
> * EmailAddressId : la clé primaire
> * PersoneId : l'identifiant de la personne à qui appartient l'adresse (qui sera la clé étrangère)
> * EmailAddress : l'adresse email
>
> On pourra donc stocker les informations comme suit :
>
> EmailAddressId|PersonId|EmailAddress
> ---|---|---
> 1|1|elon.musk@tesla.com
> 2|1|elon@google.com
> 3|2|billou@live.com

### Contrainte d'unicité

Il s'agit d'une contrainte qui impose l'unicité de valeur sur une ou plusieurs colonne d'une table. Dans le fonctionnement, cela ressemble à une clé primaire.

### NOT NULL

Comme vu précédemment, il existe une valeur indiquant qu'il n'y a pas de valeur dans la ligne pour la colonne (NULL). Cette contrainte empêche d'avoir NULL dans une colonne. C'est particulièrement intéressant quand il faut toujours avoir une valeur.

### Contraintes de valeur (CHECK)

Ce sont des contraintes qui impose qu'une fonction soit vrai sur une colonne pour pouvoir insérer ou modifier sa valeur.
> Sur une colonne indiquant un prix d'article (type MONEY), on peut imposer que le prix soit toujours une valeur positive.

## Types de données

Chaque colonne d'une table doit avoir un type de données. On peut y stocker :

* Des booléens
  * BIT : équivalent à System.Bool (bool)
* Des entiers
  * INT: équivalent à System.Int32 (int)
  * BIGINT : équivalent à System.Int64 (long)
  * SMALLINT : équivalent à System.Int16 (short)
  * TINYINT : équivalent à System.Byte (byte)
* Des nombres décimaux exactes. Ils sont tous équivalents à System.Decimal (decimal) mais ont des précisions différentes.
  * NUMERIC
  * DECIMAL
  * MONEY
  * SMALLMONEY
* Des nombres décimaux approximatifs
  * FLOAT : équivalent à System.Double (double)
  * REAL : équivalent à System.Single (single)
* Des champs date/heures
  * DATETIME
  * DATETIME2
  * DATE
  * TIME
  * DATETIMEOFFSET
  * SMALLDATETIME
* Des chaînes de caractères
  * CHAR : une chaine d'une longueur fixe
  * VARCHAR : une chaine d'une longeur variable
  * TEXT : un texte
  * NCHAR, NVARCHAR, NTEXT : la même chose mais stocké en UNICODE

Il en existe d'autres mais ces types sont plus rarement utilisés. Il faut malgré tout savoir qu'il est possible de stocker des Guid (UNIQUEIDENTIFIER), des documents (BINARY ou VARBINARY), des images (IMAGE), du XML (XML), des coordonnées géographiques, ...

## Vues

Les vues sont des requêtes SQL pré-enregistrées dans le moteur de base de données. On peut effectuer des SELECT sur une vues mais, généralement (oui, il ya des exceptions), on ne peut pas écrire dans une vue. C'est généralement utilisé pour avoir en un seul élément des données provenant de plusieurs tables.

## Schémas

Les schémas sont un élément chapeau qui permet de regrouper un ensemble de tables, vues, procédures stockées, ... ensemble.

## La suite

La suite du cours va se porter sur les opérations que l'ont peut faire sur un moteur de base de données. Les premières que l'on va voir sont les opérations permettant de créer les tables, colonnes, relations et contraintes. On appelle cela des opération DDL (Data Definition Language).

## Questions orales à prévoir

Différences entre TINYINT/SMALLINT/INT/BIGINT
DECIMAL / FLOAT / MONEY
etc.