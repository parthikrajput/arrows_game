Source docs: phase/phase_3/02_LEVEL_PLAN_1001_1500.md, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-3-base-mechanics.md, specs/gameplay/phase-3-variants-and-modifiers.md.

# Spec: Gameplay — Phase 3 Level Plan (Levels 1001–1500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level progression plan for Yarn Unravel Phase 3 (Levels 1001–1500), detailing the 50-block slot map, tiers P3-A and P3-B within the fixed plateau difficulty band (D 60–76), intro level constraints, and Level 1500 Phase Finale.

## Current State
Design documented in `phase/phase_3/02_LEVEL_PLAN_1001_1500.md` and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Phase 2 spanned Levels 501–1000 with difficulty ending at D = 70.
- Phase 3 transitions into the on-device deterministic generation architecture, adopting a fixed difficulty plateau (D 60–76) where cognitive challenge stems from cyclic mechanics and modifier fusions rather than brute board size inflation.

## Proposed Change
Define the level generator parameters and block progression:

### 1. Tier Partitioning & Parameters

| Tier | Level Range | Grid Dimensions | Threads ($P$) | Max Obstacles ($O$) | Difficulty ($D$) Band |
|---|---|---|---|---|---|
| **P3-A** | 1001–1250 | 12×12 to 13×13 | 28–34 | 8–11 | **60 – 68** |
| **P3-B** | 1251–1500 | 13×13 to 14×14 | 32–40 | 10–14 | **68 – 76** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L1019, L1029 … L1499) has a target $D \approx 84$ ($76 \times 1.10$, tag `hard`, awards 30 Coins).
- **Review Level (L1491):** Block 50 intro ("Loom Mastery") features no new mechanic; combines M101, M102, M103, and M104 on a 14×14 board to test mastery.
- **Phase Finale (L1500):** "Day & Night Tapestry" features peak multi-layer cyclic synchronization; target $D \approx 91$ ($76 \times 1.20$, tag `finale`, awards 50 Coins).

### 2. 50-Block Slot Architecture
Each 10-level block adheres to the standard slot map:
- **x1 (Intro):** Key signature system, base mechanic, or variant intro. Features a focused, solvable board showcasing the new rule; tag `normal`.
- **x2–x4 (Practice):** Layout variations reinforcing the mechanic; tag `normal`.
- **x5 (Breather):** Open, low-density board with minimal obstacle interference; tag `easy` (15 Coins).
- **x6–x8 (Ramp):** Multi-thread density and layer depth escalation; tag `normal`.
- **x9 (Hard):** Block peak difficulty challenge; tag `hard` (30 Coins).
- **x0 (Milestone):** Craft Basket (Gift Box) awarding 300 Coins + 1 rotating booster; tag `normal` (L1500 awards Grand Sewing Chest).

### 3. Key Milestone & Intro Levels
- **L1001 (Block 1 x1):** Signature Intro — Day & Night Loom (introduces the 5-move A/B oscillation).
- **L1011 (Block 2 x1):** Base Mechanic 1 Intro — M101 Loom Latch (Cycle Gate).
- **L1131 (Block 14 x1):** Base Mechanic 2 Intro — M102 Day Bridge (Cycle Bridge).
- **L1251 (Block 26 x1):** Base Mechanic 3 Intro — M103 Night Pompom (Cycle Portal).
- **L1371 (Block 38 x1):** Base Mechanic 4 Intro — M104 Twilight Eyelet (Cycle Color).
- **L1491 (Block 50 x1):** Review Level — Loom Mastery.
- **L1500 (Block 50 x0):** Phase 3 Grand Finale — "Day & Night Tapestry".

### 4. Generator Constraints for Intro Levels
For every x1 intro level, the deterministic generator must enforce:
1. Max board size: 12×12.
2. Max thread count: 24.
3. Obstacle count: Exactly 2–4 instances of the intro mechanic and $\le 1$ familiar Phase 1/2 mechanic.
4. Guaranteed clear tutorial opening: at least 2 threads unblockable without interacting with the new mechanic.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_3_config.dart` (to be created: tier parameter bounds and slot definitions)
- `packages/puzzle_core/lib/src/models/level_slot.dart` (changed: integrate Phase 3 slot tags)

## Risks
- Sudden difficulty spike between P3-A and P3-B tiers. Mitigated by CI generator tuning script enforcing smooth linear difficulty slope ($D_{i+1} \ge D_i - 2$).

## Open Questions
None. Progression parameters conform to `SHARED_CORE_STANDARD.md` §11.
