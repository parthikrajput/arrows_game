Source docs: phase/phase_12/02_LEVEL_PLAN_5501_6000.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md.

# Spec: Gameplay — Phase 12 Level Plan (Levels 5501–6000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [88, 104]$), and milestone rewards for Yarn Unravel Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phase/phase_12/02_LEVEL_PLAN_5501_6000.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 12 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 12 spans 50 blocks of 10 levels each ($L \in [5501, 6000]$):
- **Block 1 (L5501–5510):** Gravity Signature System Intro:
  - L5501: Basic Hanging Loom Gravity onboarding (demonstrating falling buttons).
  - L5502–5508: Ramp-up with single-lever gravity orientation.
  - L5509: Block 1 Hard Level ($D \approx 95$).
  - L5510: Milestone Level + Craft Basket grant.
- **Block 2 (L5511–5520):** Base Mechanic 1 Intro:
  - L5511: M551 Plumb Lever onboarding (tapping to cycle gravity direction).
  - L5520: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L5521–5630):** M551 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L5631–5640):** Base Mechanic 2 Intro:
  - L5631: M552 Dropping Buttons onboarding (sliding blockers).
  - L5640: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L5641–5750):** M552 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L5751–5760):** Base Mechanic 3 Intro:
  - L5751: M553 Float Patch onboarding (anti-gravity anchor zones).
  - L5760: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L5761–5870):** M553 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L5871–5880):** Base Mechanic 4 Intro:
  - L5871: M554 Weighted Thread onboarding (heavy wire threads translating in gravity).
  - L5880: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L5881–5990):** M554 Variant Progression & Full Gravity Dynamics Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L5991–6000):** Review & Finale:
  - L5991: Review Level ("Hanging Loom Mastery", combines M551–M554).
  - L5992–5998: Climax momentum ramp.
  - L5999: Super Hard Level ($D \approx 114$).
  - L6000: Phase Finale "The Plumb Line Tapestry" ($D \approx 125$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P12-A (L5501–5750) | Tier P12-B (L5751–6000) |
|---|---|---|
| **Level Range** | 5501–5750 (250 levels) | 5751–6000 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Gravity Items ($O$)** | 8 – 11 (1–2 levers/buttons) | 10 – 14 (2–4 levers/buttons) |
| **Target $D$ Band** | **88 – 96** | **96 – 104** |
| **x9 Hard Target $D$** | $\approx 106$ ($96 \times 1.10$) | $\approx 114$ ($104 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 125$ ($104 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L5501, L5511, L5631, L5751, L5871):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or compound 4-way gravity loops.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L5991):** Comprehensive test combining Plumb Levers (M551), Dropping Buttons (M552), Float Patches (M553), and Weighted Threads (M554) on a 14×14 board.
- **Finale Level (L6000):** "The Plumb Line Tapestry", 14×14 board, 40 threads, 2 plumb levers, 6 dropping buttons, 3 float patches, 4 weighted threads, target $D = 125.0$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 12 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_12_config.dart` (to be created: Phase 12 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 12 params)

## Risks
- Players struggling to anticipate button slide stopping points. Mitigated by animated trajectory preview guidelines displayed on plumb lever hover/tap.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 12 docs.
