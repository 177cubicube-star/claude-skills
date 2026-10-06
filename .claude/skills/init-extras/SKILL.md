---
name: init-extras
version: 1.0.0
description: Complément à /init pour la rédaction de fichiers d'autorité (CLAUDE.md, README.md) sur des dépôts documentaires ou en rédaction active — mesurer l'absence d'outillage plutôt que l'inventer, ne jamais déduire la maturité d'un document de son soin rédactionnel, et ne jamais graver de décompte non re-mesurable. Use when running /init on a repo with no code or sparse build tooling, or when writing/updating an authority file (CLAUDE.md) whose source documents carry status markers ([Proposition], [À décider]) suggesting active drafting.
---

# init-extras

Complément à `/init` (skill de plateforme, non modifiable). Trois règles
observées d'abord sur un dépôt documentaire, absentes du gabarit natif.

## 1. Un champ sans mesure vaut mieux qu'un champ inventé

`/init` demande explicitement des commandes de build, de lint et de test.
Sur un dépôt sans manifeste de paquet ni fichier source, ces commandes
n'existent pas — les inventer produit une commande plausible et fausse
qu'une session future exécutera de bonne foi.

**Avant d'écrire la section :** chercher un manifeste de build
(`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) et l'historique git.
Si aucun n'existe, écrire explicitement :

> Aucune commande de build/test/lint n'existe — mesuré le <date> par
> l'absence de manifeste de paquet et par `git log`.

Ne jamais laisser la section vide (se relit comme un oubli) ni deviner
(produit une fausse certitude).

## 2. Le soin rédactionnel n'est pas un signal de maturité

Un brouillon bien écrit — tableaux, numérotation, marques de statut,
journal de décisions — et une spécification arrêtée sont
**typographiquement indiscernables**. Seule la parole de l'auteur les
sépare.

**Avant d'écrire une hiérarchie d'autorité entre documents sources**
(« le PRD gagne sur la vision », « telle contrainte est actée ») : demander
si ces documents sont stabilisés ou encore en rédaction. Par défaut, en
l'absence de réponse, écrire au **conditionnel** — « à ce jour, le PRD
arbitre la vision sur la phase 1 » — plutôt qu'à l'impératif.

## 3. Décompte de documents dans le fichier qui les décrit

Voir le Principe transversal 5 (`cross-cutting-principles.md`), amendement
« les fichiers d'autorité comptent aussi ». Résumé : par défaut, aucun
nombre — renvoyer à la liste elle-même ; si un nombre est nécessaire, il
porte sa date de mesure et se re-mesure à chaque ajout ou retrait de
fichier.
