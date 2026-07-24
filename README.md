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
   - Disque (Claude Code local) : copier `.claude/skills/<nom>/` → `~/.claude/SKILLS/<nom>/` (remplacer). **Statut au 2026-07-24 :** V0 et V0-ter (épreuve du lanceur) sont VERTES — une session ouverte par `claude-ah` lit la maison à la source et cette copie ne la sert pas. Elle reste nécessaire pour toute session ouverte par `claude` nu, qui ne voit pas la maison. Retirer la copie est donc une décision à prendre — **TO VALIDATE**, pas une conséquence automatique des verdicts.
7. **Vérifier** : en session, demander « vérifie les versions des skills » et comparer au frontmatter. Pas de confirmation = pas de déploiement.

Piège connu : « This skill name is already in use » peut persister après suppression (réservation résiduelle côté serveur ; noms du catalogue d'exemples Anthropic réservés en permanence). Contournement : suffixe `-perso`. Le déclenchement est piloté par la `description`, pas par le nom.

---

## Portée des skills de ce repo

- **Compte + disque** (partout) : `task-observer-perso`, `doc-coauthoring-perso` — adaptations personnelles de skills amont ; l'amont est cité dans chaque SKILL.md et n'est jamais installé.
- **Disque seulement** (décision 2026-07-22) : famille Obsidian (`obsidian-bases`, `obsidian-cli`, `obsidian-markdown`, `json-canvas`, `defuddle`) — servent le vault Obsidian en sessions Code locales.
- **À classer** : `context-file-optimizer`, `grill-me`, `learned` (vide — dossier retiré), `skill-intake`.

Règle pour les nouveaux skills : ne jamais coder en dur un fait de projet (numéro d'ADR, nom de repo, chemin spécifique) — lire ou détecter dynamiquement, ou paramétrer par config. Un skill qui recopie une règle de projet est une divergence en attente.
