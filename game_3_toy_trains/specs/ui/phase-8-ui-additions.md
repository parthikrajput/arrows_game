Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-7-ui-additions.md, specs/gameplay/phase-8-signature-system.md.

# Spec: UI — Phase 8 UI & Botanical Overgrowth Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, procedural ivy vine rendering, hedge trimmer scythe animations, blooming floral trellis graphics, and tutorial dialogs for Phase 8 (Overgrown Branch Line) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases handled planar rotors, optical beams, and multi-floor tracks.
- Phase 8 requires organic botanical rendering of spreading green vines, rotating trimmer blades, and blooming rose trellises.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Botanical Overgrowth & Trellis Rendering
- **Wild Ivy (M351) Vine Rendering:**
  - Rendered as lush miniature green tendrils (`#15803D`) coiling organically across wooden track ties.
  - Growth pulse: Newly occupied cells animate with a gentle scale-up leafy pop (200 ms ease-out).
- **Hedge Trimmer (M352) Scythe Graphic:**
  - Track tile features miniature spinning brass mower scythe blades.
  - Passing train triggers a high-speed blade spinning animation accompanied by flying leaf particles.
- **Seed Wagon (M353) Spore Badging:**
  - Seed Wagon displays miniature green floral seed pods loaded in its tender.
  - Deposited seed renders as an acorn-shaped wooden peg on the track.
- **Flower Arch (M354) Blooming Trellis:**
  - Heavy wooden garden trellis spanning the track corridor.
  - Displays $K$ miniature flower bud pips above the arch.
  - Each contacting ivy cell causes one bud to blossom into an open pink rose (`#F43F5E`); reaching $K$ buds swings the trellis gates open.

### 2. Tutorial Cards (`ftue_cards`)
- **L3501 (Overgrown Branch Line Intro):** "Welcome to the Overgrown Line! Wild ivy spreads across abandoned tracks every few Moves!"
- **L3511 (Wild Ivy+):** "Wild Ivy blocks track lanes! Clear trains quickly before the vines overtake your junction!"
- **L3521 (Hedge Trimmer Car):** "Send trains through Hedge Trimmer stations to slice down all adjacent vines in one stroke!"
- **L3751 (Seed Wagon):** "Seed Wagons drop dormant botanical seeds when they depart! Clear surrounding tracks before they sprout!"
- **L3871 (Flower Arch):** "Flower Arches unlock with nature! Allow ivy vines to touch the trellis to bloom the gates open!"

### 3. Accessibility & Botanical Visual Clarity
- Vine tendrils feature sharp barbed leaf contours distinguishable under monochrome and color-blind modes.
- Growth preview mode: Route Peek indicates threatened track cells with amber leaf caution pips.

## Affected Files
- `lib/features/gameplay/presentation/widgets/ivy_tendril_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/flower_arch_widget.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 8 tutorial cards)

## Design
- Screen: Gameplay screen during overgrown line levels.
- Design tokens: Consistent with Phase 1–7 wooden toy railway aesthetic.

## Risks
- Procedural ivy path drawing overhead on large 14x14 boards. Mitigation: Bake static leaf textures into an atlas; render via drawVertices/drawAtlas.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `SHARED_CORE_STANDARD.md`.
