# Proposition technique — La maison des skills et sa distribution

**Date :** 2026-07-23 · **Version 2 le 2026-07-24** (revue Claude Code : F8, option D, Android au périmètre) · **Version 3 le 2026-07-24** — la mesure du canal claude.ai est faite : les plugins ne l'atteignent PAS, les deux circuits sont séparés par conception (F9). · **Version 4 le 2026-07-24** — prérequis du canal claude.ai intégré : plan payant avec exécution de code activée, mesuré à la même source que F9.
**Version 5 le 2026-07-24** — **V0 EXÉCUTÉE, VERDICT VERT** : F8 est prouvé sur cette machine (CLI 2.1.218), l'option D est retenue. La question du mécanisme permanent (réglage au lieu du drapeau) est ouverte et distincte → V0-bis.
**Version 6 le 2026-07-24** — **V0-bis EXÉCUTÉE, VERDICT ROUGE** : `permissions.additionalDirectories` ne charge pas les skills (→ F10). Le mécanisme de l'option D est donc **le drapeau `--add-dir`, définitivement** ; le confort « ne pas le retaper » passe par un lanceur de profil PowerShell, pas par un réglage.
**Version 7 le 2026-07-24** — **ÉPREUVE DU LANCEUR EXÉCUTÉE, VERDICT VERT** : le lanceur de profil `claude-ah` monte la chaîne complète — fonction PowerShell → `--add-dir <maison>` → skills de la maison chargés dans une session App-Handyman. Le confort promis par la v6 cesse d'être une proposition : il est mesuré (→ V0-ter).
**Version 8 le 2026-07-24** — pas un verdict, une lacune comblée : le rang de priorité du `--add-dir` face à un homonyme personnel était nommé comme inconnue au § 4 depuis la v2, sans ligne au § 6. Il en a une désormais (**V3-bis**, non exécutée) — protocole, prérequis de sauvegarde et verdicts attendus au même endroit que les autres mesures.
**Statut :** VALIDÉ par Mathieu le 2026-07-24 (v4). Les décisions du § 4 (option D barrée par V0, A en repli, C à terme côté Claude Code) et la règle du rayon d'impact du § 5 sont actées ; les mesures V restent à exécuter avant tout engagement irréversible. **V0 est franchie le 2026-07-24 (VERT)** ; l'option D cesse d'être conditionnelle.
**Objet :** faire du dépôt GitHub « maison des skills » la source d'autorité unique, définir comment les skills atteignent chaque projet, comment gérer les variantes par projet, et comment prouver que tout fonctionne.
**Contexte :** poste Windows (PowerShell) · projets multiples (App-Handyman, suspension-intelligence, vault Obsidian…) · développeur unique · philosophie établie : aucune dépendance sans besoin démontré, une source d'autorité par information, tout se prouve par mesure.

---

## 1. Les faits — mesurés dans la documentation officielle et les retours d'expérience

Ces faits contraignent la conception. Sources en fin de document.

**F1 — Deux emplacements de découverte.** Claude Code charge les skills depuis `~/.claude/skills/` (personnel — toutes les sessions, tous les projets) et `.claude/skills/` à la racine du projet courant (projet — cette session seulement, voyage avec le dépôt). Un dépôt GitHub n'est ni l'un ni l'autre : c'est un entrepôt, pas un canal.

**F2 — La priorité en cas d'homonymie est contre-intuitive : le PERSONNEL gagne sur le PROJET.** La documentation officielle : « enterprise overrides personal, and personal overrides project ». Conséquence directe : on ne peut PAS « spécialiser » un skill générique en posant une variante homonyme dans un projet — c'est la version personnelle qui s'exécuterait. Toute stratégie fondée sur l'ombrage projet-sur-personnel est morte-née. *(Fait surprenant → à re-mesurer au protocole § 6, jamais présumé.)* **Confirmé verbatim le 2026-07-24** (mesure Claude Code sur la doc à la source). Leçon au passage : la citation d'origine de ce document tronquait la phrase source — sa suite nommait `--add-dir` (F8), le mécanisme qui change la recommandation. Une citation partielle peut cacher précisément ce qui compte (maladie de l'obs 14, version documentaire).

**F3 — Les liens symboliques PAR SKILL sont supportés ; le lien du DOSSIER ENTIER est cassé.** Officiellement (v2.1.203+), une entrée `<nom-du-skill>` dans un emplacement de découverte peut être un lien vers ailleurs sur le disque — suivi et chargé. Mais un bug confirmé (issue #38051, régression ~v2.1.69, liée à un correctif de sécurité) fait que si `~/.claude/skills/` est LUI-MÊME un lien symbolique, les skills personnels ne sont plus découverts du tout. C'est l'expérience « testé et jeté » la plus précieuse trouvée : le motif dotfiles classique « tout le dossier est un lien vers le clone » ne marche plus.

**F4 — Les dossiers de skills sont surveillés.** Ajouter, modifier ou retirer un skill sous `~/.claude/skills/` ou `.claude/skills/` prend effet en cours de session, sans redémarrage. **Limite (mesurée le 2026-07-24) :** créer un dossier de skills DE PREMIER NIVEAU qui n'existait pas au démarrage exige un redémarrage — le rechargement à chaud ne vaut que dans un dossier déjà surveillé. La toute première installation sur une machine vierge est donc le cas qui échappe (→ V2-bis).

**F8 — `--add-dir` charge les skills d'un répertoire ajouté (mesuré le 2026-07-24, doc officielle).** Le `.claude/skills/` d'un répertoire ajouté par `--add-dir` est chargé automatiquement. Conséquence : pointer `--add-dir` sur le clone de la maison lit les skills À LA SOURCE — aucune copie, aucun lien symbolique, `git pull` suffit. C'est l'option D du § 4, absente de la version 1 de ce document parce que sa citation de F2 tronquait la phrase qui la nommait.

**F8-bis — La doc officielle se CONTREDIT sur le réglage `permissions.additionalDirectories` (mesuré le 2026-07-24, trois pages lues à la source).** Question : le réglage permanent charge-t-il les skills comme le fait le drapeau `--add-dir` ?
- `settings.md`, tableau des réglages de permission, dit OUI : « `additionalDirectories` — Directories to scan for **skills**, subagents, and custom commands. […] Relative paths resolve from the git repository root […]. Paths added via `--add-dir` at startup take precedence over this setting. Requires Claude Code v2.1.180 or later ».
- `permissions.md` dit NON : « These exceptions apply only to directories added with the `--add-dir` flag or the `/add-dir` command. Directories listed in `permissions.additionalDirectories` in a settings file grant file access only and **don't load any of the configuration below** » — le tableau qui suit liste précisément « Skills in `.claude/skills/` — Yes, with live reload » comme exception du DRAPEAU.
- `skills.md` dit NON, au mot près : « The `permissions.additionalDirectories` setting in `settings.json` grants file access only and **does not load skills** ».

Deux pages contre une ; la page favorable est aussi la seule à porter une mention de version (v2.1.180), ce qui la rend compatible avec l'hypothèse « comportement récent, pages voisines périmées ». **Rien ne tranche sur la doc — le verdict vient de la mesure V0-bis, pas du vote.** Leçon de méthode, sœur de celle de F2 : une source unique lue à la lettre peut être fausse ; ici c'est la lecture croisée de trois pages qui a révélé le conflit, alors qu'une seule aurait produit une certitude confortable et non mesurée. **Tranché le 2026-07-24 par la mesure V0-bis → F10 : les deux pages qui disaient NON avaient raison ; `settings.md` a tort, ou décrit un comportement non livré en 2.1.218. La mention de version (v2.1.180), qui rendait la page favorable la plus crédible, s'est révélée être exactement le contraire d'une garantie.**

**F10 — Le réglage `permissions.additionalDirectories` accorde l'accès aux FICHIERS, pas la découverte des SKILLS (mesuré le 2026-07-24, CLI 2.1.218, poste Windows — V0-bis ROUGE).** Ce fait tranche la contradiction de F8-bis. Conditions de la mesure, toutes vérifiées **dans la session même qui a rendu le verdict** : le réglage présent sur disque dans `App-Handyman/.claude/settings.json` (`"additionalDirectories": ["C:/Users/mat_g/Documents/Claude/claude-skills"]`, écrit avant le démarrage de la session) ; le répertoire effectivement lié (annoncé comme répertoire de travail additionnel par l'environnement de session) ; l'accès fichiers effectivement actif (lecture réussie de `<maison>/.claude/skills/v0-sonde-adddir/SKILL.md` sans aucune demande d'approbation) ; la sonde présente sur disque ; aucun bloc `deny` dans `settings.local.json`. Résultat : `Skill(v0-sonde-adddir)` → **`Unknown skill`**, et la sonde n'apparaît pas dans la liste des skills de la session — alors que `prompt-forge` (projet) et `task-observer-perso` (personnel) y figurent, ce qui prouve que la découverte fonctionne par ailleurs. **Le drapeau `--add-dir` fait les deux ; le réglage n'en fait qu'un.** Les deux mesures (V0 vert, V0-bis rouge) sont du même jour, sur la même machine, avec la même sonde, et ne diffèrent que par le mécanisme — la cause est donc isolée. Conséquences : (1) le mécanisme de l'option D est le drapeau, définitivement ; (2) le réglage se **conserve** dans App-Handyman, mais au titre de l'accès fichiers seulement, jamais comme chargeur de skills ; (3) le confort « ne pas retaper le drapeau » cesse d'être un problème de réglage et devient un problème de **lanceur** (fonction de profil PowerShell, § 4 option D). Portée : Claude Code CLI 2.1.218 sur ce poste — V6 s'applique, tout changement de version se re-mesure.

**F9 — Les skills ne se synchronisent PAS entre surfaces, et les plugins n'atteignent pas claude.ai (mesuré le 2026-07-24, doc officielle).** Un skill installé côté Claude Code (fichiers) et un skill du compte claude.ai sont deux mondes sans aucun pont automatique — la doc l'exclut explicitement. Le seul canal documenté vers claude.ai est le téléversement manuel d'un zip par skill, via Settings > Features, individuel à chaque utilisateur (aucune distribution centralisée) — **et sous prérequis mesuré (v4) : plan Pro, Max, Team ou Enterprise AVEC exécution de code activée.** Sans ce prérequis au compte, le canal n'existe pas du tout : la porte est fermée avant même d'être testée. Les plugins déclarés au dépôt ne concernent que les sessions Claude Code (y compris cloud), jamais le compte claude.ai. Conséquence : le circuit Android (§ 7.4) est manuel PAR CONCEPTION de l'outil — pas par manque d'un tuyau qu'on pourrait poser. *(Note : la v2 de ce document demandait de mesurer avant d'affirmer que l'option C couvre Android — la mesure est faite, et elle tranche NON.)*

**F5 — Les plugins sont le mécanisme de distribution structuré.** Un dossier de skill portant un manifeste `.claude-plugin/plugin.json` se charge comme plugin ; un dépôt peut servir de place de marché (`/plugin`) ; les skills de plugin sont espacés de noms (`plugin:skill`), donc immunisés aux collisions de F2. Plus de cérémonie, mise à jour par commande.

**F6 — Windows change la donne des liens.** Les liens symboliques exigent le mode développeur ou des droits administrateur ; les jonctions de répertoires (`mklink /J` ou `New-Item -ItemType Junction`) fonctionnent sans droits particuliers. Tout mécanisme fondé sur des liens doit être écrit pour Windows, pas transposé d'un billet macOS.

**F7 — Des outils communautaires existent (skillshare, dot-claude-sync)** pour synchroniser une source vers plusieurs cibles. Ils marchent, mais chacun est une dépendance de plus dans la chaîne de confiance — contraire à la règle « aucune dépendance sans besoin démontré » tant qu'un script de dix lignes suffit.

## 2. Ce que d'autres ont essayé — et jeté

| Approche | Verdict du terrain | Pourquoi |
|---|---|---|
| Lien symbolique du dossier `~/.claude/skills/` entier vers le clone | **JETÉ** | Régression confirmée : plus aucun skill personnel découvert (F3). Le contournement documenté est le lien par skill. |
| Fork du skill dans chaque projet qui le modifie | **JETÉ** | Dérive silencieuse : trois copies divergent, personne ne sait laquelle est vraie. C'est le problème actuel, pas sa solution. |
| Variante projet homonyme pour « surcharger » le générique | **MORT-NÉ** | F2 : le personnel gagne. La surcharge attendue ne se produit pas — pire, elle échoue en silence. |
| Sous-module git de la maison dans chaque `.claude/skills/` de projet | **DÉCONSEILLÉ** | Douleur connue des sous-modules (oublis de `--recurse`, états détachés), et marie la maison à chaque dépôt. Personne ne le recommande dans les retours lus. |
| Liens PAR SKILL gérés par un installateur (motif dotfiles) | **ÉPROUVÉ** | Exactement le contournement de F3 ; permet de mélanger skills partagés et expériences locales. Retenu comme variante (§ 4, option B). |
| Copie synchronisée par script depuis un clone unique | **ÉPROUVÉ** | Le plus simple qui marche ; c'est ce que font les outils de F7 sous le capot en mode « merge ». |

## 3. Le principe de conception — moteur générique + paramètres projet

Avant tout mécanisme de distribution, la règle qui rend la distribution possible :

> **Un skill ne se fork jamais par projet — il se paramètre.** Le skill est un moteur générique qui vit dans la maison. Ce qui est propre à un projet (gabarits, chemins, conventions) vit dans les fichiers du projet, où le moteur va le lire.

Ce motif existe déjà dans la maison : `recap` et `session-prep` se déclarent « génériques, chemins configurables, seul le template est propre au projet ». La proposition l'érige en règle pour tous les skills, avec son corollaire de tri :

| Famille | Où vit la source | Où elle s'exécute | Exemples actuels |
|---|---|---|---|
| **Générique** | Maison (GitHub) | `~/.claude/skills/` via distribution (§ 4) | recap, session-prep, prompt-forge (une fois généralisé), task-observer |
| **Irréductiblement projet** | `.claude/skills/` du projet, commité avec lui | Le projet seulement | tri-inbox (vault), tdd-enforcer / architecture-guard (liés à un projet par nature) |
| **Paramètres projet d'un générique** | Fichiers du projet (jamais un skill) | Lus par le moteur | `docs/CONTINUITE-SESSION-TEMPLATE.md` pour recap |

**Règle de nommage (conséquence de F2) :** aucun skill de projet ne porte le nom d'un skill de la maison. En cas de doute, préfixer le skill de projet (`ah-`, `si-`…). L'homonymie n'est pas une fonctionnalité, c'est un piège.

**Test du tri :** si la tentation de modifier un skill pour un projet apparaît, la première question est « quelle partie est projet ? » — cette partie s'extrait en paramètre dans le dépôt du projet, le moteur reste un.

## 4. Les options de distribution, comparées

### Option A — Copie synchronisée par script (recommandée pour démarrer)

Un clone unique de la maison à un chemin fixe (ex. `C:\Users\mat_g\Documents\Claude\maison-skills`). Un script PowerShell `sync-skills.ps1` dans la maison elle-même : `git pull`, puis pour chaque skill listé dans un manifeste (`skills-distribues.txt`), copie miroir vers `~/.claude/skills/<nom>/` (`robocopy /MIR` par skill), et en fin de course un rapport : skills synchronisés, skills locaux non gérés (laissés intacts), divergences détectées avant écrasement.

*Pour :* zéro dépendance, zéro lien symbolique (immunisé à F3 et F6), fonctionnement trivial à comprendre et à déboguer, le manifeste rend explicite ce qui est distribué, les copies sont des vrais dossiers (aucun cas limite de découverte).
*Contre :* la fraîcheur dépend de lancer le script — une modification dans la maison n'arrive pas seule. Mitigation : le script s'invoque en une commande, et une vérification de fraîcheur peut s'ajouter aux rituels de démarrage de session.
*Risque propre :* une modification faite directement dans `~/.claude/skills/` (au lieu de la maison) serait écrasée au prochain sync — c'est voulu (la maison est la source d'autorité), mais le script doit le DÉTECTER et demander avant d'écraser, jamais écraser en silence.

### Option B — Jonctions par skill (variante sans copie)

Même clone unique ; au lieu de copier, chaque skill distribué devient une jonction : `~/.claude/skills/recap` → `maison-skills/skills/recap`. Le lien par skill est officiellement supporté (F3), les jonctions passent sans droits sur Windows (F6), et `git pull` dans la maison met tout à jour instantanément (F4).

*Pour :* jamais de copie périmée, une seule vérité physique sur le disque.
*Contre :* repose sur un comportement qui vient de subir une régression pour le cas voisin (F3) — le lien par skill marche aujourd'hui, mais la zone est visiblement sensible aux correctifs de sécurité de l'outil ; et toute modification accidentelle « locale » modifie en réalité la maison. À n'adopter que si la friction du sync de l'option A devient réelle.

### Option C — La maison devient une place de marché de plugins (cible à terme)

Structurer la maison en plugins (`.claude-plugin/plugin.json` + manifeste de marketplace), installer par `/plugin`, mettre à jour par commande. Espace de noms `maison:recap` → collisions impossibles (F2 neutralisé).

*Pour :* le mécanisme prévu par l'outil pour exactement ce besoin ; versionnage, activation/désactivation propres ; c'est la sortie naturelle si un jour ces skills se partagent au-delà d'une machine.
*Contre :* cérémonie de structuration réelle (manifestes, éventuel renommage des invocations en `plugin:skill`), et l'écosystème plugin est plus jeune que le mécanisme skills. Prématuré tant que la maison bouge encore chaque semaine.

### Option D — `--add-dir` sur le clone de la maison (ajoutée en v2, découverte par la revue)

Le clone unique de la maison porte ses skills sous `<clone>/.claude/skills/`. Chaque session se lance avec `--add-dir <clone>` (ou l'équivalent en réglage), et les skills sont lus à la source (F8).

*Pour :* tous les avantages de A sans son défaut — aucune copie donc aucune péremption, aucun sync à ne pas oublier, aucun lien symbolique donc immunisé à F3, `git pull` = à jour partout, zéro dépendance.
*Contre — la ligne que le comparatif de la revue omettait :* **chaque session a accès direct à la maison.** Une modification accidentelle touche la source de vérité, pas une copie jetable — le même défaut que l'option B. Mitigation élégante : la maison est un dépôt git, donc `git -C <clone> status` rend toute dérive visible ; cette vérification entre au rituel (→ V5 adapté). Autre inconnue à mesurer : le rang des skills `--add-dir` dans la chaîne de priorité de F2 — **son protocole vit au § 6, mesure V3-bis** (écrit le 2026-07-24 ; jusque-là l'inconnue était nommée ici sans être mesurable nulle part). **Inconnue tranchée le 2026-07-24 (V0-bis, ROUGE) :** la persistance sans retaper le drapeau ne passe **pas** par `permissions.additionalDirectories` (F10). Elle passe par un **lanceur de profil PowerShell** (`claude-ah`), qui grave le drapeau une fois pour toutes dans une fonction au lieu d'un fichier de réglages. Le drapeau reste le mécanisme ; il cesse d'être une friction de frappe.

### Recommandation explicite (v3)

**Option D, précédée d'une mesure V0 — A en repli documenté.** Le comportement F8 est documenté mais pas encore prouvé sur la machine de Mathieu : V0 (charger un skill de la maison via `--add-dir`, verdict binaire) est le premier geste exécutable du plan de migration — pas avant, car il exige que le clone et au moins un skill existent. V0 vert → D est le mécanisme du poste Windows. V0 rouge ou friction réelle du lancement → A, qui reste entièrement valable. **Option C : redevient « à terme », et pour le monde Claude Code seulement** — la mesure F9 a tranché : les plugins n'atteignent pas claude.ai, donc C n'a aucun rapport avec Android ; sa valeur réelle est le multi-poste Claude Code et la stabilité, quand la maison aura cessé de bouger. **Le circuit Android est un chantier séparé** (§ 7.4), manuel par conception, dont la maison est la source mais pas le tuyau. Le séquencement reste le même raisonnement que le remède B du réalignement : minimal d'abord, escalade sur preuve.

**Amendement du 2026-07-24 (v6), après V0-bis ROUGE.** La recommandation ne change pas — l'option D tient, le repli A n'est pas déclenché. Ce que V0-bis a tué, c'est uniquement l'espoir d'un mécanisme **par réglage** : le drapeau `--add-dir` est le seul chargeur (F10). Le remplaçant du confort est un **lanceur de profil PowerShell** — `claude-ah` : `cd` vers le pilote + `claude --add-dir <maison>` — qui coûte une fonction, aucune dépendance, et reste conforme à « aucune dépendance sans besoin démontré ». Effet de bord à connaître : le drapeau étant désormais gravé dans un lanceur et non dans le dépôt, il ne voyage PAS avec le projet — une session lancée par `claude` nu n'a pas les skills de la maison. Ce n'est pas une régression silencieuse (la sonde le rend mesurable), mais c'est la limite à retenir pour le jour où un second poste ou un autre humain entre en scène ; ce jour-là, c'est l'option C (plugins) qui répond, pas un réglage.

**Amendement du 2026-07-24 (v7), après l'épreuve du lanceur — VERTE.** Le lanceur `claude-ah` de l'amendement v6 est construit, installé et **prouvé de bout en bout** (V0-ter) : ouvert par cette seule commande, une session App-Handyman charge un skill présent uniquement dans la maison. L'option D est donc complète — mécanisme (drapeau, F8) et ergonomie (lanceur) sont l'un et l'autre mesurés, plus aucune pièce n'est au conditionnel. Deux limites restent, nommées et non résolues : (1) le lanceur code en dur le couple pilote+maison, donc chaque nouveau projet exige son propre lanceur ou le drapeau tapé à la main — cohérent avec la règle « un seul projet pilote à la fois » du § 5, à revoir quand le deuxième projet entre ; (2) une session ouverte par `claude` nu reste sans les skills de la maison (limite v6 inchangée). Le lanceur ne se recopie pas dans ce document — sa définition vit dans le profil PowerShell, et son existence se **mesure** par `Get-Command claude-ah`. Corollaire de méthode : cette vérification prouve l'installation, jamais l'effet ; seule la sonde prouve la chaîne.

## 5. Plan de migration — l'état actuel vers l'état cible

**Règle du rayon d'impact (v3, exigence de Mathieu) — elle prime sur toutes les étapes ci-dessous.** Ce chantier ne doit casser aucun autre projet. Quatre gardes, chacun vérifiable :
- **Un seul projet pilote à la fois.** App-Handyman est le pilote (c'est lui qui porte le bloquant). Aucun autre projet n'est touché tant que les mesures V ne sont pas vertes sur le pilote — les autres rejoignent un par un, chacun sur GO explicite.
- **L'inventaire (étape 1) liste les DÉPENDANTS de chaque skill** : quels projets l'utilisent aujourd'hui. Tout skill ayant un dépendant hors du pilote est **GELÉ** — ni déplacé, ni renommé, ni modifié — jusqu'à ce que ce projet entre dans la migration.
- **Sauvegarde avant tout premier geste d'écriture** dans `~/.claude/skills/` : copie datée du dossier entier (`robocopy` vers `skills-sauvegarde-AAAAMMJJ/`). Le retour arrière de tout le chantier tient en une restauration.
- **Aucune suppression pendant la migration.** La consolidation copie et ajoute ; les anciens emplacements ne se retirent qu'après les mesures V vertes ET le GO final — jamais dans le même geste que l'ajout. Corollaire F2 : avant de poser tout skill générique dans `~/.claude/skills/`, mesurer qu'aucun projet ne porte un skill homonyme (`ls` des `.claude/skills/` de chaque dépôt) — l'homonymie ferait gagner le générique en silence dans ce projet.

1. **Inventaire** (mesure, pas mémoire) : lister tous les skills existants — maison GitHub, `~/.claude/skills/` de la machine, `.claude/skills/` de chaque projet — avec pour chacun : où il vit, s'il existe en plusieurs copies, lesquelles divergent (`git diff` ou comparaison de fichiers), et **quels projets en dépendent**.
2. **Tri** selon le § 3 : générique / projet / à généraliser. Les divergences détectées à l'étape 1 sont chacune une décision : quelle copie est la vraie, et la partie projet s'extrait en paramètre.
3. **Consolidation** : la maison reçoit la version canonique de chaque générique ; les skills de projet restent (ou déménagent) dans le `.claude/skills/` de leur projet, commités.
4. **Distribution** : manifeste + `sync-skills.ps1` dans la maison, premier sync exécuté.
5. **Traitement des trois éléments en attente** — enfin débloqués : corrections de prompt-forge issues du jugement, observation 11 → task-observer, observation 12 → prompt-forge. Chacune se fait DANS la maison, puis descend par sync — premier aller-retour réel du circuit.
6. **Consignation** : un `README.md` de la maison décrit la règle du § 3, le manifeste, le script, et le verdict du protocole § 6. La maison devient sa propre source d'autorité documentée. Côté App-Handyman, le bloquant « rien dans `.claude/skills/` » est remplacé par la règle du § 3.

## 6. Protocole de validation — à exécuter par Claude Code, verdicts observables

Aucune de ces mesures ne se présume ; chacune produit un verdict binaire.

| # | Mesure | Verdict attendu |
|---|---|---|
| V0 | Lancer une session avec `--add-dir <clone maison>`, vérifier qu'un skill de la maison est vu et invocable | Skill chargé (F8 prouvé sur cette machine). Rouge → repli option A, consigner |
| **V0 — EXÉCUTÉE le 2026-07-24** | Sonde `v0-sonde-adddir` (nom unique, présente uniquement dans `<maison>/.claude/skills/`, absente de `~/.claude/skills/` et de tout projet), session lancée **depuis App-Handyman**. Contrôle négatif d'abord, sans le drapeau ; mesure ensuite, avec `--add-dir <clone maison>`. Exécutée de la main de Mathieu. | **VERT.** Sans le drapeau : « Unknown command » (la sonde n'existe pas). Avec le drapeau : réponse exacte `V0-VERT-SONDE-CHARGEE`. Les deux issues ont chacune une seule cause possible. **F8 prouvé sur cette machine, CLI 2.1.218. Option D retenue ; le repli A n'est pas déclenché.** |
| V0-bis | **Le réglage remplace-t-il le drapeau ?** `permissions.additionalDirectories` dans le `.claude/settings.json` du pilote, puis `claude` SANS drapeau depuis App-Handyman, invoquer la sonde. *Nécessaire car la doc officielle se contredit (voir ci-dessous) — donc à mesurer, jamais à présumer.* | Vert : la sonde répond → le mécanisme est permanent, aucun drapeau à retaper. Rouge : « Unknown command » → le réglage ne porte que l'accès fichier ; le drapeau reste obligatoire, et le mécanisme permanent devient un autre chantier (alias de lancement, ou repli A) — consigner daté |
| **V0-bis — EXÉCUTÉE le 2026-07-24** | Même sonde `v0-sonde-adddir`, session lancée depuis App-Handyman **sans le drapeau**, avec `permissions.additionalDirectories` déjà présent dans `.claude/settings.json` du pilote. Préconditions vérifiées **dans la session qui rend le verdict** : répertoire annoncé comme additionnel par l'environnement, lecture réussie d'un fichier de la maison sans demande d'approbation, sonde présente sur disque, aucun bloc `deny` dans `settings.local.json`. | **ROUGE.** `Skill(v0-sonde-adddir)` → `Unknown skill` ; sonde absente de la liste des skills de la session, alors que `prompt-forge` (projet) et `task-observer-perso` (personnel) y figurent. Le réglage ne porte que l'accès fichiers → **F10**. Le drapeau reste obligatoire ; le mécanisme permanent est un **lanceur de profil** (`claude-ah`), pas un réglage. Le réglage est **conservé** dans App-Handyman pour l'accès fichiers, jamais présenté comme chargeur de skills. CLI 2.1.218. *(La mesure précédente, avortée par une fermeture de terminal avant l'octroi du lien, était sans valeur : son « Unknown command » avait deux causes possibles. Celle-ci n'en a qu'une.)* |
| V0-ter | **Le lanceur monte-t-il la chaîne complète ?** Vérifier d'abord l'installation (`Get-Command claude-ah` → `Function`), puis ouvrir une session par cette **seule** commande — aucun drapeau tapé à la main — et invoquer une sonde jetable à nom unique, présente uniquement dans `<maison>/.claude/skills/` | Vert : la sonde rend son marqueur exact → la chaîne fonction de profil → `--add-dir` → découverte des skills est prouvée de bout en bout. Rouge : « Unknown skill » → le lanceur ne transmet pas le drapeau ; V0 reste valable, seul le confort tombe et le drapeau se retape. La vérification préalable de l'installation est obligatoire : sans elle, un rouge peut venir d'une fonction absente et non de la chaîne |
| **V0-ter — EXÉCUTÉE le 2026-07-24** | Sonde `sonde-lanceur-ah` (marqueur `AH-VERT-LANCEUR-MONTE`), présente uniquement dans `<maison>/.claude/skills/` et non suivie par git (`??` avant comme après le commit précédent). Installation vérifiée d'abord : `Get-Command claude-ah` → `Function`. Session ouverte ensuite par `claude-ah` seul. Exécutée de la main de Mathieu. | **VERT.** Session ouverte dans App-Handyman, CLI 2.1.218 ; `/sonde-lanceur-ah` → réponse exacte `AH-VERT-LANCEUR-MONTE`. La chaîne fonction de profil → `--add-dir <maison>` → chargement des skills de la maison est prouvée de bout en bout ; la conséquence (3) de F10 cesse d'être une proposition. Limites retenues : le lanceur code en dur le couple pilote+maison (tout autre projet exige son lanceur ou le drapeau) ; une session ouverte par `claude` nu reste sans les skills de la maison. Sonde supprimée après verdict — l'artefact de mesure ne survit pas à sa mesure |
| V1 | Dans deux projets différents, lister les skills vus par la session | Un skill de la maison visible dans les deux ; un skill de projet visible dans un seul |
| V2 | Modifier une ligne anodine d'un skill EXISTANT dans la maison, `git pull`, relire depuis une session | La session voit la nouvelle version (F4 : sans redémarrage) |
| V2-bis | Installer un skill ENTIÈREMENT NOUVEAU et vérifier son apparition sans redémarrage | Vert si le dossier de premier niveau existait déjà ; le cas « machine vierge » exige un redémarrage (limite F4) — les deux verdicts se consignent |
| V3 | Poser volontairement un skill de projet homonyme d'un personnel, invoquer, mesurer lequel répond, puis retirer | Le PERSONNEL répond (F2, confirmé le 2026-07-24). Si l'inverse : F2 a changé — consigner, la règle de nommage du § 3 reste valable dans les deux cas |
| V3-bis | **Le rang du `--add-dir` dans la chaîne de F2** (inconnue nommée au § 4 option D, sans protocole jusqu'au 2026-07-24). Un skill atteint par `--add-dir` l'emporte-t-il sur un homonyme personnel de `~/.claude/SKILLS/` ? **Jamais mélangée à V0 ni à V0-ter** : les copies maison et personnelles étant identiques octet pour octet (mesuré 2026-07-24), rien ne discrimine laquelle répond, et un rouge de rang serait lu à tort comme un rouge de chargement. Prérequis dans l'ordre : (1) **sauvegarde datée** de `~/.claude/skills/` — le § 5 l'exige avant tout premier geste d'écriture dans le dossier personnel, et cette mesure en est un ; (2) **marqueur délibéré** : rendre une copie maison et son homonyme personnel textuellement discriminants, chacun rendant une chaîne distincte ; (3) session ouverte par `claude-ah` depuis le pilote ; (4) marqueur retiré et copie restaurée après verdict. Sonde et marqueur se posent APRÈS le push (règle d'ordre, forme forte) | Le verdict est **le marqueur rendu**, jamais la présence du skill — un skill présent ne dit rien de sa provenance. Marqueur personnel → F2 s'étend au drapeau : la maison ne peut pas spécialiser un homonyme personnel, et tout skill de la maison doublé dans `~/.claude/SKILLS/` est servi par la copie, pas par la source. Marqueur maison → `--add-dir` prime sur le personnel, et la copie vers `~/.claude/SKILLS/` devient un piège actif (une copie périmée resterait invisible) → la décision de retrait du README cesse d'être ouverte. Les deux verdicts se consignent datés, avec la version du CLI |
| V4 | Aller-retour complet : corriger un skill depuis un projet → commit/push maison → `git pull` → vérifier dans un AUTRE projet | La correction arrive dans le second projet ; aucune copie orpheline ne subsiste |
| V5 | (Option A) Modifier directement `~/.claude/skills/<skill>`, relancer le sync — (Option D) modifier un skill via une session, puis `git -C <clone> status` | A : le script DÉTECTE et demande, n'écrase pas en silence — D : la dérive est VISIBLE dans git avant tout `pull/push` |
| V6 | Après chaque mise à jour majeure de Claude Code : rejouer V0, **V0-bis**, **V0-ter**, V2-bis et V3 (V0-bis parce que `settings.md` annonce le comportement comme livré en v2.1.180 — s'il arrive vraiment un jour, c'est cette mesure qui le verra, et le lanceur devient facultatif ; V0-ter parce que la chaîne dépend de la façon dont le CLI reçoit `--add-dir`, et qu'une fonction de profil qui existe encore ne prouve pas qu'elle porte encore) | Mêmes verdicts qu'à l'origine ; tout écart se consigne avec la version de l'outil — F2/F3/F8/F9 sont des comportements, pas des lois |
| V7-pre | Vérifier au compte claude.ai : plan éligible (Pro/Max/Team/Enterprise) ET exécution de code activée | Oui → V7 s'exécute. Non → le canal Android est INCONSTRUCTIBLE en l'état ; consigner daté, V7 sans objet jusqu'à changement de plan |
| V7 | (Circuit Android, si V7-pre vert) Depuis l'app Android, chercher le téléversement de skill dans Settings > Features ; sinon, téléverser depuis le web et vérifier que le skill apparaît sur mobile | L'un des deux chemins fonctionne — consigner LEQUEL, avec la date : c'est lui qui devient le geste de la routine du § 7.4 |

### Résultat consigné — V3-bis, exécutée le 2026-07-26

**Verdict : `MARQUEUR-V3BIS-PERSONNEL`. Le personnel l'emporte.** Un skill
atteint par `--add-dir` **ne prime pas** sur son homonyme de `~/.claude/SKILLS/`.

**Conditions de la mesure — à citer avec le verdict, car F2 est un comportement
et non une loi :** Claude Code **2.1.220**, plateforme **Windows 11**
(`windows-x86_64`). Prérequis remplis dans l'ordre exigé : sauvegarde datée du
2026-07-26 faite et vérifiée ; marqueurs posés APRÈS le push (arbre à 0
modification, `local == origin`) ; sujet `json-canvas`, marqueur ajouté à la
`description` du frontmatter de chaque copie.

**Points de mesure** (sonde `v3bis-sonde-maison` = skill à nom unique présent
uniquement dans la maison, donc sans homonyme possible) :

| Lancement | cwd | `--add-dir` | `json-canvas` | sonde maison |
|---|---|---|---|---|
| T ×3 | App-Handyman | non | `PERSONNEL` | `ABSENT` |
| M ×3 | App-Handyman | **oui** | `PERSONNEL` | **`VISIBLE`** |
| C ×1 | maison | non | `PERSONNEL` | `VISIBLE` |
| **L ×3** | App-Handyman | **oui**, homonyme personnel **renommé hors jeu** | **`MAISON`** | — |

**La ligne L est ce qui rend le verdict opposable**, et elle a été ajoutée sur
objection de Mathieu — la première série ne la comportait pas. Sans elle, un
frontmatter cassé par la pose du marqueur (YAML invalide, `description` > 1024
caractères) aurait rendu le fichier maison silencieusement inchargeable et
produit **exactement** la même sortie que le rang conclu. La sonde prouve que le
*dossier* de la maison est scanné ; elle ne prouve rien sur la *chargeabilité
d'un fichier donné*. En L, l'homonyme personnel écarté, la maison rend son
marqueur — le fichier était donc chargeable, et le `PERSONNEL` de M est bien un
rang, pas un échec de chargement. Contrôles statiques concordants : YAML valide,
`description` à 249 caractères.

**Portée du verdict, plus large que la question posée :** la ligne C montre que
le personnel l'emporte aussi sur le `.claude/skills/` du projet courant, pas
seulement sur celui atteint par le drapeau.

**Conséquence directe :** les 10 skills de la maison ayant tous un homonyme
personnel, ils sont **tous servis par la copie**, jamais par la source ; un
`git pull` sur la maison ne change rien pour eux. `--add-dir` fonctionne
(prouvé par la sonde et par L), mais sa portée utile se limite aux skills
**sans homonyme personnel**. La décision qui en découle n'est pas tranchée ici :
voir `ISSUES-LOG.md`, ISSUE-001.

**Réplication Linux — rendue le 2026-07-27, CONCORDANTE. Le verdict n'est plus
une observation locale : il est prouvé sur deux plateformes.** Banc indépendant
(bac à sable Cowork, conteneur éphémère, `HOME` isolé, aucun effet de bord),
**même version de CLI 2.1.220**, montage refait de zéro : **15 runs, 15/15
conformes, aucun raté du modèle**. Verdict identique — personnel > projet et
personnel > `--add-dir`. Fiche complète annexée en **v1.1** :
`fiche-mesure-rang-skills-20260727-linux.md` (protocole, 15 sorties brutes,
limites, conditions de révision).

Le banc Linux porte l'équivalent de la ligne L **dès sa conception** (run D,
passé en premier par choix délibéré : s'il échoue, l'instrument est aveugle et
les autres runs ne valent rien). Il en tire l'appui que la série Windows n'a
obtenu qu'après objection : **la paire D/M** — configuration et drapeau
identiques, seule la présence de l'homonyme change, et le résultat bascule de
`MAISON` à `PERSONNEL`. C'est cette paire, et non la sonde, qui exclut
l'hypothèse du fichier maison invalide.

Deux précisions que le banc Linux apporte et que Windows n'avait pas établies.
La première est le **masquage** : le personnel ne fait pas que gagner
l'arbitrage, il **efface** l'homonyme de la liste des skills — celui-ci
n'apparaît sous aucune forme dérivée ni sous aucun nom qualifié. C'est cette
propriété, et non le rang seul, qui rend le doublon dangereux : une copie maison
périmée ne laisse **aucune trace observable en session**. Elle repose sur un
cinquième run, **E**, ajouté à la relecture (fiche v1.1) : une énumération
explicitement ouverte à tout préfixe ou suffixe, qui ne remonte qu'une seule
entrée `probe-rang`, celle du personnel, alors même que la maison est montée.
**Ne pas lire cette phrase sans sa réserve**, deux paragraphes plus bas : E
énumère ce que le modèle *déclare* voir, ce qui exclut une variante qualifiée
visible mais non une entrée qu'il omettrait de rapporter.
La seconde est le contrôle interne du run T (`SONDE=ABSENT` **et**
`PROBE=PERSONNEL` dans la même réponse prouvent que la maison personnelle était
lue alors que la maison montée ne l'était pas).

**Une leçon de forme, vue deux fois en deux jours et consignée comme telle.**
La v1.0 de la fiche affirmait déjà le masquage alors que D/T/M/C n'interrogeaient
qu'un **nom exact** — ils établissent qui répond à `probe-rang`, pas l'absence de
toute variante ailleurs dans la liste. L'affirmation dépassait sa mesure, et le
run E l'a mise à niveau. C'est exactement la faute que la ligne L avait corrigée
côté Windows : dans les deux cas un énoncé plus large que l'instrument, dans les
deux cas réparé par un run supplémentaire plutôt que par une réécriture
silencieuse. Les deux bancs l'ont commise indépendamment — ce n'est donc pas un
accident d'opérateur mais une pente du protocole lui-même, à contrer par une
question posée avant d'écrire : *de quel run cette phrase tient-elle sa portée ?*

**Ce que la concordance ne couvre pas** (repris de la fiche v1.1 § 6, à ne pas
sur-lire) : un seul nom de skill éprouvé ; la maison **plugin** hors périmètre,
comme la précédence à l'intérieur d'une même maison ; le run E énumère ce que le
modèle **déclare** voir — il exclut une variante qualifiée visible, non une
entrée que le modèle omettrait de rapporter ; verdict lié à **2.1.220** — le rang
est un comportement d'implémentation, pas un contrat documenté, donc toute montée
de version rouvre la question (→ V6, à rejouer avec **D, T, M et E**).

**État restauré après mesure, vérifié :** marqueurs retirés, sonde supprimée,
arbre maison à 0 modification, copie personnelle identique octet pour octet à
la sauvegarde du jour. Écart connu et normal après `git checkout` : le fichier
maison est en CRLF (normalisation `.gitattributes`), la copie personnelle en LF
— contenu identique, comparer le contenu et non les octets.

## 7. Risques et limites — nommés d'avance

1. **Le sync est un geste humain** (option A). Oublié, les machines divergent de la maison sans bruit. Mitigation : V5 + rapport de sync + éventuel contrôle de fraîcheur en démarrage de session. Si la friction se mesure, l'option B existe.
2. **F2 et F3 sont des comportements de l'outil, pas des lois.** Ils ont déjà changé une fois (la régression de F3 en est la preuve). Le protocole § 6 se rejoue après toute mise à jour majeure de Claude Code — c'est le prix d'appuyer une architecture sur un outil vivant.
3. **Les skills liés à deux projets à la fois** (tdd-enforcer sert suspension-intelligence aujourd'hui, App-Handyman en vague 2) forceront la question du § 3 plus tôt que prévu : généraliser le moteur, ou deux skills de projet distincts. À trancher au cas par cas, pas d'avance.
4. **Deux circuits de distribution irréductiblement séparés — mesuré, plus une hypothèse** (F9, 2026-07-24). La maison reste la source d'autorité unique des FICHIERS, mais elle alimente deux canaux sans aucun pont : le poste Windows (Claude Code — option D ou A, automatisable, `git pull` suffit) et le compte claude.ai qui sert l'Android (téléversement manuel d'un zip par skill, par utilisateur, via Settings > Features — manuel par conception de l'outil). Conséquences pratiques : la maison gagne une **routine d'empaquetage** (un petit script `Compress-Archive` produisant un zip par skill distribué, prêt à téléverser) et une **liste de contrôle** de ce qui est monté au compte, datée — car aucune mesure automatique ne détectera la dérive entre la maison et le compte. **TO VALIDATE avant de graver le geste — deux portes dans l'ordre :** (1) le compte claude.ai de Mathieu porte-t-il un plan éligible AVEC exécution de code activée ? Non → le circuit est **inconstructible en l'état** ; la limite se consigne datée et V7 est sans objet jusqu'à changement de plan. Oui → (2) la doc dit « Settings > Features » sans préciser la surface — l'app Android expose-t-elle le téléversement, ou faut-il téléverser depuis le web/desktop pour que ça descende sur mobile ? Mesurer (→ V7), ne pas supposer. Tant que ce circuit n'est pas construit, les sessions Android vivent sans les skills de la maison — limite assumée et datée.
5. **Ce document ne couvre toujours pas** : le partage au-delà d'une machine côté Claude Code (multi-poste → option C d'office), et les hooks et agents (mêmes principes, emplacements voisins, à traiter quand le besoin naît).

## Sources

- Documentation officielle skills (emplacements, priorité, liens par skill, surveillance) : https://code.claude.com/docs/en/skills
- Vue d'ensemble Agent Skills (emplacements par produit) : https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Régression du lien de dossier entier : https://github.com/anthropics/claude-code/issues/38051
- Référence plugins et places de marché : https://code.claude.com/docs/en/plugins-reference
- Motif dotfiles à liens par élément (partagé + local) : https://dylanbochman.com/blog/2026-01-25-dotfiles-for-ai-assisted-development
- Outils de sync communautaires (état de l'art, non retenus) : https://dev.to/runkids/how-to-sync-ai-skills-across-claude-code-openclaw-and-codex-in-2-minutes-226e
