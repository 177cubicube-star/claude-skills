# TODO — Projet Skills

**Maison de ce document :** racine du dépôt `claude-skills` — décision Mathieu
2026-07-24. Document vivant : chaque session ajoute son entrée au journal et
met à jour la liste, sans effacer l'histoire (une tâche finie se coche et se
date, elle ne se supprime pas).

**Règles d'écriture du fichier** (héritées des passations) :
- Événements datés, pas d'états flottants — « fait le », « décidé le »,
  jamais « en attente » sans condition nommée.
- Un sujet garé porte sa **condition de réouverture** — c'est ce qui le
  distingue d'un oubli.
- Toute session future **re-mesure avant de relire**.

---

## À faire — gestes courts (prochaine occasion)

- [x] Committer les 3 documents déposés à la racine du repo le 2026-07-24
      (`carte-skills.md`, `skills-maisons-et-acces.md`, `TODO.md`) —
      staging **nommé**, jamais `-A` (règle d'ordre du README).
      **Fait le 2026-07-24, commit `0a84d6a`** (vérifié le 2026-07-26 :
      les 3 fichiers sont suivis).
- [x] **Révoquer l'accès GitHub de ChatGPT/Codex** — décidé le 2026-07-26
      après l'incident d'import. Geste de la main de Mathieu.
      **Fait le 2026-07-27, déclaré par Mathieu** (l'état des applications
      autorisées d'un compte GitHub n'est pas mesurable depuis une session :
      c'est une déclaration consignée, pas une mesure).
      **Ce qui a été mesuré, en revanche :** l'accès git propre de Mathieu
      reste intact après la révocation — `ls-remote` répond sur les trois
      dépôts (`claude-skills`, `App-Handyman`, `suspension-intelligente`).
      C'était le risque annoncé au moment de la décision, il ne s'est pas
      réalisé : la révocation coupe l'application OpenAI, pas les identifiants
      du compte.
- [x] Supprimer les doublons périmés dans `Projects\`
      (`carte-skills.md`, `skills-maisons-et-acces.md`) — maison unique
      décidée le 2026-07-24 : le repo. Geste de la main de Mathieu
      (le pont ne supprime pas).
      **Fait le 2026-07-26**, en session Code sur demande de Mathieu.
      Mesuré avant suppression : les versions du dépôt sont des sur-ensembles
      stricts (+2 lignes chacune, zéro ligne présente uniquement dans les
      copies) — aucune perte. `Projects\` n'est pas un dépôt git, donc pas de
      filet local ; le contenu survit dans la maison et sur `origin/main`.
- [x] Ranger `audit_suspension_intelligente_detaille (1).md` (71 Ko, racine
      du repo) vers le dépôt qu'il concerne — obs 15 : « le dépôt ouvert
      n'est pas le propriétaire d'un fait ».
      **Fait le 2026-07-26.** Déposé en `docs/audits/audit-depot-20260723.md`
      dans `suspension-intelligente` (commit `5e75ca9`, poussé), au nom de la
      convention locale `audit-<sujet>-AAAAMMJJ.md` ; le suffixe « (1) » de
      téléchargement est tombé. Copie vérifiée identique octet pour octet
      (71 685 o) AVANT retrait de la source — la cible d'abord, jamais zéro
      exemplaire en vol. L'historique git du fichier ne suit pas : `git mv` ne
      traverse pas les dépôts (perte assumée, un seul commit d'origine).

- [x] **Supprimer `tdd-enforcer` du compte claude.ai** — **FAIT le 2026-07-27**,
      par pilotage Chrome sur GO explicite de Mathieu.
      **Constaté avant de supprimer** (personne ne l'avait mesuré depuis le
      24 juillet) : il était bien au compte, **dernière mise à jour 26/05/2026**
      — deux mois de retard sur le dépôt. L'affirmation « périmé au compte »
      héritée de l'audit Cowork est donc vérifiée, plus seulement rapportée.
      **Vérifié APRÈS suppression** : une session Claude Code ouverte dans
      `suspension-intelligente` répond toujours `SKILL=present` (2 runs). La
      suppression du compte ne retire rien au projet — c'est la preuve la plus
      forte disponible, puisque la source du compte n'existe plus.
      Réversible : le dialogue de confirmation l'annonce, et la source est sur
      GitHub (`c892491`).
      Note de méthode : le champ `version` **n'est pas exposé de façon fiable**
      dans la liste des skills d'une session (`VERSION=inconnue` en 2 runs sur
      3). Il sert au versionnement des fichiers, pas à vérifier un déploiement.
      Pour vérifier qu'un déploiement a pris, mesurer un **marqueur de contenu**,
      pas le numéro de version.
- [x] **Supprimer `architecture-guard` du compte claude.ai** — **FAIT le
      2026-07-27**, même geste, même GO. Même situation exactement : skill de
      projet de `suspension-intelligente`, **dernière mise à jour 27/05/2026**,
      deux mois de retard, dormant au compte où il pouvait imposer des règles
      d'architecture périmées en session Cowork.
      **Vérifié après suppression**, avec témoin :
      `AG=present TDD=present` depuis `suspension-intelligente` (2 runs) ·
      `AG=absent TDD=absent` depuis `claude-skills`. Les deux skills vivent
      dans leur dépôt, le compte n'y était pour rien.
- [x] **Supprimer `tri-inbox` du compte claude.ai** — **FAIT le 2026-07-27**.
      Même logique : skill de projet, utilisé seulement dans le vault.
      Vérifié après suppression, avec témoin : `TRI=present` depuis
      `cerveau-suspension` (2 runs) · `TRI=absent` depuis `claude-skills`.

**Découverte du 2026-07-27 — un quatrième dépôt et une collision de noms.**
`tri-inbox` avait bien une maison : **`Documents\cerveau-suspension`** (vault
Obsidian, dépôt git), que les recherches précédentes n'avaient pas couvert —
elles portaient sur trois dépôts, et je l'avais dit. Ma réserve « sans
maison-source connue » tombe : ce n'était pas une dérive ADR-028, c'était une
lacune de mon inventaire.

Ce dépôt portait **4 skills**, dont deux homonymes de ceux de
`suspension-intelligente` — mais **des skills différents** (`recap` 5 496 o vs
22 265 o ; `session-prep` 9 440 o vs 31 674 o). Or le compte ne peut en servir
qu'un de chaque : **mesuré, c'est la version de `suspension-intelligente` qui
était montée** (description anglaise, `version 2.1.0`). Une session Cowork sur
le vault recevait donc le rituel de l'autre projet — cherchant des branches
`claude/*` et des ADR dans un vault qui n'en a pas, sans aucun signal.

**Traité le jour même** (dépôt `cerveau-suspension`, commits `15ed5ad` et
`7fa70b9`) : `recap` → **`recap-vault`**, `session-prep` → **`session-prep-vault`**,
et les 4 skills passés en `version: 1.0.0`. Renommage chirurgical — les
références internes au vault suivent, mais les lignes d'attribution « Adapté du
`recap` de suspension-intelligence » restent **intactes** : elles créditent un
skill qui porte réellement ce nom ailleurs, et les renommer aurait falsifié la
provenance. Vérifié avec témoin : `NOUVEAUX=recap-vault, session-prep-vault
ANCIENS=aucun` dans le vault ; `ANCIENS=recap, session-prep` inchangés dans
`suspension-intelligente`.

**`session-prep` et `recap` restent au compte — décidé le 2026-07-27, sur
mesure.** Ce sont les versions de `suspension-intelligente` (22/07, `v2.1.0` et
`v1.1.1`), déployées le jour même où ces versions ont été gravées au dépôt
(commit `7d814c0`) : **à jour**, contrairement aux trois skills retirés qui
traînaient deux mois de retard.

**Mesuré, pas supposé.** Mathieu a lancé `recap` en session Cowork avec consigne
de ne rien sauvegarder — le skill prévisualise et attend confirmation, la mesure
était donc gratuite. Résultat : **fonctionnel, et pas partiellement**. Le
contrôle décisif (les hashes de commits) passe et est vérifiable des deux
côtés : l'aperçu cite `5e75ca9` et `c892491`, deux commits faits le même jour
depuis Claude Code. Il a aussi lu le gabarit, exécuté `adr_index_drift.py
--list`, produit toutes les sections, et respecté la consigne en sautant les
étapes 5 à 8. L'hypothèse « ça ne marche sûrement pas en Cowork » est donc
fausse — elle n'avait jamais été mesurée.

**Deux réserves relevées dans l'aperçu, à traiter au moment d'une vraie
sauvegarde, pas avant :**
- L'aperçu s'est numéroté `recap-20260728-01` alors que la journée de travail
  était le **2026-07-27** (commits 06:47–07:13). Un jour d'écart, cause non
  établie — horloge de la VM ? Un recap mal daté se range mal et inverse la
  lecture du journal. **Vérifier la date avant de sauvegarder.**
- Le skill signale lui-même que `git fetch` est bloqué depuis la VM (403 proxy),
  donc le numéro `NN` est calculé sur les refs locaux : il ne peut pas voir si
  un recap du même jour existe déjà à distance.
      **Décidé le 2026-07-27 :** `tdd-enforcer` est un skill **de projet**,
      adapté à `suspension-intelligente`, utilisé en Claude Code uniquement.
      Il ne va **jamais** au compte — même statut d'exclusion que
      `prompt-forge`. Sa version `1.0.0` a été gravée le même jour
      (`suspension-intelligente`, commit `c892491`) : elle sert de référence
      de départ pour ce dépôt, pas de préparatif de téléversement.
      **Pourquoi ce n'est pas optionnel :** une copie périmée dort encore au
      compte. Tant qu'elle y est, une session Cowork peut la déclencher et
      exécuter des instructions TDD obsolètes — sans aucun signal. C'est le
      défaut d'ADR-028 vu depuis le compte : deux jeux d'instructions sous un
      même nom.
      Vérification : le skill ne doit plus figurer dans Personnaliser →
      Compétences, et une session Cowork relancée ne doit plus le proposer.

- [ ] **Réaligner les trois circuits de `task-observer-perso`** — mesuré le
      2026-07-29 à 22 h 50 locale : maison **1.4.0** (`b9ab677`), disque
      **1.3.0** (déployé le 2026-07-27 à 21 h 32), compte **1.2.0**. Les trois
      sont désalignés et le déploiement rendu obligatoire par ISSUE-001 n'a pas
      tourné pour 1.4.0. Ordre : `deploy-skills.ps1 -Apply -Backup`, puis zip
      manuel vers le compte — ce circuit n'a pas de pont (F9), le zip est son
      seul canal.
      Vérification : rouvrir une session Cowork et lire le `version:` du skill
      réellement chargé, jamais celui du dépôt.
- [x] **Revue des observations `task-observer-perso`** (étape 2 du rituel) —
      **faite le 2026-07-29** en session Claude Code : bump 1.3.0 → **1.4.0**,
      commit `b9ab677` à 22 h 13 locale, principes transverses portés de six à
      dix. Cette ligne avait été ouverte par la session Cowork à 21 h 50 alors
      que le travail était déjà en cours ailleurs : deux sessions, aucune ne
      voyait l'autre (journal du 2026-07-29).

- [x] **Relire `.claude/settings.local.json`** — **fait le 2026-07-29**, chiffré
      et consigné à ISSUE-005 § « Relecture ». Mesuré : **94 entrées**, dont
      **6 à risque** — `git push *`, `git commit *`, `git add *`, `cp *`,
      `Remove-Item *`, et `py -3.13 -c ' *` que la piste de tri ne nommait pas
      (elle exécute du Python arbitraire, portée égale à `Remove-Item *`) — plus
      **7 entrées mortes** et 76 littérales inoffensives. Deux constats de fond
      dans l'ISSUE : la règle « `git add` nommé, jamais `-A` » est contredite par
      l'autorisation `git add *` qui couvre `-A` ; et `Read(//c/Users/mat_g/**)`
      englobe cinq entrées plus étroites, ce qui rend le choix « quel bout
      garder » et non « lesquelles retirer »
- [ ] **Trancher le tri des autorisations** — la relecture est faite, l'élagage
      non : **aucune entrée n'a été retirée**, la décision est de Mathieu
      (ISSUE-005 le pose, et la session s'est arrêtée à sa demande). Trois lots
      par ordre de rendement, détaillés à l'ISSUE : les 6 jokers larges (seul lot
      qui change le risque, au prix d'une confirmation à chaque geste) · les 5
      `Read` englobés **ou** le large qui les englobe (le second restreint
      réellement) · les 2 `sed -i` de marqueurs `MARQUEUR-V3BIS-*`, mesure
      terminée. Élaguer casse des workflows en cours — ne pas le faire à sa place
- [x] **Supprimer `.git/index.lock.orphelin-20260730-0139`** — **fait le
      2026-07-29**, par nom complet, sans joker. Vérifié : `test -e` répond NON,
      aucun verrou ne subsiste dans `.git/`, `git status` répond en exit 0,
      `git fsck` sain. Le fichier faisait 0 octet et git n'était pas bloqué —
      supprimer a fermé une ligne, pas un risque. **La cause reste armée** : le
      pont Cowork ne sait pas supprimer un verrou, seulement le déplacer, donc
      toute commande git lancée depuis le pont en laissera un nouveau, et
      celui-là bloquera la commande suivante. Le garde en place (« ne pas lancer
      git depuis le pont ») est un garde **par vigilance** — le principe
      transverse 9 dirait de chercher un garde par construction. Observation
      consignée pour la prochaine revue : store `claude-skills`, obs 13

## À faire — chantiers, dans l'ordre hérité (feuille de route, passation 3 § 8)

1. [x] **Sauvegarde datée** de `~\.claude\skills\` (robocopy vers
       `skills-sauvegarde-AAAAMMJJ\`) — préalable à toute écriture là-bas.
       **Faite le 2026-07-26** →
       `Documents\Claude\sauvegardes\skills-sauvegarde-20260726\`.
       15 fichiers, 128 Ko, vérifiés identiques octet pour octet, horodatages
       préservés (`robocopy /E /COPY:DAT` — l'horodatage est le discriminant
       qui a démasqué l'import Codex, il doit survivre à la copie).
       **Deux écarts délibérés à la consigne**, à connaître avant de rejouer
       le geste : (a) la sauvegarde est posée HORS de `~\.claude\` — une
       sauvegarde qui vit dans le dossier qu'elle protège disparaît avec lui,
       et rien ne garantit qu'un dossier voisin de `SKILLS\` ne soit jamais
       scanné ; (b) le dossier s'appelle `SKILLS` en majuscules sur le disque
       (le README l'écrit ainsi, ce TODO l'écrivait en minuscules). Windows
       ne fait pas la différence, un système sensible à la casse si.
       Le dossier de sauvegarde n'est dans aucun dépôt git — vérifié.
2. [x] **Mesure du rang `--add-dir` vs personnel homonyme** dans la chaîne
       F2 — marqueur délibéré + sonde posée après push (forme forte).
       C'est LA mesure qui débloque la généralisation de prompt-forge.
       **Faite le 2026-07-26 — verdict `PERSONNEL`** (Claude Code 2.1.220,
       Windows). Le personnel l'emporte sur `--add-dir` ET sur le
       `.claude/skills/` du projet courant. Protocole et points de mesure :
       `2026-07-23-proposition-maison-skills.md` § 6, « Résultat consigné ».
       La décision qui en découle n'est PAS tranchée : `ISSUES-LOG.md`,
       ISSUE-001. **Réplication Linux rendue le 2026-07-27 — CONCORDANTE**
       (banc Cowork indépendant, même CLI 2.1.220, 15 runs 15/15) : le rang
       est prouvé sur deux plateformes, ce n'est plus une observation locale.
       Fiche annexée en v1.1 :
       `fiche-mesure-rang-skills-20260727-linux.md`. Son run E établit que le
       masquage est **total** — le perdant est effacé de la liste, donc une
       copie périmée ne laisse aucune trace observable en session.
       Le chantier est clos ; ce qui reste ouvert est une décision de
       structure, pas une mesure.
3. [x] **Étape 3 du § 5** (consolidation — presque vide, copies identiques
       mesurées) — conditions : sauvegarde faite + GO explicite.
       **Close le 2026-07-27 — acquise, non exécutée.** La mesure a montré
       qu'il n'y avait rien à consolider : la maison porte déjà la version
       canonique des 10 génériques (suivis, 0 non commité), et les skills de
       projet vivent déjà dans le `.claude/skills/` de leur projet, commités
       (App-Handyman 1/1 · Suspension-intelligente 340/340).
       **Ce qui restait d'elle était son garde**, et il passe : le corollaire
       F2 de la ligne 119 du § 5 exige qu'aucun skill de projet ne porte le
       nom d'un générique personnel. **Aucun, dans aucun dépôt.** Les 10
       homonymes de `claude-skills` ne comptent pas : ce dépôt EST la maison,
       ses skills sont les 10 personnels — c'est ISSUE-001, pas un défaut
       nouveau. `prompt-forge` (10 283 o vs 9 993 o dans deux projets)
       confirme le requalifié du 2026-07-24 : deux skills distincts sous un
       nom commun, jamais vus par la même session.
       **Ce garde a changé de nature entre son écriture et son application** :
       il anticipait qu'un générique « gagnerait en silence » ; le run E du
       2026-07-27 établit pire — le perdant est **effacé de la liste**, sans
       doublon ni avertissement. À rejouer avant toute pose d'un nouveau
       générique dans `~/.claude/SKILLS/`, c'est une commande :
       comparer `ls ~/.claude/SKILLS/` aux `ls .claude/skills/` de chaque dépôt.

   **L'étape 4 du § 5 ne démarre pas derrière celle-ci — elle attend
   ISSUE-001.** Voir « ce que cette décision débloque » dans `ISSUES-LOG.md`.
4. [ ] **Traitement des observations** — **premier aller-retour réel fait le
       2026-07-27** (obs 18 du store `Suspension-intelligence` + obs 1 du store
       `cerveau-suspension` → `task-observer-perso` v1.3.0, commit `0dd5496`,
       déployé et vérifié par marqueur de contenu). Le circuit
       maison → commit → `deploy-skills.ps1` → preuve fonctionne de bout en
       bout ; ce n'est plus une hypothèse. Chaque correction suivante emprunte
       le même chemin.
       **File recomptée le 2026-07-27** — elle porte sur **quatre** stores, pas
       deux ; les deux manquants sont ceux des dépôts découverts après
       l'écriture de cette ligne (même lacune d'inventaire que le 4ᵉ dépôt) :

       | Store | OPEN |
       |---|---|
       | `App-Handyman` | 18 |
       | `claude-skills` | 11 (pas 10) |
       | `Suspension-intelligence` | 8 (9 moins l'obs 18 close) |
       | `cerveau-suspension` | 0 (l'unique obs est close) |
       | **Total** | **37** |

       Les compteurs ci-dessus sont datés du 2026-07-27 : les relire par
       `grep -c '^\*\*Status:\*\* OPEN' ~/.claude/skill-observations/*/log.md`,
       jamais les recopier.
       **Deux blocs distincts, à ne pas traiter ensemble.** Obs 1-6 sont des
       corrections de skills nommés (obs 6 → `skill-intake`). **Obs 7, 8, 9 et
       10 forment une seule discipline** — ce qu'une mesure discrimine, ce
       qu'un contrôle présuppose, ce qu'une phrase peut porter, ce qu'un
       rapport prouve — et sont toutes candidates cross-cutting : elles se
       lisent ensemble ou pas du tout.
       **Réserve à lire avant d'en graver quoi que ce soit** (complément à
       l'obs 9) : la contre-mesure qu'elles proposent n'a jamais fonctionné
       sans relecteur extérieur. L'écrire dans un skill sans cette réserve
       commettrait sur elle la faute qu'elle prétend corriger.
5. [ ] **Entrée de Suspension-intelligente** dans la migration — sur GO
       distinct, avec son propre inventaire ; dégèle recap/session-prep,
       ferme l'obs 8.
6. [ ] **Circuit Android** — V7-pre d'abord (plan payant + exécution de
       code au compte : la porte peut être fermée), puis V7, puis la
       routine d'empaquetage zip.

## Sujets garés — ne rouvrir que sur leur condition

| Sujet | Condition de réouverture |
|---|---|
| ~~Copie `~\.claude\skills\` (redondante pour `claude-ah`, utile à `claude` nu)~~ — **condition de réouverture CADUQUE le 2026-07-26** | **Réouvert de force par V3-bis.** La prémisse du garage était fausse : la copie n'est pas redondante pour `claude-ah`, elle est **prioritaire** — les 10 skills sont servis par elle, jamais par la maison. Un sujet garé sous une prémisse fausse dormirait éternellement. Ne plus attendre « la décision à froid » : le sujet est instruit avec son fait mesuré et ses deux options dans `ISSUES-LOG.md` ISSUE-001, en attente du décideur. |
| Lanceur `claude-ah` mono-projet | entrée du 2ᵉ projet (un `claude-si`, ou généralisation du lanceur) — **condition élargie le 2026-07-27** : ce sujet est devenu le **dernier bloquant d'ISSUE-001**, l'option 1 en dépendant directement. Il se rouvre donc aussi sur « décision prise sur ISSUE-001 », sans attendre un 2ᵉ projet. |
| Option C (plugins/marketplace) | multi-poste Claude Code, ou stabilité de la maison (1 mois sans changement de structure) |
| Divergences héritées de l'audit Cowork — **moitié levée le 2026-07-27** : `tdd-enforcer` est **tranché** (voir gestes courts) ; reste `skill-creator` repo < Anthropic | décision de Mathieu — hors périmètre du chantier maison. Ne subsiste que pour `skill-creator`. |

## Prochaine session — mandat enregistré (2026-07-24)

Bâtir la **mécanique de fonctionnement du projet Skills** face aux autres
projets : le gestionnaire des skills utilisés dans les projets, le lieu où
Mathieu pose ses questions et développe ses idées — une vraie structure
fonctionnelle. Arriver avec le registre en main : 3 passations, document
d'autorité v6, carte, mémo, ce TODO.

Rappel d'ouverture de session Cowork : rebrancher les dossiers
(`claude-skills`, et au besoin le vault) — les accès ne survivent pas
à la session.

**État du mandat au 2026-07-29** — ajouté sans toucher au texte d'origine.
Quatre sessions ont eu lieu depuis son enregistrement (26, 27, 27 au soir, 30) :
« prochaine session » ne désigne donc plus personne. Livré contre ce mandat, et
mesurable dans le dépôt : le `CLAUDE.md` du projet, le rituel de déploiement et
son script (`1700fc2`), le routage en quatre questions, ce registre d'issues, et
la clarification du gel (2026-07-29). Restent ouverts : la généralisation du
lanceur `claude-ah`, et l'étape 4 — dont la nature dépendait d'ISSUE-001,
désormais tranchée (option 2), donc débloquée.

**Rappel d'ouverture de session Cowork — corrigé le 2026-07-29 par l'expérience.**
Le rappel d'origine nomme `claude-skills` et le vault. Il manquait **la copie qui
exécute** : `~\.claude\SKILLS` est un emplacement protégé, jamais connectable, et
sans elle une session Cowork ne mesure aucun circuit — elle ne voit que le dépôt
et la copie du compte, et conclut faux sur le reste (voir le journal du
2026-07-29, rétractation). Contournement éprouvé aujourd'hui : brancher un point
d'accès à cette copie (Mathieu a branché `Desktop\SKILLS`). À rebrancher, dans
cet ordre : `claude-skills`, la copie qui exécute, puis au besoin le dépôt du
projet concerné et le vault. Deux allers-retours ont été perdus faute de ce
rappel.

---

## Journal de sessions (le plus récent en haut)

### 2026-07-29 (soir) → 2026-07-30 (matin) — Session double Cowork + Code : récap fusionné

Deux sessions ont travaillé la même nuit sur les mêmes fichiers, sans se voir.
Cette entrée fusionne leurs deux récaps en un seul récit. Elle remplace le récap
partiel écrit par la session Code à 09 h 43 (`9b0b925`) et le récap Cowork
`recap-session-cowork-20260729-30.md`.

**Comment lire.** Chaque fait porte son circuit : **[CW]** session Cowork (projet
SKILLS_POLICE, via le pont), **[CC]** session Claude Code (Windows, natif),
**[M]** geste de Mathieu. Tous les horaires sont en heure locale
(America/Toronto, UTC-4) et mesurés par `git log --date=format` ou `Get-Date` —
la précision n'est pas cosmétique, une partie de la nuit a été datée du 30 par
erreur (§ 4.5).

---

#### 1. D'où ça part

Une session Claude Code travaillant sur **App-Handyman** demande à Mathieu si le
« gel » écrit dans le `CLAUDE.md` de `claude-skills` interdit de modifier
`task-observer-perso`. Elle propose deux lectures et demande un arbitrage.

Mathieu transmet la question à une session Cowork. En parallèle, une session Code
travaille sur la maison des skills. Aucune des deux ne sait ce que l'autre écrit.

Sept heures plus tard, la nuit aura produit une modification de la constitution,
un principe transverse, trois observations, un dépôt git, deux montées de version
— et cinq instruments pris en flagrant délit de répondre sans savoir.

---

#### 2. Chronologie entrelacée

C'est ce qu'aucun des deux récaps ne pouvait montrer seul.

| Heure | Circuit | Fait |
|---|---|---|
| 21 h 30 | CW | Lit `Desktop\SKILLS` : `task-observer-perso` en 1.3.0. Commence à dater son travail du **30** |
| 21 h 45-50 | CW | Écrit `ISSUES-LOG.md` et `TODO.md` |
| 22 h 06 | — | `Desktop\skill-observations` : la copie se fige **ici** |
| 22 h 12 | — | `Desktop\SKILLS` : la copie se fige **ici**, en 1.4.0 |
| 22 h 13 | CC | Commit `b9ab677` — `task-observer-perso` 1.4.0 |
| 22 h 31-33 | CC | Réécrit `ISSUES-LOG.md` et `TODO.md` **depuis sa propre lecture** — collision silencieuse, rien perdu par chance (§ 4.7) |
| 22 h 49 | CW | Mesure les trois horloges → ISSUE-007 |
| 22 h 58 | CC | Commit `af34446` — le commit groupé (ISSUE-004 à 007, `.gitignore`, règle de datation) |
| 23 h 08 | CC | Nouvelle session. Demande de trois mots : « modifier le message d'un commit groupé ». Abandonnée : « trop de trouble » |
| 23 h 15-45 | CC | R202 mesurée puis réécrite (v2.4) ; `af34446` amendé en `b3642d9`, contenu identique |
| 23 h 49 | CW | Rapporte « la revue n'a rien écrit — 426 lignes, aucun principe 11 » — **lu sur la copie figée à 22 h 06** |
| 23 h 50 | CC | Sauvegardes datées, puis revue complète des observations |
| 23 h 53 | CC | Déploiement `skill-intake` 1.1.0 + `task-observer-perso` 1.5.0, vérifié hors du rapport du script |
| 00 h 07 | CC | Sauvegarde du magasin (11 fichiers) |
| 00 h 08 | CC | Observations 15, 16, 17 consignées — **texte verbatim produit par CW**, transmis par prompt |
| 00 h 18 | CC | Commit `2109c94` |
| 00 h 20 | CC | Pose une jonction sur le Bureau — défaite plus tard dans la nuit |
| 08 h 14 | CW | Magasin déménagé dans `Documents\Claude\` ; jonction depuis `.claude` |
| 08 h 49 | CC | Magasin sous git — `02a8291` |
| 09 h 28 | CC | Principe 11 (c) amendé — `ca104be` |
| 09 h 43 | CC | Premier récap (partiel) — `9b0b925` |

---

#### 3. Ce qui a été produit

| Livrable | Foyer | Par |
|---|---|---|
| ISSUE-004 à 007 | `claude-skills/ISSUES-LOG.md` | CW |
| Règle du gel réécrite (critère + condition de levée restaurés) | `claude-skills/CLAUDE.md` | CW |
| Règle de datation ajoutée | `claude-skills/CLAUDE.md` | CW |
| `.gitignore` (une entrée, volontairement étroite) | `claude-skills/` | CW |
| R202 v2.4 — la branche partagée se mesure | `~/.claude/CLAUDE.md` | CC |
| R304 v2.5 — condition de clôture d'un travail long | `~/.claude/CLAUDE.md` | CC |
| Principe transverse 11 + index exécutable + 5 amendements | magasin | CC |
| Principe 11 (c) enrichi des cinq instruments | magasin | CW (mesure) + CC (écriture) |
| 14 observations closes, chacune avec son type de garde | magasin, store `claude-skills` | CC |
| Observations 15, 16, 17 | magasin, store `claude-skills` | CW (texte) + CC (consignation) |
| `skill-intake` 1.1.0 · `task-observer-perso` 1.5.0, déployés | dépôt + `~/.claude/SKILLS` | CC |
| Magasin sorti de la zone protégée, sous git, sans distant | `Documents\Claude\skill-observations` | CW (déplacement) + CC (git) |
| Zips pour le compte | `Documents\Claude\zips-compte-20260730\` | CC |
| 4 commits `claude-skills` + 2 commits magasin | git | CC |

---

#### 4. Les problématiques, une par une

**4.1 [CW] Le gel disait plus que ce qui avait été décidé.** La règle d'origine
(proposition du 2026-07-23, § 5) a trois parties : un **critère** (dépendant hors
du projet pilote), des **interdits**, une **condition de levée**. L'archive du
07-24 n'a gardé que le comptage et les interdits ; le `CLAUDE.md` du 07-27 a
recopié l'archive sous « Règles en vigueur » — un instantané devenu permanent.
Effet : le gel bloquait une étape que son propre plan autorisait, et n'opposait
plus rien qu'à la partie qui lui obéissait. → Ligne réécrite, **observation 17**.

**4.2 [CW] Un audit par octets fabrique de fausses divergences → ISSUE-004.**
`md5sum` a déclaré `grill-me` et `json-canvas` divergents **à version identique**
— l'alarme la plus grave du dépôt. Cause : CRLF contre LF. Le bon instrument
existait déjà dans `deploy-skills.ps1`, qui normalise avant de hacher, avec le
piège nommé en commentaire ligne 51. → **observation 16**.

**4.3 [CW+CC] La liste d'autorisations rejoue des « oui » → ISSUE-005.**
`settings.local.json` (11 869 o) n'était protégé par aucun `.gitignore`. Mesuré :
94 entrées, dont **6 à risque** — `git push *`, `git commit *`, `git add *`,
`cp *`, `Remove-Item *`, `py -3.13 -c ' *`. Constat de fond : la règle « `git add`
nommé, jamais `-A` » est **annulée** par l'autorisation `git add *`. → `.gitignore`
créé ; **aucune entrée retirée**, décision non prise.

**4.4 [CW] Le pont laisse un verrou git orphelin → ISSUE-006.** Le pont crée le
verrou mais ne sait pas le supprimer. `git --no-optional-locks` n'en pose aucun —
vérifié. Aucun réglage git ne couvre le cas et le shell du pont ne source aucun
profil : garde **par vigilance**, pas par construction.

**4.5 [CW] Les dates écrites depuis Cowork sont celles d'UTC → ISSUE-007.**

| Horloge | Réponse | Écart |
|---|---|---|
| Conteneur Cowork | 2026-07-30 02:49 UTC | +4 h |
| VM du pont | `Etc/UTC` | +4 h |
| Windows / git | 2026-07-29 22:49 `-04:00` | référence |

Dès 20 h locale, UTC est le lendemain — et les douze derniers commits du dépôt
tombent à 19 h, 20 h (×2), 21 h (×4), 22 h. **Symptôme inverse** : une session
Code date juste mais **gèle sa date à l'ouverture**, donc après minuit elle date
de la veille. Deux causes opposées, un seul symptôme ressenti. → 18 dates
rétro-corrigées, règle ajoutée, **observation 15**.

**4.6 [CC] R202 classait le risque sur le nom d'une branche.** « Any action on a
protected branch (`main`, `master`, `release/*`) » = arrêt dur. Mesuré sur ce
dépôt : 0 fork, 1 collaborateur, 1 adresse de commit sur 200, 0 PR ouverte. Le
niveau ne protégeait personne, et la tâche a été abandonnée. Le tell précédait
l'abandon : `git commit` sur `main` était formellement en arrêt dur et tournait
depuis des mois au niveau inférieur **sans que personne le relève**. Une règle
qu'on n'applique pas et dont personne ne se plaint est mal ciblée. →
**R202 v2.4**, **observation 14**.

**4.7 [CW+CC] Deux sessions ont écrit les mêmes fichiers sans se voir.** CW écrit
`ISSUES-LOG.md` et `TODO.md` à 21 h 45-50 ; CC les réécrit à 22 h 31-33 depuis sa
propre lecture. **Rien n'a été perdu — par chance**, les insertions visaient des
ancres différentes. Aucun garde n'existe. L'adaptation #3 de `task-observer-perso`
justifie le retrait de la gestion des sessions parallèles par « Mathieu travaille
en session unique » : prémisse fausse pour la **troisième fois mesurée**. Mathieu
a décidé de ne pas rouvrir ce retrait.

**4.8 [CW] `C:\Users\mat_g\.claude` est inaccessible depuis Cowork.** Windows le
protège. Les contournements **par copie** sur le Bureau ont produit trois des cinq
fausses lectures. → Le magasin est sorti de la zone protégée : vrai dossier dans
`Documents\Claude\skill-observations`, jonction depuis `.claude`. Le chemin
attendu par le skill fonctionne toujours.

**4.9 [CC] Le fichier de principes se déclarait checklist sur 426 lignes.** Une
checklist de 426 lignes est un document qu'on déclare lire. → **Index exécutable**
de onze questions, avec **clause d'exclusivité** : seule lecture demandée, un corps
ne s'ouvre que sur un « non » ou un « je ne sais pas ».

**4.10 [CC] Sept observations formaient une famille sans principe.** Les obs 1, 2,
3, 7, 8, 9 se déclaraient elles-mêmes comme une discipline unique. P1 couvrait la
calibration, P7 l'exécution ; la **conception** d'une mesure n'était écrite nulle
part. → **Principe 11**, P1 et P7 rétrécis en pointant vers lui.

**4.11 [CC] Le gel de l'obs 5 était périmé depuis cinq jours.** Il interdisait
d'écrire un principe dans le fichier ; le fichier l'avait reçu par une autre
route. Le gel ne retenait plus que l'observation qui lui obéissait — **garde par
vigilance**, et personne ne l'a vu passer. Même forme que 4.1.

**4.12 [CC] Le magasin n'avait aucun historique.** Une écriture ratée y était
définitive ; le seul filet était une sauvegarde datée posée à la main. → Sous git,
`.gitattributes` et `.gitignore` **avant** le premier commit. Fins de ligne
mesurées en octets : `App-Handyman/log.md` en CRLF pur, huit fichiers en LF, et
`Suspension-intelligence/log.md` **mixte avec lui-même** (192 CRLF + 20 LF).

**4.13 [CW+CC] Les briefs échangés portaient des prémisses fausses.** Trois sur
six au dernier passage : « obs 11 reste OPEN » (elle était ACTIONED sur arbitrage
plus récent de Mathieu), « `Desktop\SKILLS` est une jonction » (copie), « les deux
dossiers du Bureau sont supprimés » (présents, vides). Un brief énonce ses
hypothèses d'état à l'indicatif, ce qui les rend invisibles — principe 8 (b).

---

#### 5. Les cinq instruments — le fil conducteur de la nuit

| Instrument | Ce qu'il a rendu | Ce qu'il ne savait pas |
|---|---|---|
| `gh api .../branches/<b>/protection` | `403 Upgrade to GitHub Pro` | si une protection existe |
| `Desktop\skill-observations` monté | « 426 lignes, aucun principe 11 » | si la revue avait écrit |
| `Desktop\SKILLS` monté | `1.4.0` | ce qui était réellement déployé |
| `awk` sur le champ `description:` | 1114 caractères | où finit le champ |
| `grep -c $'\r'` | le nombre de lignes, pour tout fichier | si le fichier était en CRLF |

**Aucun des cinq n'a échoué.** Pas une erreur, pas un code non nul, pas une sortie
vide : les cinq ont *répondu*, et c'est la réponse qui a été prise pour la mesure.
Un instrument qui plante se voit ; celui qui répond sans savoir, non.

**Trois des cinq avaient été écrits par l'agent dans la minute** — `awk`, `grep`,
et le choix du chemin monté. Le défaut naît surtout de l'instrument improvisé pour
la question du moment, celui qu'on ne teste pas **parce qu'on vient de l'écrire**.
Le dernier a servi à déclarer fausse une mesure correcte venue de l'autre circuit.

**Contrôle d'une ligne, celui qui manquait :**
`(Get-Item "<chemin>").LinkType` → `Junction` = direct, vide = copie.

Gravé dans le corps du principe 11 (c), `ca104be`.

---

#### 6. Décisions de Mathieu

| Décision | Portée |
|---|---|
| Le gel n'interdit pas l'amélioration par la maison | ligne de `CLAUDE.md` réécrite |
| La date se mesure, jamais ne se suppose | règle ajoutée aux « Règles en vigueur » |
| Ne pas renuméroter les principes | une vingtaine de pointeurs, dont quatre dans un message de commit |
| L'index est la **seule** lecture demandée | clause d'exclusivité écrite |
| Diffs montrés avant toute écriture, y compris les petits ajouts | méthode de travail |
| Pas de `Co-Authored-By` sur un amend qui ne change que le message | le trailer suit qui a écrit le contenu |
| Obs 5 : gel levé, corollaire conservé | magasin |
| Obs 9 : entre comme **question**, pas comme principe | sa contre-mesure reste une hypothèse |
| Obs 11 : routée vers la constitution (R304), pas vers un principe | elle porte le pilotage d'un chantier |
| Pas de quatrième observation sur la concurrence entre sessions | l'adaptation #3 reste telle quelle |
| **Les skills sont locaux au projet par défaut** | politique générale — fin du travail de généralisation |
| `prompt-forge` n'est pas généralisé | brouillon supprimé |
| Le magasin passe sous git, sans distant | magasin |
| Pas d'élagage de la liste d'autorisations | reporté |
| Objectif « voir les skills déployés depuis Cowork » abandonné | aucune jonction sur le Bureau |

---

#### 7. Frictions qui risquent de revenir

Classées par probabilité de récidive.

**7.1 Le compte claude.ai se désaligne à chaque montée de version.** Aucun pont.
Aujourd'hui maison et disque en 1.5.0 / 1.1.0, compte en 1.2.0 / 1.0.0.
*Signe avant-coureur* : une session Cowork qui se comporte selon une version
ancienne, sans aucun signal. *Parade* : après tout bump, rouvrir une session
Cowork et lire le `version:` **réellement chargé**, pas celui du dépôt.

**7.2 La date fausse va revenir dans les autres projets.** La règle de datation
est écrite dans `claude-skills/CLAUDE.md` — une session Cowork sur App-Handyman ou
Suspension-intelligente **ne la lira pas**. *Parade* : la porter dans la
constitution ou dans les fichiers d'autorité des autres projets.

**7.3 Tout nouveau dossier branché peut être une copie.** Trois des cinq
instruments défaillants venaient de là. *Parade* : `LinkType` avant de croire un
dossier monté.

**7.4 Deux sessions sur les mêmes fichiers.** Aucun garde ; chaque session réécrit
le fichier entier depuis sa propre lecture. La nuit a failli coûter du travail.
*Parade actuelle* : aucune, sinon ne pas lancer deux sessions sur le même dépôt.

**7.5 Une décision prise dans un circuit n'atteint pas l'autre.** L'approbation du
diff au principe 11 (c) a été donnée le soir dans Cowork ; la session Code l'a
tenu en attente **une nuit entière**. Même forme que 4.1 et 4.11 : une décision ne
franchit pas la frontière et rien ne signale qu'elle attend. Le canal existe
désormais — Cowork écrit dans le magasin — mais aucune règle ne dit de s'en servir.

**7.6 L'instrument improvisé.** Voir § 5. Se reproduira tant que « que rend-il
dans le cas négatif, et dans le cas indisponible ? » n'est pas un réflexe.

**7.7 Les prémisses d'un brief importé.** Trois sur six étaient fausses au dernier
passage. Chaque import doit re-mesurer **avant la première étape**.

**7.8 Une règle recopiée perd sa condition de levée.** Le défaut de 4.1 se
reproduira partout où une règle décidée ailleurs est redite. Motif documenté
(observation 17), **aucun garde ne l'empêche**.

**7.9 `prompt-forge` : deux skills distincts sous un même nom.** 10 283 o dans
App-Handyman, 9 993 o dans Suspension-intelligente, jamais vus par la même
session. Le rang mesuré dit que le personnel **efface** l'homonyme sans
avertissement. *Danger précis* : poser un jour un `prompt-forge` générique dans
`~\.claude\SKILLS` ferait taire les deux versions projet, en silence.

**7.10 Le pont ne peut jamais supprimer.** Chaque nettoyage exige la main de
Mathieu ou une tâche pour une session Code. Une session Cowork qui « nettoie »
laisse toujours quelque chose derrière elle — c'est exactement pourquoi les deux
dossiers du Bureau sont encore là, vides (§ 8).

**7.11 Le magasin n'a pas de copie hors du poste.** Sous git, mais sans distant.
Si le disque meurt, les observations et les principes meurent avec lui.

**7.12 Le corps des principes grossit malgré l'index** (426 → 646 lignes en une
nuit). L'index protège la lecture, pas la taille. R602 et R304 s'appliquent au
dispositif lui-même.

**7.13 La contre-mesure (d) du principe 11 n'a jamais fonctionné seule.** Trois
écarts de portée, trois fois trouvés par un relecteur humain. Le prochain
protocole exécuté sans relecteur sera son premier test.

**7.14 Le format des réponses.** Mathieu a demandé trois fois des réponses plus
courtes et moins littéraires avant d'être entendu, et une fois de la transparence
sur l'origine de ce qui était produit. Friction réelle de la session, pas un
détail de style.

**7.15 La méthode diverge sur un chantier.** Le risque de l'observation 11, vécu
cette nuit : chaque mesure ouvre une question, et le chantier documente son propre
sur-place. *Parade écrite* : R304 — condition de clôture avant la première mesure.

---

#### 8. Ce qui n'a pas été mesuré, ou reste contradictoire

À ne pas présenter comme acquis dans une session future.

- **Les deux dossiers du Bureau existent encore**, vides (mesuré au moment
  d'écrire ceci). Le récap Cowork et Mathieu les donnaient supprimés. Leur contenu
  est parti, pas les dossiers ; le risque est nul — un dossier vide ne répond rien
  — mais l'écart entre le dit et le mesuré est lui-même la leçon de la nuit.
- **Le pont Cowork traverse-t-il une jonction Windows ?** Question posée, jamais
  tranchée — il n'y avait plus rien à tester quand elle s'est posée.
- **La copie du compte claude.ai** n'est jamais lisible directement ; tout ce qui
  la concerne passe par ce qu'une session déclare avoir chargé.
- **Suspension-intelligente et cerveau-suspension** n'ont pas été branchés ; ce qui
  les concerne vient de documents, pas de mesures.
- **Le comptage « 16 gelés / 5 libres »** ne se reconstitue plus exactement (la
  somme la plus plausible donne 17). Écart non résolu.
- **Le total d'observations dépend de la question posée** : 54 dans les logs
  actifs, **65 archives comprises** (App-Handyman 25, `claude-skills` 17,
  Suspension-intelligente 22 dont 11 archivées, cerveau-suspension 1). Les deux
  chiffres sont justes ; ils ne répondent pas à la même question.

---

#### 9. Reste à faire

**À la main de Mathieu**

- Téléverser les 2 zips (`Documents\Claude\zips-compte-20260730\`) au compte, et
  retirer les anciennes versions + `tdd-enforcer` périmé.
- Retirer 3 montages morts de la liste de dossiers Cowork : `SKILLS`,
  `Desktop--skill-observations`, `skill-observations`.
- Les deux dossiers vides du Bureau, si le rangement importe.

**Fait le 2026-07-30 (matin), après la première rédaction de cette entrée**

- **`~/.claude` est sous git** — `3404202`, 8 fichiers suivis, 70 Ko, aucun
  distant. La forme est une **liste blanche** (`*` ignore tout, huit lignes `!`
  font remonter la gouvernance), et c'est la mesure qui l'impose : le dossier
  contient 4 323 fichiers et ~195 Mo, dont 127 Mo de transcriptions de
  conversations, un jeton d'authentification et deux clés de daemon. Une liste
  noire aurait fait entrer chaque fichier nouveau, et le premier oubli aurait été
  un secret — R203. Vérifié **nominativement** avant commit puis sur
  l'historique : `.credentials.json`, `daemon/*.key` et `history.jsonl` sont
  absents des deux.
- `SKILLS/` en est **exclu**, et c'est un choix de gouvernance, pas de sécurité :
  c'est une cible de déploiement, pas une source, et l'inclure ferait une seconde
  maison pour dix skills contre ADR-028. Idem pour la jonction
  `skill-observations`, déjà son propre dépôt. Les deux motifs sont écrits **dans
  le `.gitignore`**, pour qu'une session future qui s'interroge trouve la réponse
  sur place au lieu de l'inventer.
- Les deux `CLAUDE.md.bak` y entrent **une fois**, comme trace : ils portent les
  états v2.3 et v2.4 que le dépôt ne peut pas reconstruire, naissant après eux.
  Décision inverse de celle prise pour le magasin, où les `.bak` dupliquaient un
  contenu que le premier commit capturait déjà — l'asymétrie est voulue.
- **Trois dépôts désormais** : `claude-skills` (distant GitHub privé), le magasin
  d'observations et `~/.claude` (aucun distant).

**Décisions ouvertes**

- Élaguer ou non les 6 entrées à risque de la liste d'autorisations (ISSUE-005).
- Committer ou non les deux `.bak-2026-07-29` **du magasin** comme trace — la
  question reste ouverte là, elle est tranchée pour `~/.claude` (voir ci-dessus).
- Ajouter ou non un distant **aux deux dépôts locaux**. Git les protège d'une
  écriture ratée, pas d'une panne de disque : aujourd'hui les 65 observations,
  les 11 principes et la constitution n'existent qu'ici.

**Dossiers ouverts, sans urgence**

- Généralisation du lanceur `claude-ah` (un lanceur par projet aujourd'hui).
- Étape 4 du plan de migration, dont la nature a changé avec la politique
  « skills locaux par défaut ».
- Les 14 clôtures du store `claude-skills` attendent leur archivage : elles
  restent dans le log actif parce qu'elles datent de la session courante ; c'est
  la **première écriture d'une prochaine session** qui les déplacera.

---

### 2026-07-29 (nuit) — Session Code : une garde cesse de juger sur le nom, et la checklist devient exécutable

**Point de départ, une demande de trois mots.** « Modifier le message d'un commit
groupé » — `af34446`, déjà poussé sur `main`. R202 plaçait toute action sur une
branche *nommée* `main` en arrêt dur : approbation écrite. Mathieu a abandonné —
« trop de trouble pour changer le message de commit ».

**Ce que la mesure a montré.** Le niveau ne protégeait personne :

| Mesure | Valeur |
|---|---|
| `forkCount` | 0 |
| collaborateurs | 1 |
| adresses de commit (200 derniers) | 1 |
| PR ouvertes sur `main` | 0 |

**Premier instrument écarté.** `gh api .../branches/main/protection` répond
`403 « Upgrade to GitHub Pro »` sur un dépôt privé hors plan payant —
indiscernable d'un refus de lecture d'une protection réelle. Versé dans une garde,
ce 403 produit soit un faux feu vert, soit un arrêt dur permanent. Instrument
changé, pas interprété.

**R202 v2.4.** « Branche protégée (`main`, `master`, `release/*`) » → « branche
**partagée**, mesurée ». Le nom n'élève plus le niveau ; une action non
réécrivante sur `main` reste à « confirmation required » ; l'inconnue vaut
partagé ; plancher inchangé — une réécriture ne se fait jamais en silence.
Sauvegardes : `~/.claude/CLAUDE.md.bak-2026-07-29` (état v2.3) et
`.bak-2026-07-29-v2.4` ; le dossier n'est pas sous git.

**Le circuit exercé le soir même.** Mesure → descente d'un niveau → énoncé
action / conséquence / SHA de retour → go → `af34446` devient `b3642d9`, contenu
strictement identique (`git diff af34446 b3642d9` vide), date d'auteur préservée.
Coût réel : trois commandes. C'était le but de la modification.

**Revue des observations, dans la foulée.** Le constat qui a commandé le reste :
`cross-cutting-principles.md` se déclarait « mandatory checklist » sur 426 lignes.
Une checklist de 426 lignes est un document qu'on déclare lire. Arbitrage de
Mathieu : consolider, pas ajouter.

| Geste | Contenu |
|---|---|
| Principe 11 | absorbe les obs 1, 2, 3, 7, 8, 9 — la **conception** d'une mesure, en amont de la calibration (P1) et de l'exécution (P7), qui rétrécissent en pointant vers lui |
| Index exécutable | onze questions en tête de fichier, **seule lecture demandée** ; un corps ne s'ouvre que sur un « non » ou un « je ne sais pas » |
| Amendements | P1, P3, P7, P8, P9 ← obs 2, 4, 5, 10, 12, 13, 14 |
| Skills | `skill-intake` 1.1.0 (un outil d'agent écrit au premier lancement, sans invocation) ; `task-observer-perso` 1.5.0 (la clôture nomme son garde) |

À noter sur le résultat, parce que le mot « consolider » pourrait tromper : le
**corps** du fichier a grossi, c'est l'**objet à lire** qui a rétréci — d'un
document entier à un index de onze lignes, avec la clause d'exclusivité qui
l'impose. Sans cette clause, l'index aurait été un onzième document.

**Trois réserves posées par Mathieu, toutes structurantes.** (1) Ne pas
renuméroter — mesuré : une vingtaine de pointeurs vers des numéros de principes
existent, dont quatre dans le message de `b9ab677`, non réécrivable. Le nouveau
principe prend donc le n° 11. (2) L'index n'est une checklist que s'il est la
seule lecture demandée. (3) Diffs montrés avant toute écriture, y compris les
petits ajouts.

**Le gel de l'obs 5 levé, et pourquoi ça mérite une ligne.** Il interdisait
d'écrire un principe dans `cross-cutting-principles.md`. Le fichier l'a reçu cinq
jours plus tard par une autre route. Le gel ne retenait donc plus que
l'observation qui lui obéissait, pas le fichier qu'il prétendait protéger :
**garde par vigilance**, et personne ne l'a vu passer. C'est l'obs 13 appliquée à
un artefact de l'obs 5.

**R304 ajouté à la constitution** (obs 11 — la seule que la revue n'a pas versée
dans un principe transverse : elle porte sur le pilotage d'un chantier, pas sur un
skill, et l'écrire comme 12ᵉ principe l'aurait rendue invisible dans une checklist
de conception de skill). Un travail long porte sa condition de clôture avant sa
première mesure ; par palier, « qu'est-ce qui fait aujourd'hui quelque chose qu'il
ne faisait pas hier ? » ; deux « nous savons quelque chose de plus » de suite = ça
tourne à vide. La limite est au pilote de la poser.

**Déployé dans la même session.** `deploy-skills.ps1 -Apply -Backup` : 2 fichiers
écrits, 13 déjà identiques, **sortie 0** — le correctif d'ISSUE-003 tient, deux
montées de version passent sans que le code de robocopy pollue le signal.
Sauvegarde : `Claude\sauvegardes\skills-sauvegarde-20260729`. Cible re-mesurée
hors du rapport du script (principe 7) : `skill-intake` 1.1.0,
`task-observer-perso` 1.5.0, `diff -r` source ↔ cible vide.

### 2026-07-29 (soir) — Session Cowork (projet SKILLS_POLICE) : le gel retrouve son critère

**Question reçue d'une session App-Handyman.** Le gel de `CLAUDE.md`
(« 16 skills gelés / 5 libres ») interdit-il de modifier `task-observer-perso` ?
Deux lectures étaient proposées : le texte est un durcissement et la pratique
fait foi, ou le gel tient et `0dd5496` l'a enfreint. **Aucune des deux.**

**Mesuré, source par source** (le dépôt et `Desktop\SKILLS` branchés à la
session Cowork au fil de la revue) :

| Date | Document | Ce qu'il porte |
|---|---|---|
| 2026-07-23 | proposition § 5 « rayon d'impact » | la règle entière : critère (**dépendant hors du pilote**), interdits (déplacer / renommer / modifier), **condition de lever** (jusqu'à ce que ce projet entre dans la migration) |
| 2026-07-24 | `archives/skills-maisons-et-acces-20260724.md` l. 78 | le comptage + les interdits — critère et condition de lever **perdus** |
| 2026-07-27 | `CLAUDE.md` § « Règles en vigueur » (`1700fc2`, création du fichier) | recopie de l'archive sous « Règles en vigueur » : un instantané devenu permanent |

**Conclusion.** Le gel est réel — c'est une exigence de Mathieu datée du
2026-07-23, pas un effet de rédaction — mais c'est un **garde-fou de chantier**,
pas une interdiction d'améliorer. L'étape 5 du plan de migration prévoit
explicitement « observation 11 → task-observer […] Chacune se fait DANS la
maison, puis descend par sync ». `0dd5496` (auteur et committer Mathieu, 27
juillet 21 h 33 ; dans la maison ; sans renommage — le message le dit ; avec
montée de version et dry-run mesuré) est donc **une application de la règle, pas
une entorse**. Le durcissement ne portait pas sur l'existence de la règle mais
sur la perte de sa condition de lever. Ligne 77 de `CLAUDE.md` réécrite en
conséquence : critère et condition restaurés, le comptage rétrogradé au rang
d'instantané. Même remède qu'ADR-002 dans App-Handyman — on réécrit la ligne et
on consigne l'arbitrage, on ne dispense pas en silence.

Détail arithmétique retenu au passage : le compte « 16 / 5 » ne se reconstitue
plus. Cinq libres et cinq gelés dans la maison, huit dans `suspension-intelligente`,
quatre au vault — la somme la plus plausible donne 17, pas 21. L'écart d'un n'est
pas résolvable sans brancher les deux autres dépôts. Un compte qu'on ne peut pas
reconstituer n'a pas sa place dans « Règles en vigueur » ; c'est le motif de sa
rétrogradation.

**Trois mesures de circuit faites au passage :**

- **Le déploiement disque a bien eu lieu.** `Desktop\SKILLS` porte
  `task-observer-perso` **1.3.0**, octet pour octet identique à la maison, écrit
  le 2026-07-28 à 01:32 — quatre heures après le commit. Une première lecture de
  cette session concluait au manquement à la décision ISSUE-001 sur la seule base
  de la copie du compte : **rétracté**. La conclusion portait sur un circuit non
  mesuré, faute d'accès ; c'est l'erreur que le protocole du § 6 nomme déjà
  (conclure avant d'avoir écarté une hypothèse).
- **Le compte, lui, sert encore 1.2.0** — mesuré dans la session Cowork
  elle-même, sur le skill réellement chargé. Ce n'est pas un manquement au
  rituel : c'est le circuit sans pont (F9). Geste court ajouté.
- **`grill-me` et `json-canvas` : fausse alerte de divergence.** md5 différents
  entre disque et maison à version égale — donc l'alarme la plus grave du dépôt.
  Cause réelle : CRLF contre LF, contenu identique au caractère près. Le remède
  était déjà dans `deploy-skills.ps1` (normalisation avant hachage, ligne 51).
  → **ISSUE-004**.

**Divergence à corriger hors de ce dépôt :** les instructions du projet Cowork
SKILLS_POLICE listent encore ISSUE-001 comme ouverte avec « deux options
instruites », alors qu'elle est **résolue depuis le 2026-07-27, option 2**
(`ISSUES-LOG.md`, ISSUE-001 § 0). Elles datent d'avant `1700fc2`. Geste de la main de
Mathieu — les instructions d'un projet Cowork ne sont pas un fichier du dépôt.

**Second passage, même session — « touche ce que tu as vu ».** Les deux éléments
signalés sans y toucher ont été traités, et la mesure en a fait sortir deux
autres :

- **`.claude/settings.local.json` non suivi, et aucun `.gitignore` dans le
  dépôt.** Un `git add -A` aurait poussé 11 869 octets de réglages personnels sur
  GitHub. `.gitignore` créé, une seule entrée, volontairement étroite. Mais le
  contenu du fichier est le vrai sujet : il autorise `git push`, `git commit`,
  `cp *`, `PowerShell(Remove-Item *)` et `Read(//c/Users/mat_g/**)` sans
  redemander, à toute session future — soit la permission d'écraser les copies
  déployées que la gouvernance interdit d'éditer. → **ISSUE-005**, tri laissé à
  Mathieu.
- **Le mandat du 2026-07-24 re-daté**, sans réécriture : livré / ouvert séparés,
  et le rappel d'ouverture Cowork corrigé — il oubliait la copie qui exécute,
  et c'est précisément ce qui a produit la rétractation d'aujourd'hui.
- **Un verrou git orphelin, produit par cette session.** Le `git status` de la
  revue a laissé `.git/index.lock` derrière lui : le pont Cowork crée mais ne
  supprime pas. Le prochain `git add` du poste aurait échoué en accusant un
  processus concurrent inexistant. Verrou déplacé, et règle d'usage mesurée :
  `git --no-optional-locks` ne pose aucun verrou. → **ISSUE-006**.
- **Restauration V3-bis vérifiée par effet de bord.** `json-canvas`, marqué des
  deux côtés le 2026-07-27, est identique au caractère près entre maison et
  disque. Le « marqueur retiré, copie restaurée » du protocole n'avait jamais été
  vérifié ; il l'est. → dans ISSUE-004.

**Réserve à porter à la prochaine session.** La nature exacte de
`Desktop\SKILLS` — copie de `~\.claude\SKILLS` ou jonction vers elle — n'a pas
été mesurée. Ce qui est mesuré : ce dossier n'est **pas** une copie de la copie de
travail du dépôt (les fins de ligne de deux fichiers diffèrent), il porte les dix
skills, et `task-observer-perso` y est en 1.3.0 daté du 2026-07-28 à 01:32. Les
conclusions de la journée tiennent dans les deux cas de figure, mais la question
se tranche depuis Windows, pas depuis Cowork.

**Correction du même soir — la session Cowork avait tort sur les dates, et sur
qui se trompait.** Cette entrée et les trois ISSUE créées ce soir portaient la
date du **2026-07-30** ; il était le **29 à 21 h 30** chez Mathieu. Le conteneur
de la session Cowork et la VM du pont sont tous deux en UTC ; seul Windows porte
l'heure réelle. La session Claude Code qui travaillait en parallèle datait donc
**juste**, et cette session l'a accusée à tort d'une erreur de date. Cause
mesurée, portée et règle : **ISSUE-007**, dont la règle de mesure a été promue
aux « Règles en vigueur » de `CLAUDE.md` sur GO de Mathieu le même soir —
arbitrage explicite, pas effet de rédaction. Corrigé ici : le titre de l'entrée et
quatre dates dans ce fichier.

**Et la session concurrente avait de l'avance.** À 22 h 13 locale elle a committé
`b9ab677` — `task-observer-perso` **1.4.0**, revue des observations faite, étape 5
du rituel, principes transverses portés de six à dix. Les deux gestes courts que
la session Cowork venait d'ouvrir étaient donc périmés au moment de leur écriture
(21 h 50) : la revue était en cours ailleurs, et la cible du zip n'était plus
1.3.0. Réécrits en conséquence. Effet mesuré au passage, à 22 h 50 : la maison
porte **1.4.0**, le disque **1.3.0**, le compte **1.2.0** — les trois circuits
sont désalignés, et le déploiement rendu obligatoire par ISSUE-001 n'a pas encore
tourné pour 1.4.0.

### 2026-07-27 (soir) — Session Code : le circuit fait son premier aller-retour, et un code de sortie ment

**Le chantier 4 démarre, et le circuit tient.** Première correction descendue de
bout en bout : obs 18 (store `Suspension-intelligence`) + obs 1 (store
`cerveau-suspension`) → `task-observer-perso` **v1.3.0** (`0dd5496`) → push
vérifié par `fetch` → `deploy-skills.ps1 -Apply -Backup` → **preuve par marqueur
de contenu**, pas par le numéro de version (constat du matin : `VERSION=inconnue`
en 2 runs sur 3). Ce que trois jours de documentation n'avaient pas produit —
une capacité — s'observe ici : éditer la maison change ce qui tourne.

**Le défaut corrigé, en une phrase.** Le `<project-slug>` du store était dérivé
du basename du dépôt ; celui de `suspension-intelligente` ne correspondait plus
au dossier `Suspension-intelligence`. Une application littérale de la convention
créait un store **vide** à côté de 9 observations réelles — sans erreur, sans
message, **indistinguable d'un premier usage légitime**. La garde ajoutée résout
avant de créer : exacte → candidat unique annoncé → ambiguïté = STOP → rien =
création. Critère mesuré avant d'être gravé (principe transverse #1) : préfixe
commun ≥ 75 %, dry-run sur le store réel — 3 exacts, 1 candidat à 91 %, **0 faux
positif**.

**Pas de renommage du dossier** (décision Mathieu) : 6 recaps datés de
`suspension-intelligente` citent le chemin actuel. La garde le résout à coût
nul ; renommer aurait tué des pointeurs historiques pour un gain cosmétique.

**Bundle assumé** — l'étape 2 du rituel du README impose de vider les correctifs
en attente à la ré-émission. Il y en avait un sur ce fichier exact : l'adaptation
#3 justifiait le retrait de la gestion des sessions parallèles par « Mathieu
works sequentially, single session », prémisse **mesurément fausse** depuis le
2026-07-11 (Claude Code et Cowork actifs ensemble sur le vault, l'un appliquant
les recommandations de l'autre, mal attribuées). Correction datée ajoutée sous
l'adaptation d'origine, qui n'est pas réécrite.

**`deploy-skills.ps1` sort en code 1 sur un déploiement réussi.** Mesuré ce soir,
cause établie par test isolé : `robocopy` retourne **1** quand il copie des
fichiers (« one or more files copied successfully »). Le script teste
`if ($LASTEXITCODE -ge 8) { throw }` — correct pour détecter un échec de
sauvegarde — mais ne remet jamais `$LASTEXITCODE` à zéro, et PowerShell propage
le 1 comme code de sortie du script. Conséquence qui compte : le script possède
un `exit 1` **légitime** (fichiers divergents APRÈS écriture, ligne 131). Les
deux modes partagent désormais un seul code — un vrai échec de déploiement est
indistinguable du bruit de robocopy, et tout futur hook ou gate lisant le code de
sortie lira un succès comme un échec. Le déploiement de ce soir a donc été prouvé
**hors du script**, par marqueur de contenu et diff source↔cible.
**Correctif appliqué le même soir, sur GO de Mathieu** — une ligne de
neutralisation, et les **deux sens mesurés** : un déploiement nominal rend
désormais 0 (contre 1 avant, même forme d'appel), et une sonde jetable établit
qu'un `exit 1` postérieur n'est pas avalé par la neutralisation. Détail et
réserve d'instrument : `ISSUES-LOG.md` ISSUE-003.

### 2026-07-27 — Session Code : le rang cesse d'être local, et trois dossiers se ferment

Suite directe de la session du 26 (elle a franchi minuit : commits de 21h34 le
26 à 07h13 le 27). Cinq commits, tous vérifiés après `fetch` plutôt que déduits
du rapport de push.

**Le verdict du rang devient un fait de l'outil.** La réplication Linux est
rendue et **concorde** : banc indépendant (bac à sable Cowork, conteneur
éphémère, `HOME` isolé), **même CLI 2.1.220**, montage refait de zéro,
**15 runs 15/15**. Verdict identique — personnel > projet et personnel >
`--add-dir`. Le rang n'est donc plus une particularité de poste. Fiche annexée
en **v1.1** : `fiche-mesure-rang-skills-20260727-linux.md`. Son **run E**
(énumération ouverte à tout préfixe ou suffixe) établit une propriété que
Windows n'avait pas vue : le masquage est **total** — le perdant est effacé de
la liste, pas seulement dépriorisé. Une copie maison périmée ne laisse **aucune
trace observable en session**. C'est cela, et non le rang seul, qui rend le
doublon dangereux.

**Chantier 3 (étape 3 du § 5) — clos, acquis et non exécuté.** La mesure a
remplacé le travail : la maison portait déjà la version canonique des 10
génériques, les skills de projet étaient déjà commités dans leur dépôt. Ce qui
restait d'elle était son **garde du corollaire F2**, et il passe — aucun skill
de projet n'est masqué, dans aucun dépôt. Ce garde a changé de nature entre son
écriture et son application : il redoutait qu'un générique « gagne en silence » ;
le run E établit pire.

**L'étape 4 du § 5 ne démarre pas.** Elle attend ISSUE-001, et ce blocage
n'était pas visible avant V3-bis — la nature même du `sync-skills.ps1` dépend de
l'option retenue. Consigné en ISSUE-001 § 5.

**Boucle Codex fermée sur ses trois plans** : fichiers (383 supprimés le 26),
configuration (lecture seule, liens coupés le 26), **accès** (révocation GitHub
déclarée par Mathieu le 27). L'accès git propre reste intact — mesuré par
`ls-remote` sur les trois dépôts. Distinction gardée nette : la révocation est
une **déclaration** consignée, l'accès git une **mesure**.

**`App-Handyman/.claude/settings.json` rangé.** Il portait un chemin absolu de
ce poste dans la config *partagée*, alors que le `.gitignore` du dépôt désigne
`settings.local.json` pour ça. Clé fusionnée dans le fichier local (JSON validé,
79 entrées `allow` préservées), `settings.json` supprimé, sauvegarde sortie du
dépôt. Piège relevé au passage : ce `.gitignore` ignore le nom **exact** — toute
sauvegarde suffixée posée là réapparaît en `??`.

**ISSUE-002 ouverte et close le même jour.** Deux commits portent un message
identique (`e7adc71`, `081857b`) : un appel git **rapporté comme refusé s'était
en réalité exécuté**, et l'agent a rejoué la séquence en tenant le rapport
d'échec pour un fait. Conséquence réelle : deux vérifications demandées *avant*
commit ont eu lieu après. Historique publié, donc non réécrit — traçabilité
fermée par une **note git** sur `081857b` et par ISSUE-002. La redondance est
voulue : la note sert qui lit `git log`, l'ISSUE sert qui clone (les notes ne
sont ni poussées ni récupérées par défaut).

**État de sortie, mesuré :** trois dépôts propres et alignés sur leur `origin`
(`claude-skills ede62ce` · `App-Handyman 0e4c146` · `suspension-intelligente
5e75ca9`), ref de notes poussée, **aucun geste court restant**, chantiers 3/6.

**Ce qui attend une décision — une seule :** ISSUE-001. Ses deux options ont
désormais chacune un défaut **mesuré** plutôt qu'argumenté — la stabilité de
l'option 1 adossée au manifeste de synchronisation, l'invisibilité totale de
l'option 2 établie par le run E. Dernier bloquant : la généralisation de
`claude-ah`, dont la condition de réouverture a été élargie pour qu'il cesse
d'attendre un 2ᵉ projet.

**Fermeture décidée en fin de journée — retrait, pas ajout.** Constat de
Mathieu : trois jours de travail avaient produit sept documents, un verdict et
une décision ouverte, sans qu'aucune capacité n'apparaisse — les skills se
déployaient toujours à la main. Ce qui a été fait en conséquence :
**ISSUE-001 tranchée** sur l'option 2 (§ 0), **`deploy-skills.ps1` écrit et
éprouvé** (détection d'écart testée sur une divergence réelle puis restaurée),
**`CLAUDE.md` créé** — ce dépôt était le seul des trois sans instructions de
projet —, et **deux instantanés archivés** vers `archives/` :
`carte-skills.md` et `skills-maisons-et-acces.md`, tous deux datés du
2026-07-24 et mesurés au CLI **2.1.218**, donc périmés par V3-bis. Le second
l'était sur son point central : il déclarait `prompt-forge` « bloqué sur une
mesure », celle-là même qui venait d'être faite. Leur contenu durable — grille
de décision, règles et exclusions — est remonté dans `CLAUDE.md`. Les mentions
de ces deux fichiers dans les tâches cochées plus haut désignent leur ancien
chemin à la racine : c'est de l'histoire, elle n'est pas réécrite.

**Observations 7 à 10 loggées** (hors dépôt, `~/.claude/skill-observations/`).
Elles forment une seule discipline : ce qu'une mesure discrimine, ce qu'un
contrôle présuppose, ce qu'une phrase peut porter, ce qu'un rapport prouve.
**Réserve à lire avant d'en graver quoi que ce soit :** trois d'entre elles sont
nées d'une relecture de Mathieu, jamais du protocole. La contre-mesure qu'elles
proposent — « de quel run cette phrase tient-elle sa portée ? » — n'a donc
jamais fonctionné sans relecteur extérieur. Le prochain protocole exécuté seul
sera son premier test.

### 2026-07-26 — Session Code : un autre agent avait écrit dans la maison

**Découverte.** 15 fichiers non suivis dans ce dépôt, d'origine inconnue.
Traqués jusqu'à leur cause : la **routine d'import au premier lancement de
Codex** (installé le 2026-07-24), qui a écrit à `21:42:43` sans qu'aucun agent
soit invoqué. Elle a converti les maisons Claude en format Codex par
substitution textuelle aveugle — `Claude`→`Codex`, `CLAUDE.md`→`AGENTS.md`,
et surtout `~/.claude/`→`~/.Codex/`, des chemins qui n'existent pour personne.

**Portée mesurée — 383 fichiers, 3 dépôts + le profil :**

| Emplacement | Écrit par l'import |
|---|---|
| `claude-skills` | `.agents/` (15) |
| `App-Handyman` | `.agents/` (1) + `AGENTS.md` |
| `Suspension-intelligente` | `.agents/` (342) + `AGENTS.md` + `.codex/` |
| `~/.agents/skills/` | 15 |
| `~/.codex/AGENTS.md` | la constitution globale, portée et corrompue |

**Aucune source n'a été touchée.** `git diff --name-only` = 0 dans les trois
dépôts ; les `AGENTS.md` se sont posés en `??` à côté des `CLAUDE.md`, sans
les écraser. Ce n'est pas une règle de Codex qui a protégé la maison : c'est
le **suivi git**. Un artefact non suivi reste visible dans `git status` —
d'où la règle qui en découle : ne jamais `.gitignore` ce qu'on veut voir
revenir. Corollaire du même incident : la règle « `git add` nommé, jamais
`-A` » a fait son office — un staging global du 26 au matin embarquait les
15 fichiers dans l'historique de la maison.

**Traité le jour même** (décision Mathieu : « enlève tout lien avec un autre
agent ») : les 383 fichiers supprimés, archive de sécurité détruite sur
demande — rien n'est récupérable. `~/.codex/config.toml` porté à
`sandbox_mode = "read-only"` + `approval_policy = "untrusted"` ; marketplaces
`gitkraken` (sa source pointait sur `~/.claude/plugins/`) et
`claude-plugins-official` retirés avec leurs 5 plugins ; les 3 MCP importés
retirés, seul `node_repl` (runtime OpenAI) conservé. Sauvegarde :
`~/.codex/config.toml.bak-2026-07-26`.

**Conservés délibérément**, et c'est le seul endroit où « enlever le lien »
produirait l'inverse du but : les registres `.sandbox_migration`,
`claude-cowork-import-history.json`, `external_agent_session_imports.json` —
ce sont eux qui marquent l'import comme fait. Les effacer risquerait de le
rejouer. Conservés aussi : `~/.codex/skills/.system/` (54 fichiers, mtime
`21:33:59`, soit 9 minutes AVANT l'import) — skills natifs de Codex, pas un
import. Leur contenu mentionne « Codex » de plein droit : **l'horodatage est
le seul discriminant fiable**, pas le contenu.

**Vérification — VERTE, sur l'effet.** Codex `0.146.0-alpha.3.1`.
`codex debug prompt-input` rend le texte réellement envoyé au modèle : il dit
« `sandbox_mode` is `read-only` », et le témoin forcé en `workspace-write`
diverge. Deux fausses pistes traversées, à ne pas refaire : `codex doctor`
affiche « restricted » pour `read-only` **et** pour `workspace-write` — sa
sortie seule ne prouve rien ; `codex sandbox` teste des profils nommés, pas
la clé ambiante.

**Observations loggées :** obs 6 (un outil devient dangereux quand on
l'installe, pas quand on l'invoque → cible `skill-intake`) et obs 7 (un
témoin qui ne diverge pas n'est pas un verdict mais une panne de mesure ;
insérer un troisième point extrême → candidat cross-cutting).

**Décidé pour la suite.** Si Codex doit lire ce dépôt, ce sera une **copie
jetable sur disque local, sans `.git`** — pas de remote, donc pas de chemin
de retour. Le réglage global reste `read-only` ; l'écriture s'ouvre au
lancement par geste explicite (`codex --sandbox workspace-write -C <copie>`),
jamais par modification du défaut. Rien ne remonte du bac à sable par copie
de fichier : ce que Codex touche revient avec `~/.Codex/` gravé dedans.

**Complément ajouté le 2026-07-27** — l'entrée ci-dessus ne couvrait que
l'incident Codex, alors que la même session a enchaîné, le 26 au soir, sur
**deux chantiers de la feuille de route**. Consigné ici pour que le journal
cesse de les taire, sans toucher au récit d'origine :

- **Chantier 1 — sauvegarde datée** de `~\.claude\SKILLS\` faite et vérifiée
  (`b7c5949`), préalable exigé par le § 5 avant toute écriture là-bas.
- **Chantier 2 — mesure V3-bis exécutée** (`bfe6729`), verdict **`PERSONNEL`**.
  Le protocole, les points de mesure et les conditions vivent au § 6 de
  `2026-07-23-proposition-maison-skills.md`, « Résultat consigné » — pas ici.
  La première série a conclu **avant** d'avoir écarté l'hypothèse d'un fichier
  maison inchargeable ; c'est une objection de Mathieu qui a imposé la ligne L,
  seule mesure rendant le verdict opposable. À retenir de la soirée : le
  protocole n'a pas trouvé sa propre lacune.

### 2026-07-24 — Session Cowork (projet Skills) + sessions Code (maison / App-Handyman)

**Palier atteint et clos.** Fait ce jour, en événements :
- Inventaire complet mesuré (6 foyers → 4 d'exécution ; 10/10 identiques
  SHA256 maison↔perso ; 16 gelés / 5 libres ; prompt-forge requalifié :
  deux skills différents partageant un nom, exclusion de distribution
  ADR-005).
- Trois verdicts gravés : **V0 VERT** (`--add-dir` charge à la source, F8),
  **V0-bis ROUGE** (`additionalDirectories` = fichiers seulement → **F10**),
  **épreuve lanceur VERTE** (`claude-ah` prouvé bout en bout par sonde).
- Maison restructurée (`skills/` → `.claude/skills/`, `50b99ed`) ; document
  d'autorité porté à **v6** ; règle d'ordre gravée au README (artefact
  jetable APRÈS le push ; repli : staging nommé).
- Observations 17 et 18 loggées (événement vs état ; garde par séquencement
  vs vigilance) + obs 5 claude-skills (vérifier l'effet, pas l'invocation).
- Côté Cowork : carte des skills établie et finalisée, mémo de continuité
  finalisé, maison des documents du projet décidée = **racine de ce repo** ;
  écriture racine mesurée VERTE, écriture `.claude/` mesurée BLOQUÉE
  (pont), git = lecture seule depuis Cowork.
