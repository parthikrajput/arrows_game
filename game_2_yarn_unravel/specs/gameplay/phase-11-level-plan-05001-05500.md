Source docs: phase/phase_11/02_LEVEL_PLAN_5001_5500.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md.

# Spec: Gameplay — Phase 11 Level Plan (Levels 5001–5500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [85, 101]$), and milestone rewards for Yarn Unravel Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phase/phase_11/02_LEVEL_PLAN_5001_5500.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 11 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 11 spans 50 blocks of 10 levels each ($L \in [5001, 5500]$):
- **Block 1 (L5001–5010):** Linked Boards Signature System Intro:
  - L5001: Dual Mini Hoops onboarding (demonstrating two concurrent circular embroidery hoops).
  - L5002–5008: Ramp-up with gentle cross-board threading.
  - L5009: Block 1 Hard Level ($D \approx 92$).
  - L5010: Milestone Level + Craft Basket grant.
- **Block 2 (L5011–5020):** Base Mechanic 1 Intro:
  - L5011: M501 Seam Edge onboarding (unravelling from Hoop A into Hoop B).
  - L5020: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L5021–5130):** M501 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L5131–5140):** Base Mechanic 2 Intro:
  - L5131: M502 Cross Charm onboarding (key on Hoop A opening clasp on Hoop B).
  - L5140: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L5141–5250):** M502 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L5251–5260):** Base Mechanic 3 Intro:
  - L5251: M503 Mirror Hoop onboarding (twin threads unravelling simultaneously across hoops).
  - L5260: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L5261–5370):** M503 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L5371–5380):** Base Mechanic 4 Intro:
  - L5371: M504 Relay Pompom onboarding (pompom portal teleporting between hoops).
  - L5380: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L5381–5490):** M504 Variant Progression & Full Twin Hoop Symbiosis (11 variant slots at x1; baskets at x0).
- **Block 50 (L5491–5500):** Review & Finale:
  - L5491: Review Level ("Twin Hoops Mastery", combines M501–M504).
  - L5492–5498: Climax momentum ramp.
  - L5499: Super Hard Level ($D \approx 111$).
  - L5500: Phase Finale "The Twin Hoops Symphony" ($D \approx 121$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P11-A (L5001–5250) | Tier P11-B (L5251–5500) |
|---|---|---|
| **Level Range** | 5001–5250 (250 levels) | 5251–5500 (250 levels) |
| **Grid Size (per hoop)** | Dual 8×8 to 9×9 | Dual 9×9 to 10×10 |
| **Thread Count ($P$)** | 28 – 34 (combined) | 32 – 40 (combined) |
| **Link Items ($O$)** | 8 – 11 (1–2 seams/portals) | 10 – 14 (2–4 seams/portals) |
| **Target $D$ Band** | **85 – 93** | **93 – 101** |
| **x9 Hard Target $D$** | $\approx 102$ ($93 \times 1.10$) | $\approx 111$ ($101 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 121$ ($101 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L5001, L5011, L5131, L5251, L5371):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or compound multi-portals.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L5491):** Comprehensive test combining Seam Edges (M501), Cross Charms (M502), Mirror Hoops (M503), and Relay Pompoms (M504) on dual 10×10 boards.
- **Finale Level (L5500):** "The Twin Hoops Symphony", dual 10×10 boards, 40 threads, 3 seam edges, 2 cross charms, 2 relay pompom pairs, target $D = 121.0$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 11 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_11_config.dart` (to be created: Phase 11 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 11 params)

## Risks
- Small touch targets on mobile screens when displaying two mini hoops simultaneously. Mitigated by intelligent camera zooming focused on active touch regions.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 11 docs.
