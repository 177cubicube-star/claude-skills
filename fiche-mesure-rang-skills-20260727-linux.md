# Fiche de mesure — Rang des maisons de skills (réplication indépendante)

**Date :** 2026-07-27
**Version :** 1.1 — remplace la v1.0 du même jour **avant tout commit** (ajout du run E ; voir § 4, note de traçabilité). Aucun contenu de la v1.0 n'a été retiré.
**Plateforme :** Linux (bac à sable Cowork, conteneur éphémère)
**Version CLI :** Claude Code 2.1.220
**Statut :** Mesure exécutée, 15 runs, aucun raté
**Objet :** Réplication indépendante de la mesure V3-bis (Windows, 2026-07-26), incluant le contrôle qui manquait à l'original.
**Effet de bord :** aucun — `HOME` isolé sous `/tmp`, aucun fichier du poste ni du dépôt touché.

---

## 1. Question mesurée

Quand un skill est présent simultanément dans plusieurs maisons sous le **même nom**, laquelle est réellement servie à la session ?

Maisons couvertes par cette fiche :

- **personnel** — `$HOME/.claude/skills/<nom>/SKILL.md`
- **projet** — `<dossier courant>/.claude/skills/<nom>/SKILL.md`
- **répertoire monté** — dossier passé à `--add-dir`, dans son `.claude/skills/`

Hors périmètre : la maison **plugin**, et la précédence à l'intérieur d'une même maison.

---

## 2. Protocole

Deux skills jetables, dont le marqueur de contenu vit dans le champ `description` du
frontmatter — donc lisible dans la liste des skills **sans invoquer quoi que ce soit** :

| Skill | Emplacement | Marqueur |
|---|---|---|
| `probe-rang` | personnel | `MARQUEUR-RANG-PERSONNEL` |
| `probe-rang` | maison (`--add-dir`) | `MARQUEUR-RANG-MAISON` |
| `sonde-maison` | maison uniquement | `MARQUEUR-SONDE-MAISON-VISIBLE` |

`sonde-maison` est le **discriminant** : sans homonyme personnel possible, sa visibilité
prouve que le dossier de la maison est bien scanné par la session. Sans lui, « le personnel
gagne » et « la maison n'est jamais lue » produisent une sortie identique.

**Sonde principale (D, T, M, C) :** une question sans outil, répondue en une ligne au format
`PROBE=<marqueur|ABSENT> ; SONDE=<VISIBLE|ABSENT>`. Elle interroge un **nom exact**.

**Sonde d'énumération (E) :** une question sans outil demandant de lister *tous* les skills
dont le nom contient `probe`, `rang` ou `sonde`, **quel que soit leur préfixe, suffixe ou
qualification**. Elle répond à une question que la sonde principale ne pose pas : l'homonyme
perdant survit-il ailleurs dans la liste, sous un nom dérivé ?

Chaque configuration est répétée **3 fois** (une mesure antérieure avait produit un raté
isolé du modèle).

**Ordre délibéré :** le run D passe en premier. S'il échoue, l'instrument est aveugle et
les autres runs ne valent rien — inutile de les dépenser.

| Run | Dossier courant | `--add-dir` | Homonyme personnel | Rôle |
|---|---|---|---|---|
| **D** | neutre | oui | **absent** | contrôle : le fichier de la maison est-il chargeable ? |
| T | neutre | non | présent | témoin : la maison n'intervient pas |
| M | neutre | oui | présent | la mesure du rang |
| C | = la maison | non | présent | duel projet vs personnel |
| **E** | neutre | oui | présent | le perdant survit-il sous un nom qualifié ? |

---

## 3. Résultats bruts

```
=== D : maison seule, PAS d'homonyme personnel, AVEC --add-dir ===
[D #1] PROBE=MARQUEUR-RANG-MAISON     ; SONDE=VISIBLE
[D #2] PROBE=MARQUEUR-RANG-MAISON     ; SONDE=VISIBLE
[D #3] PROBE=MARQUEUR-RANG-MAISON     ; SONDE=VISIBLE

=== T : homonyme présent, SANS --add-dir, cwd neutre ===
[T #1] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=ABSENT
[T #2] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=ABSENT
[T #3] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=ABSENT

=== M : homonyme présent, AVEC --add-dir, cwd neutre ===
[M #1] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE
[M #2] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE
[M #3] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE

=== C : homonyme présent, cwd = maison, SANS --add-dir ===
[C #1] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE
[C #2] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE
[C #3] PROBE=MARQUEUR-RANG-PERSONNEL  ; SONDE=VISIBLE

=== E : énumération exhaustive, configuration identique à M ===
[E #1] NOM=probe-rang    MARQUEUR=MARQUEUR-RANG-PERSONNEL
       NOM=sonde-maison  MARQUEUR=MARQUEUR-SONDE-MAISON-VISIBLE
[E #2] NOM=probe-rang    MARQUEUR=MARQUEUR-RANG-PERSONNEL
       NOM=sonde-maison  MARQUEUR=MARQUEUR-SONDE-MAISON-VISIBLE
[E #3] NOM=probe-rang    MARQUEUR=MARQUEUR-RANG-PERSONNEL
       NOM=sonde-maison  MARQUEUR=MARQUEUR-SONDE-MAISON-VISIBLE
```

15 runs sur 15 conformes. Aucun raté du modèle sur ce banc.

---

## 4. Verdict

**Rang mesuré : personnel > projet, et personnel > `--add-dir`.**

Quatre appuis indépendants, du plus faible au plus fort :

1. **La sonde** (M) — la session voit la maison (`VISIBLE`) et sert malgré tout la copie
   personnelle. Ce n'est donc pas un échec de montage.
2. **Le témoin** (T) — sans le drapeau, la sonde est `ABSENT` : la différence observée en M
   est bien causée par `--add-dir`, et non par autre chose.
3. **La paire D / M** — configuration identique, drapeau identique ; **seule** la présence
   de l'homonyme personnel change, et le résultat bascule de `MAISON` à `PERSONNEL`.
   C'est l'appui décisif : il exclut l'hypothèse d'un fichier maison invalide, qui aurait
   produit exactement la même sortie que le rang.
4. **L'énumération** (E) — une seule entrée `probe-rang` dans toute la liste, celle du
   personnel ; aucune variante préfixée, suffixée ou autrement qualifiée de la copie
   maison, alors même que la maison est montée (la sonde figure dans la même réponse).

**Le masquage est donc total et silencieux :** le personnel ne fait pas que gagner
l'arbitrage, il efface l'homonyme de la liste des skills. Une copie maison périmée ne
laisse aucune trace observable en session — c'est cette propriété, et non le rang seul,
qui rend le doublon dangereux.

> **Note de traçabilité — quel run porte quelle affirmation.**
> L'affirmation de masquage total figurait au § 4 de la **v1.0** de cette fiche alors que
> seuls D, T, M et C avaient été exécutés. Or ces quatre runs interrogent un **nom exact** :
> ils établissent quelle copie répond à `probe-rang`, pas l'absence de toute variante
> qualifiée ailleurs dans la liste. L'affirmation dépassait donc la mesure. Le **run E**,
> exécuté après relecture, la rend exacte — l'énumération est explicitement ouverte à tout
> préfixe ou suffixe, et ne remonte qu'une seule entrée.
> C'est la même erreur de forme que la ligne L du banc Windows, commise cette fois par le
> banc Linux : consignée plutôt que corrigée en silence, pour que la v1.0 annexée et cette
> v1.1 se lisent l'une par l'autre.

Le contrôle interne du run T mérite d'être noté : `SONDE=ABSENT` **et**
`PROBE=PERSONNEL` dans la même réponse établit que la maison personnelle était bien lue
alors que la maison montée ne l'était pas. Les deux yeux de l'instrument voyaient clair.

**Concordance :** identique au verdict V3-bis obtenu sur Windows le 2026-07-26 avec la même
version de CLI, par un montage indépendant. Le rang n'est donc pas une particularité de
poste — c'est un comportement du CLI 2.1.220 sur les deux plateformes testées.

---

## 5. Annexe — mécanique de la synchronisation compte → disque

Observée incidemment sur ce banc, et vérifiée par deux manipulations, car elle porte
directement sur la décision « retirer ou non les copies personnelles ».

Le `HOME` de test était vierge. Après le premier lancement, il contenait les skills du
compte claude.ai, installés automatiquement (canal actif dans cet environnement :
`CLAUDE_CODE_SYNC_SKILLS=1`). Deux tests ont précisé le mécanisme :

| Manipulation | Résultat |
|---|---|
| Supprimer le dossier d'un skill, relancer | **Non restauré** |
| Supprimer aussi `skills/manifest.json`, relancer | **Restauré immédiatement** |

**Lecture :** la synchronisation n'est pas un service de réparation continue, mais un
installateur gouverné par un manifeste : il ne réinstalle que ce que le manifeste ne
déclare pas déjà installé. C'est le comportement de cache déjà consigné dans ADR-028, vu
depuis l'autre extrémité.

**Conséquence pour la décision de structure :** retirer une copie personnelle **est**
stable — mais d'une stabilité adossée à un fichier d'index. Toute perte du manifeste
(réinstallation, nouvelle machine, nettoyage de cache) ressuscite les copies, et avec
elles la priorité qui masque la maison. Le retrait n'est donc pas un geste unique : c'est
un état à surveiller.

**Portée de cette annexe :** elle décrit **ce banc**, où le canal de synchronisation est
explicitement actif. Elle n'établit rien sur le poste Windows. Le relevé correspondant
côté poste — lecture seule, et son interprétation — vit dans `ISSUES-LOG.md`, ISSUE-001,
conditions de révision : c'est là qu'il faut le lire, pas ici.

---

## 6. Limites de cette mesure

- Un seul nom de skill éprouvé (`probe-rang`) — la généralisation à tout nom est une
  inférence raisonnable, pas une mesure.
- La maison **plugin** n'est pas couverte ; la précédence *à l'intérieur* d'une même
  maison non plus.
- La sonde passe par le modèle. Atténué par 15/15 déterministes, non éliminé.
- Le run E énumère ce que le modèle **déclare** voir. Il exclut une variante qualifiée
  visible ; il n'exclut pas, en toute rigueur, une entrée que le modèle omettrait de
  rapporter. Un dump du contexte réel serait une preuve plus forte — non disponible ici.
- Verdict valide pour **CLI 2.1.220**. Toute montée de version rouvre la question : le
  rang est un comportement d'implémentation, pas un contrat documenté.

---

## 7. Conditions de révision

- Montée de version du CLI → rejouer D, T, M, E (≈ 15 min).
- Apparition d'un mécanisme officiel de qualification des homonymes (préfixe de source,
  espace de noms) → le masquage silencieux disparaîtrait, et la doctrine avec lui.
- Mesure du canal de synchronisation sur le poste Windows → transforme l'annexe 5
  d'hypothèse en fait, ou l'invalide. (Premier relevé déjà versé à ISSUE-001.)
