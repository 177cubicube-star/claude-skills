# Carte de tes skills — inventaire et placements possibles

*Établie le 24 juillet 2026 · **lecture seule** : aucune modification faite à ton installation · verdicts mesurés (md5 / version / date), jamais au jugé.*

> **Maison de ce document : le dépôt `claude-skills` (racine)** — décision Mathieu 2026-07-24. Toute copie ailleurs (ex. `Projects\`) est périmée dès divergence.
>
> **Mise à jour de clôture (24 juillet, soir)** : le chantier « maison des skills » a atteint son palier. Les skills de la maison vivent désormais sous **`claude-skills\.claude\skills\`** (déplacement `git mv`, à ne pas défaire) ; le mécanisme de distribution du poste est le **drapeau `--add-dir`** via le lanceur **`claude-ah`** (V0 vert, V0-bis rouge → F10, épreuve lanceur verte) ; **prompt-forge est requalifié** : deux skills différents partageant un nom (~40 % commun), jamais distribué (exclusion ADR-005). L'état de référence complet vit dans `skills-maisons-et-acces.md` (même dossier) et le document d'autorité v6 (racine de la maison).

---

## Ce que ce document est — et n'est pas

C'est une **carte**, pas un plan de reconstruction. Ta structure actuelle — le fruit de tes heures de mise en ordre — est **saine**. Ce document ne te demande de rien refaire : il sert à *décider*, d'un coup d'œil, où placer un skill et lequel peut être réutilisé ailleurs.

Les quelques écarts relevés sont présentés comme des **faits à connaître**, pas comme une liste de corvées. Chaque remède éventuel est optionnel, minime, et reste ta décision.

---

## La boussole : trois niveaux où un skill peut vivre

Le niveau décide *où le skill est visible*. « Avoir un skill partout » = le faire monter d'un niveau — quand sa nature le permet.

| Niveau | Où | Visible dans… |
|---|---|---|
| **Projet** | `<projet>/.claude/skills/` | ce projet seulement |
| **Utilisateur / global** | ton compte claude.ai (Cowork/Chat) · `~/.claude/skills/` (local) | **tous** tes projets, automatiquement |
| **Plugin / marketplace** | repo empaqueté (`claude-skills`) installé à la demande | selon l'installation |

**Règle de nature (ton principe f) :** un skill qui *nomme* un ADR, un chemin ou une règle d'un projet ne peut pas monter au global — hors contexte, il jugerait à côté. Seul un skill agnostique voyage tel quel.

---

## Inventaire complet

### 1. Skills transversaux — maison-source : repo `claude-skills`

**Emplacements de cette maison :** GitHub (`177cubicube-star/claude-skills`, branche `main`) · clone local `C:\Users\mat_g\Documents\Claude\claude-skills` (hors `Projects`) · le compte pour les skills promus.

Tous versionnés proprement (v1.x). **Vérifié le 24 juillet : clone local = GitHub, 10/10 octet pour octet** ; et les 2 skills déployés sont aussi identiques au compte. **Aucune divergence côté transversal.**

| Skill | Version | Clone local ↔ GitHub | Sur le compte ? | Où il peut aller |
|---|---|---|---|---|
| task-observer-perso | 1.2.0 | ✅ identique | ✅ **identique** | déjà global (tous projets, Cowork/Chat) |
| doc-coauthoring-perso | 1.1.0 | ✅ identique | ✅ **identique** | déjà global |
| context-file-optimizer | 1.0.0 | ✅ identique | ⚪ dort | déployable au compte → global |
| skill-intake | 1.0.0 | ✅ identique | ⚪ dort | déployable au compte → global |
| defuddle | 1.0.0 | ✅ identique | ⚪ dort | déployable, ou local |
| grill-me | 1.0.0 | ✅ identique | ⚪ dort | déployable, ou local |
| json-canvas | 1.0.0 | ✅ identique | ⚪ dort | outil Obsidian — plutôt local |
| obsidian-bases | 1.0.0 | ✅ identique | ⚪ dort | outil Obsidian — plutôt local |
| obsidian-cli | 1.0.0 | ✅ identique | ⚪ dort | outil Obsidian — plutôt local |
| obsidian-markdown | 1.0.0 | ✅ identique | ⚪ dort | outil Obsidian — plutôt local |

> **Lecture :** tes deux vrais skills perso sont déjà partout où tu travailles en Cowork, et la source est parfaitement synchro (disque = GitHub = compte). Les huit autres existent à la source mais ne tournent nulle part — c'est un *choix à faire* (les déployer ou les laisser), pas un problème.

### 2. Skills spécifiques à un projet — maison : le repo du projet

Ils codent les règles d'un projet ; ils **restent chez eux**.

| Skill | Maison | Version | Sur le compte ? | Où il peut aller |
|---|---|---|---|---|
| architecture-guard | Suspension | — | ✅ (identique) | reste Suspension |
| tdd-enforcer | Suspension | ≈ v1.6 (repo) | ⚠️ **périmé** (mai) | reste Suspension ; copie compte à rafraîchir si voulu |
| scraping-guard | Suspension | v0.2.1 | ❌ | reste Suspension |
| portal-guard | Suspension | — | ❌ | reste Suspension |
| rag-counsel | Suspension | 0.1.0 | ❌ | reste Suspension |
| recap | Suspension | 2.1.0 | ✅ (identique) | reste Suspension — nomme ADR-026 / Notion (variante *vault* distincte, voir §2bis) |
| session-prep | Suspension | 1.1.1 | ✅ (identique) | reste Suspension (variante *vault* distincte, voir §2bis) |
| prompt-forge | Suspension **+** App-Handyman | — | ❌ | par-projet, adapté (2 variantes légitimes) |

> **Lecture :** pour ceux-là, « les avoir ailleurs » n'est pas de la distribution mais de l'*adaptation* (comme prompt-forge) — voir §2bis, où recap et session-prep sont **déjà** adaptés pour le vault.

### 2bis. Skills du vault `cerveau-suspension` — maison : `Documents\cerveau-suspension\.claude\skills`

Un **quatrième foyer**, hors `Projects`. Le vault Obsidian a ses propres skills, adaptés à son contexte (notes, pas code).

| Skill | Nature | Rapport aux autres maisons |
|---|---|---|
| tri-inbox | tri de l'inbox du vault | **source de tri-inbox** — identique au compte ✅ (question résolue) |
| recap | variante *allégée* (5,5 Ko vs 22 Ko), parle du vault | **fork volontaire**, distinct de la version Suspension |
| session-prep | variante *allégée* (9 Ko vs 32 Ko), 0 référence code | **fork volontaire**, distinct de Suspension |
| synchro-miroir | rapatrie repo → vault (sens unique, sur demande) | **skill propre au vault**, nulle part ailleurs |

> **Insight :** recap et session-prep ne sont donc **pas** « prisonniers de Suspension » — tu les as **déjà adaptés par projet** (une version code pour Suspension, une version allégée pour le vault). C'est le bon patron : on adapte par projet, on ne partage pas une copie unique. La « généralisation » évoquée plus haut n'aurait de sens que si tu voulais UNE version servant partout — ce que tu ne fais pas.
>
> Note : aucun des 4 skills du vault n'a de champ `version:` (même écart de conformité ADR-028 que les gardes de Suspension).

### 3. Skills fournis par Anthropic — déjà partout, rien à gérer

- **skill-creator** — sur ton compte, c'est la version d'Anthropic (`anthropic-example`), **plus récente que ta copie du repo Suspension**. → utilise celle d'Anthropic ; ta copie repo peut disparaître.
- **canvas-design**, **morning** — `anthropic-example`, globaux.
- **pdf**, **xlsx**, **pptx**, **docx** — skills de format Anthropic, globaux.
- **session-start-hook** — présent sur le compte (hook).

### 4. Cas à part — résolu

- **tri-inbox** — sa maison-source est le **vault** (`cerveau-suspension\.claude\skills`), et la copie du compte en est **identique** ✅. Question fermée (voir §2bis).

---

## Les faits à connaître (aucun n'exige d'action)

1. **tdd-enforcer périmé sur le compte.** Cowork/Chat chargent la version de mai, *sans* le correctif ISSUE-036. Sans effet tant que tu fais du TDD en **local** (Claude Code lit le repo à jour). Remède optionnel si tu veux Cowork à niveau : ré-uploader la version repo (~2 min).
2. **skill-creator, ta copie repo est en retard** sur celle d'Anthropic. Remède sans risque : la supprimer, garder celle d'Anthropic.
3. **Huit transversaux dorment** dans `claude-skills`. Disponibles à déployer si tu les veux globaux ; sinon laisse-les (les outils Obsidian sont sans doute destinés au local).
4. **recap / session-prep sont spécialisés.** Pertinent seulement le jour où tu voudrais les utiliser dans d'autres projets ; à ce moment-là seulement, on les généralise. Pas avant.

---

## Ta grille de décision pour tout futur skill

Quatre questions, dans l'ordre :

1. **Le skill nomme un ADR, un chemin, une règle d'UN projet ?** → il reste dans ce projet.
2. **Il est agnostique (aucun fait de projet) ?** → il va dans `claude-skills`, puis tu le déploies au compte = global partout.
3. **Il vient d'Anthropic ?** → rien à faire, il est déjà partout.
4. **Règle d'or (ADR-028) :** une seule maison-*source* par skill ; le compte et le disque sont des *cibles*, jamais éditées à la main.
