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
- [ ] **Révoquer l'accès GitHub de ChatGPT/Codex** — décidé le 2026-07-26
      après l'incident d'import. Geste de la main de Mathieu.
      Vérification : l'entrée ne doit plus figurer dans les applications
      autorisées du compte GitHub.
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

## À faire — chantiers, dans l'ordre hérité (feuille de route, passation 3 § 8)

1. [ ] **Sauvegarde datée** de `~\.claude\skills\` (robocopy vers
       `skills-sauvegarde-AAAAMMJJ\`) — préalable à toute écriture là-bas.
2. [ ] **Mesure du rang `--add-dir` vs personnel homonyme** dans la chaîne
       F2 — marqueur délibéré + sonde posée après push (forme forte).
       C'est LA mesure qui débloque la généralisation de prompt-forge.
3. [ ] **Étape 3 du § 5** (consolidation — presque vide, copies identiques
       mesurées) — conditions : sauvegarde faite + GO explicite.
4. [ ] **Traitement des observations** — file : obs 8, 11-18 (App-Handyman)
       + obs 1-5 (claude-skills). Chaque correction se fait DANS la maison
       puis redescend par le circuit — premier aller-retour réel.
5. [ ] **Entrée de Suspension-intelligente** dans la migration — sur GO
       distinct, avec son propre inventaire ; dégèle recap/session-prep,
       ferme l'obs 8.
6. [ ] **Circuit Android** — V7-pre d'abord (plan payant + exécution de
       code au compte : la porte peut être fermée), puis V7, puis la
       routine d'empaquetage zip.

## Sujets garés — ne rouvrir que sur leur condition

| Sujet | Condition de réouverture |
|---|---|
| Copie `~\.claude\skills\` (redondante pour `claude-ah`, utile à `claude` nu) | décision à froid de Mathieu — rien ne se supprime avant |
| Lanceur `claude-ah` mono-projet | entrée du 2ᵉ projet (un `claude-si`, ou généralisation du lanceur) |
| Option C (plugins/marketplace) | multi-poste Claude Code, ou stabilité de la maison (1 mois sans changement de structure) |
| Divergences héritées de l'audit Cowork (tdd-enforcer périmé au compte ; skill-creator repo < Anthropic) | décision de Mathieu — hors périmètre du chantier maison |

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
