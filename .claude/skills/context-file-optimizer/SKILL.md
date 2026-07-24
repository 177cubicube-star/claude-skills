---
name: context-file-optimizer
version: 1.0.0
description: >
  Audit and optimize working context/config markdown files — CLAUDE.md,
  instruction.md, architecture.md, and any .md that steers an agent or
  documents a project. Use when the user wants to clean up, tighten,
  deduplicate, or reconcile their .md working files, when a CLAUDE.md has
  grown long or contradictory, when instructions across files conflict, or
  when the user asks to "optimize my context files", "clean up my markdown",
  "tighten my CLAUDE.md", or similar. Also trigger on French phrasings:
  « optimise mes fichiers de contexte », « nettoie / allège mon CLAUDE.md »,
  « mes .md de travail se contredisent », « fais progresser mes documents
  de travail ». Runs a structured read → diagnose → propose → apply loop
  and never rewrites files without showing changes first.
---

# Context File Optimizer

*(Rédigé par Mathieu, 2026-07-09 ; retouches d'installation : déclencheurs FR,
frontière artefacts gelés, remède de dé-duplication, pré-vol Phase 4.)*

A skill for keeping agent-facing markdown files sharp: short, consistent,
current, and non-contradictory. Long or messy context files quietly degrade
agent behaviour — the model spends attention parsing filler, and conflicting
instructions produce unpredictable results. This skill fixes that.

It applies to any markdown that acts as *instruction or context* rather than
*deliverable prose*: `CLAUDE.md`, `instruction.md`, `architecture.md`,
`README.md` used as agent context, style guides, playbooks, and similar.

## Core principle

Every line in a context file should earn its place. If removing a line doesn't
change how the agent behaves, it's noise. Optimize for *signal density and
zero contradiction*, not completeness.

## Workflow

### Phase 1 — Take stock (read only)

1. Identify the target files. If the user named them, use those. Otherwise
   scan the working directory for `CLAUDE.md`, `*instruction*.md`,
   `*architecture*.md`, `README.md`, and other likely context files, and
   confirm the set with the user before touching anything.
2. Read each file fully. For each, note its purpose in one sentence.
3. Build a quick map of what lives where, so overlap between files is visible.

### Phase 2 — Diagnose

Check each file, and the set as a whole, against these criteria:

- **Contradictions** — two files (or two sections) that tell the agent
  different things. These are the highest-priority fixes; flag every one.
- **Redundancy** — the same instruction repeated across files or sections.
  Keep one canonical statement in the file that owns the topic; convert the
  other occurrences into pointers to it. Duplicated truths drift
  independently — detection doesn't cure them, only de-duplication does.
- **Staleness** — references to finished work, old paths, deprecated tools,
  or relative dates ("next quarter") that have since passed. Convert relative
  dates to absolute ones or remove them.
- **Bloat** — verbose phrasing, hedging, or background that doesn't change
  behaviour. Tighten to the minimum that preserves meaning.
- **Ambiguity** — instructions vague enough to be interpreted multiple ways.
  Make them concrete and testable.
- **Structure** — headings that don't match content, missing sections a
  reader needs, or ordering that buries important rules.

### Phase 3 — Propose (do NOT edit yet)

Present a concise report, grouped by file, listing each issue with:
its type, the exact excerpt, and the proposed change. Order by impact
(contradictions and staleness first, cosmetic tightening last). Show the
user a clear before → after for anything non-trivial. Wait for approval.

### Phase 4 — Apply

Apply only the changes the user approved, editing files in place. Preserve the
user's voice and formatting conventions — this is surgery, not a rewrite. After
editing, give a one-line summary per file: what changed and how many lines were
removed or reworded.

#### Pre-flight (before applying anything)

1. Every change about to be applied was explicitly approved — nothing extra.
2. Re-read each shortened line: same instruction, same intent, user's voice.
3. No frozen artifact touched (rule below).
4. Net direction is subtractive — if the file grew, justify or revert.

## Rules

- **Never rewrite a whole file silently.** Always diagnose and propose before
  applying. The user stays in control of what changes.
- **Frozen artifacts are out of scope.** Files whose history is the point are
  never "optimized": accepted ADR bodies (decision history is immutable),
  session recaps (terminal archives), locked sections of living documents
  (e.g. 🔒-marked rules). If a target file has its own governance rules,
  those rules win — optimize only its mutable fields, or skip it and say why.
- **Contradictions are non-negotiable to surface** — even if you can't resolve
  them, flag every one so the user can decide.
- **Don't add content the user didn't ask for.** The default direction is
  *subtract and sharpen*, not expand.
- **Respect the confidentiality boundary.** Don't move project-specific or
  private details into files meant to be shared or generic.
- **Preserve intent.** When tightening, verify the shortened version still
  instructs the agent to do the same thing. When unsure, ask rather than guess.

## Good vs bad edits

Bad (rewrites voice, adds content, applies without asking):
> Rewrote CLAUDE.md into a cleaner structure with new sections on testing.

Good (surgical, reviewed, subtractive):
> CLAUDE.md: removed 3 duplicate "run tests before commit" lines (kept the one
> under Workflow), converted "ship by next sprint" to "ship by 2026-07-20",
> flagged a conflict — the root file says use pnpm, architecture.md says npm.
