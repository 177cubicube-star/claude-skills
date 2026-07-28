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

---

## Journal de sessions (le plus récent en haut)

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
**Correctif non appliqué à cette date** — instruit en `ISSUES-LOG.md` ISSUE-003.

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
