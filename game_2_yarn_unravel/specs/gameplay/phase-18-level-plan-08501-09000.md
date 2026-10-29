Source docs: phase/phase_18/02_LEVEL_PLAN_8501_9000.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-18-signature-system.md, specs/gameplay/phase-18-base-mechanics.md.

# Spec: Gameplay — Phase 18 Level Plan (Levels 8501–9000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 18 (Levels 8501–9000).

## Current State
Documented in `phase/phase_18/02_LEVEL_PLAN_8501_9000.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 18 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 18 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Combo Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P18-A** | 8501–8750 | 12×12 – 13×13 | 28–34 | 8–11 | **106 – 114** |
| **P18-B** | 8751–9000 | 13×13 – 14×14 | 32–40 | 10–14 | **114 – 122** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L8519, L8529 ... L8999) targets $D \approx 134$ ($122 \times 1.10$).
- **Finale Level (L9000):** Targets $D \approx 146$ ($122 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L8501–8510):** Signature Intro (L8501: Multi-System Synergy introduction, $D \approx 106$).
- **Block 2 (L8511–8520):** Combo Mechanic 1 Intro (L8511: M851 Cycle Crate, $D \approx 107$).
- **Blocks 3–13 (L8521–8630):** M851 Cycle Crate variant ramp ($D$ 108–113).
- **Block 14 (L8631–8640):** Combo Mechanic 2 Intro (L8631: M852 Floor Beam, $D \approx 110$).
- **Blocks 15–25 (L8641–8750):** M852 Floor Beam variant ramp ($D$ 112–115).
- **Block 26 (L8751–8760):** Combo Mechanic 3 Intro (L8751: M853 Fogged Stair, $D \approx 114$).
- **Blocks 27–37 (L8761–8870):** M853 Fogged Stair variant ramp ($D$ 115–119).
- **Block 38 (L8871–8880):** Combo Mechanic 4 Intro (L8871: M854 Satin Charm Crate, $D \approx 117$).
- **Blocks 39–49 (L8881–8990):** M854 Satin Charm Crate variants and Multi-System Synthesis ($D$ 118–122).
- **Block 50 (L8991–9000):**
  - Level 8991: Review Level ("Remix A Mastery", $D \approx 122$).
  - Level 9000: Phase Finale "The Grand Atelier Loom" ($D \approx 146$).

### 3. Finale Level 9000 ("The Grand Atelier Loom")
- Board layout: 14×14 linen canvas integrating Day/Night cycles, multi-floor organza layers, sliding satin crates, and optical prism beams into a masterwork loom challenge.
- Target $D$: 146.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks Phase 18 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L9000 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_18_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 18 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.
