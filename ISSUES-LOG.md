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
Réplication Linux : RENDUE le 2026-07-27, CONCORDANTE — banc indépendant
(Cowork, conteneur éphémère, HOME isolé), même CLI 2.1.220, 15 runs 15/15.
Le rang est donc prouvé sur deux plateformes, plus une observation locale.
Fiche annexée en v1.1 : fiche-mesure-rang-skills-20260727-linux.md
Masquage total établi par le run E (énumération ouverte à tout préfixe ou
suffixe) : le perdant est effacé de la liste, pas seulement dépriorisé.
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
*Contre, ajouté le 2026-07-27 — mesuré, versé au dossier sans trancher :* le
retrait **est** stable, mais d'une stabilité **adossée à un fichier d'index**.
La synchronisation compte → disque n'est pas un service de réparation continue
mais un installateur gouverné par `skills/manifest.json` : supprimer le dossier
d'un skill ne le fait pas revenir, supprimer le manifeste le fait revenir
immédiatement (mesuré sur le banc Linux, où `CLAUDE_CODE_SYNC_SKILLS=1`). Toute
perte du manifeste — réinstallation, nouvelle machine, nettoyage de cache —
**ressuscite les copies, et avec elles le masquage de la maison**. Le retrait
n'est donc pas un geste unique mais un état à surveiller.

**Option 2 — Garder les copies et rendre l'étape 6 obligatoire.**
Rien à changer à l'outillage ; les sessions `claude` nu continuent de servir.
*Contre :* la copie devient le point de contrôle réel de la maison. Une copie
périmée est **invisible** — aucune mesure automatique ne la détecte, et le
symptôme est précisément celui qu'ADR-028 décrit : des sessions qui se
contredisent sous le même nom de skill.
*Renforcé le 2026-07-27 — l'invisibilité n'est plus une crainte, elle est
mesurée :* le run E de la fiche Linux (énumération explicitement ouverte à tout
préfixe ou suffixe, 3/3) ne remonte qu'une seule entrée, celle du personnel. Le
perdant n'est pas déprioritisé, il est **effacé de la liste des skills**. Une
copie maison périmée ne laisse donc **aucune trace observable en session** : ni
doublon, ni nom qualifié, ni avertissement. C'est ce qui fait passer ce
contre-argument du registre du risque à celui du fait.

**Ce qui manque pour trancher — mis à jour le 2026-07-27.** Le premier bloquant
est levé : la réplication Linux a rendu et concorde. Il reste **une** décision,
et elle est de structure : la **généralisation du lanceur** `claude-ah`,
aujourd'hui garée dans `TODO.md` sous la condition « entrée du 2ᵉ projet ».
L'option 1 en dépend directement — sans lanceur généralisé, retirer les copies
prive de skills toute session ouverte par `claude` nu.

Le nouvel élément du manifeste **ne bloque pas** la décision : il en change le
prix. L'option 1 cesse d'être « un geste et c'est réglé » pour devenir « un geste
plus une surveillance ». À peser contre l'option 2, dont le défaut symétrique est
qu'une copie périmée est invisible.

### 5. Conditions de révision

Reprises de la fiche Linux § 7, plus la troisième que son annexe 5 impose.

1. **Montée de version du CLI** → rejouer D, T, M **et E** (≈ 15 min). Le rang
   est un comportement d'implémentation, pas un contrat documenté : `2.1.220`
   est la borne de validité, pas une garantie. Déjà couvert par V6 du § 6.
2. **Apparition d'un mécanisme officiel de qualification des homonymes**
   (préfixe de source, espace de noms) → le masquage silencieux disparaîtrait,
   et cette ISSUE avec lui.
3. **Le canal de synchronisation compte → disque sur le poste Windows.**
   L'annexe 5 de la fiche mesure ce canal sur Cowork, où il est explicitement
   actif (`CLAUDE_CODE_SYNC_SKILLS=1`), et pose lui-même la réserve : rien
   n'établissait qu'il le soit ici.

   **Relevé du 2026-07-27 sur ce poste, lecture seule — indication forte
   d'inactivité, pas une preuve :** aucun `manifest.json` sous `~/.claude`
   (recherché à deux niveaux) ; `CLAUDE_CODE_SYNC_SKILLS` absente de
   l'environnement ; `~/.claude/SKILLS/` contient exactement les 10 skills
   déployés à la main, aucun skill du compte. S'y ajoute un fait non provoqué
   mais probant : **une douzaine de sessions CLI ont été lancées depuis ce poste
   la veille, le 2026-07-26**, pour la mesure V3-bis — aucune n'a créé de
   manifeste ni installé quoi que ce soit.

   La manip proposée par la fiche (« supprimer `manifest.json` et relancer »)
   est donc **sans objet ici** : il n'y a pas de manifeste à supprimer. Ce qui
   reste ouvert est étroit et nommé : l'absence de la variable dans un shell ne
   prouve pas qu'elle soit absente pour l'application, et un canal piloté côté
   serveur peut s'activer sans changement local. À rejouer si des skills du
   compte apparaissent un jour dans `~/.claude/SKILLS/` sans geste de Mathieu —
   ce serait le signal que le canal s'est ouvert, et l'option 1 changerait de
   prix sur ce poste comme elle en change sur Cowork.

### 6. Réflexe réutilisable

Une sonde qui prouve qu'un **dossier** est scanné ne prouve pas qu'un **fichier**
donné y est chargeable. Les deux échecs rendent la même sortie. Tout protocole
qui conclut à un rang de priorité doit porter un contrôle de chargeabilité :
écarter le concurrent et vérifier que le candidat rend bien son marqueur seul.
