# claude-skills

Maison git des skills Claude **transversaux** de Mathieu — ceux qui servent dans plusieurs projets (ou hors de tout projet). **Ce repo est la source de vérité unique** : toute modification d'un skill se fait ICI, jamais dans les copies déployées.

Les skills **spécifiques à un projet** (recap, session-prep, tdd-enforcer, architecture-guard…) ne vivent PAS ici : leur maison est le `.claude/skills/` du repo de leur projet.

---

## Principe : une maison par skill

| Emplacement | Rôle | On y édite ? |
|---|---|---|
| Ce repo (`.claude/skills/<nom>/`) | **Source de vérité** | ✅ Oui — uniquement ici |
| Compte claude.ai (Cowork/Chat) | Cible de déploiement | ❌ Jamais |
| `~/.claude/SKILLS/` (Claude Code local) | Cible de déploiement | ❌ Jamais |

Éditer une copie déployée recrée la « dérive des maisons multiples » : deux versions divergentes sous le même nom, des sessions qui se contredisent. C'est le problème que ce repo existe pour éliminer.

---

## Structure

```
claude-skills/
├── README.md            ← ce fichier
└── .claude/
    └── skills/
        └── <nom>/
            ├── SKILL.md     ← frontmatter: name, version, description
            └── references/  ← fichiers d'appui (optionnel)
```

**Pourquoi `.claude/skills/` et pas `skills/`** (décision du 2026-07-24, voir `2026-07-23-proposition-maison-skills.md` § 4 option D) : c'est le seul chemin qu'une session lit à la source via `--add-dir <clone>`. Sous `skills/`, la maison n'était qu'un entrepôt qu'il fallait recopier ; sous `.claude/skills/`, elle est directement lisible — `git pull` suffit. Le déplacement est un renommage git : l'historique de chaque skill est intact.

Le frontmatter de chaque `SKILL.md` est l'autorité sur sa version — pas de table d'inventaire recopiée ici (elle divergerait). Pour lister l'état :

```bash
grep -H -A2 "^name:" .claude/skills/*/SKILL.md | grep -E "name:|version:"
```

---

## Rituel de déploiement (à chaque modification)

1. **Éditer la source** : `.claude/skills/<nom>/SKILL.md` dans ce repo, rien d'autre.
2. **Vérifier les correctifs en attente** (log d'observations task-observer) — toute correction notée « à appliquer à la ré-émission » s'applique maintenant.
3. **Monter `version:`** — toujours, même pour une ligne. Deux contenus différents ne portent jamais le même numéro. Retouche : +0.0.1 · ajout : +0.1.0 · refonte : +1.0.0.
4. **Contraintes d'upload claude.ai** (mesurées 2026-07-22) : `description` ≤ 1024 caractères · nom du dossier = `name` du frontmatter · `SKILL.md` requis.
5. **Commit + push** ce repo — **par `git add` nommé, jamais `git add -A` ni `git add .`, tant qu'une sonde de mesure vit dans `.claude/skills/`** (règle du 2026-07-24). Une sonde est un skill jetable, non suivi par conception ; un staging global l'embarquerait dans l'historique de la maison, où elle n'a rien à faire.
   **Règle plus forte, à préférer chaque fois qu'elle est applicable : poser la sonde APRÈS le push, jamais avant.** Le séquencement rend l'erreur impossible au lieu de la surveiller ; le `git add` nommé n'est que le repli pour le cas où une sonde doit coexister avec un commit. Vérification en une commande : `git status --short` doit montrer la sonde en `??` avant ET après le commit.
6. **Déployer vers chaque cible** où le skill doit tourner :
   - Compte claude.ai (Cowork/Chat) : zipper le dossier du skill → Personnaliser → Compétences → supprimer l'ancien → téléverser → relancer l'app desktop au complet.
   - Disque (Claude Code local) — **une commande, depuis la racine du dépôt** :

     ```powershell
     .\deploy-skills.ps1                 # rapport seul : que changerait un déploiement ?
     .\deploy-skills.ps1 -Apply -Backup  # déploie, après sauvegarde datée
     ```

     **Cette étape n'est pas optionnelle, et c'est mesuré** (V3-bis, 2026-07-26 Windows ; répliqué 2026-07-27 Linux ; CLI 2.1.220). Le skill personnel l'emporte sur son homonyme atteint par `--add-dir` **et** sur celui du `.claude/skills/` du projet courant — et il l'**efface** de la liste. Les 10 skills de la maison ayant tous un homonyme personnel, **ils sont tous servis par la copie, jamais par la source** : `git pull` ne déploie rien, et une copie périmée est **invisible** en session. Le script est le seul détecteur.

     Ce que V0/V0-ter avaient prouvé reste vrai et n'est pas rétracté : `--add-dir` lit bien la maison à la source — mais seulement pour les skills **sans homonyme personnel**. La question « retirer les copies personnelles ? » est **tranchée le 2026-07-27** : non, option 2 retenue (`ISSUES-LOG.md`, ISSUE-001 § 0).
7. **Vérifier — un chemin par cible, jamais une question en l'air.** Ouvrir le fichier de la cible testée et en lire `version:` plus un marqueur de contenu propre à la nouvelle version. Pas de lecture = pas de déploiement.

   | Cible | Fichier à ouvrir | Depuis |
   |---|---|---|
   | Maison | `.claude/skills/<nom>/SKILL.md` | ce dépôt |
   | Disque | `~/.claude/SKILLS/<nom>/SKILL.md` | session Claude Code locale |
   | Compte | **le chemin que la session annonce** — le lui demander | session claude.ai (Cowork/Chat) |

   **Pour le compte, demander le chemin avant de le dicter.** Il varie selon le
   type de session : `/mnt/skills/user/<nom>/` mesuré le 2026-07-30,
   `/root/.claude/skills/<nom>/` mesuré le 2026-07-31 dans une autre session.
   Un témoin qui code le chemin en dur échoue sur la moitié des sessions, et son
   échec ressemble à « le skill n'est pas là ». Forme juste : « d'où vient le
   skill `<nom>` que tu as chargé ? » puis « lis ce fichier-là et rends `version:`
   + le marqueur ».

   **Pourquoi le chemin et pas la question** (obs 19 du store, 2026-07-30). Les trois circuits portent le même contenu sous le même nom — c'est justement ce qu'on cherche à établir. Aucune question sur le contenu ne peut donc dire *lequel* a répondu : le seul discriminateur est l'emplacement lu, et il doit être écrit dans le témoin, pas déduit de la réponse. Un témoin qui admet plusieurs sources mesure la plus commode.

   **Ne jamais formuler la consigne en négatif** (« réponds sans lire aucun fichier »). Le contenu d'un skill **n'est pas préchargé** en session : seuls son `name` et sa `description` entrent en contexte. Utiliser le skill *signifie* lire son fichier — une interdiction de lire ne laisse que le blocage ou la fabrication. Mesuré le 2026-07-30, sur trois témoins dont deux faux.

   **`version:` lu dans le fichier est fiable ; demandé au listing d'une session, non** (`VERSION=inconnue` sur 2 runs / 3, mesuré le 2026-07-27). La réserve porte sur le listing, pas sur le fichier ouvert.

   **Borne de validité — et la preuve qu'elle sert.** Le chemin du compte est un fait d'environnement, pas un contrat documenté — même statut que la borne CLI 2.1.220. Écrit ici le 2026-07-30 comme `/mnt/skills/user/`, il était **faux dès le lendemain** : une session du 31 n'avait pas de `/mnt/skills/` du tout et chargeait depuis `/root/.claude/skills/`. Un jour d'écart a suffi. C'est pourquoi la table ci-dessus ne donne pas de chemin pour le compte : la borne ne suffisait pas, il fallait retirer le chemin du geste lui-même.

Piège connu : « This skill name is already in use » peut persister après suppression (réservation résiduelle côté serveur ; noms du catalogue d'exemples Anthropic réservés en permanence). Contournement : suffixe `-perso`. Le déclenchement est piloté par la `description`, pas par le nom.

---

## Portée des skills de ce repo

- **Compte + disque** (partout) : `task-observer-perso`, `doc-coauthoring-perso` — adaptations personnelles de skills amont ; l'amont est cité dans chaque SKILL.md et n'est jamais installé.
- **Disque seulement** (décision 2026-07-22) : famille Obsidian (`obsidian-bases`, `obsidian-cli`, `obsidian-markdown`, `json-canvas`, `defuddle`) — servent le vault Obsidian en sessions Code locales.
- **À classer** : `context-file-optimizer`, `grill-me`, `learned` (vide — dossier retiré), `skill-intake`.

Règle pour les nouveaux skills : ne jamais coder en dur un fait de projet (numéro d'ADR, nom de repo, chemin spécifique) — lire ou détecter dynamiquement, ou paramétrer par config. Un skill qui recopie une règle de projet est une divergence en attente.
