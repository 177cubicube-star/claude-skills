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

## ISSUE-007 — Les dates écrites par une session Cowork sont celles d'UTC : tout travail fait après 20 h locale est daté du lendemain

**Date :** 2026-07-29
**Statut :** **Corrigé** — 18 dates rétro-corrigées dans quatre fichiers, règle de
mesure posée ci-dessous
**Contexte :** session Cowork du 2026-07-29 (projet SKILLS_POLICE) · ISSUE-004 à
ISSUE-006, l'entrée de journal du 29 et le `.gitignore`, tous créés ce soir-là ·
question de Mathieu : « le décalage d'heure, c'est une problématique générale que
j'ai et je ne sais pas pourquoi »
**Type :** Méthode de mesure
**Sévérité :** Élevée — dans un dépôt dont toute la méthode est la mesure datée,
une date fausse casse la chronologie qui sert de preuve

**En une ligne :** la session Cowork a daté tout son travail du **2026-07-30**
alors qu'il était **le 2026-07-29 à 21 h 30** chez Mathieu, puis a accusé une
session Claude Code d'avoir mal daté le sien — c'est l'inverse qui était vrai.

**Mesuré le 2026-07-29 à 22 h 49 locale :**

| Horloge | Réponse | Écart |
|---|---|---|
| Conteneur infonuagique de la session Cowork | 2026-07-30 02:49 UTC | +4 h |
| VM du pont sur le poste (`device_bash`) | `Etc/UTC`, `+0000` | +4 h |
| Windows / git (`%ad` des commits) | 2026-07-29 22:49 `-04:00` | référence |

Les deux environnements qu'une session Cowork peut interroger sont en UTC. Le
seul qui porte l'heure de Mathieu est Windows, et il n'est atteignable
qu'indirectement — par git, qui horodate avec le fuseau du poste.

**Pourquoi ce défaut le touche systématiquement.** Toronto est à UTC-4 : dès
**20 h locale**, UTC est déjà le lendemain. Or les douze derniers commits du dépôt
tombent à 21 h (×4), 20 h (×2), 22 h (×1), 19 h (×1) — la majorité du travail est
dans la fenêtre où la date UTC est fausse. Ce n'est pas un incident, c'est le
régime normal de ses soirées.

**Le symptôme inverse existe aussi**, et il explique l'autre moitié de la
confusion : une session **Claude Code** sur Windows lit l'horloge locale et date
juste, mais si elle traverse minuit elle garde la date de son ouverture. Selon
l'outil, la même soirée produit donc des dates en **avance** (Cowork, dès 20 h) ou
en **retard** (Code, après minuit). D'où l'impression d'un décalage général sans
cause identifiable — il y a deux causes opposées, pas une.

**Rétro-correction appliquée le 2026-07-29 :** 18 occurrences de `2026-07-30`
ramenées à `2026-07-29` — `CLAUDE.md` (1), `.gitignore` (1), `TODO.md` (4 plus le
titre de l'entrée de journal), `ISSUES-LOG.md` (8, dont les en-têtes de date
d'ISSUE-004, ISSUE-005 et ISSUE-006), et les mentions d'heures relues en local.
Laissé tel quel comme trace : le nom `index.lock.orphelin-20260730-0139`, que le
fichier a réellement porté.

**Règle de mesure.** Une date qui entre dans un fichier de ce dépôt se **mesure**
sur l'horloge du poste — jamais sur l'en-tête de la session, jamais sur `date` du
pont. Commande de référence, disponible depuis le pont :

```
git log -1 --format=%ad --date=format:'%Y-%m-%d %H:%M %z'
```

Elle rend l'heure locale et son décalage, parce que git horodate avec le fuseau de
Windows. Depuis un conteneur, `TZ=America/Toronto date` fait l'affaire. Le contrôle
qui aurait suffi ce soir : comparer la date qu'on s'apprête à écrire au `%ad` du
dernier commit.

**Réflexe réutilisable.** « Mesurer plutôt que supposer » vaut aussi pour la date.
Elle a l'air d'un fait donné ; c'est une mesure, et elle a un fuseau. Un agent qui
écrit une date sans l'avoir mesurée signe le document avec l'heure du serveur qui
l'héberge.

---

## ISSUE-006 — Toute commande git lancée depuis le pont Cowork laisse un `.git/index.lock` orphelin : le pont ne sait pas supprimer

**Date :** 2026-07-29
**Statut :** **Fermé sur le symptôme, cause armée** — verrou déplacé le
2026-07-29 à 21 h 39, puis **supprimé et vérifié absent** le même soir en session
Claude Code (`test -e` négatif, `git fsck` sain) ; la règle d'usage ci-dessous est
un garde par vigilance, pas par construction
**Contexte :** session Cowork avec `claude-skills` monté par le pont
(`device_bash`) · `git status --short` lancé à 01:39
**Type :** Outillage / pont Cowork
**Sévérité :** Élevée — un verrou orphelin bloque la **prochaine** commande git
du poste, et son message d'erreur accuse une cause qui n'existe pas

**En une ligne :** `git status` a fonctionné, puis a échoué à retirer son propre
verrou — `warning: unable to unlink '.git/index.lock': Operation not permitted` —
laissant un fichier de 0 octet qui aurait fait échouer le prochain `git add` de
Mathieu sur Windows.

**Ce qui se passe.** Git pose `.git/index.lock` dès qu'il rafraîchit l'index,
même pour une lecture, puis le retire. Le pont Cowork monte le dossier en
lecture-écriture mais **interdit `unlink`** : création autorisée, suppression
refusée. Le verrou survit donc à la commande qui l'a posé.

**Conséquence sur le poste.** La commande git suivante échoue par « Unable to
create '.git/index.lock': File exists », qui désigne un processus git concurrent
inexistant. Le diagnostic naturel — « une session a planté » — est faux, et la
vraie cause n'est pas visible depuis Windows.

**Contournement appliqué le 2026-07-29.** Le verrou a été **déplacé**, pas
supprimé (le pont ne sait pas supprimer) : `.git/index.lock` →
`.git/index.lock.orphelin-20260730-0139` — nom dont la date est elle-même en UTC
(ISSUE-007), conservé tel quel puisque le fichier l'a porté. Supprimé depuis.

**Portée élargie, mesurée le 2026-07-31 : un second dépôt est touché.**
`Suspension-intelligente` portait un `.git/index.lock` de 0 octet daté du
2026-07-30 à 13 h 09, qui a fait échouer un `git switch` dix-huit heures plus
tard. Le motif n'est donc pas propre à `claude-skills` : il suit le pont, pas le
dépôt. Retiré par nom complet, sans joker ; `git status` exit 0, `fsck` sain.

**Et le contournement s'accumule — la parade est une garde `qui se régénère`.**
Le même dépôt portait un dossier `.git/_locks-perimes-a-supprimer/` avec
**quatre verrous git** datés du 2026-07-20 : `index.lock`, `packed-refs.lock`, et
deux verrous de référence (`recap-20260719-04.lock`,
`issue035-rag-counsel-trigger.lock` — noms de branches, vérifiés au reflog).
Onze jours dans un dossier dont le nom est un ordre que personne n'a exécuté.
C'est la forme la plus littérale de l'obs 18 du store : le geste de contourner
produit l'artefact qui atteste que le problème est traité, donc plus personne ne
le cherche. Les quatre supprimés le 2026-07-31, le dossier avec — un dossier vide
portant ce nom n'est pas neutre, il invite à rejouer la parade.
**Ce que ça ne corrige pas :** la cause. Cinq verrous retirés, zéro mécanisme
changé. Le prochain passage du pont en posera un autre.

**Règle d'usage, mesurée.** Depuis une session Cowork, lire l'état git avec
`git --no-optional-locks <commande>` — le drapeau existe exactement pour cela.
Vérifié le 2026-07-29 : `git --no-optional-locks status --short` rend le même
résultat et **ne crée aucun verrou**. Les commandes d'écriture (`add`, `commit`,
`push`) restent hors de portée du pont et doivent le rester : elles posent un
verrou qu'elles ne pourront pas reprendre.

**Ce que cela révise.** Le journal du 2026-07-24 notait « git = lecture seule
depuis Cowork » comme une limite d'accès subie. C'en est aussi une **règle de
sécurité** : une écriture git depuis le pont laisserait le dépôt verrouillé
derrière elle.

**Réflexe réutilisable.** Sur un système de fichiers monté à distance, vérifier
non pas ce qu'on peut écrire, mais ce qu'on peut **retirer**. Un outil qui pose
un fichier temporaire sans pouvoir le reprendre laisse une panne différée, à un
endroit qui n'accusera pas le vrai coupable.

---

## ISSUE-005 — La liste d'autorisations locale de la maison rejoue indéfiniment `git push`, `Remove-Item *` et la lecture de tout le profil — et rien ne la protégeait d'un commit accidentel

**Date :** 2026-07-29
**Statut :** **Rouvert le 2026-07-30 — l'élagage ne tient pas.** Garde
**qui se régénère** : ni par construction, ni par vigilance. Mesuré trois minutes
après l'élagage, **trois des dix entrées retirées étaient revenues** —
`Bash(git add *)`, `Bash(git push *)`, `Bash(python *)` — soit exactement les
trois commandes utilisées entre-temps. Se servir d'une commande **réinscrit son
motif large**. Les sept autres ne « tiennent » pas : elles sont inutilisées, et
reviendront au premier usage. Parade minimale du 2026-07-29 (`.gitignore` étroit,
étendu à la classe `.bak-*` le 2026-07-30) : **toujours valide**, elle protège la
publication et non le contenu de la liste.
**Contexte :** `.claude/settings.local.json` (11 869 o, écrit le 2026-07-28 à
00:31), non suivi par git · règle « `git add` nommé, jamais `-A` » (CLAUDE.md,
README) · ADR-028 (le dépôt est la source ; le disque est une cible jamais
éditée à la main)
**Type :** Gouvernance
**Sévérité :** Moyenne pour le risque de commit, Élevée pour la portée des
autorisations

**Deux problèmes distincts dans un même fichier.**

### 1. Rien ne le protégeait

Le dépôt n'avait **aucun `.gitignore`**. Un `git add -A` — celui que la règle
d'ordre interdit précisément — aurait committé puis poussé sur GitHub un fichier
de réglages personnels de 11 869 octets, avec les chemins absolus du poste et
l'historique des commandes autorisées. La règle existait, le filet non.

**Parade posée le 2026-07-29 :** `.gitignore` créé, avec **une seule entrée** —
`.claude/settings.local.json`. Volontairement étroite : ignorer `.claude/` en bloc
décrocherait la maison entière (`.claude/skills/`, dix skills suivis). Vérifié
après écriture : le fichier a disparu de `git status`, les dix skills y restent.

### 2. Son contenu est une autorisation permanente que personne ne relit

La liste `permissions.allow` a grossi par accumulation : chaque « oui » ponctuel
d'une session s'y est gravé. Elle contient aujourd'hui, entre autres :

```
"Bash(git add *)"           "Bash(git commit *)"       "Bash(git push *)"
"Bash(cp *)"                "PowerShell(Remove-Item *)"
"Read(//c/Users/mat_g/**)"  "Read(//c/Users/mat_g/.claude/skill-observations/**)"
```

Conséquence mesurable : toute session Claude Code ouverte dans ce dépôt peut
committer, pousser sur `origin/main`, copier n'importe quoi et supprimer par
PowerShell **sans redemander**, et lire l'intégralité du profil utilisateur — y
compris `~/.claude`, que ce dépôt traite par ailleurs comme une cible qu'on
n'édite jamais à la main.

C'est la contradiction à nommer : la gouvernance interdit d'éditer les copies
déployées, et la liste d'autorisations permet de les écraser sans confirmation.
L'incident du 2026-07-26 (« un autre agent avait écrit dans la maison ») a été
consigné comme un problème d'accès externe ; ce fichier montre que la porte
intérieure est ouverte aussi.

**Ce que cette entrée ne tranche pas.** Quelles entrées retirer. Ce fichier est
la configuration vivante des sessions de Mathieu ; l'élaguer depuis une session
Cowork casserait des workflows en cours sans qu'il l'ait demandé. Le tri lui
appartient.

**Piste de tri, si elle est jugée utile.** Les entrées à joker large
(`git push *`, `Remove-Item *`, `cp *`, `Read(//c/Users/mat_g/**)`) portent tout
le risque. Les entrées littérales et longues — une commande git complète avec son
chemin — sont inoffensives et documentent l'histoire des mesures ; elles peuvent
rester.

**Élagage du 2026-07-30 — exécuté, 143 → 133.** Sur décision de Mathieu. La
re-mesure a d'abord montré que le fichier avait **grossi de 94 à 143 entrées en
deux jours** — la liste repousse à l'usage, ce qui fait de tout décompte un
instantané.

Dix entrées retirées, toutes des jokers portant un verbe à effet de bord :

| Retirée | Motif |
|---|---|
| `Bash(git add *)` `Bash(git commit *)` `Bash(git push *)` | **annulaient R202**, règle [SAFETY LOCK] qui exige confirmation |
| `Bash(cp *)` `PowerShell(Remove-Item *)` | copie et suppression sans confirmation |
| `Bash(py -3.13 -c ' *)` `Bash(python *)` | exécution de code arbitraire |
| `Bash(gh repo *)` `Bash(gh api *)` | couvrent `gh repo delete` et le changement de visibilité — donc **rendre publics** les dépôts privés créés le matin même |
| `PowerShell(winget install *)` | installation de paquets sans confirmation |

Les quatre dernières n'existaient pas lors de la mesure du 2026-07-29 : elles sont
apparues pendant les deux jours suivants. Contrôle après écriture, relu depuis le
disque : **0 joker à effet de bord** dans les 133 entrées restantes.

Conséquence assumée, et c'est le fond de cette ISSUE : la session qui a fait
l'élagage venait d'enchaîner une dizaine de commits et de pushes **sans une seule
confirmation**. Ils en demanderont désormais. La friction qui revient n'est pas un
effet de bord — c'est R202 qui reprend effet après avoir été dispensée en silence
par un « oui » ponctuel que personne n'avait décidé de rendre permanent.

Sauvegarde avant écriture : `.claude/settings.local.json.bak-20260730` (16 600 o).
Le fichier étant ignoré par git, c'est le seul chemin de retour.

**Reste non tranché** : les 7 entrées mortes et la redondance de
`Read(//c/Users/mat_g/**)`, qui englobe cinq entrées `Read` plus étroites. Sans
risque — du bruit, pas une faille.

**Correction du 2026-07-30, trois minutes plus tard — l'élagage ne tient pas.**
Le paragraphe ci-dessus disait « 0 joker à effet de bord » et le statut de cette
ISSUE a été écrit « Résolu, garde par construction », puis poussé. **C'était
faux.** Re-mesure après trois commandes :

| Retirée | État 3 min plus tard |
|---|---|
| `Bash(git add *)` · `Bash(git push *)` · `Bash(python *)` | **REVENUES** — les trois utilisées entre-temps |
| les sept autres | absentes — mais **inutilisées**, pas protégées |

Le mécanisme est démontré : **se servir d'une commande réinscrit son motif large**.
Élaguer une liste d'autorisations est donc un geste sans effet durable — le
fonctionnement ordinaire du système le défait.

Trois enseignements, dans l'ordre de leur portée :

1. **Un troisième type de garde existe**, que le vocabulaire de l'observation 13
   ne prévoyait pas. Après `par construction` et `par vigilance` : **`qui se
   régénère`**. Il est pire que l'absence de garde, parce qu'il laisse une trace
   écrite affirmant que le problème est réglé. C'est ce qui s'est produit ici,
   sur GitHub, pendant trois minutes.
2. **La faute de rédaction est celle du principe 11 (d)** : un énoncé dont la
   portée dépasse l'instrument. « 0 joker » était vrai **à l'instant de la
   mesure** ; « l'occasion n'existe plus » en tirait un état permanent qu'aucun
   run ne portait. La contre-mesure — re-mesurer après un usage — n'a été
   appliquée que par accident, en vérifiant si un `push` demanderait confirmation.
3. **Le vrai remède est ailleurs, dans un fichier que la session ne réécrit pas.**
   `permissions.ask` ou `permissions.deny` posés dans le `.claude/settings.json`
   **suivi par git** — mesuré ci-dessous.

**Mesure de précédence du 2026-07-30.** Protocole conçu pour que chaque verdict
n'ait qu'une cause possible (principe transverse 11 a et c). Le piège évité :
une règle `ask` qui ne déclenche rien est indiscernable d'un fichier de réglages
non rechargé. D'où un **troisième point de mesure** — une règle `deny`, dont la
précédence sur `allow` est documentée : si `deny` mord, les réglages sont chargés
et le verdict sur `ask` a un sens.

Les deux commandes testées étaient présentes dans `allow` de la liste locale au
moment du test — prémisse vérifiée, pas supposée.

| Commande | Dans `allow` | Règle posée | Résultat |
|---|---|---|---|
| `git rev-list --count HEAD` | oui | `deny` | **bloquée** |
| `git status --short` | oui | `ask` | **exécutée, sans confirmation** |

**Précédence mesurée : `deny` > `allow` > `ask`.**

Conséquence directe : **`ask` est inutilisable** contre une liste qui se
régénère — elle est écrasée par le premier `allow` que l'usage réinscrit. Seul
`deny` tient.

Deux faits mesurés au passage, à connaître avant d'écrire un `deny` :

- **`deny` interdit, il ne demande pas.** Il n'y a pas de niveau « confirmer »
  opposable à un `allow`. Une commande refusée ne peut pas être approuvée en
  session : il faut éditer le fichier.
- **`deny` s'applique à la chaîne entière.** Une commande composée contenant un
  fragment interdit est refusée en bloc — mesuré en tentant de retirer le fichier
  de test par une commande qui mentionnait `git rev-list`.

**Recadrage, avant de conclure que R202 était contournée.** Une entrée `allow`
n'annule pas R202 : elle retire le **filet du harnais**, pas la règle. R202 est
une règle que l'agent applique, et elle l'a été — chaque `push` de la session du
2026-07-29→30 a eu lieu parce que Mathieu avait écrit « push ». Ce que `Bash(git
push *)` supprime, c'est la seconde ligne de défense, celle qui protège d'un agent
qui n'appliquerait pas la règle. La distinction change le remède : il ne s'agit
pas de rétablir une confirmation déjà obtenue, mais de rendre **structurels les
arrêts durs** de R202.

**Piste retenue, non appliquée — décision de Mathieu.** Poser en `deny` dans le
`.claude/settings.json` suivi par git la liste des arrêts durs de R202 :
`git push --force`, `git reset --hard`, `git clean -fd`, `gh repo delete`,
`gh repo edit` (visibilité). Coût assumé : ces gestes deviendraient impossibles
sans édition du fichier — c'est la définition d'un arrêt dur, et cette session en
a exécuté un (le `--force-with-lease` du 2026-07-29), qui aurait exigé ce geste.

Décompte : **94 entrées** dans `permissions.allow`.

| Classe | Nombre | Porte le risque ? |
|---|---|---|
| Joker large sur verbe d'écriture | **6** | Oui — tout le risque |
| Joker étroit | 12 | Partiellement (voir entrées mortes) |
| Littéral — une commande exacte, une seule chose possible | **76** | Non — documentaires |

Les six à risque, dont **une que la piste de tri ne nommait pas** :

```
Bash(git push *)            Bash(git commit *)         Bash(git add *)
Bash(cp *)                  PowerShell(Remove-Item *)  Bash(py -3.13 -c ' *)
```

`Bash(py -3.13 -c ' *)` exécute du code Python arbitraire : sa portée réelle
égale celle de `Remove-Item *`. Elle avait échappé au premier tri — et à mon
propre classificateur, calibré sur des **verbes** au lieu de la **sémantique**.
Le défaut est celui de l'amendement du principe transverse 1 (« la cause
structurelle à connaître avant de choisir un motif »), commis une heure après
son écriture. Une liste d'autorisations ne se trie pas par nom de commande.

**La contradiction à nommer, mesurée.** `CLAUDE.md` et `README.md` posent
« `git add` nommé, jamais `-A` » — règle qui existe précisément pour empêcher
qu'une sonde jetable entre dans l'historique. La liste accorde
`Bash(git add *)`, **qui couvre `git add -A`**. La règle interdit le geste,
l'autorisation le permet sans confirmation. Même forme que la contradiction déjà
nommée au § 2 sur les copies déployées, mais portant sur la règle la plus citée
du dépôt.

**Sept entrées mortes, mesurées.** `Read(//c/Users/mat_g/**)` **englobe**
`Read(…/Documents/**)`, `Read(…/Documents/Claude/**)`,
`Read(…/.claude/skill-observations/**)` et les deux
`Read(…/.claude/projects/…claude-skills/**)` — cinq entrées qui n'ajoutent
aucun droit. Elles documentent le mécanisme d'accumulation : chaque session a dit
oui à un chemin plus étroit, puis un oui a été donné au profil entier, et
personne n'a retiré les précédents. **Le choix n'est donc pas de les retirer,
mais de décider quel bout on garde** — le large (les cinq tombent, rien ne
change) ou les étroits (le large tombe, et le privilège se restreint réellement).
S'y ajoutent les deux `sed -i` posant les marqueurs `MARQUEUR-V3BIS-*`,
reliquats d'une mesure terminée.

**Parade vérifiée.** `git check-ignore -v .claude/settings.local.json` confirme
que l'entrée du `.gitignore` mord, et qu'elle reste étroite — `.claude/` n'est pas
ignoré en bloc, la maison demeure suivie.

**Réflexe réutilisable.** Une liste d'autorisations est un journal qui **exécute**.
Elle enregistre des « oui » ponctuels et les rejoue indéfiniment, sans date et
sans motif. Elle se relit à intervalle, comme un ISSUES-LOG — sinon elle devient
une porte que personne n'a décidé d'ouvrir.

---

## ISSUE-004 — Comparer les octets entre deux circuits fabrique de fausses divergences : `grill-me` et `json-canvas` signalés divergents, contenu identique

**Date :** 2026-07-29
**Statut :** **Constaté** — règle de méthode posée ci-dessous ; reste ouverte la
question de rejouer l'audit repo ↔ compte du 2026-07-26
**Contexte :** session Cowork (projet SKILLS_POLICE), premier accès mesuré à la
copie personnelle depuis Cowork (`Desktop\SKILLS` branché par Mathieu) ·
`deploy-skills.ps1` lignes 51-56 · audit md5 repo ↔ compte du 2026-07-26
**Type :** Méthode de mesure
**Sévérité :** Moyenne — aucun effet sur le contenu déployé ; effet réel sur la
confiance qu'on peut accorder à un verdict de divergence

**En une ligne :** un `md5sum` brut sur `SKILL.md` a déclaré deux skills
divergents entre la copie personnelle et la maison **à numéro de version
identique** — la divergence était entièrement due aux fins de ligne.

**Mesuré le 2026-07-29 :**

```
grill-me      disque LF  (24 lignes,   811 o) · maison CRLF (24 lignes,   835 o)
json-canvas   disque LF  (245 lignes, 7639 o) · maison CRLF (245 lignes, 7884 o)
diff --strip-trailing-cr  →  identiques au caractère près, les deux
```

Les huit autres skills sont identiques octet pour octet, `task-observer-perso`
compris. L'écart ne suit donc aucune règle globale : il ne s'anticipe pas
fichier par fichier, il se mesure.

**Ce qui se passe.** Le dépôt porte `* text=auto` (`.gitattributes`), donc git
compare des contenus normalisés et ne voit rien. L'état réel des fichiers, lui,
n'est pas uniforme — mesuré le 2026-07-29 sur les dix skills :

| Fin de ligne | Maison (copie de travail) | Disque (`~\.claude\SKILLS`) |
|---|---|---|
| CRLF | `grill-me`, `json-canvas` | aucun |
| LF | les huit autres | les dix |

Les deux fichiers signalés sont donc les seuls, dans la copie de travail, que
rien n'a réécrits depuis l'extraction par git ; les huit autres ont été réécrits
en LF par un outil de session à un moment indéterminé. `git status` reste muet
dans les deux cas. Un audit par octets ne mesure donc pas la dérive de contenu :
il mesure **quel outil a touché le fichier en dernier**.

**Bénéfice inattendu de la mesure.** `json-canvas` est précisément le fichier
marqué des deux côtés pendant la mesure V3-bis du 2026-07-27
(`MARQUEUR-V3BIS-MAISON` et `MARQUEUR-V3BIS-PERSONNEL`, visibles dans la liste
d'autorisations locale). Le protocole exigeait « marqueur retiré et copie
restaurée après verdict » sans que personne ne l'ait vérifié depuis. C'est fait,
trois jours plus tard, par effet de bord : les deux copies sont identiques au
caractère près. La restauration a bien eu lieu.

**Pourquoi c'est une issue et pas une note de bas de page.** La règle du dépôt
dit que deux contenus différents ne portent jamais le même numéro de version. Un
faux positif de divergence à version égale déclenche donc exactement l'alarme la
plus grave de la maison, et envoie chercher une dérive qui n'existe pas — le
coût est une session, pas un fichier.

**Le remède existait déjà dans le dépôt.** `deploy-skills.ps1` normalise
`\r\n` → `\n` avant de hacher, et son commentaire de la ligne 51 nomme le piège
mot pour mot : « Comparer les octets ferait voir une divergence sur chaque
fichier. » Le script avait raison ; l'instrument improvisé avait tort.

**Règle de méthode (applicable immédiatement).** Toute comparaison de copies
entre deux circuits — maison ↔ disque ↔ compte — normalise les fins de ligne
avant de comparer, ou réutilise la fonction de hachage de `deploy-skills.ps1`.
Un `md5sum` ou `Get-FileHash` brut n'est pas un instrument d'audit valide dans
ce dépôt.

**Question ouverte.** L'audit md5 repo ↔ compte du 2026-07-26 — celui qui a
conclu « `tdd-enforcer` périmé sur le compte » — a-t-il normalisé ? Si non, son
verdict peut rester juste par ailleurs, mais sa méthode est à rejouer sous la
règle ci-dessus. Non mesurable depuis Cowork : le compte n'expose pas ses
fichiers.

**Réflexe réutilisable.** Avant de conclure à une divergence entre deux copies,
mesurer d'abord **comment l'outil qui les déploie les compare**. L'instrument de
l'audit doit être celui du déploiement, jamais un raccourci de session.

---

## ISSUE-003 — `deploy-skills.ps1` sort en code 1 sur un déploiement réussi : le succès de robocopy masque l'échec réel

**Date :** 2026-07-27
**Statut :** **Corrigé (2026-07-27)** — neutralisation posée, **les deux sens
mesurés** (voir « Vérification » en fin d'entrée)
**Contexte :** `deploy-skills.ps1` lignes 106-132 · premier usage réel du script
(déploiement de `task-observer-perso` v1.3.0, commit `0dd5496`)
**Type :** Outillage
**Sévérité :** Moyenne — aucun effet sur le contenu déployé ; effet réel sur la
capacité à détecter un déploiement raté

**En une ligne :** `.\deploy-skills.ps1 -Apply -Backup` retourne **1** alors que
le déploiement a réussi et que le script l'affiche lui-même en vert.

**Ce qui se passe.** `robocopy` retourne `1` quand il a copié au moins un fichier
(« one or more files copied successfully ») — un code de **succès** dans sa
convention, pas d'échec. Le script teste `if ($LASTEXITCODE -ge 8) { throw }`,
ce qui est **correct** pour détecter un échec de sauvegarde, mais il ne remet
jamais `$LASTEXITCODE` à zéro ensuite. PowerShell propage donc le `1` de robocopy
comme code de sortie du script entier.

**Mesuré par test isolé le 2026-07-27 :**

```
robocopy <cible> <tmp> /E /COPY:DAT ...  → LASTEXITCODE = 1  (copie reelle)
robocopy <cible> <tmp> /E /COPY:DAT ...  → LASTEXITCODE = 0  (rien a copier)
```

Le déclencheur est donc `-Backup` **avec** des fichiers à sauvegarder — c'est-à-dire
le cas nominal. Sans `-Backup`, ou sur une sauvegarde sans nouveauté, le script
sort en 0.

**Pourquoi cette entrée existe — le vrai risque n'est pas le faux échec.** Le
script possède un `exit 1` **légitime** en ligne 131 : « fichiers divergents
APRÈS écriture », le seul signal qui distingue un déploiement raté d'un
déploiement réussi. Les deux modes partagent maintenant un même code de sortie.
Deux conséquences :

1. Tout hook, gate ou script d'automatisation qui lirait `$LASTEXITCODE` (ou
   `if ($?)`) prendrait un déploiement nominal pour un échec.
2. Plus grave, dans l'autre sens : l'opérateur qui voit « code 1 » sur chaque
   déploiement réussi **apprend à l'ignorer** — et le jour où le 1 est le vrai,
   il n'a plus de signal. Une alarme qui sonne toujours ne sonne plus.

Cette inversion est cousine d'ISSUE-002 : là, un rapport d'échec faux avait fait
rejouer une séquence déjà exécutée ; ici, un code d'échec faux entraîne à ne plus
croire le vrai. Dans les deux cas, **le rapport de l'outil n'est pas l'état du
monde** — le déploiement du 2026-07-27 a d'ailleurs été prouvé hors du script,
par marqueur de contenu et diff source ↔ cible.

**Correctif appliqué le 2026-07-27 :** neutraliser le code de robocopy dès qu'il
a été jugé, pour que seul le script parle de son propre succès. Une ligne, juste
après le test existant (accompagnée du commentaire qui dit pourquoi) :

```powershell
if ($LASTEXITCODE -ge 8) { throw "Sauvegarde echouee (robocopy $LASTEXITCODE). Rien ecrit." }
$global:LASTEXITCODE = 0        # <- robocopy 1..7 = succes ; ne pas le laisser fuir en code de sortie
```

**Vérification — les deux sens, par exécution.**

1. **Le succès sort bien 0.** Divergence délibérée posée dans la cible
   (`defuddle/SKILL.md`), puis `deploy-skills.ps1 -Apply -Backup` lancé en
   **processus séparé** — seule façon de lire le vrai code de sortie. La
   sauvegarde a bien copié (donc robocopy a bien rendu 1 en interne) et le
   script a rendu **0**, contre **1** avant correctif sur la même forme d'appel.
   La cible a été restaurée par le déploiement lui-même : aucun résidu.
2. **L'échec légitime sort toujours 1.** La divergence post-écriture (ligne 131)
   ne se force pas naturellement — le mécanisme a donc été mesuré sur une sonde
   jetable reproduisant la structure exacte : `robocopy` → neutralisation →
   `exit 1` plus loin. Résultat : robocopy 1 → neutralisé à 0 → **la sonde sort
   1**. Un `exit` explicite postérieur n'est pas avalé par la neutralisation.
   C'est un **proxy du mécanisme**, pas le chemin réel du script parcouru de
   bout en bout — la distinction est gardée nette exprès.

**Réflexe :** quand un script enveloppe un outil natif, le code de sortie de
l'outil n'est pas le sien. Le juger, puis le neutraliser — sinon la convention
de l'outil (robocopy : 1 = succès) écrase celle du script (1 = échec), et les
deux deviennent illisibles.

---

## ISSUE-002 — Deux commits au message identique : un seul changement logique, scindé par un rapport d'échec faux

**Date :** 2026-07-27
**Statut :** Résolu — traçabilité fermée, historique non réécrit
**Contexte :** commits `e7adc71` et `081857b`
**Type :** Git
**Sévérité :** Mineure — aucun effet sur le contenu, effet réel sur la lisibilité
de l'historique

**En une ligne :** `e7adc71` et `081857b` sont **un seul changement logique**,
scindé par un rapport d'échec faux ; `081857b` n'ajoute que le renvoi inline
(3 lignes).

**Ce qui s'est passé :** l'appel d'outil portant `git add` + `commit` + `push` a
été rapporté à l'agent comme **refusé**, alors qu'il s'était exécuté —
l'interruption est arrivée après l'exécution. L'agent a tenu le rapport d'échec
pour un fait, supposé l'arbre inchangé, et rejoué la séquence. D'où deux commits
au message identique. Détecté en lisant une plage de push incohérente avec le
dernier état connu (`e7adc71..081857b` au lieu de `bfe6729..`).

**Pourquoi cette entrée existe :** `git log` seul raconterait à une session
future une histoire fausse — doublon accidentel, ou revert manqué. Le récit
complet vit dans le log d'observations (obs 10), **hors du dépôt**, à un endroit
qu'aucun rituel de session ne lit. Une note git est également attachée à
`081857b` ; elle porte le même texte, mais les notes ne sont ni poussées ni
récupérées par défaut — un clone frais ne les verrait pas. D'où la redondance
délibérée : la note pour qui lit `git log`, cette entrée pour qui clone.

**Effet secondaire à assumer :** Mathieu avait demandé deux vérifications
**avant** commit ; le commit avait déjà eu lieu. Le contenu final est conforme —
la 4ᵉ limite figurait déjà dans `e7adc71` — mais la séquence exigée ne l'a pas
été. Historique publié, donc non réécrit.

**Réflexe :** un rapport d'échec est une affirmation sur le monde, pas le monde.
Après tout appel rapporté refusé, interrompu ou en échec, mesurer l'état réel
avant l'action suivante — surtout quand l'action rapportée en échec était
irréversible.

---

## ISSUE-001 — Les 10 skills de la maison sont servis par leur copie personnelle, jamais par la source

**Date :** 2026-07-26
**Statut :** **RÉSOLU le 2026-07-27 — option 2 retenue** (voir § 0)
**Contexte :** `README.md` étape 6 du rituel de déploiement ·
`2026-07-23-proposition-maison-skills.md` § 6 mesure V3-bis · lanceur `claude-ah`
**Type :** Architecture
**Sévérité :** Élevée — touche la prémisse de rafraîchissement de tous les skills
transversaux
**Décision de référence :** ADR-028 (une maison par skill) — sa prémisse
« `~/.claude/SKILLS` est une cible de déploiement » est confirmée, mais sa
**conséquence opérationnelle** change (voir § 4)

---

### 0. Décision — 2026-07-27, Mathieu

**Option 2 retenue : les copies personnelles restent, et l'étape de déploiement
devient obligatoire.**

Mise en œuvre le jour même : `deploy-skills.ps1` à la racine du dépôt. Il
compare la maison à `~/.claude/SKILLS/`, ne supprime jamais rien, signale les
orphelins, exige `-Apply` pour écrire, et **vérifie après écriture** au lieu de
se fier à son rapport. Le défaut mesuré de l'option 2 — l'invisibilité totale
d'une copie périmée, établie par le run E — est adressé par là : le script est
le seul détecteur, il doit donc tourner.

**Pourquoi l'option 1 est écartée** : elle exigeait de généraliser `claude-ah`
et faisait perdre les 10 skills à toute session ouverte par `claude` nu. Coût
réel, bénéfice théorique. L'option 2 ne demande qu'une commande.

**Ce que cette décision débloque** : l'étape 4 du § 5, qui attendait derrière
elle, est de fait exécutée — `deploy-skills.ps1` EST la distribution. Et le
sujet garé « lanceur `claude-ah` mono-projet » retrouve sa condition d'origine
(entrée du 2ᵉ projet) : il n'est plus le dernier bloquant de rien.

**Note honnête sur la genèse de cette ISSUE.** Elle a été rédigée comme une
délibération à deux options avec bloquants et conditions de révision, alors que
la mesure donnait déjà la réponse : la copie est ce qui tourne, donc le
déploiement n'est pas optionnel. La structure a produit du travail
d'instruction là où un constat suffisait. Consigné pour que le patron ne soit
pas rejoué tel quel — une ISSUE se justifie quand un arbitrage reste ouvert,
pas quand une mesure a déjà tranché.

Les sections 1 à 7 ci-dessous sont conservées telles qu'écrites avant la
décision : elles portent les mesures, pas l'arbitrage.

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

### 5. Ce que cette décision débloque — ajouté le 2026-07-27

**L'étape 4 du § 5 du plan de migration** (« Distribution : manifeste +
`sync-skills.ps1` dans la maison, premier sync exécuté ») **est à l'arrêt
derrière cette ISSUE**, et ce blocage n'était pas visible avant V3-bis.

La raison : la nature même de cette étape change selon l'option retenue.

- **Option 1 retenue** (retirer les copies personnelles) → le script de sync
  **n'a plus d'objet**. `--add-dir` sert la maison directement, `git pull`
  suffit, et l'étape 4 se réduit à supprimer un besoin plutôt qu'à construire
  un outil.
- **Option 2 retenue** (garder les copies) → le script cesse d'être un confort
  et devient l'**infrastructure critique** : c'est lui, et lui seul, qui décide
  de ce que les sessions exécutent réellement. Il lui faut alors ce qu'un
  simple script de copie n'a pas — détection de dérive, rapport de fraîcheur,
  et un garde contre la copie périmée silencieuse.

**Conséquence opérationnelle :** ne pas construire `sync-skills.ps1` avant que
cette ISSUE soit tranchée. Le bâtir maintenant, c'est produire l'outil d'une des
deux options en pariant sur laquelle sera choisie — et, si le pari est perdu, un
outil qu'il faudra jeter ou, pire, qu'on gardera par inertie en laissant la
décision se prendre toute seule.

L'étape 3, elle, est close (2026-07-27) : la mesure a montré qu'il n'y avait
rien à consolider, et son garde du corollaire F2 passe dans tous les dépôts.

### 6. Conditions de révision

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

### 7. Réflexe réutilisable

Une sonde qui prouve qu'un **dossier** est scanné ne prouve pas qu'un **fichier**
donné y est chargeable. Les deux échecs rendent la même sortie. Tout protocole
qui conclut à un rang de priorité doit porter un contrôle de chargeabilité :
écarter le concurrent et vérifier que le candidat rend bien son marqueur seul.
