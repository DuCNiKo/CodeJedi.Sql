# Formation SQL

## Introduction

Il s'agit du support pour la formation SQL. Le but est d'apprendre et de savoir utiliser les base de données relationnelles.

## Sommaire

 1. [Le modèle relationnel](./docs/1-relational-model.md)
 1. [Best practices](./docs/2-best-practices.md)
 1. [La création du modèle](./docs/3-ddl-operations.md)
 1. [Les opérations de bases](./docs/4-dml-operations.md)
 1. [Les fonctions de base](./docs/5-basic-functions.md)
 1. [Les jointures](./docs/6-joins.md)
 1. [Les fonctions d'agrégat](./docs/7-aggregates-functions.md)
 1. [Fonctionnalités avancées](./docs/8-advanced-usage.md)
 1. [Performances](./docs/9-performance.md)

## Pré-requis

Pour pouvoir suivre cette formation, il est nécessaire d'avoir une instance SQL Serveur d'installée. De préférence, avoir la dernière version complète mais une version [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-editions-express) est suffisante (installable avec Visual Studio).

Tout au long de ce cours, nous allons créer des tables, insérer des données pour illustrer chaque chapître. Vous trouverez dans le répertoire `src` des fichiers d'initialisation (xxx.initialization.sql), d'exemples (xxx.exemple.sql) et des fichiers contenant les réponses aux questions (xxx.answers.sql). Chaque chapître sera classé par schéma.

### Initialisation de la base de données

Ouvrir SSMS et se connecter à une instance SQL où vous avez des droits d'adminsitration (généralement celle que vous avez installé sur votre poste). Ouvrir une requête et taper la commande suivante :

```SQL
CREATE DATABASE [CodeJediSQL];
```

La base devrait maintenant être visible le panneau "Object Explorer" (après un rafraichissement avec la touche <kbd>F5</kbd>).