# 6. Les jointures

* [6. Les jointures](#6-les-jointures)
  * [Syntaxe](#syntaxe)
  * [CROSS JOIN](#cross-join)
  * [INNER JOIN](#inner-join)
  * [LEFT/RIGHT/FULL JOIN](#leftrightfull-join)
    * [LEFT JOIN](#left-join)
    * [RIGHT JOIN](#right-join)
    * [FULL JOIN](#full-join)
  * [Exercices](#exercices)

L'utilisation de jointures est primordiale en SQL. Cela permet de lier deux jeux de données ensembles. Cela veut dire que si on joint deux tables, on obtient une troisième table contenant l'intégralité des colonnes des deux tables jointes. Le nombre de lignes change en fonction du type de jointure utilisé.

> Durant ce chapitre, nous allons considérer les deux tables suivantes pour voir l'effet des jointures sur le résultat. (fichier d'initialisation "[6-joins.exemple.sql](../src/6-joins.exemple.sql)")
>
> **Table1**
> Table1Id|Valeur1
> ---|---
> 1|A
> 2|B
> 3|C
> 4|D
> 5|E
>
> **Table2**
> Table2Id|Table1Id|Valeur2
> ---|---|---
> 1|*NULL*|A
> 2|1|B
> 3|4|C
> 4|*NULL*|D
> 5|2|E
> 6|3|F

## Syntaxe

Voici la syntaxe des jointures :

```SQL
FROM { <table_source> } [ ,...n ] ]

<table_source> ::=
{
    table_or_view_name [ [ AS ] table_alias ]
    | <joined_table>
}

<joined_table> ::=
{
    <table_source> <join_type> <table_source> ON <search_condition>
    | <table_source> CROSS JOIN <table_source>
}

<join_type> ::=
    [ { INNER | { { LEFT | RIGHT | FULL } [ OUTER ] } } [ <join_hint> ] ] JOIN
```

## CROSS JOIN

Le `CROSS JOIN` est le produit cartésien de deux tables. Si la table1 contient 10 lignes et la table2 30 lignes, le résultat d'un cross join entre les deux tables nous ramènera 300 lignes (10x30). Il est possible de faire un cross join en mettant un espace entre les tables au lieu de mettre les mots-clés `CROSS JOIN`.

```SQL
-- Exemple avec l'utilisation du mot-clé
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    CROSS JOIN [Table2] T2

-- Exemple sans le mot-clé
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    , [Table2] T2
```

> Voici le résultat de la requête :
> > Table1Id|Value1|Value2|Table2Id
> ---|---|---|---
> 1|A|A|1
> 1|A|B|2
> 1|A|C|3
> 1|A|D|4
> 1|A|E|5
> 1|A|F|6
> 2|B|A|1
> 2|B|B|2
> 2|B|C|3
> 2|B|D|4
> 2|B|E|5
> 2|B|F|6
> 3|C|A|1
> 3|C|B|2
> 3|C|C|3
> 3|C|D|4
> 3|C|E|5
> 3|C|F|6
> 4|D|A|1
> 4|D|B|2
> 4|D|C|3
> 4|D|D|4
> 4|D|E|5
> 4|D|F|6
> 5|E|A|1
> 5|E|B|2
> 5|E|C|3
> 5|E|D|4
> 5|E|E|5
> 5|E|F|6

## INNER JOIN

Le `INNER JOIN` permet de relier les données de deux tables en fonction d'un prédicat. Autrement dit, on va limiter le nombre de ligne retourné en fonction du prédicat. Si le prédicat est vrai pour une ligne, elle sera retournée. Si le prédicat est faux, la ligne n'apparaîtra pas.

```SQL
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    INNER JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];
```

> Voici le résultat de la requête :
> Table1Id|Value1|Value2|Table2Id
> ---|---|---|---
> 1|A|B|2
> 4|D|C|3
> 2|B|E|5
> 3|C|F|6

## LEFT/RIGHT/FULL JOIN

Jusqu'à présent, les jointures vues affichaient soit l'intégralité de la combinatoire de deux tables, soit les éléments pouvant être reliés dans les tables grâce à un prédicat. Les trois jointures que l'on va voir (`LEFT`,`RIGHT`,`FULL`) permettent de voir les éléments d'une table et s'il existe une relation, les données de la deuxième table.

### LEFT JOIN

Le `LEFT JOIN` affiche l'intégralité des données de la table situé à gauche. Ensuite, pour chaque ligne de la table de droite, si le prédicat est vrai, on verra la ligne de droite, si le prédicat est faux pour toutes les lignes de la table de droite, on verra `NULL` dans les colonnes de la table de droite.

```SQL
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    LEFT JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];
```

> Dans cet exemple, on aura toutes les lignes de la table 1 (id et valeur). Pour chaque ligne de la table 2, le moteur SQL va tester le prédicat :
> * Pour chaque ligne où le prédicat est vrai, les données de la ligne de la table 2
> * Si aucune ligne de la table 2 ne respecte le prédicat, on aura NULL dans les colonnes de la table 2
>
> Voici le résultat :
> Table1Id|Value1|Value2|Table2Id
> ---|---|---|---
> 1|A|B|2
> 2|B|E|5
> 3|C|F|6
> 4|D|C|3
> 5|E|*NULL*|*NULL*

### RIGHT JOIN

Le `RIGHT JOIN` fonctionne de la même façon que le `LEFT JOIN` mais, comme son nom l'indique, ce sont les données de la table de droite que l'on verra intégralement et les données de la table de gauche pour les lignes qui respectent le prédicat.

```SQL
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    RIGHT JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];
```

> Voici le résultat :
> Table1Id|Value1|Value2|Table2Id
> ---|---|---|---
> *NULL*|*NULL*|A|1
> 1|A|B|2
> 4|D|C|3
> *NULL*|*NULL*|D|4
> 2|B|E|5
> 3|C|F|6

### FULL JOIN

Le `FULL JOIN` fonction toujours de la même façon mais on verra ce coup-ci l'intégralité des données des deux tables.

```SQL
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
    FULL JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];
```

> Voici le résultat :
> Table1Id|Value1|Value2|Table2Id
> ---|---|---|---
> 1|A|B|2
> 2|B|E|5
> 3|C|F|6
> 4|D|C|3
> 5|E|*NULL*|*NULL*
> *NULL*|*NULL*|A|1
> *NULL*|*NULL*|D|4

## Exercices

Le but est d'obtenir en une seule requête les informations suivantes :

1. Afficher les noms, prénoms des employés (290 employés).
2. Ajouter à la requête précédentes les téléphones.
3. Modifier la requête précédente pour afficher tous les employés et leurs téléphones portables (s'il en ont un).