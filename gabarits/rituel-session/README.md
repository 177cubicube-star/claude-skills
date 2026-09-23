# Gabarit — rituel de session (`recap` + `session-prep`)

**version du gabarit : 1.1.1**

Le champ `version:` des fichiers `SKILL.gabarit.md` porte **la version du
gabarit**, la même que ci-dessus. Une instance tient ensuite sa propre version
(décidé en pratique le 2026-09-23, au passage en 1.0.1).

Modèle de référence pour doter un projet de son propre couple
clôture / ouverture de session. **Ce n'est pas un skill** : rien ici ne se
déploie, rien ne se charge. On l'**instancie** dans le projet, où la copie
devient un skill local — politique « les skills sont locaux au projet par
défaut » (décision de Mathieu, journal du 2026-07-29/30 § 6).

**Pourquoi ce dossier est hors de `.claude/skills/`.** `deploy-skills.ps1`
copie *tout* dossier de `.claude/skills/` vers `~/.claude/SKILLS/`. Un gabarit
posé là deviendrait un skill personnel actif. Les fichiers portent en plus le
nom `SKILL.gabarit.md` : ni Claude Code ni le compte ne chargent ce nom. Garde
**par construction**, pas par vigilance.

---

## Fond et forme

Chaque fichier du gabarit est découpé en blocs balisés :

| Balise | Contenu | À l'instanciation |
|---|---|---|
| `<!-- 🔒 FOND:<id> -->` … `<!-- /FOND:<id> -->` | la méthode : honnêteté, preuves, aperçu avant écriture, DELTA… | **copié tel quel, jamais édité dans l'instance** |
| `<!-- ✏️ FORME:<id> -->` … `<!-- /FORME:<id> -->` | ce qui est propre au projet : chemins, commandes, scripts, gestes | **rempli pour le projet** |
| `{{…}}` | valeur ponctuelle (nom, suffixe) | remplacée |

Une amélioration du **fond** se fait **ici**, dans le gabarit (bump de version),
puis se reporte dans chaque instance. Une instance qui voudrait changer son fond
signale un besoin du gabarit, pas une adaptation locale.

---

## Marche à suivre — instancier dans un projet

L'instanciation se fait **dans une session Claude Code ouverte dans le projet
cible**, pas depuis Cowork, pour deux raisons mesurées. Le pont Cowork laisse
des verrous git orphelins (ISSUE-006) et ne sait pas supprimer. Surtout, il
**refuse toute écriture sous `.claude/`** (« Writing to .claude is not permitted
via remote tools », 1re instance, Dr-bobo, 2026-09-23 ; déjà consigné au journal
du 2026-07-24). Une session Cowork peut **préparer** une instance, mais pas la
poser. Compter une session courte.

### 0. Avant de commencer

| Vérification | Comment |
|---|---|
| Le dépôt du projet est propre | `git status --short` → rien, sinon committer ou ranger d'abord |
| La maison est à jour | `git -C <maison> pull`, puis noter `git -C <maison> rev-parse --short HEAD` (le sha à graver) |
| Le suffixe est libre | choisir un suffixe court (`ah` = App-Handyman). **Jamais** `recap` ni `session-prep` nus : ces noms appartiennent à `suspension-intelligente` et sont servis au compte. Vérifier qu'aucun `recap-<suffixe>` n'existe : `ls ~/.claude/SKILLS/` et `ls <projet>/.claude/skills/` |
| Le projet a-t-il déjà un rituel ? | si oui (un `recap` maison, un template), **le lire d'abord** : sa forme remplit le bloc FORME ; ses scripts testés se déclarent au lieu d'être remplacés |

### 1. Prompt à coller dans la session Claude Code du projet

Remplacer les trois valeurs entre chevrons, puis coller :

```text
CONTEXTE
Je veux doter ce dépôt d'un rituel de session (ouverture + clôture) à partir du
gabarit « rituel-session » de ma maison des skills :
<maison>/gabarits/rituel-session/ (lire README.md en entier avant tout).
Suffixe du projet : <suffixe>. Nom du projet : <nom>.

TÂCHE — une seule : instancier le gabarit dans ce dépôt.

CONTRAINTES
- Plan d'abord : liste des fichiers créés et valeurs FORME proposées, puis
  attends mon GO avant toute écriture.
- Blocs « 🔒 FOND » : copiés à l'identique, jamais édités.
- Blocs « ✏️ FORME » : chaque valeur est MESURÉE sur ce dépôt (chemins lus,
  commandes exécutées une fois avec leur sortie réelle montrée). Rien de
  mémoire. Valeur sans objet → « aucun ».
- Si le dépôt a déjà un template de continuité, un TODO, des ADR, des fils ou
  des scripts de rituel : les déclarer dans la FORME, ne rien remplacer.
- Noms : recap-<suffixe>, session-prep-<suffixe>. version: 1.0.0.
  Renseigner la ligne « Instancié depuis » (version du gabarit + sha de la maison).
- Date : appliquer la règle « la date se mesure, et la mesure se contrôle » du
  fond (instrument valide, sinon « NON MESURÉE »). Lectures git : --no-optional-locks.
- Lecture des règles (session-prep) : lister les titres du fichier de règles,
  proposer un MOTIF, exécuter la commande awk de l'étape 5 avec ce motif et me
  MONTRER le nombre de lignes extraites sur le total, les titres retenus et les
  sections laissées de côté ; attendre mon choix. Une section qui mêle
  référence et règle ENTRE dans la liste si elle porte une règle de travail
  active : la borne vient de la liste fixe, pas du nombre de lignes. Le motif
  s'écrit dans le bloc « Lecture des règles », jamais dans le tableau.
- Aucun commit sans mon GO ; git add nommé, jamais -A.

LIVRABLE
1. .claude/skills/recap-<suffixe>/SKILL.md
2. .claude/skills/session-prep-<suffixe>/SKILL.md
3. docs/CONTINUITE-SESSION-TEMPLATE.md (seulement si le dépôt n'en a pas)
4. La sortie des deux contrôles du § 3 du README du gabarit, exécutés dans les
   deux sens : placeholders restants = 0 (avec contrôle positif sur le
   gabarit), et FOND identique au gabarit.
```

### 2. Fichiers attendus dans le projet

```
<projet>/.claude/skills/recap-<suffixe>/SKILL.md         ← recap/SKILL.gabarit.md
<projet>/.claude/skills/session-prep-<suffixe>/SKILL.md  ← session-prep/SKILL.gabarit.md
<projet>/docs/CONTINUITE-SESSION-TEMPLATE.md             ← template-continuite.md (si absent)
```

Le chemin du template est libre : c'est la valeur `{{TEMPLATE}}` du bloc FORME
qui fait foi.

### 3. Contrôles avant commit

À exécuter, pas à déclarer (principe transverse 7) :

```bash
G=<maison>/gabarits/rituel-session
I=<projet>/.claude/skills
# a) plus aucun placeholder — contrôle positif d'abord : le gabarit doit en contenir
grep -c '{{' "$G/recap/SKILL.gabarit.md"          # attendu > 0
grep -n '{{' "$I"/recap-*/SKILL.md "$I"/session-prep-*/SKILL.md   # attendu : rien
# b) le fond est intact
fond() { awk '/<!-- 🔒 FOND:/,/<!-- \/FOND:/' "$1" | tr -d '\r'; }
diff <(fond "$G/recap/SKILL.gabarit.md")        <(fond "$I"/recap-*/SKILL.md)        && echo "FOND recap intact"
diff <(fond "$G/session-prep/SKILL.gabarit.md") <(fond "$I"/session-prep-*/SKILL.md) && echo "FOND session-prep intact"
```

`tr -d '\r'` normalise les fins de ligne. Git réécrit ces fichiers en CRLF à
l'extraction (`text=auto`), et comparer des octets bruts fabriquerait une
fausse divergence (ISSUE-004). Sous Windows, ces commandes tournent dans Git Bash.

### 4. Commit dans le dépôt du projet

`git add` **nommé** des deux dossiers de skills (et du template s'il est
nouveau). Aucun geste dans la maison : le gabarit n'a pas changé.

### 5. Premier usage : le vrai test

Les procédures en ligne non calibrées (voir § « Ce que le fond porte ») font
leur premier tour ici.

1. Lancer `/session-prep-<suffixe>`. Attendus : un briefing en lecture seule,
   les lignes 📖 et 🕐 présentes, et un verdict de continuité (`INDÉTERMINÉ —
   aucun recap` est normal au tout premier usage).
2. En fin de session, lancer `/recap-<suffixe>`. Attendus : un aperçu, puis un
   « oui », puis l'écriture ; le fichier porte `HEAD : \`sha\``.
3. Pousser, puis relancer `/session-prep-<suffixe>`. Attendu : **OK**, et pas
   GAP. Si c'est GAP, les fichiers de clôture sont mal déclarés dans la FORME.
4. **Projet avec du code seulement** : faire une session **sur une branche de
   travail**, avec au moins un commit de code, puis la clôturer. Attendus :
   `recap` classe la session « code » et lance les instantanés déclarés (tests,
   dette) ; `session-prep` affiche les axes de synchronisation de la branche.
   Première occasion de roder ce qu'un dépôt de documents ne peut pas exercer.
5. Tout écart va dans le store d'observations du projet (`task-observer-perso`),
   et remonte au gabarit s'il touche le fond.

---

## Utiliser les instances

| Où | Comment ça se charge | Ce qu'il faut faire |
|---|---|---|
| **Claude Code**, ouvert dans le projet | le `.claude/skills/` du projet est lu directement | rien : `/session-prep-<suffixe>` en ouverture, `/recap-<suffixe>` en clôture |
| **Cowork / Chat** (compte claude.ai) | seulement ce qui est téléversé au compte, et servi dans **toutes** les sessions | téléverser l'instance, voir ci-dessous — ou s'en passer |

**Téléverser une instance au compte.** C'est le rituel du README de la maison,
étape 6 : un zip avec des `/`, le nom du dossier égal au `name`, une
`description` de 1024 caractères au plus. Deux points propres aux instances :

- **Leur `description` nomme le projet.** Sur le compte, toutes les instances
  sont visibles en même temps ; c'est ce nom qui fait qu'une session sur le
  projet A ne déclenche pas le recap du projet B.
- **Le `recap` et le `session-prep` de `suspension-intelligente` sont au compte,
  avec une description qui se dit « générique ».** Ils peuvent se déclencher à
  la place d'une instance. Il faut vérifier après téléversement, en demandant à
  la session **d'où vient** le skill chargé, puis en lisant `version:` dans ce
  fichier-là (README de la maison, étape 7).

---

## Mettre à jour une instance quand le gabarit évolue

1. **Repérer les instances**, qui se mesurent au lieu de se lister :
   ```bash
   grep -l "Instancié depuis le gabarit \`rituel-session\`" <racine-des-projets>/*/.claude/skills/*/SKILL.md
   ```
   Le sha et la version gravés dans chaque instance disent de quel état du
   gabarit elle part.
2. **Mesurer l'écart** : le contrôle 3 b), lancé contre le gabarit courant.
   Un diff non vide = le fond de l'instance est en retard (ou a été édité à
   tort).
3. **Reporter** : remplacer chaque bloc FOND de l'instance par celui du
   gabarit. Dans les blocs FORME, **ne modifier aucune valeur existante** ; si le
   gabarit ajoute une **clé** de forme (une ligne de la table), l'ajouter avec
   sa valeur **mesurée** sur le projet, ou `aucun`. Si le gabarit **déplace** une
   clé (d'une cellule vers un bloc, par exemple), déplacer la valeur **sans la
   changer**. Relancer ensuite 3 a) et 3 b) :
   le contrôle a) attrape toute clé ajoutée mais laissée en `{{…}}`.
4. **Bumper l'instance** (`version:` +0.1.0 si le fond change son comportement,
   +0.0.1 pour une retouche), mettre à jour la ligne « Instancié depuis », puis
   committer dans le dépôt du projet.

**Versionnement du gabarit.** La version en tête de ce README suit le contenu de
`recap/`, de `session-prep/` et de `template-continuite.md`. Elle monte à chaque
changement de ces fichiers (retouche +0.0.1 · ajout +0.1.0 · refonte +1.0.0).
Une modification de ce seul README ne la change pas : les instances n'en
dépendent pas. Git date ces retouches.

**Une instance qui a besoin d'un fond différent** signale un besoin du gabarit,
pas une adaptation locale. On améliore le gabarit, ou bien le projet sort du
gabarit en le disant (le skill redevient simplement local, et la ligne
« Instancié depuis » est retirée).

---

## Ce que le fond porte, et d'où il vient

Chaque règle du fond est née d'un incident mesuré. Les pointeurs servent à
retrouver pourquoi ; ils ne se recopient pas dans les instances.

| Règle du fond | Origine |
|---|---|
| Le recap **écrit** `HEAD : \`sha\``, mesuré sur la réf distante | obs 21, store `Suspension-intelligence` |
| session-prep lit les recaps **sur la réf**, verdict distinct si le dernier n'y est pas | obs 23, même store |
| TODO : motif mesuré, contrôle positif, ligne 📖 obligatoire | obs 22, même store |
| Date mesurée par un instrument **contrôlé** (un `+0000` pour un fuseau non-UTC = invalide), jamais par `date` nu ni l'en-tête de session | ISSUE-007, `claude-skills` ; défaut Git Bash trouvé par la 1re instance (Dr-bobo), 2026-09-23 |
| Lectures git en `--no-optional-locks` (pont Cowork) | ISSUE-006, `claude-skills` |
| `fetch` en échec (403 en VM) → le déclarer, ne pas le taire | TODO `claude-skills`, 2026-07-27 |
| DELTA « ne pas refaire » appuyé par une preuve ; recaps frères du jour | `session-prep` de `suspension-intelligente` |
| Aucun VALIDÉ sans accord explicite ; aperçu puis « oui » avant écriture | `recap` de `suspension-intelligente` |

**État de calibration des procédures en ligne du fond** (principes transverses
1, 9, 11) :

| Procédure | État |
|---|---|
| Verdict de continuité (session-prep, étape 2) | **Rodé sur dépôt jetable, 2026-09-23** : 5 cas (aucun recap, RECAP_LOCAL, OK après clôture, GAP, sans HEAD) rendent le verdict attendu, 0 verrou restant. Ce rodage a **trouvé un défaut** : sans exclure les fichiers de clôture, chaque clôture propre rendait GAP ; corrigé et re-mesuré. **Validé sur un vrai dépôt, Dr-bobo, 2026-09-23** : `INDÉTERMINÉ — aucun recap` avant le premier recap, puis **OK** après la clôture poussée (`0 commit hors sessions/ après 1495dbe`, briefing @ `0282b6a`) — le faux GAP du rodage n'est pas revenu. |
| Contrôles d'instanciation (§ Instancier, étape 5) | **Rodés dans les deux sens** : instance correcte en CRLF acceptée, mutation du fond détectée, modification de forme seule acceptée, placeholder oublié détecté. |
| Procédure « Mettre à jour une instance » | **Exercée une fois, 2026-09-23** : report 1.0.0 → 1.0.1 dans Dr-bobo (commit `1495dbe`). FOND des deux instances identique au gabarit `bc77723`, FORME inchangée, provenance mise à jour, 0 placeholder — vérifié sur les fichiers. |
| Mesure de la date (v1.0.1) | **Rodée en conteneur, 2026-09-23** : fuseau connu accepté ; fuseau inconnu → repli UTC **attrapé** (le défaut réel, reproduit : `exit 0`, `+0000`) ; projet réellement en UTC **non rejeté** ; aucun instrument valide → « NON MESURÉE ». **Validée sous Windows, dans le skill, 2026-09-23 (Dr-bobo)** : `TZ` déclaré invalide (`+0000`), PowerShell retenu — `recap-drbobo` à `14:34 -04:00`, `session-prep-drbobo` à `14:48 -04:00`. |
| Axes de sync, shortlist anti-sur-claim, gate code/docs | **Non calibrés** — gardes par vigilance. Première instance (Dr-bobo, projet sans code) : **non exercés** — ni code, ni branche de travail, ni claim à auditer. |
| Recaps frères du même jour (session-prep, étape 2) | **Déclaré conforme par Mathieu, 2026-09-23** (Dr-bobo, après `recap-20260923-02`) : deux recaps lus, DELTA commun, pas de doublon, `OK`. Briefing **non versé** : c'est une déclaration, pas une mesure lue ici. **Observé ensuite sur un briefing lu ici** (Dr-bobo, @ `00fd682`) : trois recaps du jour lus, `OK`. |
| Lecture des règles par sections (v1.1.0 → 1.1.1) | Rodée en conteneur (awk : un défaut `in` trouvé et corrigé). **Validée en conditions réelles, Dr-bobo, 2026-09-23** : 186/236 lignes, 9 sections exactes, briefing @ `00fd682`. **Défaut trouvé par ce premier passage** : le motif, rangé dans une cellule de tableau, y était écrit avec `\|` ; copié tel quel, il extrait **0 ligne**. L'agent a compensé de lui-même, en retirant les `\` : une garde par jugement. **1.1.1** : le motif sort du tableau, dans un bloc copié tel quel (garde par construction). Autre défaut : la ligne 📏 unique perdait deux interdits extraits → une ligne par interdiction active. |
| Archivage du journal (v1.1.0) | **Rodé en conteneur, 2026-09-23** : TODO de 6 lignes → 4 restantes + 3 archivées − 1 pointeur = CONFORME ; une ligne perdue en route → ÉCART détecté. Non exercé sur un vrai projet. |
| Défaut cosmétique relevé | au premier briefing réel, la ligne `CONTINUITÉ` a été affichée deux fois — à surveiller, non corrigé |

Là où un projet possède un script testé qui fait le même travail,
son bloc FORME le déclare et le fond l'invoque à la place.

---

## Contrainte de conception — toute lecture est bornée

**Origine.** L'observation de Mathieu qui a déclenché la réorganisation des
skills : l'historique grossissait sans arrêt, et l'exécution des skills prenait
un temps fou. Un rituel de session est exactement le genre d'outil qui recrée ce
problème en silence : chaque clôture écrit, chaque ouverture relit. Traces de ce
motif dans les documents : obs 22 (store `Suspension-intelligence`, un TODO de
591 lignes lu tronqué sans le dire) et friction 7.12 (journal de la maison,
2026-07-30).

**Règle.** Tout ce que le rituel **lit** à chaque session a une borne qui ne
dépend pas de l'âge du projet. Tout ce qu'il **écrit** est un fichier nouveau,
ou un ajout à un fichier que quelque chose archive.

| Élément | État en 1.1.0 |
|---|---|
| Taille des skills | environ 255 lignes chacun en 1.1.0 (240 en 1.0.1) — **borné** |
| Recaps lus par `session-prep` | ceux du jour le plus récent seulement — **borné par construction** |
| TODO lu par `session-prep` | par `grep` sur les items ouverts, avec un contrôle positif — **borné par le nombre d'items ouverts**, pas par l'âge du fichier ; les items cochés ne sont jamais relus |
| Recap écrit par `recap` | un fichier neuf par session — **n'alourdit aucun fichier lu** |
| Journal alimenté par `recap` (TODO, fils) | **1.1.0** : mesuré à chaque clôture (ligne 📏) ; au-delà du seuil déclaré, archivage **proposé**, jamais imposé, avec un contrôle de conservation — **borné par proposition**, si le seuil et les archives sont déclarés |
| Fichier de règles actives lu par `session-prep` | **1.1.0** : mesuré, lu par **sections déclarées** ou sous un **plafond** de lignes, portée déclarée en 📖 — **borné** |

**Limite assumée** : la borne du journal dépend de la FORME. Un projet qui
déclare `aucun` pour le seuil ou pour les archives retombe dans le non-borné,
et le rituel le **dit** (ligne 📏, ou signalement dans l'aperçu), sans le
corriger à sa place. Dr-bobo (ni TODO ni fils) n'est pas concerné ; un projet
comme `suspension-intelligente` le serait.

---

## Fichiers

| Fichier | Rôle |
|---|---|
| `README.md` | ce mode d'emploi |
| `recap/SKILL.gabarit.md` | clôture de session |
| `session-prep/SKILL.gabarit.md` | ouverture de session, lecture seule |
| `template-continuite.md` | template minimal du recap, bloc d'en-tête `HEAD` compris |
