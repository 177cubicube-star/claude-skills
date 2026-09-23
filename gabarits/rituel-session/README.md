# Gabarit — rituel de session (`recap` + `session-prep`)

**version du gabarit : 1.0.0**

Modèle de référence pour doter un projet de son propre couple
clôture / ouverture de session. **Ce n'est pas un skill** : rien ici ne se
déploie, rien ne se charge. On l'**instancie** dans le projet, où la copie
devient un skill local — politique « les skills sont locaux au projet par
défaut » (décision de Mathieu, journal du 2026-07-29/30 § 6).

**Pourquoi ce dossier est hors de `.claude/skills/`.** `deploy-skills.ps1`
copie *tout* dossier de `.claude/skills/` vers `~/.claude/SKILLS/`. Un gabarit
posé là deviendrait un skill personnel actif. Les fichiers portent en plus le
nom `SKILL.gabarit.md` : ni Claude Code ni le compte ne chargent ce nom. Garde
**par construction**, pas par vigilance.

---

## Fond et forme

Chaque fichier du gabarit est découpé en blocs balisés :

| Balise | Contenu | À l'instanciation |
|---|---|---|
| `<!-- 🔒 FOND:<id> -->` … `<!-- /FOND:<id> -->` | la méthode : honnêteté, preuves, aperçu avant écriture, DELTA… | **copié tel quel, jamais édité dans l'instance** |
| `<!-- ✏️ FORME:<id> -->` … `<!-- /FORME:<id> -->` | ce qui est propre au projet : chemins, commandes, scripts, gestes | **rempli pour le projet** |
| `{{…}}` | valeur ponctuelle (nom, suffixe) | remplacée |

Une amélioration du **fond** se fait **ici**, dans le gabarit (bump de version),
puis se reporte dans chaque instance. Une instance qui voudrait changer son fond
signale un besoin du gabarit, pas une adaptation locale.

---

## Instancier dans un projet

1. **Choisir le suffixe** du projet (`ah` pour App-Handyman, par exemple).
   Les noms de l'instance seront `recap-<suffixe>` et `session-prep-<suffixe>`.
   **Jamais `recap` ni `session-prep` nus** : ces noms sont portés par
   `suspension-intelligente` et servis au compte, et un homonyme est effacé
   sans signal (ISSUE-001, run E). Vérifier avant :
   `ls ~/.claude/SKILLS/` et le `.claude/skills/` de chaque dépôt actif.
2. **Copier** dans le projet :
   ```
   <projet>/.claude/skills/recap-<suffixe>/SKILL.md         ← recap/SKILL.gabarit.md
   <projet>/.claude/skills/session-prep-<suffixe>/SKILL.md  ← session-prep/SKILL.gabarit.md
   <projet>/docs/CONTINUITE-SESSION-TEMPLATE.md             ← template-continuite.md (si le projet n'en a pas)
   ```
3. **Remplir chaque bloc FORME** en **mesurant** le projet : les commandes de
   test ou de dette s'exécutent une fois et leur sortie réelle se relit avant
   d'être gravée. Une valeur sans objet s'écrit `aucun` — le fond saute alors
   l'étape et le dit.
4. **Remplacer `{{…}}`**, mettre `version: 1.0.0`, et laisser la ligne
   `Instancié depuis` renseignée (version du gabarit + sha de la maison).
5. **Contrôles avant commit**, dans cet ordre :
   ```bash
   G=<maison>/gabarits/rituel-session
   I=<projet>/.claude/skills
   # a) plus aucun placeholder — contrôle positif d'abord : le gabarit doit en contenir
   grep -c '{{' "$G/recap/SKILL.gabarit.md"          # attendu > 0
   grep -n '{{' "$I"/recap-*/SKILL.md "$I"/session-prep-*/SKILL.md   # attendu : rien
   # b) le fond est intact
   fond() { awk '/<!-- 🔒 FOND:/,/<!-- \/FOND:/' "$1" | tr -d '\r'; }
   diff <(fond "$G/recap/SKILL.gabarit.md")        <(fond "$I"/recap-*/SKILL.md)        && echo "FOND recap intact"
   diff <(fond "$G/session-prep/SKILL.gabarit.md") <(fond "$I"/session-prep-*/SKILL.md) && echo "FOND session-prep intact"
   ```
   Le `diff` normalise les fins de ligne (`tr -d '\r'`) : comparer des octets
   bruts fabrique de fausses divergences (ISSUE-004).
6. Commit dans le **dépôt du projet**, `git add` nommé.

Le même contrôle (b) sert plus tard à détecter une instance dont le fond a
dérivé du gabarit, ou un gabarit amélioré pas encore reporté.

---

## Ce que le fond porte, et d'où il vient

Chaque règle du fond est née d'un incident mesuré. Les pointeurs servent à
retrouver pourquoi ; ils ne se recopient pas dans les instances.

| Règle du fond | Origine |
|---|---|
| Le recap **écrit** `HEAD : \`sha\``, mesuré sur la réf distante | obs 21, store `Suspension-intelligence` |
| session-prep lit les recaps **sur la réf**, verdict distinct si le dernier n'y est pas | obs 23, même store |
| TODO : motif mesuré, contrôle positif, ligne 📖 obligatoire | obs 22, même store |
| Date mesurée par git / `TZ`, jamais par `date` nu ni l'en-tête de session | ISSUE-007, `claude-skills` |
| Lectures git en `--no-optional-locks` (pont Cowork) | ISSUE-006, `claude-skills` |
| `fetch` en échec (403 en VM) → le déclarer, ne pas le taire | TODO `claude-skills`, 2026-07-27 |
| DELTA « ne pas refaire » appuyé par une preuve ; recaps frères du jour | `session-prep` de `suspension-intelligente` |
| Aucun VALIDÉ sans accord explicite ; aperçu puis « oui » avant écriture | `recap` de `suspension-intelligente` |

**État de calibration des procédures en ligne du fond** (principes transverses
1, 9, 11) :

| Procédure | État |
|---|---|
| Verdict de continuité (session-prep, étape 2) | **Rodé sur dépôt jetable, 2026-09-23** : 5 cas (aucun recap, RECAP_LOCAL, OK après clôture, GAP, sans HEAD) rendent le verdict attendu, 0 verrou restant. Ce rodage a **trouvé un défaut** : sans exclure les fichiers de clôture, chaque clôture propre rendait GAP ; corrigé et re-mesuré. Jamais tourné sur un vrai dépôt. |
| Contrôles d'instanciation (§ Instancier, étape 5) | **Rodés dans les deux sens** : instance correcte en CRLF acceptée, mutation du fond détectée, modification de forme seule acceptée, placeholder oublié détecté. |
| Axes de sync, shortlist anti-sur-claim, gate code/docs | **Non calibrés** — gardes par vigilance. Première instance = premier test. | Là où un projet possède un script testé qui fait le même travail,
son bloc FORME le déclare et le fond l'invoque à la place.

---

## Fichiers

| Fichier | Rôle |
|---|---|
| `README.md` | ce mode d'emploi |
| `recap/SKILL.gabarit.md` | clôture de session |
| `session-prep/SKILL.gabarit.md` | ouverture de session, lecture seule |
| `template-continuite.md` | template minimal du recap, bloc d'en-tête `HEAD` compris |
