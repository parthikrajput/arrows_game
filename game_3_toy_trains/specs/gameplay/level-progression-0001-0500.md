Source docs: phase_1/02_LEVEL_PROGRESSION_0001_0500.md, ../../SHARED_CORE_STANDARD.md

# Spec: Level Progression 0001–0500 (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the 500-level progression architecture, difficulty scaling model, 10-level block patterns, FTUE onboarding sequence, and L500 Grand Central Finale for Toy Trains: Wooden Railway Puzzle Phase 1.

## Current State
Design documented in phase_1/02_LEVEL_PROGRESSION_0001_0500.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 500 levels bundled in `assets/levels/phase_1.json.gz`.
- Strict 10-level block cadence introducing one new mechanic at every x1 level (M001–M049).
- Difficulty follows the formula `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`.
- Grid caps at 11x11 in Phase 1 (cell size >= 29 dp on 360 dp width devices; no camera zoom/pan).
- Zero ads in FTUE L1–10; gameplay banner ads appear starting at L11.

## Proposed Change
Implement the level structure, difficulty constraints, and progression validators in `packages/puzzle_core` and `tools/levelgen`:

### 1. Phase 1 Tiers & Board Boundaries
| Tier | Levels | Grid Size | Trains (P) | Max Obstacles (O) | D Band |
|---|---|---|---|---|---|
| **FTUE-a** | 1–3 | 4×4 – 5×5 | 2–4 | 0 | 1–4 |
| **FTUE-b** | 4–10 | 5×5 – 6×6 | 4–8 | 0 | 3–8 |
| **T1** | 11–100 | 6×6 – 8×8 | 6–14 | 1–4 | 6–18 |
| **T2** | 101–200 | 7×7 – 9×9 | 10–18 | 3–6 | 14–26 |
| **T3** | 201–300 | 8×8 – 10×10 | 14–22 | 4–8 | 22–36 |
| **T4** | 301–400 | 9×9 – 10×10 | 18–26 | 5–9 | 30–44 |
| **T5** | 401–500 | 10×10 – 11×11 | 22–30 | 6–10 | 38–52 |

- **Grid Size Limit:** Maximum grid size is 11×11. Minimum cell touch target is 29 dp. Zoom and pan gestures are strictly disabled in Phase 1.
- **FTUE Move Caps:** L1–3 optimal solution moves <= 4; L4–10 optimal solution moves <= 8. Median clear time targets: L1–3 <= 10 s; L4–10 <= 20 s.

### 2. Difficulty Calculation (D Formula)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
```
- `P`: Total train count on the board.
- `C`: Longest dependency chain (dependency edges in the solver graph; C = 0 if all trains can exit independently).
- `O`: Total obstacle instances on the board.
- `N`: Non-monotone interactive mechanics (levers, switches, turntables, rotating yards, plates).
- `S`: Extra solution moves (`solution.length - P`).
- Generator rejects any level where `D` falls outside slot target band (+/- 3).
- **Hard Level (x9) Target:** Tier high-end × 1.10.
- **Grand Central Finale (L500) Target:** T5 high-end × 1.20 (target D ≈ 62.4).

### 3. 10-Level Block Cadence (Blocks N1–N0)
Each 10-level block is tagged in the level JSON with `slot` (progression role) and `tag` (economy tier):
| Slot | Role | Target Band | `slot` | `tag` | Clear Coins |
|---|---|---|---|---|---|
| **x1** | **Intro:** Introduces new mechanic M00k; only intro mechanic + <= 1 prior mechanic allowed | Low | `intro` | `normal` | 20 |
| **x2–x4** | **Practice:** Combines new mechanic with existing puzzle elements | Low → Mid | `practice` | `normal` | 20 |
| **x5** | **Breather:** High-satisfaction easy level to prevent churn | Low | `breather` | `easy` | 15 |
| **x6–x8** | **Ramp:** Escalating complexity and train count | Mid → High | `ramp` | `normal` | 20 |
| **x9** | **Hard:** Peak challenge; displays red "Hard" badge on Level Map | High +10% | `hard` | `hard` | 30 |
| **x0** | **Milestone:** Rewards Conductor's Gift Crate | Mid | `milestone` | `normal` | 20 |

- **L500 Phase Finale:** Boss board featuring Clock Tower Guardian (M049) and interlocking railway tracks (`slot`: `finale`, `tag`: `finale`, clear coins: 50, grants Grand Central Chest).

### 4. FTUE Sequence (Levels 1–10)
- **L1:** 4×4, 2 trains, optimal 2 moves, `ftue_step = tap_to_depart`. Hand points to first free engine. Clean tracks.
- **L2:** 4×4, 3 trains, optimal 3 moves, `ftue_step = route_peek_intro`. Tutorial introduces long-press Route Peek.
- **L3:** 5×5, 4 trains, optimal 4 moves, `ftue_step = green_signal_hint`. Grants 3 Green Signal Hints; prompts player to activate one.
- **L4:** 5×5, 5 trains, introduces curved carriage bodies.
- **L5:** 5×5, 6 trains, introduces 2-direction cross-traffic.
- **L6:** 6×6, 6 trains, introduces 3-train dependency chain.
- **L7:** 6×6, 7 trains, introduces trains positioned nose-to-tail.
- **L8:** 6×6, 8 trains, introduces long 4-carriage freight trains.
- **L9:** 6×6, 8 trains, FTUE peak difficulty with complex routing.
- **L10:** 6×6, 8 trains, FTUE milestone; grants first Conductor's Gift Crate (150 coins + 1 Green Signal Hint).

### 5. Booster & Feature Unlock Schedule
- **L2:** Route Peek (Path Preview) available free.
- **L3:** Green Signal Hint unlocks (3 free granted).
- **L10:** First Conductor's Gift Crate (150 coins + 1 Hint).
- **L15:** Daily Timetable Run unlocks; Cowcatcher Shield unlocks (1 free granted).
- **L25:** First Golden Express Coin Rush bonus round; Track Crane unlocks (1 free granted).
- **Every 25 levels (25, 50, 75... 475):** Golden Express Coin Rush.
- **Every 10 levels (10, 20... 490):** Conductor's Gift Crate.
- **L500:** Grand Central Finale + Grand Central Chest.

## Affected Files
- `packages/puzzle_core/lib/src/gen/difficulty.dart` (to be created)
- `packages/puzzle_core/lib/src/model/level.dart` (to be created)
- `tools/levelgen/bin/validate.dart` (to be created)
- `apps/toy_trains/assets/levels/phase_1.json.gz` (bundled dataset)
- `apps/toy_trains/lib/features/level_map/level_node.dart` (to be created)

## Risks
- High dependency chains (C > 6) in mid tiers could cause player fatigue if breather levels are misplaced.
- Difficulty formula must accurately reflect extra moves spent on interactive switches and turntables.

## Open Questions
- None. Slot map, tier numbers, and unlock milestones match phase_1/02 and SHARED_CORE_STANDARD.md.
