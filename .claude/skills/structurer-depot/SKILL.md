---
name: structurer-depot
version: 1.0.1
description: Analyse un dépôt (documents, code ou mixte) et recommande sa structure — en lecture seule par défaut. Mesure l'état réel par commandes, classe le dépôt, diagnostique orphelins, doublons, noms trompeurs, paires à synchroniser et éléments manquants, puis propose un tableau « actuel → proposé » sans rien déplacer. Option sur demande : créer seulement le squelette de gouvernance manquant (CLAUDE.md, README, dossiers) après aperçu et GO. Use when the user asks to analyse, audit, structure or reorganise a repo, or asks "qu'est-ce qui manque dans ce dépôt".
---

# structurer-depot

Un dépôt se structure d'après ce qu'il **contient**, pas d'après ce qu'on
imagine qu'il devrait contenir. Ce skill mesure d'abord, recommande ensuite,
et ne touche à rien sans GO.

## Garde-fous — non négociables

- **Lecture seule par défaut.** Les étapes 1 à 4 n'écrivent aucun fichier.
- **Jamais** déplacer, renommer, supprimer ou écraser un fichier existant
  (R200/R201). Une réorganisation est une *recommandation*, jamais un geste.
- **Jamais lire la valeur** d'un `.env`, d'une clé, d'un certificat (R203) :
  signaler leur présence par le nom du fichier seulement.
- **Jamais de décompte recopié** dans un fichier durable : y mettre la commande
  qui le mesure (R603).
- **Refaire l'étape 1 à chaque lancement** — ne jamais se fier à un état vu
  plus tôt dans la session (R104).
- Aucun commit, aucun push : ce skill n'en fait pas.

## Étape 1 — Mesurer (aucune écriture)

Confirmer le répertoire (`pwd`), puis mesurer. Chaque fait de l'analyse doit
venir d'une de ces commandes, jamais d'une déduction :

```bash
pwd
git rev-parse --show-toplevel; git status --short; git log --oneline -5; git remote -v
git ls-files | wc -l                              # fichiers suivis
git ls-files | sed 's/.*\.//' | sort | uniq -c | sort -rn | head   # extensions
git ls-files --others --exclude-standard          # non suivis
ls -la                                            # racine
```

Chercher ensuite la présence (oui/non, par `ls` ou `git ls-files`) de :
`CLAUDE.md`, `README.md`, `.gitignore`, `docs/`, un manifeste
(`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.csproj`),
des tests (`tests/`, `*_test.*`, `*.spec.*`), une CI (`.github/workflows/`).
Signaler les fichiers de secrets **par nom seulement**.

Hors dépôt git : le dire, et mesurer avec `ls -R` à profondeur limitée.

## Étape 2 — Classer

| Type | Critère mesuré |
|---|---|
| **Documentaire** | extensions dominantes `.md/.html/.docx/.pdf`, aucun manifeste, aucun fichier source |
| **Code** | manifeste présent ET fichiers source dominants |
| **Mixte** | les deux, ou documents + scripts isolés |

Annoncer le verdict en une ligne avec la mesure qui le fonde. Si le critère
est ambigu : `TO VALIDATE`, et demander.

## Étape 3 — Diagnostiquer

Chaque constat porte une étiquette : **CONFIRMED** (une commande l'établit),
**ASSUMPTION**, **TO VALIDATE** (R101). Grille par type :

**Tous types :** fichiers à la racine qui devraient être sous un dossier ·
doublons (noms voisins, versions `-v2`, `-final`, `copie`) · fichiers non
suivis · noms trompeurs (le nom ne dit pas le contenu : lire le titre interne)
· absence de README / CLAUDE.md / `.gitignore`.

**Un « aucun » ne se conclut qu'avec un contrôle positif.** Avant d'écrire
« aucun orphelin », « aucun doublon » ou « aucun test », essayer la même
commande sur un cas où la réponse est connue (un fichier qu'on sait référencé,
un nom qu'on sait présent). Si la commande rend aussi zéro sur ce cas, elle ne
sait pas répondre : le constat devient `TO VALIDATE`, jamais « aucun ».
Noter l'outil et son environnement à côté du résultat : la même commande peut
rendre zéro dans un environnement et un résultat dans un autre.

**Documentaire, en plus :** paires source ↔ dérivé (ex. `.md` et son `.html`)
à garder synchronisées · documents jamais référencés par un autre
(`grep -l` sur le nom) · **ne jamais déduire la maturité d'un document de son
soin rédactionnel** : un brouillon soigné et un document arrêté se
ressemblent. Demander, ou écrire au conditionnel.

**Code, en plus :** absence de tests ou de CI · dossier source sans entrée
claire · dépendances non verrouillées (manifeste sans lockfile) · commandes de
build/test **mesurées dans le manifeste**, jamais inventées. S'il n'y en a
aucune, l'écrire : « aucune commande — mesuré le <date> par l'absence de
manifeste ».

## Étape 4 — Recommander (aucune écriture)

Produire, à l'écran seulement :

1. **Verdict** — type, taille, état git, en 3 lignes.
2. **Constats** — tableau : constat · étiquette · commande qui l'établit.
3. **Structure cible** — arborescence proposée, minimale (YAGNI : ne proposer
   un dossier que s'il a déjà des fichiers à y mettre).
4. **Tableau de migration** — `fichier actuel → emplacement proposé · raison`.
   Le présenter comme une *proposition* ; rien n'est déplacé.
5. **Risques** — liens relatifs qui casseraient, paires à resynchroniser,
   historique git touché par un renommage.

Terminer par : « Veux-tu l'option squelette (étape 5) ? »

## Étape 5 — Option : squelette de gouvernance (sur demande seulement)

Ne s'exécute que si l'utilisateur dit oui à l'étape 4.

1. Lister **uniquement ce qui manque** (CLAUDE.md, README.md, `.gitignore`,
   dossiers déjà justifiés par l'étape 3).
2. **Montrer l'aperçu** du contenu de chaque fichier à créer, puis attendre
   le GO.
3. Créer **seulement des fichiers nouveaux**. Si un fichier existe déjà,
   le sauter et le dire — jamais l'écraser.
4. Un CLAUDE.md généré applique `init-extras` : pas de commande inventée,
   état git par commande de re-mesure, jamais par recopie.
5. Rapporter : fichiers créés, rien d'autre modifié (`git status --short`
   collé en preuve). Laisser le commit à l'utilisateur.

## Vérification avant livraison (pré-vol)

Relire les garde-fous. Répondre **par exécution**, pas par coche :
`git status --short` montre-t-il uniquement des fichiers `??` créés à
l'étape 5, ou rien ? Chaque constat de l'étape 3 nomme-t-il sa commande ?
Si non, corriger avant de livrer.
