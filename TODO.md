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

- [ ] Committer les 3 documents déposés à la racine du repo le 2026-07-24
      (`carte-skills.md`, `skills-maisons-et-acces.md`, `TODO.md`) —
      staging **nommé**, jamais `-A` (règle d'ordre du README).
- [ ] Supprimer les doublons périmés dans `Projects\`
      (`carte-skills.md`, `skills-maisons-et-acces.md`) — maison unique
      décidée le 2026-07-24 : le repo. Geste de la main de Mathieu
      (le pont ne supprime pas).
- [ ] Ranger `audit_suspension_intelligente_detaille (1).md` (71 Ko, racine
      du repo) vers le dépôt qu'il concerne — obs 15 : « le dépôt ouvert
      n'est pas le propriétaire d'un fait ».

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
