Source docs: phase_1/02_LEVEL_PROGRESSION_0001_0500.md, SHARED_CORE_STANDARD.md

# Spec: Level Progression (Levels 1–500)

## Status
Draft

## Type
New Feature

## Goal
Specify the Phase 1 progression architecture covering 500 levels, tier structures, 10-level block patterns, FTUE onboarding, booster tutorial milestones, layer introduction schedule, and the Level 500 Phase Finale for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_1/02_LEVEL_PROGRESSION_0001_0500.md and SHARED_CORE_STANDARD.md, not yet implemented.
- 500 levels delivered via pre-generated, CI-validated asset pack `assets/levels/phase_1.json.gz`.
- Introduces one new mechanic every 10 levels on the x1 slot (M001 at L11 up to M049 at L491).
- 6 Tiers: FTUE (L1-10), T1 (L11-100), T2 (L101-200), T3 (L201-300), T4 (L301-400), T5 (L401-500).
- Hand-tuned levels include FTUE L1-10, all x1 intro levels, all x9 Hard levels, and the L500 Finale.
- Maximum grid size in Phase 1 is 11x11 to maintain a minimum 29 dp cell size on 360 dp screens without pinch-to-zoom.

## Proposed Change
Implement the progression data models, validator, and level loader:

### 1. Tier Architecture
| Tier | Levels | Grid Range | Lines (P) | Max Obstacles (O) | Difficulty (D) Band |
|---|---|---|---|---|---|
| FTUE | 1–3 | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

- Minimum cell size is strictly 29 dp. No pinch-zoom in Phase 1; auto-fit layout only.
- Difficulty never decreases between tiers: tier base D >= previous tier mid D.

### 2. Difficulty Metric D (CI Computed)
`D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`
- `P`: Total line count (ants + bees).
- `C`: Longest dependency chain (dependency graph depth; independent exits = 0).
- `O`: Obstacle instances count.
- `N`: Non-monotone mechanic instances count (levers, pressure plates, countdowns).
- `S`: Solution moves minus line count (`solution.length - P`, representing extra interactive moves).
- Every generated level must fall within its slot target band (±3); otherwise CI rejects the level.

### 3. The 10-Level Block Pattern
Every block `N1…N0` follows a structured 10-level progression:
- **x1 (Intro):** Introduces the new mechanic with <= 1 earlier mechanic type. Dedicated tutorial card with animated illustration. Slot: `intro`, Tag: `normal` (20 coins).
- **x2–x4 (Practice):** Blends the new mechanic with established mechanics. Slot: `practice`, Tag: `normal` (20 coins).
- **x5 (Breather):** Simple layout with lower line count and <= 25% bee share. Slot: `breather`, Tag: `easy` (15 coins).
- **x6–x8 (Ramp):** Increasing density, multi-step chains. Slot: `ramp`, Tag: `normal` (20 coins).
- **x9 (Hard):** Red badge on map and gameplay HUD, difficulty +10% above block high. Slot: `hard`, Tag: `hard` (30 coins).
- **x0 (Milestone):** Thematic culmination awarding **Queen's Gift Box**. Slot: `milestone`, Tag: `normal` (20 coins).
- **L500 (Phase Finale):** Queen's Garden Gala. Slot: `finale`, Tag: `finale` (50 coins). Awards Royal Honey Chest.

### 4. Layer Schedule & M004/M032 Swap
- **Levels 1–40 (Ants Only):** Single layer (`layers: 1`), 0% bees. Player learns foundational line logic with pebbles, twig fences, and dew-stuck lines.
- **Level 41 (Bee Lines Intro):** Introduces Air layer (`layers: 2`) via engine rule M032 (Two Layers) placed in the M004 slot. Tooltip explains: "Bees fly over ants — they never bump each other." Features exactly one cover-lock teaching moment.
- **Level 42:** Introduces first tall obstacle (Sunflower Stalk, M001 `tall: true`). Tooltip: "Tall plants block bees too."
- **Levels 42–100:** Air layer in >= 70% of levels; bees constitute 20%–35% of total lines.
- **Levels 101–300:** Air layer in >= 80% of levels; bees constitute 25%–45% of total lines.
- **Level 321 (Dew Key & Thorn Lock):** Key & Lock mechanic (engine rule M004) introduced in the M032 slot. Keys and locks can be ground or tall.
- **Levels 301–500:** Air layer in >= 85% of levels; bees constitute 30%–50% of total lines.

### 5. FTUE — Levels 1–10 Onboarding
Hand-tuned ant-only levels with 0 obstacles. Interstitial ads and banners strictly disabled:
- **L1 (4×4, 2 lines, D 1–2):** "Tap a line — the ants march out!" Both lines independent.
- **L2 (4×4, 3 lines, D 2–3):** Teaching clear-order: one line in another's lane. "Clear the way first."
- **L3 (5×5, 4 lines, D 3–4):** Nectar Glow Hint tutorial. Grants 3 free Hints; hand points to Hint button.
- **L4 (5×5, 4–5 lines, D 3–5):** Scent Trail Preview tutorial. "Hold a line to see its trail" (long-press 350 ms).
- **L5 (5×5, 5 lines, D 3–4):** Breather level. Hearts HUD tooltip: "A bonk costs 1 heart" (bump not forced).
- **L6 (6×6, 6 lines, D 4–6):** Ramp, chain depth 2.
- **L7 (6×6, 6–7 lines, D 5–7):** Ramp, chain depth 3. Star explanation on Level Complete.
- **L8 (6×6, 7 lines, D 5–7):** Ramp, chain depth 3.
- **L9 (6×6, 8 lines, D 7–8):** Ramp (Normal tag; no Hard badge in FTUE; first Hard badge is L19).
- **L10 (6×6, 8 lines, D 6–7):** Milestone. First Queen's Gift Box: 150 coins + 1 Nectar Glow Hint. Level Map unlock tooltip.

### 6. Feature Unlock Schedule
- **L3:** Nectar Glow Hint tutorial (+3 free Hints granted).
- **L11:** First Obstacle (Garden Pebble M001); Gameplay banner ads activate.
- **L15:** Queen's Royal Shield tutorial (+1 Shield granted); Daily Garden Almanac unlock; Starter Pack offer (48 h); Interstitial eligibility activates.
- **L25:** Leaf Blower tutorial (+1 Hammer granted); First Golden Nectar Rush unlocked.
- **L41:** Bee Lines introduced (Two layers active).
- **L321:** Dew Key & Thorn Lock introduced.
- **L500:** Queen's Garden Gala Finale; Royal Honey Chest (1,000 coins + 2 of each booster).

## Affected Files
- `packages/puzzle_core/lib/src/models/level.dart` (to be created)
- `packages/puzzle_core/lib/src/models/level_metadata.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/level_validator.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/data/level_repository.dart` (to be created)
- `apps/ants_bees/assets/levels/phase_1.json.gz` (bundled asset)

## Risks
- Incorrect slot/tag configuration in JSON metadata could lead to incorrect coin rewards or missing Gift Boxes.
- CI solver must guarantee that every single level from 1 to 500 is solvable with 0 hearts lost and 0 boosters.

## Open Questions
- None. Progression schedule, tier bands, and M004/M032 swap rules are strictly defined.
