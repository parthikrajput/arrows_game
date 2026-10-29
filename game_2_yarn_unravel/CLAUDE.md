# Yarn Unravel: Cozy Thread Puzzle

## What This Is
Design and technical documentation for the mobile puzzle game "Yarn Unravel: Cozy Thread Puzzle". It is one of four games built on one shared puzzle engine. Full product context: PRODUCT_OVERVIEW.md. This folder has docs only, no code yet.

## Stack (planned)
- Flutter 3.x, Dart 3, Impeller, CustomPainter plus Ticker game loop
- flutter_bloc, hive_ce, shared pure-Dart engine packages/puzzle_core
- AdMob plus UMP, in_app_purchase, Firebase (Analytics, Crashlytics, Remote Config), games_services

## Key Commands
None. These are markdown documents.

## Folder Map
- README.md: overview, key numbers, coverage matrix
- SCALING_TO_10000_LEVELS.md: plan from 500 to 10,000 levels
- phase_1/: launch scope, levels 1 to 500 (docs 01 to 07)
- phase_2/: levels 501 to 1000 plus LiveOps (docs 01 to 06)
- specs/: SDD specs (WORKFLOW, TEMPLATE, INDEX, and group folders)
- This folder also holds the shared standards as game-wise copies: SHARED_CORE_STANDARD.md and the other cross-game standards

## Undocumented Architecture
This file is read in full every session, every line here is a fixed cost paid on every task. Keep this section lean; a feature-specific invariant belongs in that feature's own spec, not here.
- ./SHARED_CORE_STANDARD.md (in this folder) is the single source of truth for rules and numbers. If a number in this folder differs, the standard wins. Never change a shared rule or number only in this game; change it in this copy and in the same file of the other three game folders.
- Shared standards (game-wise copies, in this folder): SOUND_EFFECTS_IMPLEMENTATION.md, VFX_IMPLEMENTATION.md, LOGGING_AND_ERROR_TRACKING.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md.

## Rules
See .claude/rules/ for modular rules and specs/ for all specs.

## Session Startup
At the start of every session: read CLAUDE.md, read specs/WORKFLOW.md, then read specs/INDEX.md to learn which specs exist (names, paths and one line descriptions only, not full contents). Then wait for a task. Read a specific spec only when a relevant task comes in.

Available commands:
- /sdd-audit: read and report on a module, touch nothing
- /sdd-spec: create a new spec for a new feature
- /sdd-change: update an existing spec when requirements change
- /sdd-implement: implement an approved spec
- /sdd-cleanup: repo-wide housekeeping pass, run occasionally, not part of daily work

## Communication
Always respond in plain, simple English. Avoid technical jargon where possible. Keep responses short and clear unless the task genuinely needs detail. Existing documents are mostly written in Gujarati with English terms; when editing a document, keep its existing language and style.

## Team Rules (seeded from the SDD guide)
- Do not rename existing names (terms, mechanic IDs, booster names, file names) to match product wording. Follow the name already used in that file.
- All AI prompts, if any are added, must be versioned inside the spec for that feature. No hardcoded prompts.
- Code comments explain why, not where. Never reference a spec filename, CR number or line number in a comment.
