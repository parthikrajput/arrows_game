Source docs: phase_3/06_UI_AND_QA_PHASE_3.md, phase_3/01_PHASE_3_SCOPE_AND_RULES.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-3-signature-system.md.

# Spec: UI — Phase 3 UI Additions & Accessibility

## Status
Draft

## Type
New Feature

## Goal
Specify the UI components, Sun/Moon cycle dial HUD, variant tutorial cards, color-blind shape encodings, and accessibility adaptations for Phase 3.

## Current State
Design documented in `phase_3/06_UI_AND_QA_PHASE_3.md`, not yet implemented.
- Phase 1 & 2 HUD displayed Moves, Hearts, Settings, and the 🔍 Fit button.
- Phase 3 requires real-time display of the alternating Day & Night cycle state and moves remaining until the next transition.

## Proposed Change
Implement the Sun/Moon dial HUD and tutorial presentation in `lib/features/gameplay/presentation/`:

### 1. Sun/Moon Cycle Dial HUD
- **Location:** Top gameplay status bar adjacent to the Moves counter.
- **Component Design:**
  - Circular dial containing central celestial icon (Golden Sun in Day state, Silver Moon in Night state).
  - 5 segmented radial pips surrounding the perimeter.
  - On each valid Move, 1 pip illuminates with an audio tick.
  - When the 5th pip fills, the dial performs a 180° rotation (300 ms easeOutBack), shifting between Day and Night.
- **Text Companion (Accessibility):** Optional text string below or beside dial: "Day: N moves left" / "Night: N moves left".

### 2. M101–M104 & Variant Tutorial Cards
- Introductions at L1001 (Cycles), L1011 (M101), L1131 (M102), L1251 (M103), L1371 (M104).
- Standard card layout matching Phase 1/2 conventions:
  - Header: Character icon (Grandpa Tortoise) + localized mechanic title.
  - Center: Animated looped visual demonstration.
  - Rule line: Clear 1-sentence explanation of behavior.
  - Bottom: "Got it!" interactive button.
- Settings -> Jungle Guide updated with Phase 3 catalog entries.

### 3. Accessibility & Color-Blind Encodings
- **M104 Twilight Flower Gate Support:**
  - Color transitions (e.g. Teal ↔ Amber) are paired with distinct geometric petal shape glyphs:
    - Day color: Circular center + round petals.
    - Night color: Diamond center + pointed petals.
- **Reduce Motion Support:**
  - Disables the 180° dial spin animation; replaces with an instantaneous alpha fade (100 ms).
  - Ambient board lighting tween duration reduced to 0 ms (instant color swap).

## Affected Files
- `lib/features/gameplay/presentation/widgets/hud_cycle_dial.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/mechanic_tutorial_card.dart` (extended for Phase 3)
- `lib/features/settings/presentation/screens/jungle_guide_screen.dart` (Phase 3 cards added)

## Risks
- Crowded top HUD on compact narrow screens (< 360 dp width). Addressed by responsive scaling of pip indicator diameter (from 44 dp to 36 dp on small screens).

## Open Questions
- None. UI specs match `phase_3/06_UI_AND_QA_PHASE_3.md`.
