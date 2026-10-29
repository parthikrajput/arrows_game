Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-4-ui-additions.md, specs/gameplay/phase-5-signature-system.md.

# Spec: UI — Phase 5 UI & Shunting HUD Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, shunting directional guides, cart weight badges, pit filling visual feedback, and tutorial dialogs for Phase 5 (Yard Shunting+) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases featured static track grids and vertical floor controls.
- Phase 5 requires real-time visual feedback for cart displacement vectors, heavy ballast resistance, and filled pit states.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Shunting HUD & Dynamic Vector Guides
- **Push Vector Arrows:** When long-pressing a train pointing toward a push cart (Route Peek), an amber directional arrow projects through the cart into the cell behind it, indicating whether the space is clear (green ring) or blocked (red buffer clack indicator).
- **Weight Badging:**
  - Ballast Cart (M204) displays an embossed cast-iron weight icon (`"2x Weight"`) on its side chassis.
  - Attempting to push with a single standard locomotive highlights the weight badge with a momentary red vibration pulse.
- **Ticket Cart Pad Glow:**
  - Ticket Cart (M203) and its destination receptor pad share an animated pulsing color halo (`#EF4444` for red, `#3B82F6` for blue).
  - Upon landing on the pad, the barrier gate lock plays an unlocking key turn icon above the pad.

### 2. Cart Pit Conversion Feedback
- Empty Cart Pit (M201) renders as a deep dark excavation hole with wooden retaining ties.
- When a cart enters the pit:
  - Immediate visual transition: the pit fills with wooden plank decking (`#B45309`) matching the standard track floor.
  - Track ties seamlessly extend across the filled pit, indicating it is now safe for train transit.

### 3. Tutorial Cards (`ftue_cards`)
- **L2001 (Yard Shunting Intro):** "Welcome to the Shunting Yard! Trains can shove freight carts forward to clear pathways!"
- **L2011 (Cart Pit):** "Excavation Pits block your trains! Push a wooden cart into the pit to build a solid track bridge!"
- **L2131 (Ice Block Cart):** "Ice Carts have no brakes! They slide continuously across the rails until hitting an obstacle or pit!"
- **L2251 (Ticket Cart):** "Shove the Ticket Cart onto its matching color sensor pad to lower the railway barrier gate!"
- **L2371 (Ballast Cart):** "Heavy Ballast Wagons are too heavy for single engines! Use Wide Load or Coupled Engines to push them!"

### 4. Accessibility & Color-Blind Integrity
- Receptor pads display both color enamel and geometric identification symbols (Circle, Square, Diamond).
- Ice Block Carts feature frosted jagged edge borders distinct from standard wooden carts.

## Affected Files
- `lib/features/gameplay/presentation/widgets/shunting_vector_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/cart_weight_badge.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 5 tutorial cards)

## Design
- Screen: Gameplay screen during shunting yard levels.
- Design tokens: Consistent with Phase 1–4 wooden toy railway aesthetic.

## Risks
- Vector arrow clutter when multiple trains align with push carts. Mitigation: Render vector arrows strictly during active Route Peek long-press on a specific train.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `SHARED_CORE_STANDARD.md`.

