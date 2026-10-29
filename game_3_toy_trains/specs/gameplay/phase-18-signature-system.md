Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-17-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 18 Signature System (Remix A Early Era Systems Synergy)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 18 signature system "Remix A" (Early Era Synergy `S18`): data-driven synergistic fusions of Phase 1 through 6 mechanics, combining Day/Night cycles, multi-floor station elevations, push cart shunting, and optical chromatic signal beams for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md`, `phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases introduced isolated signature systems per phase.
- Phase 18 represents the first synthesis tier, requiring disparate subsystems to cross-activate and resolve atomically within the turn loop.

## Proposed Change
Extend `packages/puzzle_core` with multi-system cross-interaction adapters:

### 1. Synergy Mechanics & Tick Pipeline
- **Day/Night Ticket Cart (M851):**
  - Shunting ticket carts through Day/Night tunnels synchronizes their state with the active lighting cycle (Day Phase A vs Night Phase B). The cart only unlocks barriers corresponding to its stamped time state.
- **Station Floor Shunting Lift (M852):**
  - Multi-floor station lifts capable of carrying mobile ballast and ice push carts between Upper Deck F2 and Ground Floor F1.
- **Prism Signal Sensor (M853):**
  - Refracted chromatic light beams aimed through colored filters that activate electronic drawbridge gates.
- **Ice Cart Blackout Chute (M854):**
  - Free-sliding ice carts pushed into goods chutes, dropping down into blackout pitch patches to bridge missing track gaps.

### 2. Multi-System Solver Heuristics
- Solver builds composite state graph unifying multi-floor coordinates, cyclic turn timers, push physics vectors, and optical ray paths.

## Affected Files
- `packages/puzzle_core/lib/src/engine/remix_a_adapter.dart` (to be created)
- `packages/puzzle_core/lib/src/models/remix_a_state.dart` (to be created)

## Risks
- State explosion from 4 overlapping mechanics. Mitigation: Board sizes remain clamped to 12x12–14x14; max 2 compound systems active simultaneously per level.

## Open Questions
- None. Rules match `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md` and `SHARED_CORE_STANDARD.md` §11.
