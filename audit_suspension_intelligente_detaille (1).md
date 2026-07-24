# Audit approfondi du dépôt — Suspension Intelligence

**Mode :** lecture seule  
**Dépôt :** `177cubicube-star/suspension-intelligente`  
**Branche :** `main`  
**Commit audité :** `56803bbc665b7a0061afe0be095b460941122a04`  
**Date de l’audit :** 2026-07-23  
**Auteur du rapport :** copilote technique Suspension Intelligence

> **Portée de preuve.** Le dépôt a été inspecté par l’interface GitHub connectée, fichier par fichier et par recherches de symboles. Le conteneur d’analyse ne pouvait pas résoudre le réseau GitHub, donc aucun clone local n’a été possible. Les suites Gradle, Android instrumentées et Python n’ont pas été exécutées. Le rapport distingue systématiquement le code lu, les résultats historiques rapportés par le dépôt et les inconnues d’exécution.

## Sommaire

1. Executive verdict
2. Repository status dashboard
3. Actual system map
4. Top findings
5. Architecture drift matrix
6. ADR alignment matrix
7. Diagnostic-engine assessment
8. RAG knowledge-base integrity
9. Test and CI assessment
10. Technical-debt register
11. V1 readiness assessment
12. Prioritized remediation roadmap
13. Open decisions requiring Mathieu
14. Unknowns and analysis limitations

---

# 1. Executive verdict

## **ARCHITECTURALLY AT RISK**

Le dépôt possède une base architecturale sérieuse : frontière `DiagnosticEngine`, modèles de domaine explicites, Room local, migrations fail-fast, corpus de causes versionné et gouvernance ADR exceptionnellement développée. La direction logique `ui → domain`, `data → domain`, `di → composition` est globalement respectée dans les fichiers inspectés. En revanche, l’état exécutable de la V1 contredit une décision centrale acceptée : ADR-013 impose le RAG comme moteur V1 par défaut, tandis que la production lie encore `RuleBasedDiagnosticEngine`. Deux des six entrées diagnostiques produisent actuellement un résultat vide sans mission de complétion. Le flux Journal construit un `bikeId = 0` incompatible avec la clé étrangère Room obligatoire et devrait échouer lors de l’insertion réelle. Le setup guidé est un prototype en mémoire qui porte des règles génériques et des valeurs de réglage directement dans la couche UI. Le corpus de cause est cohérent sur ses 18 identités, mais il n’est chargé par aucun retriever runtime opérationnel. Les tests observés protègent plusieurs invariants solides, mais certains consacrent les comportements problématiques et aucune CI n’apporte de preuve sur le commit audité. La V1 n’est donc pas prête pour un groupe de testeurs multi-vélos avant correction de ses verticales critiques.

---

# 2. Repository status dashboard

| Dimension | Score /10 | Confidence | Summary |
|---|---:|---|---|
| Architecture | 6 | High | Bonne séparation logique dans un seul module, mais frontières non imposées par le compilateur et drift majeur ADR-013/DI. |
| Domain model | 6 | High | Situation, contexte, mission, dégradation et causes sont bien typés; validation des entrées vélo et influence réelle de la complétude demeurent insuffisantes. |
| Diagnostic engine | 4 | High | Contrat moderne et testable, ranker déterministe; moteur de production incomplet sur 2/6 symptômes et RAG non opérationnel. |
| Data integrity | 5 | High | Room v2 et migration fail-fast solides; sauvegarde RideLog invalide et sérialisation enum fragile. |
| RAG knowledge base | 7 | High | 18/18 identités cohérentes et validateurs structurés; aucun loader/retriever runtime actif. |
| ADR alignment | 5 | High | Gouvernance riche et traçable; décision RAG V1 contredite et document d’architecture volontairement périmé. |
| Testing | 5 | Medium | Bonne densité de tests de domaine et de validateurs; verticales Room/UI insuffisantes et aucune exécution dans cet audit. |
| Build and CI | 4 | Medium | Stack Gradle cohérente sur papier; aucun statut ni workflow CI au commit audité, build non exécuté. |
| Maintainability | 6 | Medium | Nommage et KDoc soignés; gros volume d’artefacts méthodologiques, règles produit codées dans UI, source d’autorité fragmentée. |
| Security and privacy | 7 | Medium | Données Room exclues des backups et secrets exemples seulement; permissions localisation/réseau restent déclarées sans besoin V1 démontré. |
| V1 product readiness | 3 | High | Plusieurs écrans existent, mais Journal, sélection vélo, mission diagnostique et setup adaptatif empêchent un test terrain fiable. |

### Critères de notation

Les scores sont des **repères d’orientation**, pas des mesures mathématiques. Un score élevé signifie que les mécanismes critiques sont à la fois présents, alignés avec les décisions, reliés en verticale et protégés par des preuves d’exécution. Un score moyen indique une fondation crédible avec des chemins incomplets ou non vérifiés. Un score faible indique qu’un utilisateur ou un testeur peut rencontrer un comportement incohérent, trompeur ou bloquant malgré la présence de fichiers et de tests unitaires.

---

# 3. Actual system map

## 3.1 Repository map

| Area | Path | Purpose | Main technologies | Status |
|---|---|---|---|---|
| Application Android | `app/` | UI Compose, domaine, données Room et composition Hilt | Kotlin, Compose, Hilt, Room | Actif, verticales inégales |
| Point d’entrée | `app/src/main/java/com/suspensionintelligence/` | `Application` Hilt et `MainActivity` | Android, Hilt, Compose | Implémenté |
| Domaine | `app/src/main/java/com/suspensionintelligence/domain/` | Modèles, ports, use cases, moteur abstrait, ranking | Kotlin/JVM | Actif, majoritairement pur |
| Données | `app/src/main/java/com/suspensionintelligence/data/` | Room, repositories, fallback et orchestrateur RAG | Kotlin, Room | Partiel pour le RAG |
| UI | `app/src/main/java/com/suspensionintelligence/ui/` | Navigation, écrans et ViewModels | Compose, Lifecycle | Actif, certaines règles métier embarquées |
| Injection | `app/src/main/java/com/suspensionintelligence/di/` | DB, repositories et choix moteur | Hilt | Actif; moteur RuleBased en prod |
| Tests JVM | `app/src/test/` | Domaine, use cases, engines, ranking | JUnit, coroutines | Présents; non exécutés ici |
| Tests Android | `app/src/androidTest/` | Migration Room réelle | AndroidX Test, Room | 3 scénarios visibles; non exécutés ici |
| Schémas Room | `app/schemas/` | Traçabilité des versions DB | JSON Room | Présence référencée; non validée par exécution |
| ADR | `docs/decisions/` | Décisions 001 à 028 et index | Markdown | Très actif |
| Corpus diagnostique | `docs/diagnostic/corpus-de-cause/` | 18 causes fines structurées | YAML | Cohérent sur les identités |
| Fiches/méthodologie diagnostic | `docs/diagnostic/` | Mappings, fallback, templates, doctrine | Markdown, YAML | Actif |
| Base de connaissances | `docs/knowledge-base/` | Couches de connaissance RAG | Markdown/YAML | Éditoriale; loader runtime absent |
| Gouvernance automatisée | `tools/` | Validateurs ADR, corpus, recaps et hooks | Python | Riche, testée par sources; non exécutée ici |
| Pipeline externe | `pipeline/` | Collecte et validation des fiches fabricants | Python, Pydantic | Support externe, non runtime Android |
| Agents et skills | `.claude/agents/`, `.claude/skills/` | Orchestration documentaire et qualité | Markdown, Python, JSON | Actif |
| Artefacts d’évaluation | `.claude/skills/skill-creator/*-workspace/` | Benchmarks, sorties et grading d’agents | JSON, Markdown | Volumineux, périphérique au produit |
| Synchronisation documentaire | `scripts/sync-notion/` | Synchronisation Notion | Node.js | Périphérique |
| Brouillons | `Brouillons/` | Travail non canonique | Markdown | Non autoritatif |
| Hooks | `.githooks/` | Garde locale avant commit | Shell/Python | Présent; activation locale inconnue |

## 3.2 Module map

Le build contient **un seul module Gradle**, `:app` (`settings.gradle.kts:1-18`). Les quatre couches attendues sont donc des packages logiques, et non des modules compilés séparément.

```text
:app
 ├─ com.suspensionintelligence.domain
 │   ├─ model
 │   ├─ repository
 │   ├─ usecase
 │   └─ diagnostic
 ├─ com.suspensionintelligence.data
 │   ├─ local (Room)
 │   ├─ repository
 │   └─ diagnostic
 ├─ com.suspensionintelligence.ui
 │   ├─ navigation
 │   ├─ screen
 │   └─ theme
 └─ com.suspensionintelligence.di
```

### Dépendances réellement visibles

```text
UI/ViewModel -> Use cases + modèles domain
Use cases    -> ports Repository + DiagnosticEngine
Data         -> ports et modèles domain
DI           -> implémentations data + abstractions domain
Domain       -> Kotlin/coroutines + javax.inject pour les constructeurs de use case
```

Les recherches d’imports n’ont pas trouvé d’import `android.*` dans les sources du domaine ni d’import direct `data.*` dans les écrans inspectés. Cette conformité est toutefois **conventionnelle** : le module unique n’empêche pas une future violation au moment de compiler.

## 3.3 Composition roots et points d’entrée

```text
SuspensionIntelligenceApp (@HiltAndroidApp)
  -> graphe Hilt
MainActivity (@AndroidEntryPoint)
  -> SuspensionIntelligenceTheme
  -> AppNavigation
  -> NavHost Compose
```

**Preuves :**

- `app/src/main/java/com/suspensionintelligence/SuspensionIntelligenceApp.kt:8-13`
- `app/src/main/java/com/suspensionintelligence/MainActivity.kt:13-24`
- `app/src/main/java/com/suspensionintelligence/ui/navigation/AppNavigation.kt:39-103`
- `app/src/main/java/com/suspensionintelligence/di/DatabaseModule.kt:20-43`
- `app/src/main/java/com/suspensionintelligence/di/RepositoryModule.kt:19-37`
- `app/src/main/java/com/suspensionintelligence/di/DiagnosticModule.kt:15-41`

## 3.4 Runtime workflows

### Rider creation and retrieval — implemented by code trace

```text
RiderProfileScreen
  -> RiderProfileViewModel
  -> ObserveRiderUseCase / SaveRiderUseCase
  -> RiderRepository
  -> RiderRepositoryImpl
  -> RiderDao
  -> Room AppDatabase
  -> StateFlow UI
```

**Status:** implemented by static trace; runtime not executed.

### Bike entry — write implemented, list absent

```text
BikeEntryScreen
  -> BikeEntryViewModel
  -> SaveBikeUseCase
  -> RiderRepository.getRider()
  -> BikeRepository.saveBike()
  -> BikeRepositoryImpl
  -> BikeDao
  -> Room
```

The route named `BikeList` renders the same `BikeEntryScreen` as `BikeEntry`, with no observation/list use case (`AppNavigation.kt:43-49,87-92`; `BikeEntryViewModel.kt:39-111`).

**Status:** write path present; list and explicit active-bike selection absent.

### Setup modification — scaffold only

```text
SetupFromScratchScreen
  -> SetupFromScratchViewModel
  -> in-memory list SETUP_FROM_SCRATCH_STEPS
  -> currentStep/completedSteps in StateFlow
```

No repository, use case or persistence appears in the ViewModel (`SetupFromScratchViewModel.kt:27-131`). The setup repository is read by the diagnostic use case, but no complete setup creation/update vertical slice was identified.

**Status:** prototype UI, not a persisted setup workflow.

### Diagnostic flow — partially implemented

```text
DiagnosticScreen
  -> DiagnosticViewModel
  -> DiagnoseSymptomUseCase
     -> RiderRepository.getRider()
     -> BikeRepository.getBikes(rider.id).firstOrNull()
     -> SetupRepository.getLatestSetup(bike.id)
     -> SymptomSituationMapping
     -> DiagnosticEngine
  -> Hilt binding: RuleBasedDiagnosticEngine
  -> DiagnosticResult
  -> UI renders hypotheses / mission / workshop referral / empty state
```

**Status:** code path exists, but only four of six symptom mappings receive a fallback hypothesis; the two all-`UNKNOWN` mappings reach an empty result.

### RAG nominal flow — implemented as orchestrator, unreachable in production

```text
RagDiagnosticEngine
  -> build intent from determined situation fields + notes
  -> KnowledgeRetriever.retrieve()
  -> EvidenceAggregator.aggregate()
  -> CauseRanker.rank()
  -> DiagnosticResult
       hypotheses + mission + referral + sources + degradation
```

The production binding does not instantiate this engine, no concrete `KnowledgeRetriever` was identified, and `DeferredEvidenceAggregator.aggregate()` raises `TODO()` (`DiagnosticModule.kt:19-41`; `DeferredEvidenceAggregator.kt:21-26`).

**Status:** architectural scaffold and unit-test target; not runtime-ready.

### Ride log — broken vertical slice

```text
RideLogScreen
  -> RideLogViewModel.saveLog()
  -> RideLog(bikeId = 0, riderId = 0)
  -> SaveRideLogUseCase replaces riderId only
  -> RideLogRepositoryImpl
  -> RideLogDao.insert()
  -> Room FK bikeId -> bikes.id
  -> expected FK failure for bikeId 0
```

**Status:** write path is structurally wired but semantically invalid.

### Knowledge loading — planned only

```text
YAML/Markdown corpus
  -X-> no runtime loader/retriever found
  -X-> no on-device index found
  -X-> no production EvidenceAggregator
```

**Status:** editorial knowledge exists; runtime knowledge path absent.

### Baseline SAG — educational text only

SAG appears as hard-coded instructions and target ranges in `SetupFromScratchViewModel.kt`. No stable manual/photo landmark provider contract, image pipeline or uncertainty propagation was found in executable application sources.

**Status:** prototype guidance; automated or persisted measurement absent.

### Telemetry — no runtime implementation identified

ADR-006 defines zero passive collection in V1. No telemetry session workflow was found in the executable paths inspected. The manifest nevertheless still declares location and network permissions with stale telemetry/sync comments (`AndroidManifest.xml:6-12`).

---

# 4. Top findings

## Finding `F-001` — Ride logs are inserted with an invalid bike foreign key

**Severity:** High  
**Confidence:** Confirmed  
**Category:** Data / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/ui/screen/ridelog/RideLogViewModel.kt:64-81`
- `app/src/main/java/com/suspensionintelligence/domain/usecase/SaveRideLogUseCase.kt:19-26`
- `app/src/main/java/com/suspensionintelligence/data/local/entity/RideLogEntity.kt:13-35`
- `app/src/main/java/com/suspensionintelligence/data/repository/RideLogRepositoryImpl.kt:18-25`
- `app/src/test/java/com/suspensionintelligence/domain/usecase/SaveRideLogUseCaseTest.kt:30-37,52-59`

**Current behavior:**  
`RideLogViewModel` creates every new log with `bikeId = 0L`. `SaveRideLogUseCase` replaces only `riderId`, then the repository converts and inserts the entity. Room requires a non-null `bikeId` referencing an existing row in `bikes`. The unit test uses a fake repository and also accepts `bikeId = 0`, so it cannot expose the real foreign-key failure.

**Expected behavior:**  
A log must be associated with an existing, explicitly resolved bike before persistence. The failure path must be represented and shown to the UI without leaving a spinner or coroutine exception.

**Why it matters:**  
The Journal is a core V1 feature and the setup guide explicitly directs the rider to save a baseline there. In the real Room path, this vertical slice is expected to fail or crash rather than persist the log.

**Recommended remediation boundary:**  
Resolve an active/selected bike in a domain use case, reject missing selection explicitly, preserve the FK invariant and add a Room-backed integration test from use case to DAO. Do not patch the DAO to tolerate `0`.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** Owner decision on active-bike policy; bike list/selection capability.

---

## Finding `F-002` — Two of six diagnostic entries return silence instead of a mission

**Severity:** High  
**Confidence:** Confirmed  
**Category:** Diagnostic / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/domain/diagnostic/SymptomSituationMapping.kt:34-40,66-73`
- `app/src/main/java/com/suspensionintelligence/domain/diagnostic/SituationFallbackCauses.kt:19-25`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/RuleBasedDiagnosticEngine.kt:29-38`
- `app/src/main/java/com/suspensionintelligence/di/DiagnosticModule.kt:19-31`
- `app/src/main/java/com/suspensionintelligence/ui/screen/diagnostic/DiagnosticScreen.kt:188-215`
- `app/src/test/java/com/suspensionintelligence/data/diagnostic/RuleBasedDiagnosticEngineTest.kt:57-64`

**Current behavior:**  
`TOO_HARSH` and `POOR_TRACTION` are deliberately mapped to six `UNKNOWN` dimensions. The production fallback excludes both, returns an empty hypothesis list and no mission. The screen displays “Aucune hypothèse disponible pour cette situation.” The fallback test explicitly verifies this emptiness.

**Expected behavior:**  
A fully indeterminate input must produce the accepted `InputCompletionMission`, asking discriminating questions without inventing a cause. ADR-025’s type and mission content already exist.

**Why it matters:**  
One third of the visible diagnostic choices leads to a dead end. The application fails precisely where the rider needs guided clarification, weakening trust in the diagnostic interaction.

**Recommended remediation boundary:**  
Place the all-`UNKNOWN` mission behavior on the production orchestration path without invoking the deferred aggregator. Preserve the rule that the fallback itself does not fabricate a cause.

**Estimated effort:** Small to Medium  
**Dependencies or prerequisites:** Clarify the production orchestrator boundary while resolving F-003.

---

## Finding `F-003` — The production engine contradicts accepted ADR-013

**Severity:** High  
**Confidence:** Confirmed  
**Category:** ADR / Architecture / RAG  
**Evidence:**

- `docs/decisions/ADR-013-rag-moteur-base-v1.md:42-49,77-85,97-110,145-152`
- `app/src/main/java/com/suspensionintelligence/di/DiagnosticModule.kt:19-41`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/DeferredEvidenceAggregator.kt:10-26`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/RagDiagnosticEngine.kt:29-50`

**Current behavior:**  
ADR-013 accepts RAG as the default V1 engine and rejects RuleBased as the V1 default. The Hilt binding does the opposite. The repository contains a RAG orchestrator, but its production aggregator is a deliberate `TODO()` and no concrete runtime retriever was identified.

**Expected behavior:**  
Either the accepted decision is implemented—RAG default with RuleBased fallback—or a newer ADR explicitly supersedes it. An implementation debt must not silently become a contrary architecture.

**Why it matters:**  
The project’s V1 product promise, corpus work and retrieval strategy all depend on this decision. Continuing feature work atop a knowingly opposite binding multiplies drift and creates false confidence that the RAG swap is only a one-line DI change.

**Recommended remediation boundary:**  
Make an owner-level scope decision, then either complete the minimum on-device retrieval/aggregation vertical slice before changing the binding, or supersede ADR-013 and update all affected narrative documents. Never bind the current RAG engine while `DeferredEvidenceAggregator` remains reachable.

**Estimated effort:** Architectural  
**Dependencies or prerequisites:** Mathieu decision; ADR-027 implementation choices; corpus packaging/index strategy.

---

## Finding `F-004` — Context completeness is recorded but does not lower diagnostic confidence

**Severity:** High  
**Confidence:** Confirmed  
**Category:** Diagnostic / Domain  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/domain/model/DiagnosticContext.kt:5-29,32-53`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/RuleBasedDiagnosticEngine.kt:29-38`
- `app/src/main/java/com/suspensionintelligence/domain/diagnostic/SituationFallbackCauses.kt:25-65`
- `app/src/main/java/com/suspensionintelligence/domain/diagnostic/CauseRanker.kt:57-117,155-173`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/RagDiagnosticEngine.kt:93-108`

**Current behavior:**  
`DiagnosticContext` states that completeness influences confidence, and `DiagnosticResult` stores a snapshot. The production fallback copies fixed bands from the curated table regardless of whether bike/setup data exist. The RAG ranker assigns bands only by relative evidence-group position and never receives context completeness.

**Expected behavior:**  
Missing context should reduce or qualify confidence without turning absence into negative evidence. The rule must be explicit, versioned and testable.

**Why it matters:**  
A rider can receive the same qualitative confidence with or without the bike and current setup. This creates false certainty and defeats the stated role of the context layer.

**Recommended remediation boundary:**  
Define a small domain policy that transforms or annotates output confidence from `ContextCompleteness`, with reference cases. Keep cause ranking and confidence calibration separate.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** Mathieu validates the qualitative policy; reference diagnostic cases.

---

## Finding `F-005` — Setup from scratch contains unscoped tuning rules in the UI layer

**Severity:** High  
**Confidence:** Confirmed  
**Category:** Architecture / Diagnostic / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/ui/screen/setup/SetupFromScratchViewModel.kt:13-99`
- `app/src/main/java/com/suspensionintelligence/ui/screen/setup/SetupFromScratchViewModel.kt:101-131`
- `ARCHITECTURE.md:29-39`
- `CLAUDE.md:51-84`

**Current behavior:**  
The ViewModel hard-codes fork/shock SAG targets, pressure increments, median-click baselines, bounce-test interpretation and 2–3-click changes. The workflow has no bike/manufacturer input, no use case, no persisted output and no source reference at runtime.

**Expected behavior:**  
Product guidance that can alter a suspension setup should originate from validated domain rules or manufacturer data, carry its applicability and uncertainty, and persist the resulting baseline when required.

**Why it matters:**  
The current text can be read as universal mechanical advice although suspension architecture, manufacturer direction, adjuster conventions and rider use differ. It also violates the project’s separation between UI presentation and domain logic.

**Recommended remediation boundary:**  
Classify the current screen as a non-authoritative prototype or replace its hard-coded steps with a domain-driven guide sourced from verified bike/component context. Persist only validated setup data.

**Estimated effort:** Large  
**Dependencies or prerequisites:** Mathieu decision on the product role of this mode; manufacturer-data strategy.

---

## Finding `F-006` — No explicit active-bike model exists for multi-bike use

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Domain / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/domain/usecase/DiagnoseSymptomUseCase.kt:56-68`
- `app/src/main/java/com/suspensionintelligence/ui/navigation/AppNavigation.kt:43-49,87-92`
- `app/src/main/java/com/suspensionintelligence/ui/screen/bike/BikeEntryViewModel.kt:39-111`
- `app/src/main/java/com/suspensionintelligence/ui/screen/ridelog/RideLogViewModel.kt:64-80`

**Current behavior:**  
The diagnostic use case treats `bikes.firstOrNull()` as the active bike. The bottom navigation’s “Vélo” route opens the entry form, not a list/selector. Ride logs have no bike selection.

**Expected behavior:**  
The active bike must be explicit and stable, especially for a three-to-four-bike tester cohort. It should not depend on database ordering.

**Why it matters:**  
The diagnostic can silently use the wrong geometry/setup, and logs cannot be attributed reliably. This turns good domain data into misleading context.

**Recommended remediation boundary:**  
Add a narrowly scoped active-bike selection contract and use it consistently in diagnosis, setup and logs.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** Mathieu chooses the active-bike UX and persistence policy.

---

## Finding `F-007` — Bike input silently creates invalid or invented measurements

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Domain / Data / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/ui/screen/bike/BikeEntryViewModel.kt:62-103`

**Current behavior:**  
An invalid wheel size silently becomes `29f`; invalid shock stroke or rear travel becomes `0`. These conversions occur in the UI layer and the resulting object is sent to persistence.

**Expected behavior:**  
A measurement must be valid, explicitly unknown or rejected. A parsing failure must never invent a physically meaningful value.

**Why it matters:**  
The diagnostic context can contain false geometry, and later calculations can treat zero travel or a fabricated wheel size as fact.

**Recommended remediation boundary:**  
Move validation into domain constructors/value objects or use-case validation; represent unknown separately from numeric zero and return structured validation errors.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** Decide which bike fields are mandatory for V1.

---

## Finding `F-008` — Error handling can leave the UI inconsistent or fail silently

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Reliability / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/ui/screen/diagnostic/DiagnosticViewModel.kt:44-57`
- `app/src/main/java/com/suspensionintelligence/ui/screen/bike/BikeEntryViewModel.kt:85-108`
- `app/src/main/java/com/suspensionintelligence/ui/screen/ridelog/RideLogViewModel.kt:64-97`
- `app/src/main/java/com/suspensionintelligence/domain/usecase/SaveRideLogUseCase.kt:11-25`

**Current behavior:**  
Diagnostic and bike ViewModels catch only `IllegalStateException`; unexpected exceptions can escape while loading flags remain set. RideLog catches nothing. `SaveRideLogUseCase` returns silently when no rider exists, so the ViewModel can mark the operation saved even when no insert occurred.

**Expected behavior:**  
Every vertical slice must return an explicit success/failure domain result and restore UI state on all paths.

**Why it matters:**  
Users can see a false success, a stuck spinner or a crash without a recovery action.

**Recommended remediation boundary:**  
Adopt the already documented sealed-result direction incrementally on the critical save/diagnose use cases; map errors to UI state exhaustively.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** None beyond the corrected bike invariant.

---

## Finding `F-009` — The knowledge base has no executable loading path

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** RAG / Product  
**Evidence:**

- `app/src/main/java/com/suspensionintelligence/domain/diagnostic/KnowledgeRetriever.kt` (port found)
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/RagDiagnosticEngine.kt:44-50`
- `app/src/main/java/com/suspensionintelligence/data/diagnostic/DeferredEvidenceAggregator.kt:21-26`
- repository search for `KnowledgeRetriever` returned the interface, orchestrator, tests and documentation, but no concrete data implementation

**Current behavior:**  
The editorial corpus and RAG orchestration exist, but no loader, index builder, packaged knowledge store or production retriever was identified.

**Expected behavior:**  
ADR-027’s on-device retrieval path must package validated knowledge, fail explicitly on invalid data and expose deterministic retrieval results through `KnowledgeRetriever`.

**Why it matters:**  
The corpus cannot influence the Android diagnostic at runtime; its integrity work is disconnected from product behavior.

**Recommended remediation boundary:**  
Implement one minimal end-to-end retrieval slice with a tiny versioned corpus before scaling ingestion or embeddings.

**Estimated effort:** Large  
**Dependencies or prerequisites:** Retrieval implementation ADR, corpus packaging, benchmark constraints.

---

## Finding `F-010` — Tests protect local invariants but miss the failing vertical slices

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Test  
**Evidence:**

- `app/src/test/java/com/suspensionintelligence/domain/usecase/SaveRideLogUseCaseTest.kt:20-96`
- `app/src/test/java/com/suspensionintelligence/data/diagnostic/RuleBasedDiagnosticEngineTest.kt:57-64`
- `app/src/androidTest/java/com/suspensionintelligence/data/local/MigrationTest.kt:16-121`
- no GitHub commit status or workflow run on `56803bbc...`

**Current behavior:**  
The RideLog test replaces Room with a permissive fake and therefore misses the FK failure. The fallback test declares empty output for two visible symptoms as correct. Migration tests are well designed but instrumented and not evidenced on the audited commit. No CI run is attached.

**Expected behavior:**  
Critical vertical-slice tests should prove the user-visible invariant, not merely the local class contract. CI should execute JVM validators and build checks on every commit/PR.

**Why it matters:**  
A green unit suite could coexist with a broken Journal and a diagnostic dead end.

**Recommended remediation boundary:**  
Add targeted contract/integration tests around Room-backed log save and all six symptom outcomes; establish a minimal CI gate.

**Estimated effort:** Medium  
**Dependencies or prerequisites:** Correct expected behavior for F-001/F-002.

---

## Finding `F-011` — Privacy declarations and Android permissions are inconsistent

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Security / Privacy / ADR  
**Evidence:**

- `app/src/main/AndroidManifest.xml:6-12`
- `docs/decisions/README.md:40-42` (ADR-006 summary)
- `app/src/main/res/xml/backup_rules.xml:3-12`
- `app/src/main/res/xml/data_extraction_rules.xml:3-16`
- `app/build.gradle.kts` contains no network client dependency in the inspected dependency list

**Current behavior:**  
The manifest declares fine/coarse location and network permissions with comments about GPS telemetry and Supabase background sync. ADR-006 defines zero passive collection in V1, and no telemetry/network vertical slice was identified. Room data are correctly excluded from cloud backup and device transfer.

**Expected behavior:**  
V1 should request only permissions required by an implemented, consented feature. Documentation and manifest comments must reflect current decisions.

**Why it matters:**  
Unused sensitive permissions increase attack surface, complicate tester trust and preserve obsolete product intent.

**Recommended remediation boundary:**  
Remove unused permissions/comments from the V1 manifest or gate them behind a real, explicitly consented feature and a new review of ADR-006.

**Estimated effort:** Small  
**Dependencies or prerequisites:** Confirm that no hidden feature requires location/network.

---

## Finding `F-012` — Clean Architecture is logical, not compiler-enforced

**Severity:** Medium  
**Confidence:** Confirmed  
**Category:** Architecture / Maintainability  
**Evidence:**

- `settings.gradle.kts:1-18`
- `docs/decisions/README.md:36-39`
- search inspection found no domain `android.*` import and no direct UI import of data implementations in the inspected sources

**Current behavior:**  
All layers live inside `:app`. Current code generally respects the intended direction, but Gradle cannot prevent a UI class from importing Room or a domain class from importing Android in a future change.

**Expected behavior:**  
Either automated architecture guards must be mandatory and run in CI, or the most important boundaries should become modules when the project’s size justifies it.

**Why it matters:**  
The repository relies heavily on agent discipline and local scripts. Without CI evidence, an architectural regression can merge unnoticed.

**Recommended remediation boundary:**  
First make the existing guard executable in CI. Consider module extraction only after the product verticals stabilize; avoid premature multi-module refactoring.

**Estimated effort:** Small for CI guard; Large for modularization  
**Dependencies or prerequisites:** CI baseline.

---

# 5. Architecture drift matrix

| Declared architectural claim | Source | Actual implementation evidence | Status | Drift severity |
|---|---|---|---|---|
| Four logical layers domain/data/ui/di | ADR-001; README | Packages exist and DI binds abstractions; one Gradle module | Partially aligned | Medium |
| Domain must avoid Android/Room/UI | ADR-001; CLAUDE.md | No violating import found in inspected domain sources | Aligned by inspection | Low residual risk |
| UI accesses business data through use cases | ADR-003 | Rider, bike, diagnostic and log ViewModels use use cases | Aligned | Low |
| Diagnostic engine depends on domain contract | ADR-002/024 | UI use case receives `DiagnosticEngine`; impl in data | Aligned | Low |
| V1 default engine is RAG | ADR-013 | DI binds RuleBased; RAG dependencies incomplete | Contradicted | High |
| RuleBased is fallback only | ADR-013/025 | RuleBased is direct production engine | Contradicted | High |
| App remains offline-capable | README; ADR-027 | Core Android paths use Room; no runtime network client found | Aligned for current paths | Low |
| Zero passive telemetry V1 | ADR-006 | No telemetry code found, but location/network permissions remain | Partially aligned | Medium |
| Unknown is insufficient information | ADR-020/025 | Explicit UNKNOWN enums and all-unknown predicate exist | Aligned in model | Low |
| All-unknown produces completion mission | ADR-025 | Only RagDiagnosticEngine does so; production fallback returns empty | Contradicted at runtime | High |
| Output is multi-hypothesis + mission + referral | ADR-024/025 | Contract and UI render all three | Aligned structurally | Low |
| Context reliability influences confidence | ADR-022; DiagnosticContext KDoc | Completeness snapshot stored; no confidence adjustment | Partially aligned | High |
| RAG retrieval is on-device, generation extractive | ADR-027 | No concrete retriever/index; orchestration only | Not implemented | High |
| Room is local source of truth | AppDatabase KDoc / current V1 | Local repositories use Room; no mandatory server path | Aligned | Low |
| Validated rules should not live in UI | Architecture/CLAUDE | Setup tuning guide hard-coded in ViewModel | Contradicted locally | High |
| Governance checks are versioned and tested | ADR-019 | Multiple `tools/*.py` validators and synthetic tests exist | Aligned in source | Medium residual because not CI-proven |
| Fiche/corpus identity must be stable | ADR-021/023 | 18 YAML headers match 18 enum IDs | Aligned | Low |
| Three diagnostic modes share a foundation | ADR-016 | Diagnostic visible; Setup prototype; Discovery/Sandbox absent | Not implemented | Medium |

---

# 6. ADR alignment matrix

> **Semantics used:** “Accepté” means that Mathieu validated the decision; it does not prove implementation. The table below evaluates implementation separately, in accordance with ADR-018.

| ADR | Declared decision | Implementation evidence | Status | Drift severity |
|---|---|---|---|---|
| ADR-001 | Clean Architecture 4 layers | Logical packages and correct DI direction; single module | partially aligned | Medium |
| ADR-002 | `DiagnosticEngine` domain boundary | Contract in domain, implementations data, DI switch point | aligned | Low |
| ADR-003 | Mandatory use-case boundary | Critical ViewModels inspected depend on use cases | aligned | Low |
| ADR-004 | Temporary CRUD waiver removed | Current inspected ViewModels do not call repositories directly | obsolete/historical | Low |
| ADR-005 | Single rider per device V1 | Use cases resolve one rider; no multi-rider UI found | aligned | Low |
| ADR-006 | No passive telemetry; declarative logs only | No telemetry code identified; permissions stale | partially aligned | Medium |
| ADR-007 | Explicit exception strategy V1 | Exceptions used, but silent RideLog return and incomplete catches remain | partially aligned | Medium |
| ADR-008 | Rider-owned FK preparation | riderId FKs/indexes in entities/migration | aligned | Low |
| ADR-009 | Supabase source of truth for tester portal | Portal implementation not audited/identified | indeterminate | Unknown |
| ADR-010 | Separate Supabase project | No live project/config evidence inspected | indeterminate | Unknown |
| ADR-011 | Orphan migration fail-fast | Guard before destructive migration + instrumented tests | aligned by source | Low |
| ADR-012 | Moratorium third-party free-text PII | No runtime third-party ingestion path found; pipeline scope not exhaustively executed | partially aligned | Medium |
| ADR-013 | RAG default engine in V1 | RuleBased bound as production; RAG not runnable | contradicted | High |
| ADR-014 | Permissive manufacturer collection with legal gates | Pipeline exists; enforcement behavior not executed in this audit | indeterminate | Medium |
| ADR-015 | Two-regime source hierarchy | Documentation/agent artifacts exist; runtime use absent | partially aligned | Medium |
| ADR-016 | Diagnostic/Sandbox/Discovery modes | Diagnostic present; other modes absent or prototype | not implemented | Medium |
| ADR-017 | Multi-layer knowledge base | Knowledge docs exist; runtime ingestion cycle not connected | partially aligned | Medium |
| ADR-018 | ADR status means validation, not code state | Index and ADR headers use this distinction | aligned | Low |
| ADR-019 | Checks in versioned tested scripts | Validators and test files present | aligned by source | Medium residual |
| ADR-020 | Dynamic situation model, input/output separation | Six explicit dimensions; causes only in output | aligned | Low |
| ADR-021 | Enum + cause corpus linked by stable `cause_id` | 18 enum values and 18 matching YAML files | aligned | Low |
| ADR-022 | Durable context with reliability and interpretation roles | Context object exists; reliability not applied to confidence | partially aligned | High |
| ADR-023 | Cause-corpus schema and hard guards | Validator implements identity, hard core, scales and seats | aligned by source | Medium residual |
| ADR-024 | Request situation + multi-hypothesis result | Contract and UI migrated | aligned | Low |
| ADR-025 | Retrieval intent + completion mission | RAG orchestrator implements; prod path bypasses | partially aligned / contradicted at runtime | High |
| ADR-026 | Decision triage and grep-able notes | Skill/docs artifacts present; every-recap enforcement not exhaustively audited | indeterminate | Medium |
| ADR-027 | On-device retrieval + extractive generation | Ports and orchestration only; no concrete retrieval | not implemented | High |
| ADR-028 | One canonical home per skill | Recent decision; repository contains canonical skills plus many evaluation snapshots | partially aligned | Medium |

### Governance observations

1. The ADR numbering is contiguous from 001 to 028 in the index; no duplicate number was observed.
2. All indexed ADRs are marked accepted, but several commit-reference fields remain incomplete or their implementation is explicitly deferred.
3. `ARCHITECTURE.md` warns that it is not fully synchronized and that accepted ADRs override it. This prevents silent conflict, but it raises the cost of reconstructing the current architecture.
4. The most consequential drift is not an ambiguous documentation mismatch: ADR-013 explicitly rejects the production configuration that currently executes.

---

# 7. Diagnostic-engine assessment

## 7.1 Input model

`DiagnosticRequest` combines:

- a `DiagnosticSituation` containing six observational axes;
- a `DiagnosticContext` containing rider, bike, setup, trail conditions and notes.

This separation is conceptually strong. `Symptom` remains an UI vocabulary and is translated through `SymptomSituationMapping`, outside the engine contract. The design correctly avoids storing a diagnosis as input evidence.

### Assessment

- **Observation vs conclusion:** well separated in types.
- **Felt location vs responsible component:** input uses felt location; output cause is independent.
- **Travel position vs movement:** separate enums.
- **Shaft velocity vs bike speed:** explicit `ShaftVelocityRegime` terminology.
- **Mixed vs unknown:** separate enum values in the model; no fallback conflation found.
- **Invalid states:** all six axes can be all-`UNKNOWN`, which is valid and should trigger a mission.

## 7.2 Question routing

There is no interactive question router in the production engine. The accepted five completion questions exist through `MissionCompletionQuestions` and are returned by `RagDiagnosticEngine` only. The current production path is one-shot symptom selection plus optional free notes.

**Verdict:** structurally designed, operationally absent.

## 7.3 Evidence handling

The nominal RAG design is:

```text
KnowledgeChunk -> EvidenceAggregator -> CauseEvidence -> CauseRanker
```

`CauseRanker` uses only positive optional evidence. Missing evocation/frequency contributes zero, not a penalty. This follows the repository’s anti-invention and monotonicity rules. The actual aggregator is deferred, so no runtime evidence is produced.

## 7.4 Unknown handling

The model treats unknown as an explicit enum, not `null` or a default answer. The RAG orchestrator recognizes all-unknown semantically and avoids retrieval on a blank intent. The production fallback does not wrap this case, so the user sees silence for two symptoms.

**Verdict:** correct domain semantics, incorrect production composition.

## 7.5 Hypothesis generation and ranking

### Production fallback

- Exact reverse lookup from situation to a curated symptom mapping.
- Four canonical determined situations.
- One fixed `RankedCause` each.
- Any other situation: empty.

This is deterministic and explainable but extremely narrow. It is not a general situation-based rule engine despite its name.

### Nominal RAG ranker

- Additive score from `evocation + frequency`.
- No negative evidence or interactions.
- Ties preserve equal rank and generate a discrimination mission.
- Maximum three rendered hypotheses; no arbitrary truncation within a tie group.
- Workshop referral is not absorbed.
- Rule and corpus versions can be traced.

This is a good V1 invariant framework. The source itself correctly says that invariant tests prove consistency, not diagnostic correctness; reference cases are still needed.

## 7.6 Confidence behavior

The output exposes `ConfidenceBand`, but current bands mean different things depending on path:

- fallback: fixed curated band per symptom/cause;
- ranker: relative position of evidence groups;
- context completeness: stored separately, not applied.

No single calibrated confidence semantics is enforced. A “STRONG” label can therefore mean first relative group rather than high absolute confidence. This should be made explicit in UI copy and domain policy.

## 7.7 Cause chaining

The cause corpus supports mechanical links paired with tests, but the runtime ranker does not chain causes or propagate causal graphs. That is consistent with its documented V1 scope. No hidden recursive causal claim was found.

## 7.8 Recommendation generation

The post-migration contract deliberately removed free-form generated prose. Fallback discrimination tests are curated strings and generally prescribe one change at a time. The setup guide also says one change at a time, but its generic numeric advice is hard-coded and outside the diagnostic engine.

## 7.9 Baseline SAG, tires, technique and maintenance

The 18-cause corpus includes:

- spring rate and progressivity;
- LSC/HSC/rebound/packing/tune;
- tire pressure and casing;
- rider braking/position/landing technique;
- cockpit, chassis balance and kinematics.

This breadth correctly prevents the engine ontology from equating rider sensation with damper adjustment. However, the production fallback reaches only four causes and does not consume the full corpus. Baseline SAG is presented as a discrimination test or setup step, not as a programmatic prerequisite gate.

## 7.10 Frequency vs intervention order

The ranker uses frequency as likelihood evidence, while discrimination tests remain separate. No code was found that equates the first cause with the first physical check. This is aligned with the project rule that frequency and verification order are distinct. The UI should continue to avoid implying otherwise.

## 7.11 Testability and explainability

Strengths:

- pure Kotlin contract;
- deterministic ranker;
- explicit reasoning source;
- trace model and version identifiers;
- mission and referral are typed;
- fallback data are curated and separately validated.

Gaps:

- no reference diagnostic cases proving mechanical correctness;
- no production mission for all-unknown;
- no context-confidence policy;
- no end-to-end RAG retrieval test with packaged knowledge;
- no UI test proving all six buttons yield a useful next action.

## 7.12 Can a future RAG engine replace V1 without UI/use-case changes?

**Contractually: yes. Operationally today: no.**

The use case and UI depend on `DiagnosticEngine` and the migrated `DiagnosticResult`, so no UI/use-case signature change should be required. But a production swap currently requires more than a DI edit: a concrete `KnowledgeRetriever`, a real `EvidenceAggregator`, packaged/indexed knowledge, failure handling, performance validation and end-to-end tests must first exist. Binding `RagDiagnosticEngine` now would expose the deliberate `TODO()` on successful retrieval.

---

# 8. RAG knowledge-base integrity

## 8.1 Inventory result

| Metric | Result | Confidence |
|---|---:|---|
| Cause fiches found | 18 | High |
| Unique internal `cause_id` | 18 | High |
| Values in `DominantCause` | 18 | High |
| Missing enum-to-corpus entries | 0 observed | High |
| Corpus entries absent from enum | 0 observed | High |
| Duplicate `cause_id` | 0 observed | High |
| Filename/content mismatches | 0 observed | High |
| `tune_inadapte` | Present and aligned | High |
| `carcasse_inadaptee` | Present and aligned | High |
| Runtime-loaded fiches | 0 proven | High |

### IDs verified

`assiette_desequilibree`, `carcasse_inadaptee`, `cinematique_inadaptee`, `cockpit_inadapte`, `hsc_excessive`, `hsc_insuffisante`, `lsc_excessive`, `lsc_insuffisante`, `packing_rebond`, `pression_pneu_inadaptee`, `progressivite_insuffisante`, `rebond_trop_rapide`, `spring_rate_excessif`, `spring_rate_insuffisant`, `technique_freinage`, `technique_position`, `technique_reception`, `tune_inadapte`.

## 8.2 Validator coverage

`tools/validate_corpus_de_cause.py` checks:

- closed `kind` values;
- required diagnostic core;
- closed qualitative scales;
- no numeric values where prohibited;
- applicable-seat alphabet, uniqueness and singleton rules;
- mechanical link/test pairing;
- filename equals `cause_id`;
- duplicate IDs;
- separate workshop-referral schema;
- non-zero exit code on deviations.

The associated synthetic test file exercises these failure paths, including the historical filename/content mismatch class.

### Explicit blind spots

The validator itself states that it does **not** judge:

- whether an evidential value is mechanically correct;
- whether all workshop motifs are wired to output;
- whether cause-corpus references resolve into the knowledge base;
- ingestion behavior before that ingestion exists.

Those exclusions are appropriate but must not be mistaken for full content validation.

## 8.3 Schema/template drift

No unsupported `rag_card`, hidden engine-rule block or `§0` was observed in the YAML cause files inspected. The cause corpus is YAML and follows ADR-023 rather than the §1–§13 Markdown fiche template; these are separate artefact families. No silent extension of the cause-corpus hard core was identified.

## 8.4 Invalid-data loading behavior

No Android runtime loader was found. Therefore malformed YAML currently cannot corrupt a runtime RAG result because the application does not load it—but this is absence of functionality, not a safety guarantee. The future loader must fail explicitly and version the accepted corpus rather than silently skip malformed files.

## 8.5 Knowledge issues table

| Knowledge issue | File(s) | Evidence | Runtime consequence | Validator coverage |
|---|---|---|---|---|
| Runtime corpus disconnected | `docs/diagnostic/corpus-de-cause/*`, RAG ports | No retriever/loader implementation found | Full corpus cannot influence app | Not covered; implementation absent |
| Mechanical correctness unproven | All 18 YAML | Validator checks form, not truth | Wrong values could rank consistently | Explicitly out of scope |
| Reference cases absent | Ranker/corpus | Ranker KDoc says built, not validated | Invariants may not equal correct diagnosis | Not covered by schema validator |
| Filename/content drift | 18 YAML | Manual headers match; test exists | None observed | Hard-fail covered |
| Missing sensitive causes | `tune_inadapte`, `carcasse_inadaptee` | Both present and aligned | Historical concern resolved | Identity covered |

---

# 9. Test and CI assessment

## 9.1 Tests discovered

### Kotlin/JVM and Android

Repository search exposed at least the following test groups:

- `CauseRankerTest`
- `CauseRankerInvariantsTest`
- `CauseRankerTraceTest`
- `RagDiagnosticEngineTest`
- `RuleBasedDiagnosticEngineTest`
- `DiagnosticRequestTest`
- `DiagnosticSituationTest`
- `DiagnosticMissionTest`
- `InputEnumCompletenessTest`
- `OrdinalRankGuardTest`
- `CranMappingTest`
- `ForceFamilyTest`
- `SymptomSituationMappingTest`
- `SuspensionCalculationsTest`
- `SaveBikeUseCaseTest`
- `SaveRideLogUseCaseTest`
- `ObserveRideLogsUseCaseTest`
- `MigrationTest` under `androidTest`
- placeholder `ExampleUnitTest`

The connector result was truncated, so this list is a lower bound, not an exact count.

### Python validators and pipeline

Visible test files include tests for:

- cause-corpus validation;
- enum/corpus asymmetry;
- curated-view fidelity;
- mapping collisions;
- ADR index drift;
- recap gaps and hooks;
- precommit gate;
- claims audit;
- active thread checks;
- bike spec schema;
- fiche validation;
- citation harvesting;
- risk scoring.

## 9.2 Tests executed during this audit

```text
Command: No Gradle or Python test command executed.
Result: Not executed.
Passed: Unknown.
Failed: Unknown.
Skipped: All executable suites.
Important warnings: No GitHub combined status and no workflow run on commit 56803bbc...
Environment limitations: Repository could not be cloned because the container had no GitHub DNS/network resolution; Android SDK/emulator status unavailable.
```

No statement in this report treats historical “GREEN” recaps as current execution proof.

## 9.3 Strong test architecture elements

- Ranker invariants are separated from domain correctness claims.
- Migration tests use real Room/SQLite behavior and explicitly test cascade enforcement.
- Corpus validators have synthetic negative fixtures and exit-code tests.
- Mapping collisions and curated views have dedicated guards.
- The domain code is structured for plain JVM testing.

## 9.4 Critical coverage gaps

1. No Room-backed RideLog save test validates the required bike FK.
2. No test requires every visible diagnostic entry to return at least one of: hypotheses, mission or workshop referral.
3. No reference-case suite validates that ranked causes are mechanically appropriate.
4. No test proves context incompleteness lowers confidence.
5. No production RAG test loads a packaged corpus through a concrete retriever.
6. No Compose/UI test verifies error recovery, active-bike selection or setup persistence.
7. No CI evidence proves tests and validators are mandatory on the audited commit.

## 9.5 Tests that do not protect the intended rule

- `SaveRideLogUseCaseTest` proves only rider-ID substitution through a fake repository; it does not protect referential integrity.
- `RuleBasedDiagnosticEngineTest` correctly reflects the fallback contract but protects an empty user result for two symptom buttons.
- Migration tests protect v1→v2 but cannot establish current app feature correctness.
- Schema validators protect form, not diagnostic truth.

---

# 10. Technical-debt register

| ID | Debt | Impact | Probability | Effort | Recommended timing |
|---|---|---|---|---|---|
| TD-001 | RideLog bike invariant absent | Core save failure | High | Medium | before further feature work |
| TD-002 | All-unknown mission absent in prod | 2/6 diagnostic dead ends | Certain | Small–Medium | before further feature work |
| TD-003 | ADR-013 vs DI contradiction | Product/architecture drift | Certain | Architectural | before further feature work |
| TD-004 | Context completeness not applied | False confidence | High | Medium | before internal testing |
| TD-005 | Setup rules hard-coded in UI | Misleading guidance and coupling | High | Large | before internal testing |
| TD-006 | No active-bike concept | Wrong bike context/log attribution | High | Medium | before internal testing |
| TD-007 | Silent numeric defaults | Corrupted semantic data | Medium | Medium | before internal testing |
| TD-008 | Exception/silent-return flow control | False success/crash/stuck UI | High | Medium | before external testers |
| TD-009 | Runtime retriever/aggregator absent | RAG promise unavailable | Certain | Large | before external testers if ADR-013 retained |
| TD-010 | No diagnostic reference cases | Correctness unvalidated | High | Large | before external testers |
| TD-011 | No CI proof | Regressions can merge | High | Medium | before internal testing |
| TD-012 | Package-only architecture boundaries | Future coupling risk | Medium | Small for guard, Large for modules | before external testers for CI guard |
| TD-013 | Stale manifest permissions/comments | Privacy/trust drift | Medium | Small | before external testers |
| TD-014 | `TrailConditions.valueOf` without compatibility fallback | DB read crash after enum/schema drift | Medium | Small–Medium | before production |
| TD-015 | `setupId` has no Room FK | Stale setup reference possible | Medium | Medium | before production |
| TD-016 | Python dependencies use ranges, not lock | Pipeline reproducibility drift | Medium | Small | later optimization |
| TD-017 | `ARCHITECTURE.md` knowingly stale | High reconstruction cost | Certain | Medium | before external testers |
| TD-018 | Large agent-evaluation artefact footprint in product repo | Search noise and maintenance burden | Medium | Medium | optional cleanup |
| TD-019 | Placeholder `ExampleUnitTest` | Signal noise | Certain | Small | optional cleanup |

---

# 11. V1 readiness assessment

| Readiness level | Verdict | Blocking conditions |
|---|---|---|
| Developer-only use | **Conditionally ready** | Build/tests must be run locally; user must know Journal and 2 symptoms are incomplete; no claim of RAG. |
| Internal dogfooding | **Not ready** | Fix RideLog, all-unknown mission, active bike, structured error handling and misleading setup guidance. |
| Three-to-four-bike tester cohort | **Not ready** | Explicit bike selection, reliable per-bike logs/setups, migrations/CI, reference diagnostic cases. |
| External beta testers | **Not ready** | All prior items plus privacy permission cleanup, recovery UX, runtime RAG decision resolved, instrumentation/observability. |
| Public release | **Not ready** | Production build evidence, migration matrix, security/privacy review, validated diagnostic corpus and complete critical verticals. |

### Developer-only interpretation

The repository can support continued engineering and controlled demonstrations of selected flows. It should not be presented as a coherent V1 diagnostic product yet. A developer can inspect the four curated fallback cases and the Room rider/bike skeleton, but must avoid interpreting file presence as feature completeness.

---

# 12. Prioritized remediation roadmap

## Horizon 0 — Stop-the-line issues

### H0-1 — Enforce a valid bike on every ride log

- **Action:** Resolve active/selected bike before constructing `RideLog`; reject missing bike explicitly.
- **Reason:** Prevent guaranteed FK failure and false save state.
- **Affected files/modules:** RideLog ViewModel, save use case, bike-selection domain, Room integration tests.
- **Prerequisite:** Active-bike policy decision.
- **Acceptance criteria:** No `RideLog` reaches repository with non-existent bike ID; user sees actionable error.
- **Suggested test:** Room-backed use-case test saving a log against a real bike, plus missing-bike negative case.

### H0-2 — Guarantee a useful diagnostic outcome for all visible inputs

- **Action:** Route all-unknown inputs to `InputCompletionMission` in the production path.
- **Reason:** Eliminate 2/6 visible dead ends without inventing causes.
- **Affected files/modules:** Diagnostic composition/DI, fallback wrapper or orchestrator, engine tests, UI test.
- **Prerequisite:** Resolve H0-3 production engine direction.
- **Acceptance criteria:** Each symptom returns hypotheses, mission or referral; never an empty triple.
- **Suggested test:** Parameterized test over all `Symptom.entries` asserting the invariant.

### H0-3 — Resolve the ADR-013 contradiction

- **Action:** Decide whether RAG remains mandatory for V1, then implement or supersede explicitly.
- **Reason:** Stop architecture and product scope from diverging further.
- **Affected files/modules:** ADR-013/027, `DiagnosticModule`, RAG data layer, roadmap/architecture docs.
- **Prerequisite:** Mathieu decision.
- **Acceptance criteria:** Accepted ADR, DI binding, KDoc and runtime behavior all agree.
- **Suggested test:** DI integration test proving the bound engine and fallback behavior.

### H0-4 — Stop presenting generic setup numbers as authoritative

- **Action:** Mark the current screen as prototype/non-authoritative or remove numeric tuning instructions until sourced.
- **Reason:** Prevent mechanically over-general guidance from reaching testers.
- **Affected files/modules:** Setup UI/ViewModel, product copy, future domain guide.
- **Prerequisite:** Mode-role decision.
- **Acceptance criteria:** No universal pressure/click/SAG recommendation is shown without applicability/source.
- **Suggested test:** Content contract test against approved guide data, not hard-coded UI strings.

## Horizon 1 — Before adding features

### H1-1 — Introduce explicit active-bike state

- **Action:** Implement list/selection and a domain port/use case for active bike.
- **Reason:** Stabilize diagnosis, setup and logs around one source of truth.
- **Affected files:** navigation, bike screen/ViewModel, repositories/use cases, DB preference or selected ID store.
- **Prerequisite:** Owner UX decision.
- **Acceptance criteria:** Multi-bike order cannot change active context.
- **Suggested test:** Two-bike test proving selection persists and all consumers use the selected ID.

### H1-2 — Replace silent defaults with typed validation

- **Action:** Add value objects/results for year, travel, stroke and wheel size.
- **Reason:** Preserve unknown and reject physically impossible values.
- **Affected files:** bike domain models, save use case, entry ViewModel.
- **Prerequisite:** Mandatory-field policy.
- **Acceptance criteria:** Invalid text never becomes `0` or `29` implicitly.
- **Suggested test:** Property/boundary tests and UI-state mapping tests.

### H1-3 — Apply a versioned confidence policy

- **Action:** Separate cause ranking from confidence calibration and consume context completeness.
- **Reason:** Prevent missing data from appearing equally certain.
- **Affected files:** domain diagnostic policy, result model/UI copy, tests.
- **Prerequisite:** Mathieu validates qualitative effects.
- **Acceptance criteria:** Same evidence with less context cannot yield stronger confidence.
- **Suggested test:** Monotonic context-completeness cases.

### H1-4 — Make architecture/governance gates mandatory

- **Action:** Run architecture guard and Python validators in CI.
- **Reason:** Convert conventions into enforceable repository rules.
- **Affected files:** `.github/workflows/`, tools runner documentation.
- **Prerequisite:** None.
- **Acceptance criteria:** A seeded domain Android import and malformed corpus fixture fail CI.
- **Suggested test:** CI self-test/negative fixture strategy.

## Horizon 2 — Before external testers

### H2-1 — Build the minimal on-device knowledge vertical

- **Action:** Package a tiny accepted corpus, implement retriever and aggregator, then bind the orchestrator.
- **Reason:** Make ADR-013/027 observable in the app.
- **Affected modules:** data diagnostic, assets/storage, DI, performance tests.
- **Prerequisite:** H0-3 and retrieval implementation ADR.
- **Acceptance criteria:** Offline query returns cited chunks; empty/unavailable cases degrade predictably.
- **Suggested test:** Instrumented cold/warm retrieval benchmark and golden diagnostic case.

### H2-2 — Create reference diagnostic cases

- **Action:** Encode Mathieu-approved scenarios with expected hypothesis sets, exclusions, missions and verification order.
- **Reason:** Prove diagnostic usefulness, not only deterministic ranking.
- **Affected files:** test fixtures, cause corpus, evaluation docs.
- **Prerequisite:** Stable minimum corpus and confidence policy.
- **Acceptance criteria:** Cases cover tires, technique, spring, damping, chassis and maintenance/referral.
- **Suggested test:** Table-driven golden cases with explicit acceptable alternatives.

### H2-3 — Harden persistence and migrations

- **Action:** Add FK for `setupId` or remove the semantic promise; add enum compatibility strategy and migration matrix.
- **Reason:** Prevent stale references and read crashes after evolution.
- **Affected files:** entities, migrations, schemas, tests.
- **Prerequisite:** Setup model finalized.
- **Acceptance criteria:** Old data survive or fail explicitly with tested recovery.
- **Suggested test:** v1→current, v2→current, corrupt enum and cascade scenarios.

### H2-4 — Complete error/recovery UX

- **Action:** Use sealed results and exhaustive UI rendering for save/diagnose/retrieval.
- **Reason:** Avoid false success and stuck states.
- **Affected files:** use cases, ViewModels, Compose tests.
- **Prerequisite:** Correct domain invariants.
- **Acceptance criteria:** Every failure resets loading and offers a next action.
- **Suggested test:** ViewModel coroutine failure cases and Compose state tests.

### H2-5 — Minimize permissions

- **Action:** Remove unused location/network permissions and stale comments.
- **Reason:** Align with no-passive-telemetry V1 and tester trust.
- **Affected files:** manifest, privacy docs.
- **Prerequisite:** Feature inventory confirmation.
- **Acceptance criteria:** APK requests no sensitive permission without an implemented consented feature.
- **Suggested test:** manifest/permission static assertion.

## Horizon 3 — Later improvements

### H3-1 — Consider Gradle module boundaries

- **Action:** Split domain/data/ui only if feature count and team size justify it.
- **Reason:** Compiler enforcement can reduce future coupling, but not before vertical correctness.
- **Affected files:** Gradle structure and packages.
- **Prerequisite:** Stable APIs and CI.
- **Acceptance criteria:** No cyclic module dependency; JVM domain tests remain fast.
- **Suggested test:** module dependency graph and architecture tests.

### H3-2 — Consolidate living architecture documentation

- **Action:** Rewrite `ARCHITECTURE.md` from current accepted ADRs and mark superseded passages.
- **Reason:** Reduce reconstruction cost and contradictory onboarding.
- **Affected files:** architecture, roadmap, index.
- **Prerequisite:** H0-3 decision.
- **Acceptance criteria:** Every major architectural claim links to active ADR and executable evidence.
- **Suggested test:** document link/ADR drift validator.

### H3-3 — Separate product source from agent-evaluation artefacts

- **Action:** Archive or move large skill workspaces if they are not needed for product builds.
- **Reason:** Improve discoverability and repository signal-to-noise.
- **Affected paths:** `.claude/skills/skill-creator/*-workspace/`.
- **Prerequisite:** ADR-028 deployment policy.
- **Acceptance criteria:** Canonical skill remains traceable; generated evaluations remain reproducible elsewhere.
- **Suggested test:** skill deployment audit and repository size report.

### H3-4 — Pin Python environments reproducibly

- **Action:** Add a lock/constraints strategy for pipeline and tools.
- **Reason:** Prevent validator behavior drift from dependency resolution.
- **Affected files:** `pipeline/requirements.txt`, tool environment docs.
- **Prerequisite:** CI baseline.
- **Acceptance criteria:** Clean environment installs identical versions and passes suites.
- **Suggested test:** locked clean-install CI job.

---

# 13. Open decisions requiring Mathieu

## Decision O-001 — Is RAG still a mandatory V1 boundary?

- **Question:** Must the first tester-ready V1 use on-device RAG as the default engine, as ADR-013/027 require?
- **Options:**
  1. **Retain ADR-013:** finish minimum retriever/aggregator and bind RAG; RuleBased remains fallback.
  2. **Supersede ADR-013:** explicitly ship a narrower rule-based internal MVP, with a new scope/exit condition.
- **Technical consequence:** Option 1 increases near-term implementation effort but aligns the product with the knowledge architecture. Option 2 reduces immediate scope but requires formal governance repair and accepts limited diagnostic coverage.
- **Recommended option:** Retain ADR-013 if the tester cohort is meant to assess the project’s differentiating diagnostic value. Use option 2 only for a clearly labeled engineering prototype, not a product V1.
- **Evidence that would change the recommendation:** On-device benchmark showing unacceptable package size/latency, or a validated rule-based reference-case set that provides sufficient tester value without RAG.

## Decision O-002 — What is the product status of Setup from scratch?

- **Question:** Is this mode an educational checklist or an adaptive, authoritative setup workflow?
- **Options:**
  1. Educational prototype with prominent limitations and no universal numeric prescriptions.
  2. Data-driven workflow using component/manufacturer baselines and persisted measurements.
- **Technical consequence:** Option 1 is small but offers limited product value. Option 2 requires domain rules, source attribution, bike context and persistence.
- **Recommended option:** Option 2 for tester-facing use; until implemented, expose only option 1 with reduced claims.
- **Evidence that would change the recommendation:** A validated, intentionally generic coaching protocol approved by Mathieu for the exact target cohort.

## Decision O-003 — How is the active bike selected?

- **Question:** What invariant determines the bike used by diagnosis, setup and logs?
- **Options:**
  1. Explicit user-selected active bike persisted locally.
  2. Bike chosen at the start of each workflow/session.
  3. Single-bike-only V1 enforced in the model/UI.
- **Technical consequence:** Option 1 supports the planned multi-bike tester cohort with least repetition. Option 2 is explicit but adds friction. Option 3 is simplest but contradicts multi-bike testing expectations.
- **Recommended option:** Explicit persisted active bike, with visible confirmation on diagnostic/log screens.
- **Evidence that would change the recommendation:** A firm V1 scope limiting each device to one bike.

---

# 14. Unknowns and analysis limitations

## Files and repository state

- The GitHub connector did not provide a complete raw tree export; mapping used repository search, direct file fetches and commit metadata.
- Untracked and ignored local files were not accessible.
- Generated KSP sources and local Gradle caches were not inspected.
- Git hooks may exist but their installation/activation on Mathieu’s machine is unknown.

## Commands not run

- `./gradlew projects`
- `./gradlew test`
- `./gradlew lint`
- Android instrumented tests
- Python validator/test runners
- dependency reports
- APK manifest merge inspection
- Room schema diff tools

## Environment limitations

- The analysis container could not resolve GitHub for cloning, even though the GitHub connector could read files.
- Android SDK, emulator and signing environment were not established.
- No Supabase, Strava, Reddit, DeepL, Perplexity or manufacturer service credentials were used.
- No GitHub Actions run or combined status was attached to the audited commit.

## Confidence boundaries

- “No implementation found” means none was found through the complete set of relevant repository searches and inspected paths; it is not a cryptographic proof of absence from every blob.
- Corpus identity counts are based on 18 YAML search results and direct header inspection of all 18 files, cross-checked against the 18-value enum.
- Runtime failure of `bikeId = 0` is inferred directly from Room’s declared required FK and insertion path; it was not reproduced on an emulator.
- Security review was static and targeted, not a full penetration test or supply-chain scan.

---

# Final synthesis

Suspension Intelligence has already solved many problems that early projects usually postpone: explicit uncertainty, stable cause IDs, domain ports, deterministic ranking invariants, migration governance and strong decision traceability. The principal risk is now the inverse: **the architecture and documentation have advanced faster than the executable product verticals**. The next highest-value work is not adding another model, fiche or agent. It is closing four concrete loops—valid bike identity, useful result for every visible diagnosis, one coherent V1 engine decision and setup guidance whose authority is explicit—then proving them through Room-backed tests and CI.

---

### Passation de session

- **Sujet principal :** audit profond en lecture seule du dépôt `suspension-intelligente` au commit `56803bbc...`.
- **Décisions validées :** aucune nouvelle décision de projet n’a été prise dans cet audit; les ADR existants ont été évalués sans modification.
- **Propositions non validées :** horizons H0–H3, politique active-bike, confiance contextuelle, CI obligatoire et réduction des permissions.
- **Conflits détectés :** ADR-013 RAG V1 vs binding RuleBased; ADR-025 mission tout-UNKNOWN vs production; contexte censé influencer la confiance vs snapshot seulement; ADR-006 vs permissions/commentaires manifest; architecture vivante vs `ARCHITECTURE.md` périmé.
- **Fichiers ou ADR concernés :** ADR-001, 002, 006, 007, 008, 011, 013, 016–028; `DiagnosticModule.kt`, moteurs diagnostiques, `RideLogViewModel.kt`, `SaveRideLogUseCase.kt`, Room entities/migrations, setup ViewModel, manifest, corpus et validateurs.
- **Travail restant :** exécuter localement Gradle/Python/Android, reproduire F-001, vérifier toutes les sorties de diagnostic, trancher O-001 à O-003 et convertir les choix retenus en tickets/ADR.
- **Conversation ou document canonique à mettre à jour :** créer un audit versionné sous `docs/audits/` puis mettre à jour `ARCHITECTURE.md`, `ROADMAP.md` et l’ADR approprié après décisions de Mathieu.
