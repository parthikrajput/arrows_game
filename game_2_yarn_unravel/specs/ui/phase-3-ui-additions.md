Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-3-signature-system.md.

# Spec: UI — Phase 3 UI & HUD Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the HUD controls, Sun/Moon Loom Dial widget, ambient canvas color transitions, tutorial prompt cards, and accessibility enhancements required for Yarn Unravel Phase 3 (Day & Night Loom).

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md`, not yet implemented.
- Phase 2 HUD in `specs/ui/ui-ux-screens.md` contained the Move counter, Level badge, Hearts, and "Fit" button.
- Phase 3 requires real-time visualization of the 5-move Cycle countdown and ambient atmospheric day/night shifts.

## Proposed Change
Implement the Phase 3 presentation components in `lib/features/gameplay/view/widgets/`:

### 1. Sun/Moon Loom Dial Widget (`LoomDialWidget`)
- Located in the top gameplay HUD adjacent to the Move Counter.
- **Visual Design:** Circular carved birch wood dial framed with miniature brass studs:
  - **Stitch Dots:** 5 illuminated stitch dots representing moves remaining until the next cycle shift.
  - **Countdown:** On each valid player Move, one dot extinguishes ($5 \to 4 \to 3 \to 2 \to 1$).
  - **Active State Icon:** Displays a warm golden sun icon during State A (Day) and a polished silver crescent moon icon during State B (Night).
  - **Urgency Warning:** When exactly 1 move remains before shift (`remainingMoves == 1`), the dial pulses softly (scale $1.0 \to 1.08 \to 1.0$ over 600 ms) with a gentle haptic `selectionClick`.

### 2. Canvas Ambient Lighting Transitions
- The linen fabric background of the craft board dynamically transitions between day and night tones:
  - **State A (Day Loom):** Warm cream linen hue (`#FFF9F0`).
  - **State B (Night Loom):** Cool twilight blue linen tone (`#EBF3FA`).
- **Transition Duration:** Smooth 400 ms color cross-fade executed via `ColorTween` driven by the cycle state cubit.
- **Reduced Motion:** If system reduced motion is enabled, background color changes instantly without tweening.

### 3. Tutorial Cards (Illustrated Purl Cards)
Presented as non-blocking dialogue modals on first encounter:
- **L1001 (Day & Night Loom):** Purl pointing a needle at the dial: *"The loom shifts every 5 stitches! Watch the sun and moon."*
- **L1011 (M101 Loom Latch):** Purl inspecting a wooden latch: *"Loom Latches open in the day and close tight at night!"*
- **L1131 (M102 Day Bridge):** Purl standing on a bridge: *"Day Bridges let threads cross by day, but collapse into walls by night!"*
- **L1251 (M103 Night Pompom):** Purl touching glowing wool: *"Night Pompoms only glow and teleport threads when the moon is high!"*
- **L1371 (M104 Twilight Eyelet):** Purl threading a needle: *"Twilight Eyelets shift their favorite yarn color when night falls!"*

### 4. Accessibility & Color-Blind Modes
- **High-Contrast Text Toggle:** In accessibility settings, enables textual status tags `"☀️ DAY"` and `"🌙 NIGHT"` displayed directly beneath the dial.
- **Pattern Matching for Eyelets (M104):** Twilight Eyelet rims render distinct geometric shapes (Circle for Color A, Diamond for Color B) matching the pattern icons stamped on thread needles.

## Affected Files
- `lib/features/gameplay/view/widgets/loom_dial_widget.dart` (to be created)
- `lib/features/gameplay/view/board_canvas.dart` (changed: integrate ambient linen color tween)
- `lib/features/gameplay/view/dialogs/purl_tutorial_dialog.dart` (changed: add Phase 3 tutorial assets)

## Risks
- 400 ms canvas color tween causing GPU redraw overhead on low-end devices. Mitigated by tweening background canvas `Color` rather than rebuilding the static obstacle picture.

## Open Questions
None. HUD design and color values match Phase 3 documentation.
