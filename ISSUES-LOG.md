# Issues — dépôt `claude-skills`

> Registre des problèmes mesurés de la maison des skills transversaux.
> Suit le patron du template de `suspension-intelligente`
> (`docs/ISSUES-LOG-TEMPLATE.md`).
>
> Ce registre ne remplace pas les ADR. Une ISSUE **constate et instruit** ;
> elle ne tranche pas. Quand la décision est prise, elle devient un ADR (ou un
> amendement à un ADR existant) et l'ISSUE se ferme en le référençant —
> c'est la séquence ISSUE-038 → ADR-028.

**Numérotation :** locale à ce dépôt, à partir de 001. Ne pas confondre avec la
série de `suspension-intelligente`.

---

## ISSUE-001 — Les 10 skills de la maison sont servis par leur copie personnelle, jamais par la source

**Date :** 2026-07-26
**Statut :** Ouvert — **en attente du décideur (Mathieu)**
**Contexte :** `README.md` étape 6 du rituel de déploiement ·
`2026-07-23-proposition-maison-skills.md` § 6 mesure V3-bis · lanceur `claude-ah`
**Type :** Architecture
**Sévérité :** Élevée — touche la prémisse de rafraîchissement de tous les skills
transversaux
**Décision de référence :** ADR-028 (une maison par skill) — sa prémisse
« `~/.claude/SKILLS` est une cible de déploiement » est confirmée, mais sa
**conséquence opérationnelle** change (voir § 4)

---

### 1. Problème

```text
Ce qui s'est produit :
Un skill de la maison atteint par --add-dir NE PRIME PAS sur son homonyme de
~/.claude/SKILLS/. La copie personnelle est servie. Le même rang s'observe face
au .claude/skills/ du projet courant.

Ce qui était attendu :
Le README affirmait, sur la foi de V0/V0-ter, qu'une session ouverte par
claude-ah « lit la maison à la source et cette copie ne la sert pas ».

Impact :
Les 10 skills de la maison ont tous un homonyme personnel. Ils sont donc tous
servis par la copie. Un git pull sur la maison ne change RIEN pour eux : la
maison peut être à jour pendant que toutes les sessions exécutent autre chose —
exactement la dérive silencieuse qu'ADR-028 existe pour éliminer.
```

### 2. Contexte technique

```text
Mesure : V3-bis, § 6 de 2026-07-23-proposition-maison-skills.md
Environnement : Claude Code 2.1.220, Windows 11 (windows-x86_64)
Réplication Linux : EN COURS (hors de ce poste) — tant qu'elle n'a pas rendu,
le verdict est une observation locale à Windows
Sujet : json-canvas, marqueur posé dans la description du frontmatter
Contrôle de chargeabilité : homonyme personnel renommé hors jeu → la maison rend
son marqueur (×3). Le verdict est donc un rang, pas un échec de chargement.
Restauré et vérifié après mesure : arbre à 0 modification, copie personnelle
identique octet pour octet à la sauvegarde du 2026-07-26.
```

### 3. Ce qui reste vrai — à ne pas rétracter

`--add-dir` **fonctionne** : une sonde à nom unique présente uniquement dans la
maison est visible avec le drapeau et absente sans lui. V0 et V0-ter ne sont pas
infirmées. Ce qui est réfuté est plus étroit : le drapeau ne **gagne pas** un
conflit de noms. Sa portée utile est donc les skills **sans homonyme personnel**.

### 4. Les deux options — non tranchées

**Option 1 — Retirer les copies personnelles des 10 skills de la maison.**
La maison redevient ce que le drapeau sert réellement ; `git pull` suffit et
l'étape 6 disparaît pour ces skills.
*Contre :* toute session ouverte par `claude` nu (sans `--add-dir`) perd les 10
skills. Le lanceur `claude-ah` devient obligatoire, et il est aujourd'hui
mono-projet — il faudrait le généraliser d'abord.

**Option 2 — Garder les copies et rendre l'étape 6 obligatoire.**
Rien à changer à l'outillage ; les sessions `claude` nu continuent de servir.
*Contre :* la copie devient le point de contrôle réel de la maison. Une copie
périmée est **invisible** — aucune mesure automatique ne la détecte, et le
symptôme est précisément celui qu'ADR-028 décrit : des sessions qui se
contredisent sous le même nom de skill.

**Ce qui manque pour trancher :** le résultat de la réplication Linux, et une
décision sur la généralisation du lanceur (aujourd'hui garée dans `TODO.md` sous
la condition « entrée du 2ᵉ projet »). L'option 1 en dépend directement.

### 5. Réflexe réutilisable

Une sonde qui prouve qu'un **dossier** est scanné ne prouve pas qu'un **fichier**
donné y est chargeable. Les deux échecs rendent la même sortie. Tout protocole
qui conclut à un rang de priorité doit porter un contrôle de chargeabilité :
écarter le concurrent et vérifier que le candidat rend bien son marqueur seul.
