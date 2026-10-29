Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-5-ui-additions.md, specs/gameplay/phase-6-signature-system.md.

# Spec: UI — Phase 6 UI & Optical Signal Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, chromatic beam shaders, timer countdown rings, blackout darkness masks, and tutorial dialogs for Phase 6 (Signal Lights+) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases handled shunting guides and multi-floor camera transitions.
- Phase 6 requires visual representations of optical beam paths, chromatic refraction, and unlit blackout tracks.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Optical Beams & Blackout Shaders
- **Chromatic Light Beams:** Rendered as glowing additive corridors across track lines:
  - Natural Lamp Beam: `#FEF3C7` (Warm Amber Glow).
  - Ruby Lens Beam: `#EF4444` (Vibrant Red).
  - Emerald Lens Beam: `#10B981` (Bright Green).
  - Sapphire Lens Beam: `#3B82F6` (Electric Blue).
- **Twin-Sensor Gate HUD Pips:**
  - Gate barrier displays two miniature LED status lamps above the archway.
  - Lamp 1 & 2 illuminate Green when receiving beam, Red when unlit.
  - Gate lowers only when both LEDs show solid Green.
- **Blackout Patch Darkness Mask:**
  - Dark cells render with translucent charcoal vignette (`#111827`, opacity 0.85).
  - When struck by a light beam, the vignette dissolves via circular reveal mask, illuminating trains in warm depot lamplight.

### 2. Lamp Timer Countdown Ring
- Lamp Timer (M253) features a brass circular bezel with radial progress pips.
- Notches tick down clockwise with each valid player Move, indicating moves until beam state toggle.

### 3. Tutorial Cards (`ftue_cards`)
- **L2501 (Signal Lights Intro):** "Welcome to Signal Junction! Light beams trigger automated sensors and open blocked gates!"
- **L2511 (Coloured Lens):** "Colored Lenses tint light beams! Match the beam color to the colored sensor box to open the way!"
- **L2631 (Twin Sensor Gate):** "Dual Sensor Gates require two light beams at the exact same time to unlock!"
- **L2751 (Lamp Timer):** "Timer Lamps turn on and off as you make Moves! Time your departures carefully!"
- **L2871 (Blackout Patch):** "Darkness shrouds these tracks! Direct a light beam into the darkness to wake sleeping locomotives!"

### 4. Accessibility & Color-Blind Integrity
- Chromatic lenses and sensors feature geometric icon badges: Red = Diamond, Green = Triangle, Blue = Square, Amber = Circle.
- Light beam trails embed subtle pulsing micro-patterns matching the filter shape.

## Affected Files
- `lib/features/gameplay/presentation/widgets/optical_beam_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/blackout_mask_layer.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 6 tutorial cards)

## Design
- Screen: Gameplay screen during optical signal levels.
- Design tokens: Consistent with Phase 1–5 wooden toy railway aesthetic.

## Risks
- Heavy fill-rate during multi-beam additive drawing on low-end GPUs. Mitigation: Pre-calculate beam segments into a single flattened path.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `SHARED_CORE_STANDARD.md`.
