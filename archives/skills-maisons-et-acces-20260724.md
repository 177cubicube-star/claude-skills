---
name: skills-maisons-et-acces
description: >
  Mémo de continuité pour le travail de gouvernance des skills — dossiers
  connectés, chemin de chaque maison, mécanisme de distribution retenu,
  verdicts mesurés, sujets garés. À relire au démarrage d'une session
  « skills ». Compagnon de carte-skills.md (même dossier).
metadata:
  node_type: continuité
  type: gouvernance-skills
  etabli: 2026-07-24
  finalise: 2026-07-24 (clôture du palier V0/lanceur)
  maison: dépôt claude-skills (racine) — décision Mathieu 2026-07-24 ;
    toute copie ailleurs (ex. Projects/) est périmée dès divergence
---

# Skills — maisons, mécanismes et état du palier

*Établi puis finalisé le 24 juillet 2026, à la clôture du palier « V0 /
lanceur ». Compagnon de `carte-skills.md`. Autorité supérieure : le document
« Proposition — La maison des skills », **v6**, à la racine du dépôt maison ;
en cas de divergence, lui gagne. L'histoire complète vit dans les trois
passations (contexte + F1-F9 · inventaire + verdicts V0 · clôture).*

## Règle de lecture

Toute session future **re-mesure avant de relire** : ce mémo date du
2026-07-24 ; les faits F sont des comportements de l'outil, pas des lois
(protocole V6 : re-mesurer après toute mise à jour majeure de Claude Code).

## Dossiers connectés à la session Cowork (pont desktop)

| Dossier | Rôle |
|---|---|
| `C:\Users\mat_g\Documents\Claude\Projects` | racine des projets (connexion initiale du projet Skills) |
| `C:\Users\mat_g\Documents\Claude\claude-skills` | la maison (accordé en session — à rebrancher à chaque session) |
| `C:\Users\mat_g\Documents\cerveau-suspension` (+ son `.claude`) | vault Obsidian (idem) |

Écriture impossible dans tout dossier `.claude` via le pont (lecture seule) ;
`~\.claude` est un emplacement protégé, jamais connectable.

## Les maisons (état à la clôture)

1. **Maison** — dépôt `177cubicube-star/claude-skills`, clone
   `Documents\Claude\claude-skills`. Skills désormais sous
   **`.claude/skills/`** (git mv `50b99ed` — ne pas défaire). 10 skills,
   document d'autorité v6 + règle d'ordre au README à la racine.
2. **`~\.claude\skills\`** (perso disque) — copie 10/10 **identique SHA256**
   à la maison (mesuré 2026-07-24). Redondante pour les sessions `claude-ah`,
   encore utile aux sessions `claude` nu. Rien ne se supprime sans décision.
3. **Projets** — App-Handyman (pilote : prompt-forge) ·
   Suspension-intelligente (8 skills projet, **GELÉS**) · vault
   cerveau-suspension (4 skills, hors exécution Claude, usage actif déclaré).
4. **Compte claude.ai** — sert Cowork/Chat/Android. Aucun pont automatique
   avec les fichiers (F9) ; canal = zip manuel par skill, sous prérequis
   plan payant + exécution de code (V7-pre, jamais mesuré).

## Verdicts mesurés du palier (2026-07-24, CLI 2.1.218)

- **V0 VERT** — `--add-dir <maison>` charge les skills à la source (F8
  prouvé). Option D retenue, par mesure.
- **V0-bis ROUGE → F10** — `permissions.additionalDirectories` accorde
  l'accès FICHIERS, pas la découverte des SKILLS. La doc se contredisait à
  trois pages ; la mesure a tranché contre la page « la plus crédible ».
- **Épreuve lanceur VERTE** — `claude-ah` (fonction de profil PowerShell :
  cd App-Handyman + `claude --add-dir <maison>`) prouvé bout en bout par
  sonde (`AH-VERT-LANCEUR-MONTE`). Sonde supprimée ensuite. Limite : le
  drapeau ne voyage pas avec le projet — `claude` nu n'a pas la maison ;
  multi-poste/multi-humain = option C (plugins), le jour venu.

## Règles et exclusions en vigueur

- **prompt-forge ne se distribue JAMAIS** vers `~\.claude\skills\` —
  exclusion de gouvernance ADR-005 (plus forte qu'un gel). Requalifié :
  deux skills différents partageant un nom (~40 % commun), classe
  « à généraliser », **bloqué sur une mesure** (rang `--add-dir` dans F2),
  pas sur une décision.
- **16 skills GELÉS / 5 LIBRES** (defuddle, json-canvas, obsidian-bases,
  obsidian-cli, obsidian-markdown). Le gel interdit modifier/déplacer/
  renommer — pas distribuer (la distribution D est additive).
- **Règle d'ordre (README maison)** : artefact jetable posé APRÈS le dernier
  geste git ; coexistence inévitable → `git add` nommé, jamais `-A`.
- Pas d'homonyme entre niveaux (F2 : personnel > projet, écrasement
  silencieux) ; une maison-source par skill ; copies jamais éditées.

## Sujets garés — chacun avec sa condition de réouverture

| Sujet | Réouverture |
|---|---|
| Copie `~\.claude\skills\` (redondante côté `claude-ah`) | décision à froid ; rien ne se supprime avant |
| Lanceur mono-projet | entrée du 2ᵉ projet (un `claude-si`, ou généralisation) |
| Rang `--add-dir` vs personnel homonyme | sauvegarde datée d'abord + sonde après push — c'est LA mesure qui débloque prompt-forge |
| Étape 3 (consolidation, presque vide) | sauvegarde datée + GO explicite |

## Feuille de route héritée (ordre)

Sauvegarde datée de `~\.claude\skills\` → mesure du rang F2 → étape 3 →
traitement des observations (obs 8, 11-18 App-Handyman ; obs 1-5
claude-skills) = premier aller-retour réel du circuit → entrée de
Suspension sur GO distinct (dégèle recap/session-prep, ferme l'obs 8) →
circuit Android (V7-pre d'abord, la porte peut être fermée par le plan).

## Écarts hérités de l'audit Cowork du 2026-07-24 (hors palier, toujours vrais à leur date)

- `tdd-enforcer` : copie **compte** figée en mai vs repo Suspension (≈ v1.6,
  correctif ISSUE-036) — sans effet en local, désaligné en Cowork/Chat.
- `skill-creator` : copie repo Suspension plus vieille que la version
  Anthropic du compte.
- Audit 71 Ko d'un autre projet encore à la racine de la maison (obs 15).

## Les leçons gravées (résumé, détail dans la passation 3)

Quand la doc se contredit, la mesure tranche — pas le vote des pages. Un
garde par séquencement protège toujours, un garde par vigilance une fois ;
la fragilité se cherche aussi dans les séquences qui ont réussi. Vérifier
l'invocation n'est pas vérifier l'effet — une chaîne se vérifie à sa sortie.
Distinguer l'événement (vrai pour toujours) de l'état (dépend d'un geste
d'autrui, inécrivable comme fait). Un sujet garé porte sa condition de
réouverture — c'est ce qui le distingue d'un oubli.
