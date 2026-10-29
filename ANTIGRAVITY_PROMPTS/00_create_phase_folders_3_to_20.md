# Antigravity Prompt 00: Create phase_3 to phase_20 Folders (docs)

Run this FIRST for Phases 3 to 20, before the phase spec prompts (`phase_03_...md` and later).
Today every game folder has only `phase_1/` and `phase_2/`. This prompt creates `phase_3/` to `phase_20/` in the same style, so every phase has its own docs. The spec prompts then read those docs.

Use: open ONE game folder in Antigravity as the workspace, set BATCH (see the top of the prompt), paste, and repeat per batch and per game.
Recommended batches (18 phases x 7 files is too much for one run): 3-5, 6-8, 9-11, 12-14, 15-17, 18-20.

---

```
BATCH: phases <FIRST> to <LAST>      <- replace with e.g. "phases 3 to 5" before pasting

You are creating the missing phase documentation folders for this game.
The workspace root is ONE game folder. Do not touch other game folders. The shared standards (SHARED_CORE_STANDARD.md, SOUND_EFFECTS_IMPLEMENTATION.md, VFX_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md) are in this folder.
Today this folder has phase_1/ (levels 1 to 500) and phase_2/ (levels 501 to 1000). Create phase_N/ folders for the phases in BATCH only, in the same style as phase_2/.

STEP 0: READ FIRST (do not write anything yet)
1. CLAUDE.md, PRODUCT_OVERVIEW.md, README.md, .claude/rules/*.md
2. All of phase_1/ and phase_2/ (README and every numbered doc). Learn the structure, headings, table style, language (Gujarati with English terms) and level of detail. Your new docs must look like they belong next to these.
3. This game's SCALING_TO_10000_LEVELS.md, fully. Especially section 3 (generator, D formula, tiers, validator), section 4 (seeds), section 5 (level JSON), section 6 (Phases 3 to 20 themed table: signature system, mechanic IDs, names, rules), section 7 (variants and modifiers), sections 8 to 10 (cadence, tuning, QA).
4. From this game folder (the shared standards are copied here): VFX_IMPLEMENTATION.md (sections 3 to 5) and SHARED_CORE_STANDARD.md, fully. Especially sections 6 (economy), 9 (phases, tiers), 11 (Phases 3 to 20 plan), 12 (generation), 16 and 17 (binding clarifications; 17.24, 17.28, 17.34, 17.38 matter most).
5. If a previous batch already created phase_N/ folders, read the last one to keep the same style and numbers.

PHASE TABLE (from SHARED_CORE_STANDARD section 11; verify against the docs, trust the docs if they differ and report it)
| Phase | Levels | Signature system | 4 new base mechanics |
|---|---|---|---|
| 3 | 1001-1500 | Cycles (board A/B state every 5 Moves) | Cycle Gate, Cycle Bridge, Cycle Portal, Cycle Color |
| 4 | 1501-2000 | Multi-floor (up to 3 floors, stairs) | Stairs, Glass Floor, Drop Hole, Elevator |
| 5 | 2001-2500 | Push Physics+ | Crate Holes, Sliding Ice Crates, Crate Keys, Heavy Crate |
| 6 | 2501-3000 | Light & Beams+ | Color Filter, Beam Splitter Lock, Beam Timer, Dark Cells |
| 7 | 3001-3500 | Rotation | Sub-board Rotor, Rotating Edges, Spin Path, Rotation Lock |
| 8 | 3501-4000 | Growth | Vine Spread+, Pruner Tile, Seed Path, Bloom Gate |
| 9 | 4001-4500 | Split & Merge | Merger Pad, Twin Splitter, Segment Lock, Rejoin Gate |
| 10 | 4501-5000 | Sequencing | Rhythm Gate, Pattern Lock, Order Edge, Echo Sequence |
| 11 | 5001-5500 | Linked Boards (2 mini boards) | Board Link Edge, Cross-board Key, Mirror Board, Relay Portal |
| 12 | 5501-6000 | Gravity | Gravity Lever, Falling Blockers, Anti-grav Tile, Weight Path |
| 13 | 6001-6500 | Hidden Info | Scout Path, Mimic Fog, False Wall, Reveal Plate |
| 14 | 6501-7000 | Mirror Worlds | Mirror Axis, Reflect Lock, Twin Board, Inverse Path |
| 15 | 7001-7500 | Conveyors & Tracks | Belt Junction, Reversible Belt, Belt Lever, Track Loop |
| 16 | 7501-8000 | Keys Deluxe | Key Chain, Key Crafting, Skeleton Key, Key Swap |
| 17 | 8001-8500 | Guardians | Twin Guardian, Shield Guardian, Spawner Guardian, Guardian Core |
| 18 | 8501-9000 | Remix A (systems of Phases 1 to 6) | 4 combo mechanics chosen by data |
| 19 | 9001-9500 | Remix B (systems of Phases 7 to 12) | 4 combo mechanics chosen by data |
| 20 | 9501-10000 | Grand Master (all systems; L10000 Grand Finale) | per the docs |
Mechanic IDs: Phase n base mechanics = M(50*(n-1)+1) to +3 (Phase 3: M101 to M104, Phase 4: M151 to M154, ... Phase 20: M951 to M954).
Use THIS GAME's themed names and rules from SCALING section 6, not the generic names above.

STEP 1: FOR EACH PHASE IN BATCH, CREATE THIS FOLDER
phase_N/
  README.md                                   scope, goal, what is new vs the previous phase, content summary table, release prerequisites, unlocks, doc index (same layout as phase_2/README.md)
  01_PHASE_N_SCOPE_AND_RULES.md               what changes vs the previous phase, rules that apply, Remote Config keys (maxPhase), limits (grid, path count, D band 60 to 76)
  02_LEVEL_PLAN_<first>_<last>.md             slot map for the 500 levels: block 1 x1 signature intro; x1 of blocks 2, 14, 26, 38 = the 4 base mechanics; the other blocks 3 to 49 = 45 variants; block 50 x1 = review level; hand-tuned levels; Finale and Phase Chest at the last level; tiers and bands
  03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_N.md   the signature system and the 4 new base mechanics: exact rules, parameters, edge cases, tick order (16.17), solver impact, intro level of each
  04_VARIANTS_AND_MODIFIERS_PHASE_N.md        the 45 variant slots: for each slot, base mechanic x modifier, plus modifier rules
  05_REWARDS_AND_ECONOMY_PHASE_N.md           Gift Box, Phase Chest, Coin Rush levels, and any new reward, using only numbers from the standard
  06_UI_AND_QA_PHASE_N.md                     new HUD and visuals for the signature system, a "VFX" section (effects for the signature system and the 4 mechanics, reusing effect classes from ../VFX_IMPLEMENTATION.md section 4, within the tier limits; new classes only as open decisions), tutorial cards, accessibility, CI validation, par/meta data, performance, rollout (maxPhase), analytics events, QA checklist, risks
Phase 3 only: README and doc 01 must also point to SCALING sections 2 to 4 for on-device generation (first phase that uses it).
Phase 18, 19: the 4 combo mechanics are "chosen by data". Do not invent them. Describe the selection rule and mark the choice as an open decision in the README.
Phase 20: include the Grand Finale at L10000 and what the player sees after it, only as far as the docs say. Otherwise mark it as an open decision.

RULES FOR WRITING THE DOCS
- Same language and style as phase_2/: Gujarati with English technical terms, same heading style, same table style, "Related docs" line and a one line purpose under the title.
- Use relative links only. Link to ../SHARED_CORE_STANDARD.md and ../SCALING_TO_10000_LEVELS.md for numbers instead of copying long tables.
- Use only real numbers, names, IDs and level ranges from the docs. Never invent a number. If the docs do not define something, write it in an "Open decisions" section at the end of that doc.
- If a number differs between this game's docs and SHARED_CORE_STANDARD.md, use the standard and note the difference in Open decisions.
- Keep this game's own theme names. Do not use names from the other three games.
- Every level must stay solvable with 0 hearts lost and 0 boosters. State how each new mechanic keeps this true.
- No wall-clock timers. Timed mechanics count Moves.
- Each doc must be useful on its own: someone should be able to build the phase from these docs.

STEP 2: UPDATE ONLY THESE EXISTING FILES
- This game's README.md: add the new phase_N folders to the Folder Map and Coverage section, nothing else.
- Do not edit phase_1/, phase_2/, SCALING_TO_10000_LEVELS.md, specs/, or anything outside this game folder.

STEP 3: CHECK
- Every phase in BATCH has all 7 files and the level range is exactly 500 levels.
- Mechanic IDs and names match SCALING section 6 for this game.
- No doc contradicts SHARED_CORE_STANDARD.md without a note in Open decisions.
- All relative links resolve.

STEP 4: REPORT (short, plain English)
1. Folders and files created
2. Conflicts or gaps found between SHARED_CORE_STANDARD.md and this game's docs
3. Open decisions that need a human answer
4. The BATCH to run next

RULES
- Documents only. No app code, no spec files in this run.
- Do not rename any existing term, ID or file.
```

---

## Order of work (per game)

1. Run this prompt for each batch until `phase_3/` to `phase_20/` exist.
2. Review the docs and answer the Open decisions.
3. Then run the spec prompts one by one: `phase_03_...md`, `phase_04_...md`, and so on. They read the new `phase_N/` docs.
4. Repeat for the other three games.
