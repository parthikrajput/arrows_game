Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-8-ui-additions.md, specs/gameplay/phase-9-signature-system.md.

# Spec: UI — Phase 9 UI & Train Coupling Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, coupling pad graphics, split train seam lines, rejoin archway indicators, and tutorial dialogs for Phase 9 (Couple & Uncouple) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases handled static train bodies and fixed carriages.
- Phase 9 requires visual cues indicating interactive coupling junctions, splitting locomotives, and recombined trains.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Coupling & Splitting Visual Indicators
- **Coupling Pad (M401) Tile:**
  - Dual interlocking brass buffer plates embedded into the tabletop wood (`#B45309`).
  - Central lever knob glows green when both candidate trains are correctly parked.
  - Tapping plays an interlocking knuckle snap animation where train buffers couple together.
- **Twin Split Train (M402) Seam Graphic:**
  - Double-width or tandem locomotives render a perforated golden seam line running down their central spine.
  - Hovering/long-pressing displays subtle outward divergence arrows indicating split trajectory.
- **Coupling Lock (M403) Graphic:**
  - Heavy cast-iron coupler clamp wrapping the coupling knuckle, padlock icon displayed above.
- **Rejoin Arch (M404) Keystones:**
  - Dual-arch portal frame; keystone features two halves of an interlocking gear symbol.
  - When part 1 passes, half the keystone illuminates; when part 2 passes, full keystone flashes green.

### 2. Tutorial Cards (`ftue_cards`)
- **L4001 (Couple & Uncouple Intro):** "Welcome to the Coupling Yard! Park two trains on the Coupling Pads to combine them into one long express!"
- **L4011 (Coupling Pad):** "Align both locomotive heads onto the pads and tap the lever to link them together!"
- **L4131 (Twin Split Train):** "Tap Twin Split Trains to divide them into two parallel engines that can fit through narrow sidings!"
- **L4251 (Coupling Lock):** "These couplers are locked! You must guide the Key Train off the board before the lock opens!"
- **L4371 (Rejoin Arch):** "Send both halves of the split train through the Rejoin Arch to unlock the final line!"

### 3. Accessibility & Coupling Visual Clarity
- Coupled trains render distinct brass coupling chain links between cars, clearly distinguishing multi-car trains from independent engines.
- Color-blind mode adds matching alphanumeric tags (e.g. `[A1]` and `[A2]`) to split pairs.

## Affected Files
- `lib/features/gameplay/presentation/widgets/coupling_pad_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/split_train_seam_layer.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 9 tutorial cards)

## Design
- Screen: Gameplay screen during coupling yard levels.
- Design tokens: Consistent with Phase 1–8 wooden toy railway aesthetic.

## Risks
- Tap ambiguity between tapping individual carriages vs tapping the coupling pad lever. Mitigation: Coupling pad hit-test prioritized over train carriages when tapped directly.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `SHARED_CORE_STANDARD.md`.
