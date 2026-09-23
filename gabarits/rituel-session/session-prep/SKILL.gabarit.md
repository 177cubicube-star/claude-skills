---
name: session-prep-{{SUFFIXE}}
version: 1.0.0
description: Ouverture de session du projet {{PROJET}} — lecture seule, reconstruit l'état RÉEL sur la référence distante (recaps, ADR, TODO, sync git) et signale ce qui est déjà fait (« ne pas refaire »). À lancer AVANT tout travail sur « où en est-on », « reprendre », « début de session ».
---

# session-prep-{{SUFFIXE}} — ouverture de session ({{PROJET}})

> Instancié depuis le gabarit `rituel-session` v{{VERSION_GABARIT}} — maison
> `claude-skills` @ `{{SHA_MAISON}}`. Les blocs 🔒 FOND ne s'éditent pas ici.

<!-- 🔒 FOND:role -->
**Rôle** : répondre à « où en est-on **maintenant** ? », et non à « où en
était-on à la dernière session ? ». Chaque session part de son propre contexte
et ne voit pas ce que les autres ont poussé. Sans cette vérification, on refait
un ADR, une PR ou une fonctionnalité déjà mergés. Le **DELTA** sert à attraper
ce cas **avant** que le travail commence.

**Lecture seule, sans exception.** Ce skill n'écrit aucun fichier, ne committe
rien et ne touche ni au working tree ni au stash. Seul `git fetch` est permis :
il met à jour les refs, pas les fichiers. La sortie unique est un briefing à
l'écran.
<!-- /FOND:role -->

<!-- ✏️ FORME:config -->
## Forme du projet

| Paramètre | Valeur pour {{PROJET}} |
|---|---|
| Référence distante | `{{REF}}` |
| Fuseau du poste | `{{FUSEAU}}` |
| Dossier des recaps | `{{SESSIONS}}` |
| Branches de travail | `{{PREFIXE_BRANCHES}}` (ex. `claude/*`) |
| ADR | dossier `{{DECISIONS}}` ou `aucun` · ligne de statut `{{LIGNE_STATUT}}` |
| TODO | `{{TODO}}` ou `aucun` · marqueurs `{{MARQUEURS_TODO}}` |
| Règles actives du projet | `{{INSTRUCTIONS}}` (ex. `CLAUDE.md`) |
| Pages de fil | `{{FILS}}` ou `aucun` |
| Scripts testés du projet | gap recap `{{SCRIPT_GAP}}` · axes de sync `{{SCRIPT_AXES}}` · ADR sur la réf `{{SCRIPT_ADR_REF}}` · fils actifs `{{SCRIPT_FILS}}` · vues dérivées `{{SCRIPTS_DERIVES}}` — ou `aucun` |
<!-- /FORME:config -->

<!-- 🔒 FOND:regles-transverses -->
## Règles transverses

- **Toute lecture git se fait en `git --no-optional-locks …`**, pour ne laisser
  aucun verrou orphelin depuis le pont Cowork.
- **Le script d'abord** : un script déclaré s'invoque tel quel, et son verdict
  est inséré verbatim. Les procédures en ligne ci-dessous sont des gardes **par
  vigilance, non calibrées**.
- **La date se mesure** : `TZ=<fuseau> date`, jamais `date` nu.
- **Un verdict INDÉTERMINÉ nomme la précondition qui a manqué.** Un
  « indéterminé » opaque est un détecteur qui se tait sur sa propre panne.
- On collecte tout (étapes 1 à 5) avant d'afficher quoi que ce soit.
<!-- /FOND:regles-transverses -->

<!-- 🔒 FOND:etape-1-2 -->
## Étape 1 — État git réel

```bash
git fetch origin                       # refs seulement ; retenter à 2, 4, 8 s ; sinon DÉCLARER « réf possiblement périmée »
git --no-optional-locks branch --show-current
git --no-optional-locks log --oneline -15 <ref>
git --no-optional-locks branch -a --list "<branches de travail>"
git --no-optional-locks status --porcelain     # SIGNALER seulement : c'est le travail de l'utilisateur
git --no-optional-locks stash list
```

**Trois axes de synchronisation** (sauf si un script est déclaré) :

| Axe | Mesure | Lecture |
|---|---|---|
| 1 · branche ↔ réf | `rev-list --left-right --count <ref>...HEAD` | contexte : +N à merger, −M de retard |
| 2 · main local ↔ réf | `rev-list --left-right --count <ref>...main` | **ALERTE** si main local porte des commits non poussés ; ⚠️ s'il est en retard |
| 3 · branche ↔ son upstream | `rev-list --count @{u}..HEAD` | **ALERTE** si des commits locaux ne sont pas poussés (session coupée en vol ?) |

Si un opérande manque, on écrit `[axe N non vérifiable — <lequel manque>]`.

## Étape 2 — Recaps, lus sur la référence

Les deux côtés d'une comparaison se lisent **dans le même référentiel**. Lire
les recaps sur le disque et compter les commits sur la réf produirait un faux
`OK` pour un recap jamais poussé.

1. La liste des recaps sur la réf :
   `git ls-tree --name-only <ref> -- <sessions> | sort -V`. Le plus récent, et
   **tous ceux de la même date** (sessions parallèles), se lisent par
   `git show <ref>:<chemin>`.
2. **Verdict de continuité** (sauf si un script est déclaré). On prend le champ
   `HEAD : \`sha\`` du dernier recap sur la réf, puis on compte les commits
   postérieurs **en excluant les fichiers de clôture** (recaps, TODO, fils
   déclarés dans la forme) :
   `git rev-list --count <sha>..<ref> -- . ':(exclude)<sessions>' ':(exclude)<todo>' ':(exclude)<fils>'`.
   Sans cette exclusion, le commit qui dépose le recap, forcément postérieur au
   `HEAD` qu'il grave, rendrait GAP après chaque clôture propre (mesuré sur un
   dépôt jetable). Limite assumée : une session qui n'a touché **que** des
   fichiers de clôture n'est pas détectée.
   - `0` → **OK** ;
   - `> 0` → **GAP** : des commits ont avancé la réf sans recap ;
   - le dernier recap du **disque** est absent de la réf → **RECAP_LOCAL** :
     un recap n'a pas été poussé, le trou est local ;
   - recap sans champ `HEAD` → **INDÉTERMINÉ — recap sans HEAD** (le
     producteur n'a pas écrit la clé) ;
   - sha inconnu de la réf → **INDÉTERMINÉ — sha hors historique** ;
   - aucun recap sur la réf → **INDÉTERMINÉ — aucun recap sur <ref>**.
3. Dans ces recaps, extraire les **candidats du DELTA**, repérés **par le sens**
   et non par numéro de section : ce qui n'est pas fait, seulement proposé, un
   ADR en attente, un point ouvert, une prochaine action.
<!-- /FOND:etape-1-2 -->

<!-- 🔒 FOND:etape-3-5 -->
## Étape 3 — ADR sur la référence (si déclarés)

On utilise le script déclaré, sinon on liste avec
`git ls-tree --name-only <ref> -- <dossier ADR>` et on lit la ligne de statut
de chacun avec `git show <ref>:<fichier>`. On en tire les ADR **Proposés** non
actés et le **prochain numéro libre** (max + 1, sans jamais réutiliser ni
sauter un numéro). Si le dossier n'est pas vide mais qu'aucun statut n'est lu :
`[convention de statut à vérifier]`.

## Étape 4 — TODO (si déclaré)

Un fichier long se tronque **sans le dire**, et une lecture partielle passe
alors pour une lecture complète. On procède donc en trois temps :

```bash
grep -nE '<marqueurs>' "$TODO" | head -3    # 1. mesurer le motif réel du fichier
grep -cE '<toutes classes>' "$TODO"         # 2. CONTRÔLE POSITIF : doit être > 0
grep -nE '<classes ouvertes>' "$TODO"       # 3. à faire + en cours + bloquant, TOUTES
```

Un compte à 0 met en cause l'instrument, pas le fichier. Le tri par priorité
se fait dans le briefing, pas dans le grep.

## Étape 5 — Règles actives

On lit le fichier de règles du projet et on résume en **une ligne** ce qui
change ce qu'on a le droit de faire maintenant : politique git et merge, plan
avant code, skills obligatoires. On résume, on ne recopie pas.
<!-- /FOND:etape-3-5 -->

<!-- 🔒 FOND:etape-6 -->
## Étape 6 — DELTA recap ↔ réf (la fonction clé, obligatoire)

| Le recap dit… | …et la réf montre | Verdict |
|---|---|---|
| « ADR-X proposé / à acter » | ADR-X **Accepté** | 🛑 NE PAS REFAIRE |
| « créer le fichier F » | F existe | 🛑 NE PAS REFAIRE |
| « prochaine action : Y » | un commit réalise Y | 🛑 NE PAS REFAIRE |
| « tâche Z ouverte » | Z cochée dans le TODO | ⚠️ Probablement fait — vérifier |
| « ADR-X proposé » | absent ou encore Proposé | ✅ Encore à faire |

Règles de jugement :

- **Mieux vaut un faux positif qu'un faux négatif** : un doublon raté coûte
  une PR en conflit, une alerte de trop coûte dix secondes.
- **Un 🛑 cite sa preuve** (sha, fichier, ligne de statut). Sans preuve, le
  verdict descend à ⚠️.
- Les candidats en double entre recaps frères se **dédupliquent** : une ligne,
  avec les recaps sources cités.
- **Aucun delta → on le dit** (« recap ↔ réf cohérents ») : une absence de
  doublon est une information.
- **Vues dérivées** : seulement si des scripts sont déclarés, avec leur rapport
  tel quel. Sinon, on écrit `ⓘ aucune vérif dérivée déclarée`.
<!-- /FOND:etape-6 -->

<!-- 🔒 FOND:etape-7 -->
## Étape 7 — Aiguillage : quelle ancre de reprise ?

Si des pages de fil sont déclarées, on liste les fils non archivés, triés par
dernière activité (`git log -1 --format=%cs -- <fichier>`), et on demande
**« Quel fil reprends-tu ? »**. Options :

- **un fil** : on démarre par sa prochaine action n° 1 ;
- **récent** : on démarre par la première action du dernier recap absente
  du 🛑 ;
- **aucun** : on affiche la vue d'ensemble ;
- **interrompue** (seulement si GAP) : on reconstruit depuis le `HEAD` du
  dernier recap, puis on demande confirmation ;
- **clore l'interrompu** (seulement si l'axe 3 est en ALERTE) : on relit les
  commits non poussés, puis on pose la question de merge, **jamais de merge
  sans GO**.

Sans fils, on propose seulement « récent », « aucun » et les options
conditionnelles. On attend la réponse. Le DELTA, lui, n'est pas ré-ancré : il
porte toujours sur les recaps du jour le plus récent.
<!-- /FOND:etape-7 -->

<!-- 🔒 FOND:briefing -->
## Étape 8 — Briefing (sortie unique, lisible en ~15 s)

```
═══ SESSION-PREP · <projet> · <ref> @<sha> · ancre : <…> ═══
🛑 NE PAS REFAIRE : <item ← preuve> | « rien — recap ↔ réf cohérents »
   ⓘ DELTA basé sur le(s) recap(s) du <date> : <liste>
   🛑 CONTINUITÉ : <OK | GAP | RECAP_LOCAL | INDÉTERMINÉ — précondition manquante>
➡️  DÉMARRER PAR : <selon l'ancre>
❓ Ouvert : [!] … · [~] … · [ ] …
🌿 Branche <x> · vs <ref> +N/−M · main local +K non poussé(s) (si K>0) · branches de travail : …
🧰 Working tree : <propre | N modifs — ne pas toucher> · stash : <vide | N>
📖 Périmètre de lecture : <intégral | partiel — source, ce qui n'a PAS été lu, motif>
🕐 Fetch : <OK | ÉCHEC — réf possiblement périmée> · date mesurée : <AAAA-MM-JJ HH:MM ±zone>
📐 Prochain ADR libre : … · Proposés non actés : …
📏 Règles ce cycle : <1 ligne>
📋 Reprise : <pointeur vers la section de reprise de l'ancre>
════════════════════════════════
```

- **📖 et 🕐 sont obligatoires, même quand tout est vert.** Une ligne absente
  se lit comme « tout va bien ».
- **📋 est un pointeur**, jamais les prompts de reprise recopiés.
- Les lignes sans objet dans ce projet (ADR `aucun`, fils `aucun`) s'omettent,
  sauf 📖 et 🕐.
<!-- /FOND:briefing -->

<!-- 🔒 FOND:checklist -->
## Checklist (avant d'afficher)

- [ ] Fetch tenté ; un échec est déclaré
- [ ] Recaps lus **sur la réf**, y compris les frères du même jour ; verdict de
      continuité rendu, avec la précondition nommée s'il est INDÉTERMINÉ
- [ ] Chaque 🛑 appuyé par une preuve ; le cas « ADR déjà Accepté » vérifié
- [ ] Motif du TODO mesuré, contrôle positif > 0
- [ ] Aiguillage présenté, réponse attendue
- [ ] Lignes 📖 et 🕐 présentes
- [ ] Toutes les lectures git en `--no-optional-locks` ; **aucun fichier écrit**
<!-- /FOND:checklist -->
