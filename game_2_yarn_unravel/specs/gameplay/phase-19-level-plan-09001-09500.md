Source docs: phase/phase_19/02_LEVEL_PLAN_9001_9500.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-19-signature-system.md, specs/gameplay/phase-19-base-mechanics.md.

# Spec: Gameplay — Phase 19 Level Plan (Levels 9001–9500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 19 (Levels 9001–9500).

## Current State
Documented in `phase/phase_19/02_LEVEL_PLAN_9001_9500.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 19 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 19 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Combo Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P19-A** | 9001–9250 | 12×12 – 13×13 | 28–34 | 8–11 | **109 – 117** |
| **P19-B** | 9251–9500 | 13×13 – 14×14 | 32–40 | 10–14 | **117 – 125** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L9019, L9029 ... L9499) targets $D \approx 137$ ($125 \times 1.10$).
- **Finale Level (L9500):** Targets $D \approx 150$ ($125 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L9001–9010):** Signature Intro (L9001: Spatial Kinematic Synergy, $D \approx 109$).
- **Block 2 (L9011–9020):** Combo Mechanic 1 Intro (L9011: M901 Twirl Weighted Thread, $D \approx 110$).
- **Blocks 3–13 (L9021–9130):** M901 Twirl Weighted variant ramp ($D$ 111–116).
- **Block 14 (L9131–9140):** Combo Mechanic 2 Intro (L9131: M902 Ivy Hoop Rotor, $D \approx 113$).
- **Blocks 15–25 (L9141–9250):** M902 Ivy Hoop Rotor variant ramp ($D$ 115–118).
- **Block 26 (L9251–9260):** Combo Mechanic 3 Intro (L9251: M903 Rhythm Belt, $D \approx 117$).
- **Blocks 27–37 (L9261–9370):** M903 Rhythm Belt variant ramp ($D$ 118–122).
- **Block 38 (L9371–9380):** Combo Mechanic 4 Intro (L9371: M904 Seam Edge Split, $D \approx 120$).
- **Blocks 39–49 (L9371–9490):** M904 Seam Edge Split variants and Kinematic Tapestry Orchestrations ($D$ 121–125).
- **Block 50 (L9491–9500):**
  - Level 9491: Review Level ("Remix B Mastery", $D \approx 125$).
  - Level 9500: Phase Finale "The Symphony of Motion" ($D \approx 150$).

### 3. Finale Level 9500 ("The Symphony of Motion")
- Board layout: 14×14 linen canvas uniting 2 hoop rotors, ivy tendrils, gravity plumb lines, twirl weighted threads, and rhythmic conveyors into a culminating kinematic symphony.
- Target $D$: 150.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks Phase 19 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L9500 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_19_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 19 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.

