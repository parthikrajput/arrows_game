# Antigravity Prompt: Phase 2 Specs (game wise)

Use: open ONE game folder in Antigravity (e.g. `game_1_snakes_slither`) as the workspace, paste the prompt below, replace nothing. Repeat for each game folder.
Run this AFTER the Phase 1 specs exist in `specs/` (Phase 2 specs depend on them).

---

```
You are setting up the Phase 2 (Levels 501 to 1000 + LiveOps) specs for this game using spec-driven development.
The workspace root is ONE game folder. Do not touch other game folders. The shared standards (SHARED_CORE_STANDARD.md, SOUND_EFFECTS_IMPLEMENTATION.md, VFX_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md) are in this folder.

STEP 0: READ FIRST (do not write anything yet)
1. CLAUDE.md, PRODUCT_OVERVIEW.md, README.md
2. specs/WORKFLOW.md, specs/TEMPLATE.md, specs/INDEX.md
3. .claude/rules/*.md
4. .claude/skills/sdd-spec/SKILL.md -> the exact procedure for creating a spec. Follow it manually for every spec below (your IDE may not run it as a slash command).
5. Every Phase 1 spec already listed in specs/INDEX.md (Phase 2 builds on them; do not duplicate their content, link to them by file path).
6. Every file in phase_2/ (README.md and 01 to 06) and SCALING_TO_10000_LEVELS.md
7. From this game folder (the shared standards are copied here): SHARED_CORE_STANDARD.md (single source of truth for rules and numbers; read Phase 2 related sections: mechanics M051 to M099, section 9 grid/tiers, section 10 onboarding, section 12 level data, section 6 economy, section 16 mechanic order), SOUND_EFFECTS_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md Also read VFX_IMPLEMENTATION.md and specs/ui/vfx-and-juice.md (already exists as Draft).
Read them fully, not just headings. If a number differs between a game doc and SHARED_CORE_STANDARD.md, the standard wins; note the difference under Open Questions in the spec.

STEP 1: CREATE THESE SPECS (one file each, status = Draft)
Use specs/TEMPLATE.md as the structure. Path format: specs/<group>/<name>.md

| # | Spec file | Source of truth |
|---|---|---|
| 1 | specs/gameplay/phase-2-scope-and-rules.md | phase_2/01 (what changes vs Phase 1, zoom/pan, 14x14 grid, diagonal directions, 3 layers, Remote Config keys, maxPhase rollout) |
| 2 | specs/gameplay/level-progression-0501-1000.md | phase_2/02 (tiers P2-A and P2-B, biomes, L501 to 510 onboarding, finale L1000) |
| 3 | specs/gameplay/obstacle-catalog-phase-2.md | phase_2/03 + mechanics library M051 to M099 |
| 4 | specs/meta/liveops-sticker-album.md | phase_2/04 (album part) |
| 5 | specs/meta/liveops-weekly-star-race.md | phase_2/04 (star race part, ghost fill, server plausibility validation) |
| 6 | specs/economy/piggy-bank-and-cosmetics.md | phase_2/04 (piggy bank + cosmetics shop part), IAP product, economy changes |
| 7 | specs/tech/offline-and-cloud-sync.md | phase_2/05 (identity, local-first sync, Firestore model, account deletion) |
| 8 | specs/tech/backend-cloud-functions-and-release-prerequisites.md | phase_2/README section 4 (R1 to R10) + Cloud Functions list from phase_2/04 and 05 |
| 9 | specs/tech/frontend-and-qa-phase-2.md | phase_2/06 (client work, monitoring, rollout, QA checklist) |
| 10 | specs/audio/sound-effects-phase-2.md | SOUND_EFFECTS_IMPLEMENTATION.md (Phase 2 additions for this game only; skip if there are none and say so in the report) |
| 11 | specs/ui/vfx-phase-2.md | VFX_IMPLEMENTATION.md + phase_2/ docs: Phase 2 additions only (M051 to M099 grouped by effect classes in section 4.4, 3 layers, diagonal directions, zoom/pan, LiveOps rewards such as Album sticker and Star Race, Piggy Bank, cosmetics, Finale L1000). Depends on specs/ui/vfx-and-juice.md; do not duplicate it, link to it. Reuse existing effect classes first; skip a part and say so in the report if the docs define nothing for it |

If a source doc is large, you may split one spec into several smaller specs in the same group (for example obstacle-catalog-phase-2 into one spec per 100 levels). Keep each spec focused and implementable on its own.

HOW TO FILL EACH SPEC
- Type: New Feature (use Improvement for work that changes a Phase 1 behaviour, and say which Phase 1 spec it changes).
- Goal: 1 to 2 sentences.
- Current State: there is no code yet. Write "Design documented in <source files>, not yet implemented", then list the key facts from the docs. For anything that changes a Phase 1 spec, list the Phase 1 spec path and the exact behaviour that changes.
- Proposed Change: ordered list of requirements and acceptance criteria. Use the real numbers, names, IDs, level ranges, prices and Remote Config keys from the docs. Never invent new values.
- Affected Files: planned Flutter modules, Cloud Functions and Firestore collections as described in the docs. Mark them "to be created" or, if they come from a Phase 1 spec, "changed".
- Design: fill only for specs with UI (album, star race, piggy bank, cosmetics, zoom/pan). Reuse screen and component names from the docs.
- API Changes: fill for backend specs (Cloud Function names, request and response shape, security rules).
- Database Changes: fill for Firestore collections and local save schema changes.
- Risks and Open Questions: real conflicts, gaps and unclear points you found. Do not leave empty if you found any.
- Skip sections that do not apply (for example AI Prompts), as the template allows.
- Write in plain, simple English. Keep the game's own theme names exactly as written in README.md.
- Add one line at the top of each spec: "Source docs: <list of files>. Depends on: <Phase 1 spec paths>."

STEP 2: UPDATE specs/INDEX.md
Add exactly one row per new spec: Group | File Path | one-line description | Draft. Do not change existing Phase 1 rows.

STEP 3: CONSISTENCY CHECK
- Every spec number matches SHARED_CORE_STANDARD.md or is listed in Open Questions.
- No section of phase_2/01 to 06 is missing from the specs. List any section you could not place.
- Every level range 501 to 1000 and every mechanic M051 to M099 is covered in specs 2 and 3.
- Every release prerequisite R1 to R10 is covered in spec 8.
- Every Phase 2 change to a Phase 1 behaviour names the Phase 1 spec it changes.

STEP 4: REPORT (short, plain English)
1. List of specs created
2. Conflicts or gaps found between docs
3. Phase 1 specs that need an update because of Phase 2 (do not edit them, only list them)
4. Anything you could not find or were unsure about
5. Suggested order to implement the specs

RULES
- Do not write any app or backend code. Specs only.
- Do not edit the existing docs (README, phase_1, phase_2, SCALING), the Phase 1 specs, or anything outside this game folder.
- Do not set any status to Approved. The developer approves after review.
- Do not rename any existing term, ID or file.
```

---

## After Antigravity finishes

1. Review each spec, fix mistakes, then change `Status` to `Approved`.
2. Check the report item 3 (Phase 1 specs that need an update) and use `/sdd-change <spec-name>` for each.
3. Implement one spec at a time with `/sdd-implement <spec-name>`. Backend spec (8) first, because the Star Race, cloud sync and Piggy Bank specs need it.
4. Repeat for the other three game folders.
