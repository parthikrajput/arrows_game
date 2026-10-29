Source docs: phase_5/06_UI_AND_QA_PHASE_5.md, phase_5/01_PHASE_5_SCOPE_AND_RULES.md. Depends on: specs/ui/ui-ux-screens.md, specs/ui/phase-4-ui-additions.md, specs/gameplay/phase-5-signature-system.md.

# Spec: UI — Phase 5 UI Additions & Accessibility

## Status
Draft

## Type
New Feature

## Goal
Specify the UI indicators for push trajectory and force requirements, tutorial cards for M201–M204 and variants, pit filling visual feedback, and accessibility adaptations for Phase 5.

## Current State
Design documented in `phase_5/06_UI_AND_QA_PHASE_5.md` and `phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, not yet implemented.
- Earlier phases provided visual affordances for basic taps, cycle dials, and multi-floor tabs.
- There are currently no visual cues indicating push eligibility, trajectory direction, terrain alteration, or weight restrictions.

## Proposed Change
Implement push cues, boulder warning prompts, and tutorial card presentations in `lib/features/gameplay/presentation/`:

### 1. Push Direction & Eligibility Cues
- **Push Trajectory Chevron:**
  - When an eligible snake's head is orthogonally adjacent to and facing a pushable coconut (M053, M202, M203), a subtle directional chevron pulses gently on the coconut surface along the push vector.
  - If the push path is blocked, no chevron is shown; long-pressing reveals the standard red bonk indicator via Tongue-Flick Preview.
- **Heavy Boulder "Too Heavy!" Feedback (M204):**
  - When a standard snake is tapped while pointed at a Jackfruit Boulder, a brief floating tooltip reads `"Too Heavy!"` with a subtle horizontal shake (4 dp, 150 ms).
  - When a Giant Anaconda (M049) is aligned with M204, a golden power chevron illuminates on the boulder to signal valid displacement.

### 2. Terrain Status Indicators (M201 Coconut Pit)
- **Empty Pit:** Dark sunken earthen circular cavity with clear drop shadows.
- **Filled Pit:** Dynamic mesh change: settles flush with surrounding board tiles, rendering packed earth and green moss texture overlay to clearly indicate traversable floor.

### 3. Tutorial Cards & Guide Integration
- Dedicated full-screen modal tutorial cards triggered on first encounter:
  - **L2001:** Coconut Grove Physics (Advanced Push Physics, momentum, open-edge clearance).
  - **L2011:** M201 Coconut Pit (Pushing coconuts into pits creates walkable floor).
  - **L2131:** M202 Dew-Slick Coconut (Continuous inertia sliding until obstruction).
  - **L2251:** M203 Key Coconut (Pushing key coconuts into matching locks).
  - **L2371:** M204 Jackfruit Boulder (Heavy mass, requires Giant Anaconda or Chained push).
- All cards feature Grandpa Tortoise dialogue, looped visual demonstration, and a "Got it!" button.
- Cataloged under `Settings -> Jungle Guide -> Coconut Grove Physics`.

### 4. Accessibility & Safe Play
- **Reduce Motion:**
  - Disables the "Too Heavy!" screen shake; replaces with static toast alert and haptic feedback.
  - Continuous sliding (M202) replaces motion blur trail with clean translation.
- **Color-Blind Support:**
  - M203 Key Coconuts and matching lock cells utilize distinct geometric keyhole glyphs in addition to color tinting.
- **Screen Reader (Semantics):**
  - Pits declare dynamic semantic states: `"Empty pit, blocking lane"` vs `"Filled pit, walkable floor"`.

## Affected Files
- `lib/features/gameplay/presentation/widgets/push_direction_indicator.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/heavy_boulder_tooltip.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/mechanic_tutorial_card.dart` (extended for Phase 5)
- `lib/features/settings/presentation/screens/jungle_guide_screen.dart` (Phase 5 guide entries added)

## Risks
- Push chevrons cluttering visually dense 14×14 boards. Mitigated by displaying chevrons only when snake is selected or long-pressed.

## Open Questions
- None. UI indicators and feedback align with `phase_5/06_UI_AND_QA_PHASE_5.md`.
