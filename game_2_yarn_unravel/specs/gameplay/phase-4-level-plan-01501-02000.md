Source docs: phase/phase_4/02_LEVEL_PLAN_1501_2000.md, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-4-base-mechanics.md, specs/gameplay/phase-4-variants-and-modifiers.md.

# Spec: Gameplay — Phase 4 Level Plan (Levels 1501–2000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level progression plan for Yarn Unravel Phase 4 (Levels 1501–2000), detailing tiers P4-A and P4-B within difficulty band D 64–80, active floor allocations (2 to 3 floors), intro level constraints, and Level 2000 Phase Finale "The Three-Tier Quilt".

## Current State
Design documented in `phase/phase_4/02_LEVEL_PLAN_1501_2000.md` and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Phase 3 operated across Levels 1001–1500 with D band 60–76.
- Phase 4 continues the fixed plateau progression with D band scaling slightly to 64–80 to account for cross-floor navigation complexity.

## Proposed Change
Configure generator parameters and block progression:

### 1. Tier Partitioning & Parameters

| Tier | Level Range | Active Floors | Grid per Floor | Threads ($P$) | Max Obstacles ($O$) | Difficulty ($D$) Band |
|---|---|---|---|---|---|---|
| **P4-A** | 1501–1750 | **2 Floors** | 12×12 to 13×13 | 28–34 | 8–11 | **64 – 72** |
| **P4-B** | 1751–2000 | **3 Floors** | 13×13 to 14×14 | 32–40 | 10–14 | **72 – 80** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L1519, L1529 … L1999) features target $D \approx 88$ ($80 \times 1.10$, tag `hard`, awards 30 Coins).
- **Review Level (L1991):** Block 50 intro ("Multi-Floor Mastery") tests combined mastery of stairs, organza, drop holes, and lifts across 3 floors.
- **Phase Finale (L2000):** "The Three-Tier Quilt" features 3 active 14×14 floors and 40 threads; target $D \approx 96$ ($80 \times 1.20$, tag `finale`, awards 50 Coins).

### 2. Key Intro & Milestone Slots
- **L1501 (Block 1 x1):** Signature Intro — Multi-Floor Navigation (introduces 2 floors and camera tab switching).
- **L1511 (Block 2 x1):** Base Mechanic 1 Intro — M151 Spiral Spool Stair.
- **L1631 (Block 14 x1):** Base Mechanic 2 Intro — M152 Organza Floor.
- **L1751 (Block 26 x1):** Base Mechanic 3 Intro — M153 Drop Hole (first 3-floor level).
- **L1871 (Block 38 x1):** Base Mechanic 4 Intro — M154 Bobbin Lift.
- **L1991 (Block 50 x1):** Review Level — Multi-Floor Mastery.
- **L2000 (Block 50 x0):** Phase 4 Grand Finale — "The Three-Tier Quilt".

### 3. Intro Level Generation Constraints
For each x1 intro level, the deterministic generator enforces:
1. Active floors: Exactly 2 floors (3 floors for L1751+).
2. Max threads: 24 total.
3. Obstacles: Exactly 2 instances of the new mechanic and $\le 1$ familiar obstacle.
4. Independent starting thread: At least 1 thread on each floor unblocks immediately without vertical transit.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_4_config.dart` (to be created: multi-floor generator configs)
- `packages/puzzle_core/lib/src/models/level_slot.dart` (changed: add Phase 4 level slot types)

## Risks
- Overly complex 3-floor boards exceeding device memory or causing player disorientation. Mitigated by restricting 3-floor levels strictly to Tier P4-B (Levels 1751–2000).

## Open Questions
None. Progression parameters and tier boundaries conform to `SHARED_CORE_STANDARD.md` §11.
