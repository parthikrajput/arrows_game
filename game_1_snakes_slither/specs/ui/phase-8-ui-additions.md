Source docs: phases/phase_8/06_UI_AND_QA_PHASE_8.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §14, §15. Depends on: specs/ui/ui-ux-screens.md, specs/ui/phase-7-ui-additions.md.

# Spec: UI — Phase 8 UI Additions and Growth Overlays

## Status
Draft

## Type
New Feature

## Goal
Implement the user interface components, growth countdown badges, seed pod germination indicators, bloom gate status meters, and tutorial cards for Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phases/phase_8/06_UI_AND_QA_PHASE_8.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Previous UI handled rotational handles and directional crests.
- Phase 8 introduces organic plant sprawl indicators, pruning pulse highlights, and delayed seed timers.

## Proposed Change
Implement Phase 8 UI additions in `lib/features/gameplay/presentation/widgets/growth/`:

### 1. Organic Growth UI Components & Indicators

1. **Vine Spread Countdown Badge (M351):**
   - Mini circular badge displaying moves until next spread tick (`3`, `2`, `1`).
   - On the turn before spreading: Candidate adjacent expansion cells flash with a soft pulsing green outline, telegraphing growth targets to the player.
2. **Pruning Shears Tile Highlight (M352):**
   - Interactive stone flagging with an embossed golden shears symbol.
   - When a prospective snake's exit lane crosses this tile, the 4 adjacent pruning cells highlight with soft golden cutting crosshairs.
3. **Seed Pod Timer Indicator (M353):**
   - Dropped seed pod displays an organic seedling icon with a numbered badge ($K \to 0$).
   - If a snake path aims toward the pod, a green footprint indicator indicates the seed will be safely trampled.
4. **Bloom Gate Clearance Meter (M354):**
   - Renders a floating flower bud progress badge reading e.g. `"2 Vines Left"`.
   - When count reaches 0: Floral bloom animation triggers and gate dissolves into falling petals.

---

### 2. Tutorial Cards (FTUE Onboarding)
Modal cards displayed at the start of respective intro levels:
- **L3511 Tutorial (Wild Vine):** *"Wild Vines grow every 3 moves into empty spaces! Don't let them spread and block your snakes."*
- **L3631 Tutorial (Pruning Shears):** *"Slither across the Pruning Tile to cut all adjacent vines! Use it to clear blocked exit paths."*
- **L3751 Tutorial (Seed-Carrier Snake):** *"This snake drops a seed when it exits! Slither over the seed before it sprouts into a thorny vine."*
- **L3871 Tutorial (Bloom Gate):** *"Bloom Gates only open when every vine in the garden is cleared! Prune all vines to finish the puzzle."*

## Affected Files
- `lib/features/gameplay/presentation/widgets/growth/vine_countdown_badge.dart` — to be created
- `lib/features/gameplay/presentation/widgets/growth/seed_pod_widget.dart` — to be created
- `lib/features/gameplay/presentation/widgets/growth/bloom_gate_meter.dart` — to be created
- `lib/features/tutorials/data/phase_8_tutorial_cards.dart` — to be created

## Risks and Open Questions
- None. Clear hierarchy and high accessibility contrast maintained.

