Source docs: phase/phase_7/02_LEVEL_PLAN_3001_3500.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-7-base-mechanics.md.

# Spec: Gameplay — Phase 7 Level Plan (Levels 3001–3500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [73, 89]$), and milestone rewards for Yarn Unravel Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phase/phase_7/02_LEVEL_PLAN_3001_3500.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 7 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 7 spans 50 blocks of 10 levels each ($L \in [3001, 3500]$):
- **Block 1 (L3001–3010):** Rotation Signature System Intro:
  - L3001: Basic Turntable Spin onboarding (tap rotor to turn thread into clear exit).
  - L3002–3008: Ramp-up with single-thread rotational alignment.
  - L3009: Block 1 Hard Level ($D \approx 80$).
  - L3010: Milestone Level + Craft Basket grant.
- **Block 2 (L3011–3020):** Base Mechanic 1 Intro:
  - L3011: M301 Hoop Rotor onboarding ($4 \times 4$ sub-board rotation).
  - L3020: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L3021–3130):** M301 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L3131–3140):** Base Mechanic 2 Intro:
  - L3131: M302 Turning Hem onboarding (moving perimeter exit gaps).
  - L3140: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L3141–3250):** M302 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L3251–3260):** Base Mechanic 3 Intro:
  - L3251: M303 Twirl Thread onboarding (needle spinning 90° CW per turn).
  - L3260: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L3261–3370):** M303 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L3371–3380):** Base Mechanic 4 Intro:
  - L3371: M304 Ratchet Pin onboarding (key-thread releasing rotor lock).
  - L3380: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L3381–3490):** M304 Variant Progression & Full Kaleidoscope Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L3491–3500):** Review & Finale:
  - L3491: Review Level ("Turning Table Mastery", combines M301–M304).
  - L3492–2498: Pre-finale climax ramp.
  - L3499: Super Hard Level ($D \approx 98$).
  - L3500: Phase Finale "The Kaleidoscope Quilt" ($D \approx 107$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P7-A (L3001–3250) | Tier P7-B (L3251–3500) |
|---|---|---|
| **Level Range** | 3001–3250 (250 levels) | 3251–3500 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Rotors & Obstacles ($O$)** | 8 – 11 (1–2 rotors) | 10 – 14 (2–3 rotors) |
| **Target $D$ Band** | **73 – 81** | **81 – 89** |
| **x9 Hard Target $D$** | $\approx 89$ ($81 \times 1.10$) | $\approx 98$ ($89 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 107$ ($89 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L3001, L3011, L3131, L3251, L3371):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or multiple intersecting rotors.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L3491):** Comprehensive test combining Hoop Rotors (M301), Turning Hems (M302), Twirl Threads (M303), and Ratchet Pins (M304) on a 14×14 board.
- **Finale Level (L3500):** "The Kaleidoscope Quilt", 14×14 board, 40 threads, 2 synchronized hoop rotors, target $D = 106.8$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 7 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_7_config.dart` (to be created: Phase 7 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 7 params)

## Risks
- Players rotating sub-boards blindly and creating deep deadlocks. Mitigated by Tangled state preventing heart loss on blocked internal threads.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 7 docs.
