---
name: task-observer-perso
version: 1.3.0
description: >
  Monitors task execution for skill improvement opportunities. Use this skill
  during ANY multi-step task, agentic workflow, or substantive work session where
  the agent is using tools and producing deliverables. It captures patterns, user
  corrections, workflow insights, and methodology worth preserving as reusable
  skills. Also triggers during post-task feedback discussions and when the user
  explicitly mentions skill observations, improvements, the observation log,
  skill taxonomy, or asks the agent to watch for skill opportunities. Also known
  as "One Skill to Rule Them All" — trigger on this phrase too. IMPORTANT:
  this skill should be invoked at the start of every task-oriented session — if
  you are about to use tools to produce deliverables, invoke this skill first.
---

# Task Observer — Continuous Skill Discovery & Improvement

**Created by Eoghan Henn / [rebelytics.com](https://rebelytics.com)** —
original: [rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all),
licence CC BY 4.0.

**Adaptation (Mathieu, 2026-07-08)** — three deliberate deviations from the
original, decided at install time:

1. **Transparent logging** — the original logs silently; this version
   announces every log write in one visible line (provenance rule:
   no silent disk writes, ever).
2. **Manual-only comprehensive review** — the original auto-fires a review
   at session start after 7 days; removed (session start belongs to the
   project's own session-start workflow, where one exists). The review runs
   ONLY on explicit request.
3. **Lean install** — Cowork-specific mechanics (present_files, read-only
   mounts), publishing machinery (licence templates, attribution templates,
   open-source confidentiality layers) and parallel-session race handling
   removed: Mathieu works sequentially, single session, and does not publish
   skills. See the original repo for the full version.

   **Correction (2026-07-11, measured):** the "single session" premise behind
   this removal is false — Claude Code and Cowork ran concurrently on the same
   vault, one applying the other's recommendations. Race handling stays out;
   the attribution rule does not follow from it. When a file changes outside
   this session, never infer the author from the channel — ask, or write
   À CONFIRMER (cross-cutting principle #2).

This skill defines a persistent behavioral layer for identifying skill creation
and improvement opportunities during task-oriented work. It doesn't replace the
skill-creator — it feeds it. The eyes and ears that notice patterns worth
capturing; the skill-creator is the hands that build.

---

## Conventions

- `<project-slug>` = basename of `git rev-parse --show-toplevel`, or `_meta`
  outside a git repo.
- **Resolve the slug against the store before using it — never create on a
  miss.** A local directory can be renamed or moved; the derived slug then
  points nowhere, and creating a fresh store there is indistinguishable from a
  legitimate first use. The failure is silent: an empty log that looks new.
  So list the store first — `ls ~/.claude/skill-observations/` — and:

| What you find | What you do |
|---|---|
| Exact match | Use it. |
| No exact match, exactly ONE near-match | Use it. Announce in one line: `ⓘ store résolu : <slug> → <dossier>`. Never create a second store. |
| No exact match, SEVERAL near-matches | STOP and ask. Never guess. |
| Nothing close | Create it (templates below), announce in one line. |

  Near-match = a directory sharing ≥ 75 % of the slug's length as a common
  prefix, compared case-insensitively. Dry-run on the real store (2026-07-27,
  4 slugs against 4 directories): 3 resolved exactly, 1 resolved to a single
  candidate at 91 %, **0 false positives**.
- The observation store lives OUTSIDE any project repo (governed repos stay
  clean):

| Purpose | Path |
|---|---|
| Active log | `~/.claude/skill-observations/<project-slug>/log.md` |
| Archive | `~/.claude/skill-observations/<project-slug>/archive/log-YYYY-MM-DD.md` |
| Cross-cutting principles | `~/.claude/skill-observations/cross-cutting-principles.md` |
| Last review date | `~/.claude/skill-observations/last-review-date.txt` |

Create files on first use, with the templates at the bottom of this document.

**Boundary with existing systems (do not duplicate):** project-specific
lessons (root causes, build gotchas, repo workflow) belong to the project's
own homes — `docs/ISSUES-LOG.md`, fils, memory. This log captures ONLY
skill-shaped insights: something a SKILL.md should say, stop saying, or
enforce differently. When an insight belongs to both, log the skill angle
here and point to the project artifact rather than copying it.

---

## The Pre-Flight Principle

The most important pattern this skill propagates to every skill it helps
create or improve: **built-in enforcement.**

Rules documented in a skill are not always followed during the creative flow
of producing output. The fix: every skill that contains explicit rules should
include a verification step where the agent re-reads the rules and checks its
output against them before delivery. A 30-second re-read prevents a 30-minute
rework cycle.

When creating or improving any skill, ask: "Does this skill have rules? If
yes, does it have a mechanism to enforce them?" If no, add one.

### Self-Enforcement

Before surfacing observations at end of session, verify:

1. Were observations logged throughout the full session — including during
   post-task feedback and reflective discussion, not just active tool use?
2. Was each log write announced in one visible line (no silent writes)?
3. Does each observation follow the format (Issue → Suggested improvement →
   Principle)?
4. For observations about existing skills, does the suggested improvement
   reference the specific section or rule?

If any observation fails these checks, fix it before surfacing.

---

## Observation Protocol

### When to Observe

Observation is active throughout the **entire task session** — from first
tool use through post-task feedback, until the session ends:

1. **Active task execution** — code, documents, analyses, deliverables.
2. **Post-task feedback and discussion** — user corrections and reviews are
   often the highest-signal input; capture them with the same diligence.
3. **Meta-discussion about skills or methodology.**
4. **Reflective and strategic conversations** — planning and post-work
   reflection produce insights too.

The observation mindset does not deactivate when the conversation shifts from
"doing work" to "discussing the work."

Not active during casual conversation or quick factual questions with no
tools and no deliverables.

### What to Watch For

**Signals for a NEW skill:**

- A multi-step workflow reusable across projects
- A methodology the user explains that no existing skill captures
- A task type recurring with similar structure and steps
- The user describing a refined process ("I always do it this way")
- A structured approach emerging naturally that could be formalised

**Signals for IMPROVING an existing skill:**

- The agent doesn't follow a skill's rules despite documentation — the skill
  needs stronger enforcement, not just better rules
- A user correction reveals a missing rule or uncovered edge case
- A skill's recommended workflow is less efficient than what emerged naturally
- A technique works so well it should be promoted to explicit recommendation
- A skill assumption turns out to be wrong in practice
- The user's corrections form a pattern across multiple instances
- A general principle emerges that applies to other skills too (see
  Principle Propagation)
- The user suggests a naming, framing, or structural change — even
  conversationally

**Signals for SIMPLIFYING an existing skill** (pruning matters as much as
growth):

- A section or rule never relevant across multiple sessions
- A rule added from a single observation, never validated by recurrence
- An elaborate workflow users consistently shortcut
- Sections loaded but never acted on (dead weight in context)
- Rules that contradict each other
- A documented rule the agent consistently fails to follow — the fix is
  rarely to write it louder; convert it to structural enforcement (checklist,
  verification step, tool call) or remove it

**Do NOT log:**

- One-off corrections that don't generalise
- Preferences already captured in an existing skill or memory
- Tool bugs or temporary issues unrelated to skill methodology
- Project lessons that belong in the project's ISSUES-LOG / fils / memory
  (see Boundary above)

### How to Log — transparent, immediate

When a correction, insight, or skill-relevant event occurs, write it to the
log **within the same turn or the next** — do not batch mentally. The act of
writing is the enforcement mechanism.

**Announce every write in one line** (adaptation #1 — no silent writes):

```
ⓘ observation loggée : [short title] → skill-observations/<slug>/log.md
```

Keep the announcement to that single line; do not interrupt the flow further.

**Numbering (mandatory pre-check):** before assigning a number, read the
actual log file and take max+1 — never trust session memory:

```bash
grep -o '### Observation [0-9]*' log.md | grep -o '[0-9]*' | sort -n | tail -1
```

Always use the `### Observation NNN:` format, always append to the END of the
file. One format, one insertion point — greppable and countable.

**Entry format:**

```markdown
### Observation [N]: [Short descriptive title]

**Status:** OPEN
**Date:** [date]
**Session context:** [what task was being worked on]
**Skill:** [existing skill name, or "New skill candidate: [working name]"]
**Phase/Area:** [which part of the skill or workflow this relates to]

**Issue:** [What happened. Specific enough to be understood weeks later
without the original conversation.]

**Suggested improvement:** [Concrete change. For existing skills, name the
section or rule.]

**Principle:** [The generalisable takeaway — the most important field.]
```

**Context preservation:** if the observation depends on session-local data,
save that context near the log and add a `**Reference file:**` line —
an observation whose supporting data died with the session is incomplete.

**Confidentiality:** strip secrets, tokens, and personal data from
observations. Skill-shaped insights rarely need them.

### Archival on Write

On every log write, first move entries already marked ACTIONED or DECLINED
**in a previous session** to `archive/log-YYYY-MM-DD.md` (preserve the header
and status key). Entries resolved in the CURRENT session stay visible until
the next write. The active log holds OPEN items plus the just-resolved ones.

---

## Surfacing Protocol

**Default cadence:** surface all observations at the end of the session, as a
grouped summary — existing skills grouped by skill name, new skill candidates
listed separately. For each: title, skill, one-sentence summary. Ask the user
which (if any) to act on; hand off approved items to skill-creator.

**Surface earlier when:**

- An observation needs user input to be complete ("pattern or one-off?")
- A skill is actively producing wrong output in the current session
- Multiple observations cluster on the same skill

---

## Acting on Observations

**Default: log, don't act.** Observations are acted on ONLY in these
contexts (adaptation #2 — no autonomous mode):

1. **The comprehensive review — on explicit request only** ("lance la revue
   des observations", "revue des skills", or equivalent). Never auto-fired.
2. **Explicit user requests during a session** — "update X skill", "act on
   observation #N now".
3. **In-session correction** when a skill is producing wrong output and the
   user should know immediately.

### Small changes — apply directly

Clearly additive, low-risk, no testing needed: new anti-pattern in a list,
clarified wording, added edge case, factual fix. Show the diff before writing
(Mathieu's "montrer le brouillon avant le disque" applies to skill files).

### Substantial changes — hand off to skill-creator

Restructured workflows, new capabilities, changed methodology — anything
where "does this actually work better?" is a genuine question.

### New skills — via skill-creator

Provide the observation(s) as the brief; they contain intent, scope, and
initial design.

---

## Principle Propagation

When an observation reveals a principle that applies to skills in general,
not just one skill:

1. Log it with `Skill: All skills` and surface it
2. If the user approves it as cross-cutting, add it to
   `~/.claude/skill-observations/cross-cutting-principles.md`
3. From then on, every skill creation or update includes a compliance check
   against the active principles — that file is a mandatory checklist during
   any skill creation or regeneration

The user decides propagation timing: **immediate** (update all skills now) or
**opportunistic** (apply at each skill's next update).

---

## Comprehensive Review (manual trigger only)

Runs ONLY when the user asks (adaptation #2). Interactive, never autonomous.

1. **Load** — read the log; extract OPEN observations. Read the
   cross-cutting principles. If nothing is open and all principles are
   propagated, say so and stop.
2. **Inventory** — list available skills (user + project). Do not modify
   built-in/platform skills; route their observations to a user-owned
   complementary skill (`{system-skill}-extras`) containing only the delta.
3. **Cross-check** — for each OPEN observation, evaluate relevance against
   each skill (use the Principle field, not just the Skill field). Present
   ALL observations grouped by skill, one-sentence summaries, flag the ones
   needing judgment as "Needs your input". Wait for approval (blanket or
   selective).
4. **Apply** — for approved items, integrate the insight into the right
   section (native, not bolted on); preserve structure and voice. Show
   diffs before writing. Substantial changes go through skill-creator.
5. **Mark** — update each applied observation from OPEN to
   `ACTIONED — Applied to [skill-name] ([date])`. Declined → DECLINED.
   Archival happens on the next log write.
6. **Timestamp** — write today's date to
   `~/.claude/skill-observations/last-review-date.txt`.
7. **Summary** — updated skills with 1-sentence changes + observations
   actioned + skipped (with reasons).

During reviews, ask "what can we remove?" as deliberately as "what should we
add?" A previously-applied observation that turned out to be a one-off is a
candidate for reverting.

---

## Session Start Protocol

When this skill activates in a task-oriented session:

1. Resolve the store against `~/.claude/skill-observations/` (§ Conventions).
   Create it only when nothing close exists — announce the outcome either way,
   in one line. "Absent" must be proven, not assumed: an absence is often a
   key that moved.
2. Read OPEN observations and active cross-cutting principles for the current
   `<project-slug>` and for `All skills`. Hold them in awareness; apply their
   insights to the current work even if the skill files haven't been updated
   yet. Don't surface them unprompted unless directly relevant.
3. No auto-review, no scheduling nag (adaptation #2 — the review is manual).

---

## Templates (first use)

**log.md:**

```markdown
# Skill Observation Log — <project-slug>

Observations captured during task-oriented work. Each entry identifies a
potential skill improvement or new skill opportunity.

**Status key:** OPEN = not yet actioned | ACTIONED = skill updated/created |
DECLINED = user decided not to pursue

---
```

**cross-cutting-principles.md:**

```markdown
# Cross-Cutting Principles

Principles that apply to all skills. Read as a mandatory checklist during
any skill creation or regeneration.

---

## Active Principles

### 1. [Principle title]
**Added:** [date]
**Applies to:** [all skills | all skills with rules]
**Requirement:** [what the principle requires]
**Propagation:** [immediate | opportunistic]
**Status:** [active]
```

---

## Quick Reference

| Question | Answer |
|----------|--------|
| When do I observe? | Full session, including feedback and reflection phases |
| How do I log? | Immediately, appended to the log, announced in ONE visible line — never silently, never batched |
| When do I surface? | End of session, or earlier if needed |
| When do I act? | Never by default — manual review, explicit request, or active wrong output |
| What format? | Issue → Suggested improvement → Principle |
| Numbering? | Read the log, max+1 — never from memory |
| Where does the log live? | `~/.claude/skill-observations/<project-slug>/` — outside every repo |
| Store missing under the derived slug? | Resolve before creating — a renamed directory makes an empty store look new (§ Conventions) |
| Project lesson or skill lesson? | Project → ISSUES-LOG/fils/memory ; skill-shaped → here |
| Review trigger? | Manual only: "lance la revue des observations" |
| Simplification? | Prune one-off rules, dead sections, skipped workflows |
