# Antigravity Prompt: Phase 1 Specs (game wise)

Use: open ONE game folder in Antigravity (e.g. `game_1_snakes_slither`) as the workspace, paste the prompt below, and replace nothing. Repeat for each game folder.

---

```
You are setting up the Phase 1 (Levels 1 to 500) specs for this game using spec-driven development.
The workspace root is ONE game folder. Do not touch other game folders. The shared standards (SHARED_CORE_STANDARD.md, SOUND_EFFECTS_IMPLEMENTATION.md, VFX_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md) are in this folder.

STEP 0: READ FIRST (do not write anything yet)
1. CLAUDE.md, PRODUCT_OVERVIEW.md, README.md
2. specs/WORKFLOW.md, specs/TEMPLATE.md, specs/INDEX.md
3. .claude/rules/*.md
4. .claude/skills/sdd-spec/SKILL.md  -> this is the exact procedure for creating a spec. Follow it manually for every spec below (your IDE may not run it as a slash command).
5. Every file in phase_1/ (README.md and 01 to 07) and SCALING_TO_10000_LEVELS.md
6. From this game folder (the shared standards are copied here): SHARED_CORE_STANDARD.md (single source of truth for all rules and numbers), SOUND_EFFECTS_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md, VFX_IMPLEMENTATION.md
Read them fully, not just headings. If a number differs between a game doc and SHARED_CORE_STANDARD.md, the standard wins; note the difference under Open Questions in the spec.

STEP 1: CREATE THESE SPECS (one file each, status = Draft)
Use specs/TEMPLATE.md as the structure. Path format: specs/<group>/<name>.md

| # | Spec file | Source of truth |
|---|---|---|
| 1 | specs/gameplay/core-concept-and-rules.md | phase_1/01 + standard section 2 |
| 2 | specs/gameplay/level-progression-0001-0500.md | phase_1/02 |
| 3 | specs/gameplay/obstacle-catalog-phase-1.md | phase_1/03 + mechanics library M001 to M049 |
| 4 | specs/economy/boosters-coins-shop.md | phase_1/04 (include ads, VIP, interstitial rules) |
| 5 | specs/meta/daily-challenge-and-streak.md | phase_1/05 |
| 6 | specs/ui/ui-ux-screens.md | phase_1/06 |
| 7 | specs/tech/frontend-implementation-and-qa.md | phase_1/07 |
| 8 | specs/audio/sound-effects.md | SOUND_EFFECTS_IMPLEMENTATION.md (this game's part only) |
| 9 | specs/tech/logging-and-error-tracking.md | LOGGING_AND_ERROR_TRACKING.md (this game's part only) |
| 10 | specs/tech/performance-optimization.md | PERFORMANCE_OPTIMIZATION.md (this game's part only) |
| 11 | specs/tech/splash-and-instant-launch.md | SPLASH_AND_INSTANT_LAUNCH.md (this game's launch intro only) |
| 12 | specs/ui/vfx-and-juice.md | VFX_IMPLEMENTATION.md (this game's part only) + phase_1/ docs. NOTE: a Draft of this spec already exists with a generic effect catalog. Do not overwrite it blindly. Open it, then complete it: fill the "VFX still to define" rows using only what phase_1/ docs and the standard define (mechanics M001 to M049 grouped by the effect classes in section 4.4, boosters, win/stars/coins, Gift Box, Finale L500). Anything the docs do not define stays in Open Questions. Keep the existing tier limits and QA IDs VFX-01 to VFX-10 |

If a source doc is large, you may split one spec into several smaller specs in the same group (for example obstacle-catalog into one spec per 100 levels, or UI into one spec per screen group). Keep each spec focused and implementable on its own.

HOW TO FILL EACH SPEC
- Type: New Feature.
- Goal: 1 to 2 sentences.
- Current State: there is no code yet. Write "Design documented in <source files>, not yet implemented", then list the key facts taken from the docs.
- Proposed Change: what must be built for Phase 1, as a clear ordered list of requirements and acceptance criteria. Use the real numbers, names, IDs, level ranges and prices from the docs. Never invent new values.
- Affected Files: the planned Flutter files/modules (for example packages/puzzle_core, lib/features/...) as described in phase_1/07. Mark them "to be created".
- Design: fill only for ui specs. Reuse names of screens and components from phase_1/06.
- Risks and Open Questions: real conflicts, gaps and unclear points you found in the docs. Do not leave empty if you found any.
- Skip sections that do not apply (AI Prompts, API Changes, Database Changes) as the template allows.
- Write in plain, simple English. Keep the game's own theme names exactly as written in README.md.
- Add one line at the top of each spec: "Source docs: <list of files>".

STEP 2: UPDATE specs/INDEX.md
Add exactly one row per spec: Group | File Path | one-line description | Draft.

STEP 3: CONSISTENCY CHECK
- Every spec number matches SHARED_CORE_STANDARD.md or is listed in Open Questions.
- No spec is missing a part of phase_1/01 to 07. List any doc section you could not place in a spec.
- Every level range 1 to 500 and every mechanic M001 to M049 is covered in specs 2 and 3.

STEP 4: REPORT (short, plain English)
1. List of specs created
2. Conflicts or gaps found between docs
3. Anything you could not find or were unsure about
4. Suggested order to implement the specs

RULES
- Do not write any app code. Specs only.
- Do not edit the existing docs (README, phase_1, phase_2, SCALING) or anything outside this game folder.
- Do not set any status to Approved. The developer approves after review.
- Do not rename any existing term, ID or file.
```

---

## After Antigravity finishes

1. Review each spec, fix mistakes, then change `Status` to `Approved`.
2. Implement one spec at a time with `/sdd-implement <spec-name>` (in Claude Code), or tell Antigravity: "Follow .claude/skills/sdd-implement/SKILL.md for <spec-name>".
3. Run the same prompt in the other three game folders.
