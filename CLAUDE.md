# CLAUDE.md — projet `claude-skills`

Maison git des skills Claude **transversaux** de Mathieu. Ce fichier dit comment
travailler ici. La constitution générale (`~/.claude/CLAUDE.md`) s'applique
au-dessus ; en cas de conflit, elle prime sauf pour les faits mesurés ci-dessous.

---

## Le fait qui gouverne tout le reste

**La copie de `~/.claude/SKILLS/` est ce qui tourne. Pas ce dépôt.**

Mesuré le 2026-07-26 (Windows) et répliqué le 2026-07-27 (Linux), CLI 2.1.220,
27 runs au total : un skill personnel l'emporte sur son homonyme atteint par
`--add-dir` **et** sur celui du `.claude/skills/` du projet courant — et il
l'**efface** de la liste, sans doublon ni avertissement.

Trois conséquences, non négociables tant que la mesure tient :

1. **Éditer ici ne change rien à une session.** Tant que `deploy-skills.ps1`
   n'a pas tourné, la modification n'existe pour personne.
2. **`git pull` ne déploie pas.** Il met la source à jour, pas la cible.
3. **Une copie périmée est invisible.** Aucune session ne signalera qu'elle
   exécute une vieille version. Le seul détecteur est le script.

Borne de validité : **CLI 2.1.220**. C'est un comportement d'implémentation,
pas un contrat documenté. À toute montée de version, rejouer le protocole
(`2026-07-23-proposition-maison-skills.md` § 6, mesures D, T, M, E).

---

## Le rituel, en une commande

```powershell
.\deploy-skills.ps1                 # que changerait un déploiement ? (rapport seul)
.\deploy-skills.ps1 -Apply -Backup  # déploie, après sauvegarde datée
```

Le script ne supprime jamais rien, signale les orphelins, et **vérifie après
écriture** au lieu de se fier à son propre rapport. Sans `-Apply`, il n'écrit pas.

Avant de déployer : **monter `version:`** dans le frontmatter. Toujours, même
pour une ligne. Deux contenus différents ne portent jamais le même numéro.
Retouche +0.0.1 · ajout +0.1.0 · refonte +1.0.0. Un skill sans `version:` ne
peut pas être suivi — c'est un défaut, pas un détail.

Le compte claude.ai est un **second circuit, sans pont automatique** : zip par
skill, téléversement manuel, `description` ≤ 1024 caractères, nom du dossier =
`name` du frontmatter. Aucune mesure ne détecte la dérive maison ↔ compte.

---

## Où va un skill — quatre questions dans l'ordre

1. **Il nomme un ADR, un chemin, une règle d'UN projet ?** → il reste dans ce
   projet, dans son `.claude/skills/`.
2. **Il est agnostique, aucun fait de projet ?** → il vient ici.
3. **Il vient d'Anthropic ?** → rien à faire, il est déjà partout.
4. **Règle d'or (ADR-028) :** une seule maison-*source* par skill. Le compte et
   le disque sont des *cibles*, jamais éditées à la main.

**Ne jamais coder en dur un fait de projet** dans un skill de ce dépôt — numéro
d'ADR, nom de dépôt, chemin. Un skill qui recopie une règle de projet est une
divergence en attente.

---

## Règles en vigueur

- **Pas d'homonyme entre niveaux.** Poser ici un nom déjà porté par un skill de
  projet efface ce dernier. Avant toute addition, comparer :
  `ls ~/.claude/SKILLS/` aux `ls .claude/skills/` de chaque dépôt actif.
- **`prompt-forge` ne se distribue jamais** vers `~/.claude/SKILLS/` — exclusion
  ADR-005, plus forte qu'un gel. Deux skills distincts partagent ce nom
  (App-Handyman et suspension-intelligente) ; ils ne se croisent jamais, chaque
  session ne voyant que son projet.
- **16 skills gelés / 5 libres** (`defuddle`, `json-canvas`, `obsidian-bases`,
  `obsidian-cli`, `obsidian-markdown`). Le gel interdit modifier, déplacer,
  renommer — pas distribuer.
- **`git add` nommé, jamais `-A`**, tant qu'une sonde jetable vit dans
  `.claude/skills/`. Forme forte, à préférer : poser la sonde **après** le push.

---

## Structure et documents vivants

```
.claude/skills/<nom>/SKILL.md   ← la source, seul endroit où l'on édite
deploy-skills.ps1               ← le pont vers ce qui tourne
README.md                       ← le rituel, en prose
CLAUDE.md                       ← ce fichier
TODO.md                         ← feuille de route + journal daté
ISSUES-LOG.md                   ← problèmes mesurés, décisions ouvertes
archives/                       ← instantanés périmés, gardés pour l'histoire
```

L'inventaire des skills ne se recopie nulle part — il se mesure :

```bash
grep -H -A2 "^name:" .claude/skills/*/SKILL.md | grep -E "name:|version:"
```

**Toute session future re-mesure avant de relire.** Les documents datés de ce
dépôt sont des instantanés ; l'état vivant est sur le disque et dans git.
