Source docs: phase_1/02_LEVEL_PROGRESSION_0001_0500.md, ../../SHARED_CORE_STANDARD.md

# Spec: Level Progression (Levels 1–500)

## Status
Draft

## Type
New Feature

## Goal
Specify the Phase 1 progression system covering 500 levels, tier structures, 10-level block patterns, FTUE onboarding, booster tutorial milestones, 50-block table, and the Level 500 Phase Finale.

## Current State
Design documented in phase_1/02_LEVEL_PROGRESSION_0001_0500.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 500 levels delivered via pre-generated, CI-validated asset pack `assets/levels/phase_1.json.gz`.
- Introduces one new mechanic every 10 levels on the x1 slot (M001 at L11 up to M049 at L491).
- 6 Tiers: FTUE (L1-10), T1 (L11-100), T2 (L101-200), T3 (L201-300), T4 (L301-400), T5 (L401-500).
- Hand-tuned levels include L1-30, all x1 intro levels, all x9 Hard levels, and the L500 Finale.
- Maximum grid size in Phase 1 is 11x11 to maintain minimum 29 dp cell size on 360 dp screens without pinch-to-zoom.

## Proposed Change
Implement the progression data models, validator, and level loader:

### 1. Tier Architecture
| Tier | Levels | Biome | Grid Range | Snakes Range | Max Obstacles | Difficulty (D) Band |
|---|---|---|---|---|---|---|
| FTUE | 1–3 | Pip's Backyard | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | Pip's Backyard | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | Garden Meadow | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | Bamboo Grove | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | Mango Orchard | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | Misty Swamp | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | Moonlit Jungle | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

- Minimum cell size is strictly 29 dp. No pinch-zoom in Phase 1; auto-fit layout only.
- Difficulty never decreases between tiers: tier base D >= previous tier mid D.

### 2. Difficulty Metric D (CI Computed)
`D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`
- `P`: Snake count.
- `C`: Longest dependency chain (number of dependency links in the solver graph; independent exits = 0).
- `O`: Obstacle instances count.
- `N`: Non-monotone mechanic instances count (levers, pressure plates, countdowns).
- `S`: Solution moves minus snake count (`solution.length - P`, representing extra interactive moves).
- Every generated level must fall within its slot target band (±3); otherwise it is rejected.

### 3. 10-Level Block Pattern
Every block `N1…N0` follows a structured 10-level progression:
- **x1 (Intro):** Introduces the new mechanic with <= 1 earlier mechanic type. Grandpa Tortoise intro card with animated loop. Tag: Normal (20 coins).
- **x2–x4 (Practice):** Mix of new and earlier unlocked mechanics. Tag: Normal (20 coins).
- **x5 (Breather):** Low difficulty breather level. Tag: Easy (15 coins).
- **x6–x8 (Ramp):** Increasing complexity and obstacle density. Tag: Normal (20 coins).
- **x9 (Hard):** Red paw badge on map. Target D is high + 10% (band max × 1.1). Tag: Hard (30 coins).
- **x0 (Milestone):** Milestone level awarding a Jungle Gift Basket (150–300 coins + 1 booster). Tag: Normal (20 coins).
- Every level JSON must declare both `slot` (intro, practice, breather, ramp, hard, milestone, finale) and `tag` (easy, normal, hard, finale).

### 4. FTUE Levels 1–10 (Onboarding)
Zero obstacles on board. Deterministic optimal move limits: L1–3 optimal moves <= 4; L4–10 optimal moves <= 8.
- **L1 (4x4, 2 snakes, D=1.2):** `1_tap_to_slither` tutorial step. Hand pulses on snake A, then B. Hearts HUD hidden.
- **L2 (4x4, 3 snakes, D=3.3):** `2_order_matters`. Hand on free snake. Bonking displays tooltip: "Ouch! A bonk costs 1 Heart Berry." Hearts HUD appears.
- **L3 (5x5, 4 snakes, D=3.9):** `3_hint`. Glow Firefly Hint tutorial. Grants 3 free Hints; guided use of 1 Hint (2 remaining).
- **L4 (5x5, 4 snakes, D=5.4):** `4_hearts`. Highlights hearts HUD with 3 berries and Second Chance explanation.
- **L5 (5x5, 5 snakes, D=4.5, Breather/Easy):** `5_preview`. Tongue-Flick Preview tutorial: press and hold for dotted line.
- **L6 (6x6, 6 snakes, D=6.6):** `6_tap_anywhere`. Tapping body segment middle; introduces caterpillar skin.
- **L7 (6x6, 6 snakes, D=6.6):** `7_moves`. One-time Move counter tooltip.
- **L8 (6x6, 7 snakes, D=7.2):** `8_curved_path`. Planning order on curved paths.
- **L9 (6x6, 8 snakes, D=7.8):** `9_think_ahead`. Tag is Normal (FTUE contains no Hard levels; first Hard is L19).
- **L10 (6x6, 8 snakes, D=6.3):** `10_gift_basket`. Milestone level awarding first Jungle Gift Basket (150 coins + 1 Hint). Unlocks Lucky Lily Wheel.
- No interstitials and no banner ads are ever shown during Levels 1–10.

### 5. Booster Unlocks & Tutorials
- **Level 3:** Glow Firefly Hint unlocked; 3 free Hints granted; guided tutorial.
- **Level 15 (Start):** Safety Shell Shield unlocked; 1 free Shield granted; tutorial tooltip. (L15 clear also unlocks Daily Jungle Puzzle, triggers 48h Starter Pack window, and wins count toward first eligible interstitial).
- **Level 25 (Start):** Magic Stone Hammer unlocked; 1 free Hammer granted; tutorial tooltip. (L25 clear triggers first Golden Slither Rush).

### 6. Full 50-Block Catalog Summary (Levels 1–500)
- **Block 1 (L1–10):** FTUE, clean board, Gift Basket at L10 (150 + 1 Hint).
- **Block 2 (L11–20):** M001 Garden Rock (L11), Hard at L19, Gift at L20 (150 + 1 Hammer). Banner ads begin at L11.
- **Block 3 (L21–30):** M002 Fallen Log (L21), Rush after L25, Hard at L29, Gift at L30 (150 + 1 Shield).
- **Block 4 (L31–40):** M003 Frost Coil (L31), Hard at L39, Gift at L40 (150 + 1 Hint).
- **Block 5 (L41–50):** M004 Bamboo Cage & Key (L41), Hard at L49, Rush after L50, Gift at L50 (150 + 1 Hammer).
- **Block 6 (L51–60):** M005 Flower Gate (L51), Hard at L59, Gift at L60 (150 + 1 Shield).
- **Block 7 (L61–70):** M006 Bamboo One-Way (L61), Hard at L69, Gift at L70 (150 + 1 Hint).
- **Block 8 (L71–80):** M007 Lotus Bud Gate (L71), Rush after L75, Hard at L79, Gift at L80 (150 + 1 Hammer).
- **Block 9 (L81–90):** M008 Rabbit Burrows (L81), Hard at L89, Gift at L90 (150 + 1 Shield).
- **Block 10 (L91–100):** M009 Branch Lever & Twig Gates (L91), Hard at L99, Rush after L100, Gift at L100 (150 + 1 Hint).
- **Blocks 11–20 (L101–200, T2 Bamboo Grove, Gift 180 coins):** M010 Jungle Mist (L101), M011 Vine-Tied Twins (L111), M012 Sleepy Python (L121), M013 Spinning Lilypad (L131), M014 Mushroom Bumper (L141), M015 Root Bridge (L151), M016 Termite Mound (L161), M017 Restless Caterpillar (L171), M018 Fern Fork Switch (L181), M019 Mossy Pressure Stone (L191). Rush after L125, L150, L175, L200. Hard at x9.
- **Blocks 21–30 (L201–300, T3 Mango Orchard, Gift 210 coins):** M020 Home Burrow (L201), M021 Phantom Snake (L211), M022 Reverse Slither (L221), M023 Two-Headed Hydra (L231), M024 Giant Anaconda (L241), M025 Patrolling Beetle (L251), M026 Jungle Gems (L261), M027 Creeping Vine (L271), M028 Hatch Order Snakes (L281), M029 Hedge Border (L291). Rush after L225, L250, L275, L300. Hard at x9.
- **Blocks 31–40 (L301–400, T4 Misty Swamp, Gift 250 coins):** M030 Flower Arch Exit (L301), M031 Closing Hedge Gap (L311), M032 Canopy & Ground (L321), M033 Petal Cage (L331), M034 Whirl Stump (L341), M035 Mama Snake (L351), M036 Hungry Caterpillar (L361), M037 Sticky Swamp Mud (L371), M038 Bouncy Fern Pad (L381), M039 Pond Twins (L391). Rush after L325, L350, L375, L400. Hard at x9.
- **Blocks 41–50 (L401–500, T5 Moonlit Jungle, Gift 300 coins):** M040 Jungle Night (L401), M041 Chameleon Snake (L411), M042 Dry Twig Bridge (L421), M043 Big Knot Cage (L431), M044 Twisty Burrow (L441), M045 Root Gear Lever (L451), M046 Tail-Biter Loop (L461), M047 Growing Caterpillar (L471), M048 Snake Parade (L481), M049 Grumpy Mongoose (L491). Rush after L425, L450, L475, L500. Hard at x9.
- **Block 50 Finale:** Level 500 Phase Finale "Mongoose King's Garden".

### 7. Level 500 Finale: "Mongoose King's Garden"
- **Properties:** Grid 11x11, 30 snakes (6 caterpillar skins), 1 layer, Tag: `finale` (50 coins), Target D ≈ 62 (T5 high 52 × 1.2).
- **Composition (Guardian + 9 mechanics = 10 instances max):**
  1. M049 Grumpy Mongoose (King skin, 3x3 at (4,4)-(6,6), HP = 6 linked snakes).
  2. M004 Bamboo Cage & Key.
  3. M009 Branch Lever & Twig Gates (1 lever, 2 gates).
  4. M010 Jungle Mist (3x2, concealing 2 linked snakes).
  5. M013 Spinning Lilypad.
  6. M016 Termite Mound (HP 2).
  7. M020 Home Burrow (behind Mongoose).
  8. M026 Jungle Gems (3 gems).
  9. M028 Hatch Order Snakes (1-3).
  10. M041 Chameleon Snake.
- **Three-Act Flow:**
  - *Act 1 (Outer Ring):* Hatch Order sequence, Key unlocks Bamboo Cage, Termite Mound 2 hits.
  - *Act 2 (Middle Ring):* Lever toggle, Lilypad rotation, Jungle Mist clear reveals hidden linked snakes.
  - *Act 3 (Core):* 6 linked snakes exit -> Mongoose HP reaches 0 -> vanishes in friendly leaf puff -> gems collected -> remaining snakes enter Home Burrow.
- **Post-Clear Sequence:** 50 clear coins (+20 for ★★★) -> Jungle Treasure Chest (1,000 coins + 2 Hint + 2 Shield + 2 Hammer + "Garden Hero" badge) -> Golden Slither Rush (30 snakes) -> Phase Complete screen.

## Affected Files
- `packages/puzzle_core/lib/src/difficulty.dart` (to be created)
- `packages/puzzle_core/lib/src/level_codec.dart` (to be created)
- `apps/snakes_slither/assets/levels/phase_1.json.gz` (to be created)
- `apps/snakes_slither/lib/data/repositories/level_repository.dart` (to be created)
- `tools/validator/bin/validator.dart` (to be created)

## Risks
- Maintaining difficulty band accuracy: generator must accurately compute chain length `C` and non-monotone moves `S` after BFS solver completion.
- Ensuring every level is solvable with 0 hearts lost and 0 boosters.

## Open Questions
- None. All tier ranges, formula coefficients, and mechanic intro slots match SHARED_CORE_STANDARD §9.
